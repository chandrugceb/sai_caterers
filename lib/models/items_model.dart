import 'package:flutter/cupertino.dart';
import 'package:sai_caterers/models/item_category_model.dart';

import 'item_model.dart';

class Items extends ChangeNotifier{
  List<Item> items = [];
  void addItem(Item item){
    items.add(item);
    print("add called with item ${item.itemId}");
    notifyListeners();
  }

  void editItem(Item item){
    items.map((_item) {
      if(_item.itemId == item.itemId){
        _item.itemCategory = item.itemCategory;
        _item.itemDescription = item.itemDescription;
        _item.itemName = item.itemName;
        _item.subItems = item.subItems;
        _item.unitPrice = item.unitPrice;
      }
    });
    notifyListeners();
  }

  void removeItem(Item item){
    if(items.contains(item)){
      items.remove(item);
    }
    notifyListeners();
  }

  void loadDummyData(){
    this.items.add(new Item(1, "Poori", null, null, ItemCategory.tiffin,10.0));
    this.items.add(new Item(2, "Vada", null, null, ItemCategory.tiffin,8.0));
    this.items.add(new Item(3, "Coconut Chutney | Sambar | Tomato Chutney | Pudhina Chutney", null, null, ItemCategory.meals,10.0));
    this.items.add(new Item(4, "Laddu", null, null, ItemCategory.sweet,8.0));
    this.items.add(new Item(5, "Rice", null, null, ItemCategory.meals,12.0));
    this.items.add(new Item(6, "Poriyal", null, null, ItemCategory.meals,10.0));
    this.items.add(new Item(7, "Water Bottle", null, null, ItemCategory.disposbles,10.0));
    this.items.add(new Item(80, "Bananna Leaves", null, null, ItemCategory.disposbles,7.0));
    this.items.add(new Item(90, "Paku Mattai", null, null, ItemCategory.disposbles,5.0));
    this.items.add(new Item(100, "Mixture", null, null, ItemCategory.snacks,10.0));
    this.items.add(new Item(110, "Samosa", null, null, ItemCategory.snacks,10.0));
  }
}