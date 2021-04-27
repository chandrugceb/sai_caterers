import 'package:flutter/material.dart';
import 'package:provider/provider.dart'  hide BuildContext;
import 'package:sai_caterers/models/plate_item_model.dart';
import 'package:sai_caterers/models/event_model.dart';
import 'dart:math';

class PlatesItemSlider extends StatefulWidget {
  int _index;
  PlatesItemSlider(this._index);
  _PlatesItemSliderState createState() => _PlatesItemSliderState(this._index);
}

class _PlatesItemSliderState extends State<PlatesItemSlider> {
  int _index;
  int _min = 0, _max = 0, _value = 0;
  OrderEvent _plate;
  PlateItem _plateItem;
  _PlatesItemSliderState(this._index);

  @override
  Widget build(BuildContext context) {
    this._plate = Provider.of<OrderEvent>(context, listen: false);
    this._plateItem = this._plate.plateItems[_index];
    print("_________PlatesItemSliderState for " + this._plateItem.item.itemName);
    _min = 0;
    _max = [this._plate.persons, this._plateItem.qty].reduce(max) + ([this._plate.persons, this._plateItem.qty].reduce(max) * 0.2).toInt();
    _value = this._plateItem.qty;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.red[700],
        inactiveTrackColor: Colors.red[100],
        trackShape: RoundedRectSliderTrackShape(),
        trackHeight: 4.0,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
        thumbColor: Colors.redAccent,
        overlayColor: Colors.red.withAlpha(32),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
        tickMarkShape: RoundSliderTickMarkShape(),
        activeTickMarkColor: Colors.red[700],
        inactiveTickMarkColor: Colors.red[100],
        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: Colors.redAccent,
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      child: Slider(
          value: this._value.toDouble(),
          min: this._min.toDouble(),
          max: this._max.toDouble(),
          divisions: 5,
          label: '$_value',
          onChanged: (value){
            setState(() {
              this._value = value.toInt();
              this._plateItem.updatePlateQty(value.toInt());
              this._plate.calculatePrice();
            });
          },
      ),
    );
  }
}
