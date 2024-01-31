import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> generateCenteredText(String text, String fileName) async {
    // making a pdf document to store a text and it is provided by pdf package
    final pdf = Document(pageMode: PdfPageMode.outlines, title: "Drona Foundation", subject: "Urgent Action Required Regarding Internship Participation");

    // Text is added here in center
    pdf.addPage(Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => Center(
        child: Text(text, style: const TextStyle(fontSize: 13)),
      ),
    ));

    // passing the pdf and name of the document to make a directory in  the internal storage
    return saveDocument(name: '$fileName.pdf', pdf: pdf);
  }

  // it will make a named directory in the internal storage and then return to its call
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    // pdf save to the variable called bytes
    final bytes = await pdf.save();

    // here a beautiful package path provider helps us and take directory and name of the file and made a proper file in internal storage
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    // returning the file to the top most method which is generate centered text.
    return file;
  }
}
