import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide BuildContext;
import 'package:flutter/foundation.dart';
import 'package:sai_caterers/models/entry_model.dart';
import 'package:sai_caterers/models/item_category_model.dart';
import 'package:sai_caterers/models/item_model.dart';
import 'package:sai_caterers/models/items_model.dart';
import 'package:sai_caterers/models/plate_model.dart';
import 'package:sai_caterers/screens/edit_item_screen.dart';
import 'package:sai_caterers/services/firestore_service.dart';
import 'package:sai_caterers/widgets/items/item_widget.dart';

class ItemsWidget extends StatefulWidget {
  BuildContext _plateContext;
  Plate _plate;
  Items _items;

  ItemsWidget(this._plateContext) {
    if (_plateContext != null) {
      _plate = Provider.of<Plate>(_plateContext);
      _items = Provider.of<Items>(_plateContext);
    }
  }

  _ItemsWidgetState createState() => _ItemsWidgetState(this._plateContext);
}

class _ItemsWidgetState extends State<ItemsWidget> {
  BuildContext _plateContext;
  Plate _plate;
  Items _items;
  FirestoreService firestoreService;

  _ItemsWidgetState(this._plateContext) {
    if (_plateContext != null) {
      _plate = Provider.of<Plate>(_plateContext);
      _items = Provider.of<Items>(_plateContext);
    }
  }

  @override
  void initState() {
    firestoreService = new FirestoreService();
    super.initState();
  }

  @override
  Widget build(BuildContext _itemsContext) {
    if (_plateContext == null) {
      _items = Provider.of<Items>(_itemsContext);
    }
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          actions: [IconButton(icon: Icon(Icons.send),
            onPressed: (){
            print("I'm here 1");
            // firestoreService.getEntries().length.then((value) => print("I'm here " + value.toString()));
            firestoreService.setEntry(new Entry(entry: "Renuka Devi"));
             print("I'm here 2");
            },
          )],
          title: Center(
              child: _plateContext == null
                  ? Text("Items")
                  : Text("${this._plate.plateItems.length} items selected")),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            tabs: ItemCategory.values.map((itemCategory) {
              return Tab(
                  text: describeEnum(itemCategory).toString().toUpperCase());
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: ItemCategory.values.map((itemCategory) {
            return Center(
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                  itemCount: this
                      ._items
                      .items
                      .where((item) => item.itemCategory == itemCategory)
                      .toList()
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    Item item = this
                        ._items
                        .items
                        .where((item) => item.itemCategory == itemCategory)
                        .toList()[index];
                    bool isSelected;
                    if (_plateContext != null) {
                      isSelected = this._plate.isItemExists(item);
                    }
                    return ItemWidget(
                        item, isSelected, _plateContext, this.refresh);
                  }),
            );
          }).toList(),
        ),
        floatingActionButton: (this._plateContext == null)
            ? FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: _itemsContext,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: "Edit Item",
                                style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold))),
                        content: EditItemScreen(
                            null, _itemsContext, false, this.refresh),
                      );
                    },
                  );
                },
                child: Icon(Icons.add_sharp, color: Colors.white),
                backgroundColor: Colors.deepOrange,
              )
            : null,
      ),
    );
  }

  refresh() {
    print(this._items.items.length);
    setState(() {});
  }
}
