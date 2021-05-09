import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide BuildContext;
import 'package:sai_caterers/providers/event_provider.dart';
import 'package:sai_caterers/providers/item_provider.dart';
import 'package:sai_caterers/widgets/dashboard/dashboard_widget.dart';
import 'package:sai_caterers/widgets/items/items_widget.dart';
import 'package:sai_caterers/widgets/orders/orders_widget.dart';
import 'package:sai_caterers/widgets/plates/events_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sai_caterers/models/oldevent_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  final List<Widget> _children = [
    DashboardWidget(),
    ItemsWidget(null),
    OrdersWidget(),
    EventsWidget()
  ];

  ItemProvider _itemProvider;
  OrderEventsProvider _orderEventProvider;

  @override
  void initState() {
    _itemProvider = new ItemProvider();
    _orderEventProvider = new OrderEventsProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //ListenableProvider<ItemProvider>(create: (context) => _itemProvider),
        ListenableProvider<OrderEventsProvider>(create: (context) => _orderEventProvider)
      ],
      child: Scaffold(
        body: _children[_currentTab],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentTab,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: 30.0,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Home',
                  style: TextStyle(
                    color: Color(0xFFFF6D00),
                  )),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.restaurant_menu_outlined,
                size: 30.0,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Items',
                  style: TextStyle(
                    color: Color(0xFFFF6D00),
                  )),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.business_center_outlined,
                size: 30.0,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Orders',
                  style: TextStyle(
                    color: Color(0xFFFF6D00),
                  )),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_business_outlined,
                size: 30.0,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Plates',
                  style: TextStyle(
                    color: Color(0xFFFF6D00),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    if(index == 3){
      return;
    }
    setState(() {
      _currentTab = index;
    });
  }
}
