import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'  hide BuildContext;
import 'package:sai_caterers/models/event_model.dart';
import 'package:sai_caterers/providers/event_provider.dart';

class EditPlateItemScreen extends StatefulWidget {
  int _index;
  BuildContext contextPlatesItemWidget;
  EditPlateItemScreen(this._index, this.contextPlatesItemWidget);

  _EditPlateItemScreenState createState() =>
      _EditPlateItemScreenState(this._index, this.contextPlatesItemWidget);
}

class _EditPlateItemScreenState extends State<EditPlateItemScreen> {
  int _index;
  OrderEvent _orderEvent;
  OrderEventsProvider _orderEventsProvider;
  BuildContext contextPlatesItemWidget;
  _EditPlateItemScreenState(this._index, this.contextPlatesItemWidget){
    this._orderEventsProvider = Provider.of<OrderEventsProvider>(contextPlatesItemWidget, listen: false);
    this._orderEvent = Provider.of<OrderEvent>(contextPlatesItemWidget, listen:false);
  }
  @override
  Widget build(BuildContext context) {
    print("edit plate item screen build was called");
    return Container(
        child: Container(
          width: 300,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                  style: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.number,
                  enableInteractiveSelection: false,
                  autofocus: false,
                  initialValue: this._orderEvent.plateItems[_index].item.unitPrice.toString(),
                  decoration: InputDecoration(
                      labelText: "Unit Price",
                      labelStyle: const TextStyle(color: Colors.amberAccent, fontSize: 16),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.amberAccent)),
                      suffixIcon: const Icon(
                        Icons.edit,
                        color: Colors.amberAccent,
                      ),
                      prefixText: '₹',
                      prefixStyle: const TextStyle(color: Colors.amber)),
                  onChanged: (String value) {
                    this._orderEvent.plateItems[_index].item.unitPrice =
                        double.parse(value);
                    this._orderEvent.plateItems[_index].updatePlatePrice();
                    this._orderEvent.calculatePrice();
                    this._orderEventsProvider.editEvent(_orderEvent);
                    setState(() {});
                  }),
            ),
            SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: TextFormField(
                  style: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  enableInteractiveSelection: false,
                  initialValue: this._orderEvent.plateItems[_index].qty.toString(),
                  decoration: InputDecoration(
                    labelText: "Qty",
                    labelStyle: const TextStyle(color: Colors.amberAccent, fontSize: 16),
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.amberAccent)),
                    suffixIcon: const Icon(
                      Icons.edit,
                      color: Colors.amberAccent,
                    ),
                  ),
                  onChanged: (String value) {
                    this
                        ._orderEvent
                        .plateItems[_index]
                        .updatePlateQty(int.parse(value));
                    this._orderEvent.plateItems[_index].updatePlatePrice();
                    this._orderEvent.calculatePrice();
                    this._orderEventsProvider.editEvent(_orderEvent);
                    setState(() {});
                  }),
            )
          ]),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.width * 0.25,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: NumberFormat.currency(
                    locale: 'en_IN', symbol: '₹', decimalDigits: 0)
                    .format(this._orderEvent.plateItems[_index].plateItemPrice),
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                    text: '\nPrice',
                    style: TextStyle(color: Colors.amberAccent, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          ]),
        ),
      );
  }
}
