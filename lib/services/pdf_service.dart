import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sai_caterers/models/event_model.dart';

class PdfService{
  final pdf = pw.Document();
  final OrderEvent _orderEvent;
  PdfService(this._orderEvent);
  String finalDocPath;

  _writeOnPdf(){
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context){
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: <pw.Widget>[
              _Header(),
              _Table(),
            ]
          );
        }
      )
    );
  }

  Future savePdf() async {
    _writeOnPdf();
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    finalDocPath = "$documentPath/" + _orderEvent.eventName.replaceAll(RegExp('\\s+'), '_') + ".pdf";
    File file = new File(finalDocPath);
    file.writeAsBytesSync(pdf.save());
  }


  pw.Widget _Header(){
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: <pw.Widget>[
            // ignore: deprecated_member_use
            pw.Header(
              level: 0,
              child: pw.Center(child: pw.Text(_orderEvent.eventName)),
            )

        ]
    );
  }

  pw.Widget _Table(){
    List<List<String>> _tableData = [];
    _tableData.add(["S.No", "Item", "Unit Price", "Qty", "SubTotal"]);
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


    return pw.Table.fromTextArray(data: _tableData);

  }

}