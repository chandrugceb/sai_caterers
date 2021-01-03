import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide BuildContext;
import 'package:sai_caterers/models/plate_model.dart';
import 'package:sai_caterers/widgets/plates/plates_display_persons_widget.dart';

class PlatesDisplayWidget extends StatelessWidget {
  Plate _plate;
  BuildContext parentContext;

  PlatesDisplayWidget(this.parentContext);

  @override
  Widget build(BuildContext contextPlatesDisplayWidget) {
    print("________PlatesDisplayWidget");
    if (parentContext == null) {
      this.parentContext = contextPlatesDisplayWidget;
    }
    this._plate = Provider.of<Plate>(parentContext);

    return Column(
      children: [
        Container(height: 20, width: double.infinity,
          child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.amber
          ),
        ),),
        Container(
          // Display Container
          constraints: BoxConstraints.expand(
            // Creating a boxed container
            height: Theme.of(contextPlatesDisplayWidget)
                        .textTheme
                        .headline4
                        .fontSize *
                    1.1 +
                50.0,
          ),
          alignment: Alignment.centerLeft,
          color: Colors.amber, // Seting the background color of the container
          child: Row(
            children: <Widget>[
              PlatesDisplayPersonsWidget(
                  0.25, false, _plate.persons, 'Persons'),
              PlatesDisplayPersonsWidget(
                  0.15, false, _plate.plateItems.length, 'Items'),
              PlatesDisplayPersonsWidget(
                  0.4, true, _plate.totalPrice.toInt(), 'Total Cost'),
              PlatesDisplayPersonsWidget(
                  0.2, true, _plate.perPlatePrice.toInt(), 'Per Plate')
            ],
          ),
        ),
      ],
    );
  }
}
