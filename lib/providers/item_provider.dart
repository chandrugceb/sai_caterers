import 'package:flutter/cupertino.dart';
import 'package:sai_caterers/models/item_category_model.dart';
import 'package:sai_caterers/services/firestore_service.dart';
import '../models/item_model.dart';

//init_firebase
class ItemProvider extends ChangeNotifier {
  final firestoreService = FirestoreService();

  Stream<List<Item>> get items => firestoreService.getItems();

  void addItem(Item item) {
    firestoreService.setItem(item);
    notifyListeners();
  }

  void editItem(Item item) {
    firestoreService.setItem(item);
    notifyListeners();
  }

  void removeItem(Item item) {
    firestoreService.removeItem(item.itemId);
    notifyListeners();
  }
}
