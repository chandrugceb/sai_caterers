import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide BuildContext;
import 'package:flutter/foundation.dart';
import 'package:sai_caterers/models/item_category_model.dart';
import 'package:sai_caterers/models/item_model.dart';
import 'package:sai_caterers/providers/item_provider.dart';
import 'package:sai_caterers/models/plate_model.dart';
import 'package:sai_caterers/screens/edit_item_screen.dart';
import 'package:sai_caterers/widgets/items/item_widget.dart';
import 'package:uuid/uuid.dart';

class ItemsWidget extends StatefulWidget {
  final BuildContext _plateContext;
  ItemsWidget(this._plateContext);

  _ItemsWidgetState createState() => _ItemsWidgetState(this._plateContext);
}

class _ItemsWidgetState extends State<ItemsWidget> {
  BuildContext _plateContext;
  Plate _plate;
  ItemProvider _itemProvider;
  Uuid _uuid;
  _ItemsWidgetState(this._plateContext) {
    _uuid = new Uuid();
  }

  @override
  void initState() {
    if (_plateContext != null) {
      _plate = Provider.of<Plate>(_plateContext);
      _itemProvider = Provider.of<ItemProvider>(_plateContext);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext _itemsContext) {
    if (_plateContext == null) {
      _itemProvider = Provider.of<ItemProvider>(_itemsContext);
    }
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _itemProvider.addItem(new Item(
                    itemId: _uuid.v1(),
                    itemName: "Item" + _uuid.v1(),
                    itemCategory: ItemCategory.SWEET,
                    unitPrice: 1.2));
              },
            )
          ],
          title: Center(
              child: _plateContext == null
                  ? Text("ITEMS")
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
              child: StreamBuilder<List<Item>>(
                stream: _itemProvider.items,
                builder: (context, snapshot) {
                  print(snapshot.connectionState);
                  print(snapshot.hasData);
                        if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                              itemCount: snapshot.data
                                  .where(
                                      (item) => item.itemCategory == itemCategory)
                                  .toList()
                                  .length,
                              itemBuilder: (context, index) {
                                Item item = snapshot.data
                                    .where(
                                        (item) => item.itemCategory == itemCategory)
                                    .toList()[index];
                                bool isSelected;
                                if (_plateContext != null) {
                                  isSelected = this._plate.isItemExists(item);
                                }
                                return new ItemWidget(
                                    item, isSelected, _plateContext, this.refresh);
                              });
                        }
                        else {
                          return Container();
                        }
                        }
                      else {
                        return Container();
                        }
                    }

              ),
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
    print(this._itemProvider.items.length);
    setState(() {});
  }
}
