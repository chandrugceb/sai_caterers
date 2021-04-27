import 'package:flutter/material.dart';
import 'package:provider/provider.dart'  hide BuildContext;
import 'package:sai_caterers/models/event_model.dart';
import 'package:sai_caterers/providers/event_provider.dart';
import 'package:sai_caterers/widgets/items/items_widget.dart';
import 'package:sai_caterers/widgets/plates/plates_display_widget.dart';
import 'package:sai_caterers/widgets/plates/plates_item_list_widget.dart';

class EventsWidget extends StatelessWidget {
  OrderEvent event;
  EventsWidget(this.event);

  @override
  Widget build(BuildContext contextPlatesWidget) {
    print("________PlatesWidget");

    return PlatesSubWidget();
  }
}

class PlatesSubWidget extends StatelessWidget{
  @override
  Widget build(BuildContext _platesSubWidgetContext) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            PlatesDisplayWidget(null),
            PlatesItemListWidget(),
          ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(_platesSubWidgetContext, MaterialPageRoute(builder: (context) => ItemsWidget(_platesSubWidgetContext)));
        },
        child: Icon(Icons.add_sharp, color: Colors.white),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}
