import 'package:flutter/material.dart';

class DashboardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Center(
                child: Text(
                  'R V Catering',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6D00),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(200.0)),
                child: Image.asset('images/sai.jpg'),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(4.0, 4.0),
                    blurRadius: 5.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}