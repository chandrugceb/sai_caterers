import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlatesDisplayPersonsWidget extends StatelessWidget {
  int count;
  String subText;
  bool money;
  double width;

  PlatesDisplayPersonsWidget(
      this.width, this.money, this.count, this.subText);

  @override
  Widget build(BuildContext context) {
    print("________PlatesDisplayPersonsWidget");
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * this.width,
      height: MediaQuery.of(context).size.width * this.width,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: this.money
              ? NumberFormat.currency(
                      locale: 'en_IN', symbol: '₹', decimalDigits: 0)
                  .format(count)
              : '$count',
          style: TextStyle(
              color: Colors.deepOrange, fontSize: 26, fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(
              text: '\n$subText',
              style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
