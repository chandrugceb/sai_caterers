import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'  hide BuildContext;
import 'package:sai_caterers/models/item_category_model.dart';
import 'package:sai_caterers/models/item_model.dart';
import 'package:sai_caterers/models/plate_model.dart';
import 'package:sai_caterers/screens/edit_item_screen.dart';
import 'package:circular_check_box/circular_check_box.dart';

class ItemWidget extends StatefulWidget {
  Item _item;
  int _index;
  double _width;
  Color itemColor;
  bool isSelected;
  Plate _plate;
  BuildContext _plateContext;
  final Function() refresh;
  ItemWidget(this._item, this.isSelected, this._plateContext, this.refresh){
    print("ItemWidget Constructor ______ " + this._item.itemName);
    createState();
  }

  _ItemWidgetState createState() =>
      _ItemWidgetState(this._item, this.isSelected, this._plateContext, this.refresh);
}

class _ItemWidgetState extends State<ItemWidget> {
  Item _item;
  int _index;
  double _width;
  Color itemColor;
  bool isSelected;
  Plate _plate;
  BuildContext _plateContext;
  final Function() refresh;

  _ItemWidgetState(this._item, this.isSelected, this._plateContext, this.refresh){
    print("ItemWidgetState Constructor ______ " + this._item.itemName);
  }

  @override
  Widget build(BuildContext contextItemWidget) {
    print("________ItemWidget for " + this._item.itemName);
    if (this._plateContext != null) {
      _plate = Provider.of<Plate>(_plateContext, listen: false);
    }
    _width = MediaQuery.of(contextItemWidget).size.width;
    switch (this._item.itemCategory) {
      case ItemCategory.SWEET:
        itemColor = Colors.deepOrange;
        break;
      case ItemCategory.TIFFIN:
        itemColor = Colors.purpleAccent;
        break;
      case ItemCategory.SNACKS:
        itemColor = Colors.yellowAccent;
        break;
      case ItemCategory.MEALS:
        itemColor = Colors.green;
        break;
      case ItemCategory.DISPOSABLES:
        itemColor = Colors.grey;
        break;
      default:
        itemColor = Colors.black;
        break;
    }
    return InkWell(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        //height: 140,
        width: double.maxFinite,
        child: Card(
          color: (this.isSelected == true)?Colors.green[100]:Colors.white,
          elevation: 5,
          shape: Border(left: BorderSide(color: this.itemColor, width: 3)),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ItemNameWidget(this._item.itemName),
                    ItemUnitPriceWidget(this._item.unitPrice),
                    this.isSelected == null
                        ? Container()
                        : CircularCheckBox(
                            value: this.isSelected,
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                            inactiveColor: Colors.redAccent,
                            disabledColor: Colors.green,
                            onChanged: null,
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
        print("onTap hit with ${this.isSelected}");
        if (this.isSelected == null) {
          showDialog(
            context: contextItemWidget,
            builder: (BuildContext context) {
              return AlertDialog(
                title: RichText(
                  textAlign: TextAlign.center ,
                    text: TextSpan(
                        text: "Edit Item",
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 22,
                            fontWeight: FontWeight.bold))),
                content: EditItemScreen(_item, contextItemWidget, true, this.refresh),
              );
            },
          );
        } else if (this.isSelected) {
          this.isSelected = false;
          this._plate.removeItem(this._item);
          widget.refresh();
        } else {
          this.isSelected = true;
          this._plate.addNewItem(this._item);
          widget.refresh();
        }
        setState(() {});
      },
    );
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
              color: Colors.deepOrange, fontSize: 26, fontWeight: FontWeight.bold),
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
              color: Colors.deepOrange, fontSize: 20, fontWeight: FontWeight.bold),
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
}
