import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sai_caterers/models/oldevent_model.dart';
import 'package:sai_caterers/models/item_model.dart';
import 'package:sai_caterers/models/order_model.dart';
import 'package:sai_caterers/models/event_model.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  static FirestoreService _instance;

  static FirestoreService getInstance() {
    if (_instance == null) {
      _instance = FirestoreService();
    }
    return _instance;
  }

  //Items
  //Get Items
  Stream<List<Item>> getItems() {
    return _db.collection('items').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Item.fromJson(doc.data())).toList());
  }

  //Upsert Item
  Future<void> setItem(Item item) {
    var options = SetOptions(merge: true);
    return _db.collection('items').doc(item.itemId).set(item.toMap(), options);
  }

  //Delete Item
  Future<void> removeItem(String itemId) {
    return _db.collection('items').doc(itemId).delete();
  }

  //Orders
  //Get Orders
  Stream<List<Order>> getOrders() {
    return _db.collection('orders').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Order.fromJson(doc.data())).toList());
  }



  //Get OrderById
  Stream<DocumentSnapshot> getOrderById(orderId) {
    return _db.collection('orders').doc(orderId).snapshots();
  }

  //Upsert Order
  Future<void> setOrder(Order order) {
    var options = SetOptions(merge: true);
    return _db
        .collection('orders')
        .doc(order.orderId)
        .set(order.toMap(), options);
  }

  //Delete Order
  Future<void> removeOrder(String orderId) {
    return _db.collection('orders').doc(orderId).delete();
  }

  //Events
  //Get Events
  Stream<List<OrderEvent>> getEventsByOrderId(orderId) {
    return _db
        .collection('orders')
        .doc(orderId)
        .collection('events')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => OrderEvent.fromJson(doc.data())).toList());
  }

  //Get EventsByDate
  Stream<List<OrderEvent>> getEventsByDate(DateTime dateTime) {
    DateTime beginDateTime, endDateTime;
    beginDateTime = new DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0, 0, 0);
    endDateTime = new DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 999, 999);

    return _db.collectionGroup('events')
        .where('startDateTime', isGreaterThan: beginDateTime)
        .where('endDateTime', isLessThan: endDateTime)
        .snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => OrderEvent.fromJson(doc.data())).toList());
  }

  //Get Event
  Stream<DocumentSnapshot> getEvent(eventId) {
    return _db
        .collection('events')
        .doc(eventId)
        .snapshots();
  }

  Stream<List<OrderEvent>> getEvents() {
    print("====================================>getEvents" + DateTime.now().toString());
    return _db
        .collection('events')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => OrderEvent.fromJson(doc.data())).toList());
  }

  //Upsert Event
  Future<void> setEvent(OrderEvent event) {
    var options = SetOptions(merge: true);
    return _db
        .collection('events')
        .doc(event.eventId)
        .set(event.toMap(), options);
  }

  //Delete Event
  Future<void> removeEvent(String eventId) {
    return _db.collection('events').doc(eventId).delete();
  }
}
