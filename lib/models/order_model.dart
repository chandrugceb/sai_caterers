import 'package:flutter/cupertino.dart';
import 'package:sai_caterers/models/event_model.dart';

import 'oldevent_model.dart';

class Order {
  //properties
  String orderId;
  String orderName;
  DateTime startDateTime;
  DateTime endDateTime;
  String customerName;
  String customerPhone;
  String orderNotes;
  String orderVenue;

  //constructors
  Order(
      {@required this.orderId,
      @required this.orderName,
      @required this.startDateTime,
      this.endDateTime,
      @required this.customerName,
      @required this.customerPhone,
      this.orderNotes,
      this.orderVenue});

  //json to object transformation functions
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        orderId: json['orderId'],
        orderName: json['orderName'],
        startDateTime: json['startDateTime'],
        endDateTime: json['endDateTime'],
        customerName: json['customerName'],
        customerPhone: json['customerPhone'],
        orderNotes: json['orderNotes'],
        orderVenue: json['orderVenue']
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'orderName': orderName,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'orderNotes': orderNotes,
    };
  }
}
