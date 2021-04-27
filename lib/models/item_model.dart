import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sai_caterers/models/item_category_model.dart';

class Item{
  //properties
  String itemId;
  String itemName;
  String itemDescription;
  ItemCategory itemCategory;
  double unitPrice;

  //constructors
  Item({@required this.itemId, @required this.itemName, this.itemDescription,
      @required this.itemCategory, @required this.unitPrice});

  //json to object transformation functions
  factory Item.fromJson(Map<String, dynamic> json){
    return Item(
      itemId: json['itemId'],
      itemName: json['itemName'],
      itemDescription: json['itemDescription'],
      itemCategory: ItemCategory.values.firstWhere((e) => e.toString() == "ItemCategory." + json['itemCategory']),
      unitPrice: json['unitPrice']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'itemDescription': itemDescription,
      'itemCategory': describeEnum(itemCategory).toString().toUpperCase(),
      'unitPrice':unitPrice
    };
  }
}