import 'package:flutter/cupertino.dart';
import 'package:sai_caterers/models/plate_item_model.dart';
import 'item_category_model.dart';
import 'item_model.dart';

class OrderEvent extends ChangeNotifier {
  //properties
  String eventId;
  String eventName;
  DateTime startDateTime;
  DateTime endDateTime;
  DateTime orderDeliveryDateTime;
  DateTime orderReadyDateTime;
  String customerName;
  String customerPhone;
  String cookingVenue;
  String eventNotes;
  int persons = 1;
  List<PlateItem> plateItems;
  double totalPrice = 1;
  double perPlatePrice = 1;

  //constructors
  OrderEvent(
      {@required this.eventId,
      @required this.eventName,
      @required this.startDateTime,
      @required this.endDateTime,
      @required this.orderDeliveryDateTime,
      @required this.orderReadyDateTime,
      @required this.customerName,
      @required this.customerPhone,
      @required this.cookingVenue,
      @required this.eventNotes,
      @required this.persons,
      this.plateItems}) {
    if(plateItems == null){
      plateItems = <PlateItem>[];
    }
    this.calculatePrice();
  }

  //helper functions
  void updatePersons(int value) {
    persons = value;
    calculatePrice();
  }

  void addPlateItem(_plateItem) {
    this.plateItems.add(_plateItem);
    calculatePrice();
  }

  void calculatePrice() {
    double _tempPerPlatePrice = 0;
    if(this.plateItems != null){
      this.plateItems.forEach((plateItem) {
        _tempPerPlatePrice = _tempPerPlatePrice + plateItem.plateItemPrice;
      });

      this.totalPrice = _tempPerPlatePrice;
      this.perPlatePrice = this.totalPrice / this.persons;
    }
    else{
      this.totalPrice = 0;
      this.perPlatePrice = 0;
    }

    print("calculate price called");
    notifyListeners();
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
      PlateItem _plateItem =
          new PlateItem(item: _item, qty: this.persons.toInt());
      this.plateItems.add(_plateItem);
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
    }
    calculatePrice();
  }

  //json to object transformation functions
  factory OrderEvent.fromJson(Map<String, dynamic> json) {
    return OrderEvent(
        eventId: json['eventId'],
        eventName: json['eventName'],
        startDateTime: json['startDateTime']!=null?json['startDateTime'].toDate():null,
        endDateTime: json['endDateTime']!=null?json['endDateTime'].toDate():null,
        orderDeliveryDateTime: json['orderDeliveryDateTime']!=null?json['orderDeliveryDateTime'].toDate():null,
        orderReadyDateTime: json['orderReadyDateTime']!=null?json['orderReadyDateTime'].toDate():null,
        customerName: json['customerName'],
        customerPhone: json['customerPhone'],
        cookingVenue: json['cookingVenue'],
        eventNotes: json['eventNotes'],
        persons: json['persons'] ?? 1,
        plateItems: json['plateItems']!=null?(json['plateItems'] as List)
            .map((_plateItem) => PlateItem.fromJson(_plateItem))
            .toList():null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'eventName': eventName,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'orderDeliveryDateTime': orderDeliveryDateTime,
      'orderReadyDateTime': orderReadyDateTime,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'cookingVenue': cookingVenue,
      'eventNotes': eventNotes,
      'persons': persons,
      'plateItems': plateItems.map((_plateItem) => _plateItem.toMap()).toList(),
    };
  }
}
