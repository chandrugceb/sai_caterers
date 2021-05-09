import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' hide BuildContext;
import 'package:sai_caterers/models/item_category_model.dart';
import 'package:sai_caterers/models/item_model.dart';
import 'package:sai_caterers/models/event_model.dart';
import 'package:sai_caterers/screens/edit_item_screen.dart';
//import 'package:circular_check_box/circular_check_box.dart';

class ItemWidget extends StatefulWidget {
  final Item _item;
  final BuildContext _plateContext;
  final Function() refresh;
  final bool isSelected;
  ItemWidget(this._item, this.isSelected, this._plateContext, this.refresh) {
    print("ItemWidget Constructor ______ " + this._item.itemName);
  }

  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  double _width;
  Color itemColor;
  OrderEvent _plate;
  bool isSelected;

@override
  void initState() {
    this.isSelected = widget.isSelected;
    super.initState();
  }
  @override
  Widget build(BuildContext contextItemWidget) {
    print("________ItemWidget for " + widget._item.itemName);
    if (widget._plateContext != null) {
      _plate = Provider.of<OrderEvent>(widget._plateContext, listen: false);
    }
    _width = MediaQuery.of(contextItemWidget).size.width;
    itemColor = getItemColor(itemCategory: widget._item.itemCategory);

    return InkWell(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        width: double.maxFinite,
        child: Card(
          color: (this.isSelected == true) ? Colors.green[100] : Colors.white,
          elevation: 5,
          shape: Border(left: BorderSide(color: this.itemColor, width: 3)),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ItemNameWidget(widget._item.itemName),
                    ItemUnitPriceWidget(widget._item.unitPrice),
                    this.isSelected == null
                        ? Container()
                        : circularCheckBox(
                            this.isSelected
                           /* checkColor: Colors.white,
                            activeColor: Colors.green,
                            inactiveColor: Colors.redAccent,
                            disabledColor: Colors.green,
                            onChanged: null,*/
                          )
                  ],
                ),
                //  PlatesItemSlider(this._index),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        onItemClick(contextItemWidget);
      },
    );
  }

  void onItemClick(BuildContext contextItemWidget) {
    print("onTap hit with ${this.isSelected}");
    if (this.isSelected == null) {
      showDialog(
        context: contextItemWidget,
        builder: (BuildContext context) {
          return AlertDialog(
            title: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Edit Item",
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 22,
                        fontWeight: FontWeight.bold))),
            content: EditItemScreen(
                widget._item, contextItemWidget, true, widget.refresh),
          );
        },
      );
    } else if (this.isSelected) {
      this.isSelected = false;
      this._plate.removeItem(widget._item);
      widget.refresh();
    } else {
      this.isSelected = true;
      this._plate.addNewItem(widget._item);
     //We don't have to refresh the list view when an item is selected
      // widget.refresh();
    }
    setState(() {});
  }

  Widget ItemUnitPriceWidget(double _plateItemPrice) {
    return Container(
      // color: Colors.blue,
      width: _width * 0.3,
      child: RichText(
        textAlign: TextAlign.right,
        text: TextSpan(
          text: NumberFormat.currency(
                  locale: 'en_IN', symbol: '₹', decimalDigits: 0)
              .format(_plateItemPrice),
          style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 26,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget ItemNameWidget(String _plateItemName) {
    return Container(
      //color: Colors.green,
      width: _width * 0.4,
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          text: _plateItemName,
          style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget circularCheckBox(bool isSelected) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: SizedBox(
        width: Checkbox.width,
        height: Checkbox.width,
        child: Container(
          decoration: new BoxDecoration(
            border: Border.all(
              width: 1,
            ),
            borderRadius: new BorderRadius.circular(5),
          ),
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.transparent,
            ),
            child: Checkbox(
              value: isSelected,
              onChanged: (state) {},
              activeColor: Colors.transparent,
              checkColor: Colors.amber,
              materialTapTargetSize: MaterialTapTargetSize.padded,
            ),
          ),
        ),
      ),
    );
  }

  // get item category color
  Color getItemColor({itemCategory}) {
    switch (itemCategory) {
      case ItemCategory.SWEET:
        return Colors.deepOrange;
        break;
      case ItemCategory.TIFFIN:
        return Colors.purpleAccent;
        break;
      case ItemCategory.SNACKS:
        return Colors.yellowAccent;
        break;
      case ItemCategory.MEALS:
        return Colors.green;
        break;
      case ItemCategory.DISPOSABLES:
        return Colors.grey;
        break;
      default:
        return Colors.black;
        break;
    }
  }
}
