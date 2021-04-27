import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide BuildContext;
import 'package:sai_caterers/models/event_model.dart';
import 'package:sai_caterers/widgets/plates/plates_item_widget.dart';

class PlatesItemListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext contextPlatesItemListWidget) {
    print("________PlatesItemListWidget");
    return Expanded(
      child: Container(
        child: Consumer<OrderEvent>(
          builder: (contextConsumer, data, child) {
            return ListView.builder(
              padding: EdgeInsets.only(top: 10.0, bottom: 60.0),
              itemCount: data.plateItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    data.plateItems.removeAt(index);
                    data.calculatePrice();
                  },
                  child: PlatesItemWidget(index, data.plateItems[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }


}
