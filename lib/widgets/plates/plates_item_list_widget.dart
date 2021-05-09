import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide BuildContext;
import 'package:sai_caterers/models/event_model.dart';
import 'package:sai_caterers/providers/event_provider.dart';
import 'package:sai_caterers/providers/item_provider.dart';
import 'package:sai_caterers/widgets/plates/plates_item_widget.dart';

class PlatesItemListWidget extends StatelessWidget {
  OrderEventsProvider _orderEventsProvider;

  @override
  Widget build(BuildContext contextPlatesItemListWidget) {
    _orderEventsProvider = Provider.of<OrderEventsProvider>(contextPlatesItemListWidget, listen: false);
    print("________PlatesItemListWidget");
    return Consumer<OrderEvent>(
          builder: (contextConsumer, data, child) {
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10.0, bottom: 60.0),
              itemCount: data.plateItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    data.plateItems.removeAt(index);
                    data.calculatePrice();
                    _orderEventsProvider.editEvent(data);
                  },
                  child: PlatesItemWidget(index, data.plateItems[index]),
                );
              },
            );
          },
    );
  }
}
