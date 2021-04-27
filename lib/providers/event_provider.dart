import 'package:flutter/cupertino.dart';
import 'package:sai_caterers/models/oldevent_model.dart';
import 'package:sai_caterers/models/event_model.dart';
import 'package:sai_caterers/services/firestore_service.dart';

class OrderEventProvider extends ChangeNotifier {
  final firestoreService = FirestoreService.getInstance();

  Stream<List<OrderEvent>> get events => firestoreService.getEvents();

  void addEvent(OrderEvent event) {
    firestoreService.setEvent(event);
    notifyListeners();
  }

  void editEvent(OrderEvent event) {
    firestoreService.setEvent(event);
    notifyListeners();
  }

  void removeEvent(OrderEvent event) {
    firestoreService.removeEvent(event.eventId);
    notifyListeners();
  }

}
