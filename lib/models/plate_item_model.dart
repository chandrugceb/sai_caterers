import 'item_model.dart';

class PlateItem{
  Item _item;
  int _qty;
  double _plateItemPrice;

  PlateItem(this._item, this._qty){
    updatePlatePrice();
  }

  void updatePlatePrice() {
    _plateItemPrice = this._item.unitPrice * this._qty;
  }

  double get plateItemPrice => _plateItemPrice;

  int get qty => _qty;

  void updatePlateQty(int _qty){
    this._qty = _qty;
    updatePlatePrice();
  }

  Item get item => _item;
}