import 'package:sai_caterers/models/item_category_model.dart';

class Item{
  int itemId;
  String itemName;
  String itemDescription;
  List<Item> subItems;
  ItemCategory itemCategory;
  double unitPrice;

  Item(this.itemId, this.itemName, this.itemDescription, this.subItems,
      this.itemCategory, this.unitPrice);
}