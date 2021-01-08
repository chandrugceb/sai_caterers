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
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ItemsWidget extends StatefulWidget {
  final BuildContext _plateContext;
  ItemsWidget(this._plateContext);
  final spinkit = SpinKitRipple(
    color: Colors.deepOrange,
    size: 200.0,
  );

  _ItemsWidgetState createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  Plate _plate;
  ItemProvider _itemProvider;
  Uuid _uuid;
  _ItemsWidgetState() {
    _uuid = new Uuid();
  }

  @override
  void initState() {
    if (widget._plateContext != null) {
      _plate = Provider.of<Plate>(widget._plateContext);
      _itemProvider = Provider.of<ItemProvider>(widget._plateContext);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext _itemsContext) {
    if (widget._plateContext == null) {
      _itemProvider = Provider.of<ItemProvider>(_itemsContext);
    }
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
              child: widget._plateContext == null
                  ? Text("ITEMS")
                  : Text("SELECT ITEMS")),
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
                                if (widget._plateContext != null) {
                                  isSelected = this._plate.isItemExists(item);
                                }
                                return new ItemWidget(
                                    item, isSelected, widget._plateContext, refresh);
                              });
                        }
                        else {
                          return Container();
                        }
                        }
                      else {
                        return widget.spinkit;
                        }
                    }

              ),
            );
          }).toList(),
        ),
        floatingActionButton: (widget._plateContext == null)
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
                            null, _itemsContext, false, refresh),
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

  void refresh(){
    setState(() {

    });
  }
}
