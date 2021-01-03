import 'package:flutter/material.dart';
import 'package:provider/provider.dart'  hide BuildContext;
import 'package:sai_caterers/models/plate_model.dart';
import 'package:sai_caterers/widgets/items/items_widget.dart';
import 'package:sai_caterers/widgets/plates/plates_display_widget.dart';
import 'package:sai_caterers/widgets/plates/plates_item_list_widget.dart';

class PlatesWidget extends StatelessWidget {
  Plate plate;

  @override
  Widget build(BuildContext contextPlatesWidget) {
    print("________PlatesWidget");
    if (true) {
      plate = new Plate(1, "My Plate", DateTime.now());
      plate.persons = 50;
     // plate.loadDummyData();
    }
    return ChangeNotifierProvider(
      create: (contextChangeNotifierProvider) => plate,
      child: PlatesSubWidget(),
    );
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
