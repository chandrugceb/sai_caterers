import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sai_caterers/models/entry_model.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  FirebaseFirestore  _db = FirebaseFirestore.instance;
  Uuid _uuid = new Uuid();

  //Get Entries
  Stream<List<Entry>> getEntries(){
    print("I'm in service");
    return _db
        .collection('entries')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Entry.fromJson(doc.data()))
        .toList());
  }

  //Upsert
  Future<void> setEntry(Entry entry){
    var options = SetOptions(merge:true);
    return _db
        .collection('entries')
        .doc(_uuid.v1())
        .set(entry.toMap(), options);
  }

  //Delete
  Future<void> removeEntry(String entryId){
    return _db
        .collection('entries')
        .doc(entryId)
        .delete();
  }

}