import 'item_model.dart';
import 'package:flutter/foundation.dart';

class PlateItem {
  //properties
  Item item;
  int qty;
  double _plateItemPrice;

  //constructors
  PlateItem({@required this.item, @required this.qty}) {
    updatePlatePrice();
  }

  //getters
  double get plateItemPrice => _plateItemPrice;
  //int get qty => _qty;
  //Item get item => _item;

  //helper functions
  void updatePlatePrice() {
    _plateItemPrice = this.item.unitPrice * this.qty;
  }

  void updatePlateQty(int _qty) {
    this.qty = _qty;
    updatePlatePrice();
  }

  //json to object transformation functions
  factory PlateItem.fromJson(Map<String, dynamic> json) {
    return PlateItem(
        item: Item.fromJson(json['item']),
        qty: json['qty']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item.toMap(),
      'qty': qty,
    };
  }
}
