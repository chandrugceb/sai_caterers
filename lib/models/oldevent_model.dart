import 'package:flutter/cupertino.dart';
import 'package:sai_caterers/models/event_model.dart';

class OldOrderEvent {
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
  OldOrderEvent eventPlatter;

  //constructors
  OldOrderEvent(
      {@required this.eventId,
      @required this.eventName,
      @required this.startDateTime,
      this.endDateTime,
      this.orderDeliveryDateTime,
      this.orderReadyDateTime,
      @required this.customerName,
      @required this.customerPhone,
      this.cookingVenue,
      this.eventNotes,
      this.eventPlatter});

  //json to object transformation functions
  factory OldOrderEvent.fromJson(Map<String, dynamic> json) {
    return OldOrderEvent(
        eventId: json['eventId'],
        eventName: json['eventName'],
        startDateTime: json['startDateTime'],
        endDateTime: json['endDateTime'],
        orderDeliveryDateTime: json['orderDeliveryDateTime'],
        orderReadyDateTime: json['orderReadyDateTime'],
        customerName: json['customerName'],
        customerPhone: json['customerPhone'],
        cookingVenue: json['cookingVenue'],
        eventNotes: json['eventNotes'],
        eventPlatter: OldOrderEvent.fromJson(json['eventPlatter'])
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
      'eventPlatter': eventPlatter.toMap()
    };
  }
}
