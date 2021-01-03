import 'package:flutter/cupertino.dart';
import 'package:sai_caterers/models/plate_item_model.dart';
import 'item_category_model.dart';
import 'item_model.dart';

class Plate extends ChangeNotifier {
  int _plateId;
  String _plateName;
  DateTime _dateTime;
  int _persons = 1;
  List<PlateItem> _plateItems;
  double _totalPrice;
  double _perPlatePrice;

  Plate(this._plateId, this._plateName, this._dateTime) {
    _plateItems = new List<PlateItem>();
  }

  int get persons => _persons;

  set persons(int value) {
    _persons = value;
    calculatePrice();
  }

  void addPlateItem(_plateItem) {
    this._plateItems.add(_plateItem);
    calculatePrice();
  }

  void calculatePrice() {
    double _tempPerPlatePrice = 0;
    this._plateItems.forEach((plateItem) {
      _tempPerPlatePrice = _tempPerPlatePrice + plateItem.plateItemPrice;
    });

    this._totalPrice = _tempPerPlatePrice;
    this._perPlatePrice = this._totalPrice / this.persons;
    print("calculate price called");
    notifyListeners();
  }

  double get totalPrice => _totalPrice;
  double get perPlatePrice => _perPlatePrice;

  List<PlateItem> get plateItems => _plateItems;

  void loadDummyData() {
    Item idly = new Item(1, "Idly", null, null, ItemCategory.tiffin, 5);
    Item sambar = new Item(2, "Sambar Vadai | Chutney | Coffee | Elaichi ",
        null, null, ItemCategory.tiffin, 3);
    Item chutney = new Item(3, "Chutney", null, null, ItemCategory.tiffin, 3);
    Item dosai = new Item(4, "Dosai", null, null, ItemCategory.tiffin, 12);
    Item vadai = new Item(5, "Medhu Vadai", null, null, ItemCategory.tiffin, 8);
    Item laddu = new Item(6, "Laddu", null, null, ItemCategory.sweet, 7);
    Item poriyal =
        new Item(7, "Poriyal Kootu", null, null, ItemCategory.meals, 7);
    Item kChutney =
        new Item(8, "Chutney (Kothumalli)", null, null, ItemCategory.tiffin, 5);
    Item ePayaam =
        new Item(9, "Ilaneer Payasam", null, null, ItemCategory.sweet, 15);
    Item bLeaves =
        new Item(10, "Banana Leaf", null, null, ItemCategory.disposbles, 5);
    Item wBottle = new Item(
        11, "Water Bottle 200ml", null, null, ItemCategory.disposbles, 8);
    Item beeda = new Item(12, "Sweet Beeda", null, null, ItemCategory.sweet, 7);
    PlateItem plate1 = new PlateItem(idly, this.persons);
    PlateItem plate2 = new PlateItem(sambar, this.persons);
    PlateItem plate3 = new PlateItem(chutney, this.persons);
    PlateItem plate4 = new PlateItem(dosai, this.persons);
    PlateItem plate5 = new PlateItem(vadai, this.persons);
    PlateItem plate6 = new PlateItem(laddu, this.persons);
    PlateItem plate7 = new PlateItem(poriyal, this.persons);
    PlateItem plate8 = new PlateItem(kChutney, this.persons);
    PlateItem plate9 = new PlateItem(ePayaam, this.persons);
    PlateItem plate10 = new PlateItem(bLeaves, this.persons + 10);
    PlateItem plate11 = new PlateItem(wBottle, this.persons + 10);
    PlateItem plate12 = new PlateItem(beeda, this.persons + 10);
    this.addPlateItem(plate1);
    this.addPlateItem(plate2);
    this.addPlateItem(plate3);
    this.addPlateItem(plate4);
    this.addPlateItem(plate5);
    this.addPlateItem(plate6);
    this.addPlateItem(plate7);
    this.addPlateItem(plate8);
    this.addPlateItem(plate9);
    this.addPlateItem(plate10);
    this.addPlateItem(plate11);
    this.addPlateItem(plate12);
  }

  bool isItemExists(Item _item) {
    var contain = this
        .plateItems
        .where((plateItem) => plateItem.item.itemId == _item.itemId);
    if (contain.isEmpty) {
      return false;
    }
    return true;
  }

  void addNewItem(Item _item) {
    if (!isItemExists(_item)) {
      PlateItem _plateItem = new PlateItem(
          new Item(_item.itemId, _item.itemName, _item.itemDescription,
              _item.subItems, _item.itemCategory, _item.unitPrice),
          this.persons.toInt());
      this._plateItems.add(_plateItem);
      calculatePrice();
    }
  }

  void removeItem(Item _item) {
    if (isItemExists(_item)) {
      print("${_item.itemName} exists of length ${this.plateItems.length}");
      this
          .plateItems
          .removeWhere((plateItem) => plateItem.item.itemId == _item.itemId);
      print(
          "after delete ${_item.itemName} exists of length ${this.plateItems.length}");
      calculatePrice();
    }
  }
}
