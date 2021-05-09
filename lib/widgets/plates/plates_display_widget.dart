import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide BuildContext;
import 'package:sai_caterers/models/event_model.dart';
import 'package:sai_caterers/providers/event_provider.dart';
import 'package:sai_caterers/widgets/plates/plates_display_persons_widget.dart';

class PlatesDisplayWidget extends StatelessWidget {
  OrderEvent _event;
  BuildContext parentContext;

  PlatesDisplayWidget(this.parentContext);

  @override
  Widget build(BuildContext contextPlatesDisplayWidget) {
    print("________PlatesDisplayWidget");
    if (parentContext == null) {
      this.parentContext = contextPlatesDisplayWidget;
    }
    this._event = Provider.of<OrderEvent>(parentContext);

    return Column(
      children: [
        Container(height: 5, width: double.infinity,
          child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.amber[100],
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
                30.0,
          ),
          alignment: Alignment.centerLeft,
          color: Colors.amber[100], // Seting the background color of the container
          child: Row(
            children: <Widget>[
              PlatesDisplayPersonsWidget(
                  0.25, false, _event.persons, 'Persons'),
              PlatesDisplayPersonsWidget(
                  0.15, false, _event.plateItems.length, 'Items'),
              PlatesDisplayPersonsWidget(
                  0.4, true, _event.totalPrice.toInt(), 'Total Cost'),
              PlatesDisplayPersonsWidget(
                  0.2, true, _event.perPlatePrice.toInt(), 'Per Plate')
            ],
          ),
        ),
      ],
    );
  }


}
