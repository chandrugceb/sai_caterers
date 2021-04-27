import 'package:flutter/cupertino.dart';
import 'package:sai_caterers/models/order_model.dart';
import 'package:sai_caterers/services/firestore_service.dart';

class OrderProvider extends ChangeNotifier {
  final firestoreService = FirestoreService.getInstance();
  OrderProvider();

  Stream<List<Order>> get orders => firestoreService.getOrders();

  void addOrder(Order order) {
    firestoreService.setOrder(order);
    notifyListeners();
  }

  void editOrder(Order order) {
    firestoreService.setOrder(order);
    notifyListeners();
  }

  void removeOrder(orderId) {
    firestoreService.removeOrder(orderId);
    notifyListeners();
  }

}
