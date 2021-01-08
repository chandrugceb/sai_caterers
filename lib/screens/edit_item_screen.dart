import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide BuildContext;
import 'package:sai_caterers/models/item_category_model.dart';
import 'package:sai_caterers/models/item_model.dart';
import 'package:sai_caterers/providers/item_provider.dart';
import 'package:uuid/uuid.dart';

class EditItemScreen extends StatefulWidget {
  Item _item;
  BuildContext contextItemWidget;
  bool _edit;
  final Function() refresh;
  EditItemScreen(this._item, this.contextItemWidget, this._edit, this.refresh);

  _EditItemScreenState createState() =>
      _EditItemScreenState(this._item, this.contextItemWidget, this._edit, this.refresh);
}

class _EditItemScreenState extends State<EditItemScreen> {
  Item _item;
  ItemProvider _itemProvider;
  bool _edit;
  String _itemName;
  double _unitPrice;
  ItemCategory _itemCategory;
  BuildContext contextItemWidget;
  Uuid _uuid;
  final Function() refresh;
  _EditItemScreenState(this._item, this.contextItemWidget, this._edit, this.refresh);

  @override
  void initState() {
    this._itemProvider = Provider.of<ItemProvider>(contextItemWidget, listen: false);
    _edit ? null: _itemCategory = ItemCategory.SWEET;
    _uuid = new Uuid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("edit item screen build was called");

    return Container(
      child: Container(
        width: 300,
        height: 400,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButton<ItemCategory>(
                  value: _edit ? _item.itemCategory : _itemCategory,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 15,
                  elevation: 16,
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (ItemCategory itemCategory) {
                    setState(() {
                      _edit?
                          _item.itemCategory = itemCategory
                          :_itemCategory = itemCategory;
                    });
                  },
                  items: ItemCategory.values
                      .map<DropdownMenuItem<ItemCategory>>(
                          (ItemCategory itemCategory) {
                    return DropdownMenuItem<ItemCategory>(
                      value: itemCategory,
                      child: Text(
                          describeEnum(itemCategory).toString().toUpperCase()),
                    );
                  }).toList()),
              SizedBox(height: 5),
              Expanded(
                flex: 1,
                child: TextFormField(
                  maxLines: null,
                  style: const TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.text,
                  enableInteractiveSelection: false,
                  autofocus: false,
                  initialValue: _edit ? this._item.itemName.toString() : "",
                  decoration: InputDecoration(
                    labelText: "Item Name",
                    labelStyle:
                        const TextStyle(color: Colors.deepOrange, fontSize: 16),
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.deepOrange)),
                    suffixIcon: const Icon(
                      Icons.edit,
                      color: Colors.deepOrange,
                    ),
                  ),
                  onChanged: ((String itemName){
                    _edit?
                    _item.itemName = itemName
                        : this._itemName = itemName;
                  }),
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                flex: 1,
                child: TextFormField(
                  style: const TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  enableInteractiveSelection: false,
                  initialValue: _edit? this._item.unitPrice.toString() : "",
                  decoration: InputDecoration(
                    labelText: "Unit Price",
                    labelStyle:
                        const TextStyle(color: Colors.deepOrange, fontSize: 16),
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.deepOrange)),
                    suffixIcon: const Icon(
                      Icons.edit,
                      color: Colors.deepOrange,
                    ),
                    prefixText: '₹',
                    prefixStyle: const TextStyle(color: Colors.deepOrange),
                  ),
                  onChanged: ((String unitPrice){
                    _edit?
                    _item.unitPrice = double.parse(unitPrice)
                        : _unitPrice = double.parse(unitPrice);
                  }),
                ),
              ),
              SizedBox(height: 5),
              OutlineButton(
                child: Text(
                  "Save",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
                highlightedBorderColor: Colors.green,
                disabledBorderColor: Colors.green,
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                onPressed: () {
                  _edit?
                      _itemProvider.editItem(this._item)
                      :_itemProvider.addItem(createItem(_itemName, _unitPrice, _itemCategory));
                  Navigator.pop(context);
                  this.refresh();
                },
              ),
            ]),
      ),
    );
  }

  Item createItem(
      String itemName, double unitPrice, ItemCategory itemCategory) {
    Item item = new Item(
        itemId: _uuid.v1(),
        itemName: itemName,
        itemDescription: null,
        itemCategory: itemCategory,
        unitPrice: unitPrice
    );
    print(item);
    return item;
  }
}
