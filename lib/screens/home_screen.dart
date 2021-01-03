import 'package:flutter/material.dart';
import 'package:provider/provider.dart'  hide BuildContext;
import 'package:sai_caterers/models/items_model.dart';
import 'package:sai_caterers/widgets/dashboard/dashboard_widget.dart';
import 'package:sai_caterers/widgets/items/items_widget.dart';
import 'package:sai_caterers/widgets/orders/orders_widget.dart';
import 'package:sai_caterers/widgets/plates/plates_widget.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  int _currentTab = 0;
  final List<Widget> _children = [
    DashboardWidget(),
    ItemsWidget(null),
    OrdersWidget(),
    PlatesWidget()
  ];

  Items items;

  @override
  Widget build(BuildContext context) {
    databaseReference.child("flutterDevsTeam1").set({
      'name': 'Deepak Nishad',
      'description': 'Team Lead'
    });
    items = new Items();
    items.loadDummyData();
    return ChangeNotifierProvider(
      create: (context) => items,
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
    setState(() {
      _currentTab = index;
    });
  }
}
