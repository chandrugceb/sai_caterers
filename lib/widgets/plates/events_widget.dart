import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide BuildContext;
import 'package:sai_caterers/models/event_model.dart';
import 'package:sai_caterers/providers/event_provider.dart';
import 'package:sai_caterers/providers/item_provider.dart';
import 'package:sai_caterers/screens/reports/pdf_preview_screen.dart';
import 'package:sai_caterers/services/pdf_service.dart';
import 'package:sai_caterers/widgets/items/items_widget.dart';
import 'package:sai_caterers/widgets/plates/plates_display_widget.dart';
import 'package:sai_caterers/widgets/plates/plates_item_list_widget.dart';
import 'dart:async';

class EventsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext contextPlatesWidget) {
    print("________PlatesWidget");

    return PlatesSubWidget();
  }
}

class PlatesSubWidget extends StatelessWidget {
  Timer _debounce;
  OrderEventsProvider _orderEventsProvider;
  OrderEvent _orderEvent;
  static const _formTextStyle = TextStyle(
      color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold);
  static const _inputDecoration = InputDecoration(
    labelText: "Label Text",
    labelStyle: const TextStyle(color: Colors.deepOrange, fontSize: 16),
    /*border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amberAccent)),*/
    suffixIcon: const Icon(
      Icons.edit,
      color: Colors.amberAccent,
    ),
  );

  @override
  Widget build(BuildContext _platesSubWidgetContext) {
    _orderEventsProvider = Provider.of<OrderEventsProvider>(
        _platesSubWidgetContext,
        listen: false);
    _orderEvent =
        Provider.of<OrderEvent>(_platesSubWidgetContext, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(_orderEvent.eventName),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded),
            tooltip: 'Share',
            onPressed: () async {
            PdfService _pdfService = new PdfService(_orderEvent);
            await _pdfService.savePdf();
            Navigator.push(_platesSubWidgetContext, MaterialPageRoute(builder: (context) => PDFPreviewScreen(_pdfService.finalDocPath)));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ExpansionTile(
                title: Center(
                  child: Text("Event Details",
                      style: TextStyle(
                          color: Colors.amber[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 30)),
                ),
                children: <Widget>[
                  EventDetailsForm(_orderEvent),
                ],
              ),
              PlatesDisplayWidget(null),
              PlatesItemListWidget(),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add your onPressed code here!
          await Navigator.push(
            _platesSubWidgetContext,
            MaterialPageRoute(
                builder: (context) => ItemsWidget(_platesSubWidgetContext)),
          );
          _orderEventsProvider.editEvent(_orderEvent);
        },
        child: Icon(Icons.add_sharp, color: Colors.white),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  Widget EventDetailsForm(OrderEvent orderEvent) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Form(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextFormField(
              style: PlatesSubWidget._formTextStyle,
              keyboardType: TextInputType.text,
              autofocus: true,
              enableInteractiveSelection: false,
              initialValue: _orderEvent.eventName,
              decoration: PlatesSubWidget._inputDecoration
                  .copyWith(labelText: "Event Name"),
              onChanged: (String value) {
                if (_debounce?.isActive ?? false) _debounce.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  _orderEvent.eventName = value;
                  _orderEventsProvider.editEvent(_orderEvent);
                });
              }),
          TextFormField(
              style: PlatesSubWidget._formTextStyle,
              keyboardType: TextInputType.number,
              autofocus: true,
              enableInteractiveSelection: false,
              initialValue: _orderEvent.persons.toString(),
              decoration: PlatesSubWidget._inputDecoration
                  .copyWith(labelText: "Persons"),
              onChanged: (String value) {
                if (_debounce?.isActive ?? false) _debounce.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  _orderEvent.updatePersons(int.parse(value));
                  _orderEventsProvider.editEvent(_orderEvent);
                });

              }),
          TextFormField(
              style: PlatesSubWidget._formTextStyle,
              keyboardType: TextInputType.text,
              autofocus: true,
              enableInteractiveSelection: false,
              initialValue: _orderEvent.customerName,
              decoration: PlatesSubWidget._inputDecoration
                  .copyWith(labelText: "Customer Name"),
              onChanged: (String value) {
                if (_debounce?.isActive ?? false) _debounce.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  _orderEvent.customerName = value;
                  _orderEventsProvider.editEvent(_orderEvent);
                });
              }),
          TextFormField(
              style: PlatesSubWidget._formTextStyle,
              keyboardType: TextInputType.text,
              autofocus: true,
              enableInteractiveSelection: false,
              initialValue: _orderEvent.customerPhone,
              decoration: PlatesSubWidget._inputDecoration
                  .copyWith(labelText: "Customer Phone"),
              onChanged: (String value) {
                if (_debounce?.isActive ?? false) _debounce.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  _orderEvent.customerPhone = value;
                  _orderEventsProvider.editEvent(_orderEvent);
                });
              }),
          DateTimePicker(
            type: DateTimePickerType.dateTimeSeparate,
            dateMask: 'd MMM, yyyy',
            initialValue: _orderEvent.startDateTime.toString(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            icon: Icon(Icons.event),
            dateLabelText: 'Event Start Date',
            timeLabelText: "Time",
            onChanged: (val) {
              _orderEvent.startDateTime = DateTime.parse(val);
              _orderEventsProvider.editEvent(_orderEvent);
            },
          ),
          DateTimePicker(
            type: DateTimePickerType.dateTimeSeparate,
            dateMask: 'd MMM, yyyy',
            initialValue: _orderEvent.orderDeliveryDateTime.toString(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            icon: Icon(Icons.event),
            dateLabelText: 'Order Delivery Date',
            timeLabelText: "Time",
            onChanged: (val) {
              _orderEvent.orderDeliveryDateTime = DateTime.parse(val);
              _orderEventsProvider.editEvent(_orderEvent);
            },
          ),
          DateTimePicker(
            type: DateTimePickerType.dateTimeSeparate,
            dateMask: 'd MMM, yyyy',
            initialValue: _orderEvent.orderReadyDateTime.toString(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            icon: Icon(Icons.event),
            dateLabelText: 'Order Ready Date',
            timeLabelText: "Time",
            onChanged: (val) {
              _orderEvent.orderReadyDateTime = DateTime.parse(val);
              _orderEventsProvider.editEvent(_orderEvent);
            },
          ),
          TextFormField(
              style: PlatesSubWidget._formTextStyle,
              keyboardType: TextInputType.text,
              autofocus: true,
              enableInteractiveSelection: false,
              initialValue: _orderEvent.cookingVenue,
              decoration: PlatesSubWidget._inputDecoration
                  .copyWith(labelText: "Cooking Venue"),
              onChanged: (String value) {
                if (_debounce?.isActive ?? false) _debounce.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  _orderEvent.cookingVenue = value;
                  _orderEventsProvider.editEvent(_orderEvent);
                });
              }),
          TextFormField(
              style: PlatesSubWidget._formTextStyle,
              keyboardType: TextInputType.multiline,
              autofocus: true,
              enableInteractiveSelection: false,
              initialValue: _orderEvent.eventNotes,
              maxLines: 10,
              decoration: PlatesSubWidget._inputDecoration
                  .copyWith(labelText: "Event Notes"),
              onChanged: (String value) {
                if (_debounce?.isActive ?? false) _debounce.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  _orderEvent.eventNotes = value;
                  _orderEventsProvider.editEvent(_orderEvent);
                });
              }),
        ],
      )),
    );
  }
}
