import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'  hide BuildContext;
import 'package:sai_caterers/models/item_category_model.dart';
import 'package:sai_caterers/models/plate_item_model.dart';
import 'package:sai_caterers/models/plate_model.dart';
import 'package:sai_caterers/screens/edit_plate_item_screen.dart';
import 'package:sai_caterers/widgets/plates/plates_item_slider_widget.dart';

class PlatesItemWidget extends StatelessWidget {
  PlateItem _plateItem;
  int _index;
  double _width;
  Color itemColor, itemBackgroundColor;

  PlatesItemWidget(this._index, this._plateItem);

  @override
  Widget build(BuildContext contextPlatesItemWidget) {
    print("________PlatesItemWidget for " + this._plateItem.item.itemName);
    _width = MediaQuery.of(contextPlatesItemWidget).size.width;
    switch (this._plateItem.item.itemCategory) {
      case ItemCategory.SWEET:
        itemColor = Colors.deepOrange;
        itemBackgroundColor = Colors.orange[50];
        break;
      case ItemCategory.TIFFIN:
        itemColor = Colors.purpleAccent;
        itemBackgroundColor = Colors.pink[50];
        break;
      case ItemCategory.SNACKS:
        itemColor = Colors.yellowAccent;
        itemBackgroundColor = Colors.yellow[50];
        break;
      case ItemCategory.MEALS:
        itemColor = Colors.green;
        itemBackgroundColor = Colors.green[50];
        break;
      case ItemCategory.DISPOSABLES:
        itemColor = Colors.grey;
        itemBackgroundColor = Colors.grey[50];
        break;
      default:
        itemColor = Colors.black;
        itemBackgroundColor = Colors.black;
        break;
    }
    return InkWell(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        //height: 140,
        width: double.maxFinite,
        child: Card(
          color: itemBackgroundColor,
          elevation: 5,
          shape: Border(left: BorderSide(color: this.itemColor, width: 3)),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    plateItemNameWidget(_plateItem.item.itemName),
                    plateItemPriceWidget(_plateItem.plateItemPrice),
                  ],
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      plateItemUnitPriceWidget(_plateItem.item.unitPrice),
                      plateItemQtyWidget(_plateItem.qty),
                    ],
                  ),
                ),
                //  PlatesItemSlider(this._index),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        showDialog(
          context: contextPlatesItemWidget,
          builder: (BuildContext context) {
            return AlertDialog(
              title: RichText(text: TextSpan(text:_plateItem.item.itemName, style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 22, fontWeight: FontWeight.bold))),
              content: EditPlateItemScreen( _index, contextPlatesItemWidget),
              //insetPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 100.0),
            );
          },
        );
      },
    );
  }

  Widget plateItemPriceWidget(double _plateItemPrice) {
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
              color: Colors.deepOrangeAccent, fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget plateItemNameWidget(String _plateItemName) {
    return Container(
      //color: Colors.green,
      width: _width * 0.5,
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          text: _plateItemName,
          style: TextStyle(
              color: Colors.deepOrangeAccent, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget plateItemUnitPriceWidget(double _plateItemUnitPrice) {
    return Container(
      // color: Colors.blue,
      width: _width * 0.5,
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          text: NumberFormat.currency(
                      locale: 'en_IN', symbol: '₹', decimalDigits: 0)
                  .format(_plateItemUnitPrice) +
              " per piece",
          style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget plateItemQtyWidget(int _plateItemQty) {
    return Container(
      // color: Colors.blue,
      width: _width * 0.3,
      child: RichText(
        textAlign: TextAlign.right,
        text: TextSpan(
          text: _plateItemQty.toString() + " qty",
          style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
