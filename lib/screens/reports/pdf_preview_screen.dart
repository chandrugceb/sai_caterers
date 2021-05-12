import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:share/share.dart';

class PDFPreviewScreen extends StatelessWidget{
  String _filePath;
  PDFPreviewScreen(this._filePath);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text(this._filePath.split("/").last),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.shareFiles([_filePath], text: "file");
              },
            ),
          ],
        ),
        path: _filePath
    );
  }

}