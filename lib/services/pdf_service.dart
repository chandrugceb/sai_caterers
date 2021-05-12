import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets/basic.dart';
import 'package:pdf/widgets/decoration.dart';
import 'package:pdf/widgets/geometry.dart';
import 'package:pdf/widgets/page_theme.dart';
import 'package:pdf/widgets/text_style.dart';
import 'package:sai_caterers/models/event_model.dart';

class PdfService {
  final pdf = pw.Document();
  final OrderEvent _orderEvent;
  PdfService(this._orderEvent);
  String finalDocPath;
  Uint8List _imageUint8List;
  _writeOnPdf() {
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: <pw.Widget>[
                  _mainHeaderBuilder(),
                  pw.SizedBox(height: 10),
                  _eventHeaderBuilder(),
                  _eventDetailsBuilder(),
                  pw.SizedBox(height: 10),
                  _invoiceTableBuilder(),
                  pw.Divider(),
                  _totalBuilder(),
                  pw.SizedBox(height: 20),
                  _eventNotes(),
                ])
          ];
        }));
  }

  Future savePdf() async {
    await loadAsset();
    _writeOnPdf();
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    finalDocPath = "$documentPath/" +
        _orderEvent.eventName.replaceAll(RegExp('\\s+'), '_') +
        ".pdf";
    File file = new File(finalDocPath);
    file.writeAsBytesSync(pdf.save());
  }

  void loadAsset() async {
    Uint8List data =
        (await rootBundle.load('images/sai.jpg')).buffer.asUint8List();
    _imageUint8List = data;
  }

  pw.Widget _mainHeaderBuilder() {
    final saiImage = pw.MemoryImage(_imageUint8List);
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: <pw.Widget>[
          pw.Expanded(flex: 2, child: pw.Image.provider(saiImage, height: 100)),
          pw.Expanded(
            flex: 6,
            child: pw.Center(
              child: pw.Text(
                "RV Catering",
                style: pw.TextStyle(
                  color: PdfColor.fromInt(0xffe06c6c),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          pw.Expanded(flex: 2),
        ]);
  }

  pw.Widget _eventHeaderBuilder() {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: <pw.Widget>[
          // ignore: deprecated_member_use
          pw.Header(
            level: 0,
            child: pw.Center(
                child: pw.Text(
              _orderEvent.eventName,
              style: pw.TextStyle(
                color: PdfColor.fromInt(0xffe06c6c),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            )),
          )
        ]);
  }

  pw.Widget _invoiceTableBuilder() {
    List<List<String>> _tableData = [];
    //_tableData.add(["S.No", "Item", "Unit Price", "Qty", "SubTotal"]);
    int counter = 0;
    _orderEvent.plateItems.forEach((_plateItem) {
      List<String> _row = <String>[
        (++counter).toString(),
        _plateItem.item.itemName,
        _plateItem.item.unitPrice.toString(),
        _plateItem.qty.toString(),
        (_plateItem.item.unitPrice * _plateItem.qty).toString()
      ];
      _tableData.add(_row);
    });

    return pw.Table.fromTextArray(
        headers: <String>[
          "S.No",
          "Item",
          "Unit Price (INR)",
          "Qty",
          "SubTotal (INR)"
        ],
        border: null,
        headerStyle: pw.TextStyle(
          fontWeight: FontWeight.bold,
        ),
        headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
        cellHeight: 30,
        cellAlignments: {
          0: pw.Alignment.center,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.centerRight,
          4: pw.Alignment.centerRight,
        },
        headerAlignments: {
          0: pw.Alignment.center,
          1: pw.Alignment.center,
          2: pw.Alignment.center,
          3: pw.Alignment.center,
          4: pw.Alignment.center,
        },
        data: _tableData);
  }

  _totalBuilder() {
    final _netTotal = _orderEvent.plateItems
        .map((_plateItem) => _plateItem.item.unitPrice * _plateItem.qty)
        .reduce((item1, item2) => item1 + item2);
    return pw.Container(
        alignment: pw.Alignment.centerRight,
        child: pw.Row(
          children: [
            pw.Spacer(flex: 6),
            pw.Expanded(
              flex: 4,
              child: pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          "Total",
                          style: pw.TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 7,
                        child: pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            "INR " + _netTotal.toString(),
                            style: pw.TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  pw.Divider(),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 5,
                        child: pw.Text(
                          "Per Plate",
                          style: pw.TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 5,
                        child: pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            "INR " +
                                (_netTotal / _orderEvent.persons).toString(),
                            style: pw.TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  pw.Divider(),
                ],
              ),
            )
          ],
        ));
  }

  pw.Widget _buildSimpleTextPair({
    String title,
    String value,
  }) {
    final style = pw.TextStyle(fontWeight: pw.FontWeight.bold);
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(title, style: style),
        pw.SizedBox(width: 2 * PdfPageFormat.mm),
        pw.Text(value),
      ],
    );
  }

  pw.Widget _buildTextPair({
    String title,
    String value,
    double width = 250,
    bool unite = false,
  }) {
    final style = pw.TextStyle(fontWeight: FontWeight.bold);

    return pw.Container(
      width: width,
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text(title, style: style)),
          pw.Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  pw.Widget _eventDetailsBuilder() {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.max,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(children: [
          _buildTextPair(
            title: "Event Start : ",
            value: _orderEvent.startDateTime.toString(),
          ),
          _buildTextPair(
            title: "Order Delivery : ",
            value: _orderEvent.orderDeliveryDateTime.toString(),
          ),
          _buildTextPair(
            title: "Order Ready : ",
            value: _orderEvent.orderReadyDateTime.toString(),
          ),
          _buildTextPair(
            title: "Cooking Venue : ",
            value: _orderEvent.cookingVenue.toString(),
          ),
        ]),
        pw.Column(children: [
          _buildTextPair(
            title: "Customer Name : ",
            value: _orderEvent.customerName.toString(),
          ),
          _buildTextPair(
            title: "Customer Phone : ",
            value: _orderEvent.customerPhone.toString(),
          ),
          _buildTextPair(
            title: "Persons : ",
            value: _orderEvent.persons.toString(),
          ),
        ])
      ],
    );
  }

  pw.Widget _eventNotes() {
    return pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
      pw.Text("Event Notes"),
      pw.Divider(),
      pw.Text(_orderEvent.eventNotes.toString()),
    ]);
  }
}
