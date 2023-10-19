import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:the_app/constants/img_path.dart';


class ShowReport extends StatelessWidget {
  final CollectionReference<Map<String, dynamic>> collection =
  FirebaseFirestore.instance.collection('logistics');

  ShowReport({super.key});

  Future<void> generatePDF() async {
    // Fetch data from Firebase
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection.get();
    List<Map<String, dynamic>> data = querySnapshot.docs.map((doc) => doc.data()).toList();

    // Generate PDF and fetch a Logo
    final pdf = pw.Document();
    final ByteData image = await rootBundle.load(taSplashImage);
    Uint8List imageData = (image).buffer.asUint8List();

    // Specify the fields you want to include in the PDF
    List<String> fieldName = ['No', 'Jenis Barang', 'Nama', 'Perolehan', 'Stok', 'Satuan', 'Kadaluarsa'];
    List<String> fieldContentsFrom = ['Kategori', 'Nama Barang', 'Asal Perolehan', 'Stok', 'Satuan'];

    pdf.addPage(
      pw.Page(
        build: (context) {
          // Define column widths
          // Define column widths
          Map<int, pw.TableColumnWidth> columnWidths = {
            0: const pw.FixedColumnWidth(30.0), // 'No' column
            1: const pw.FixedColumnWidth(55.0), // 'Jenis Barang' column
            2: const pw.FixedColumnWidth(60.0), // 'Nama' column
            3: const pw.FixedColumnWidth(60.0), // 'Perolehan' column
            4: const pw.FixedColumnWidth(35.0), // 'stok' column
            5: const pw.FixedColumnWidth(40.0), // 'Satuan' column
            6: const pw.FixedColumnWidth(60.0), // 'Tanggal' column
            // Add more fields and their corresponding widths
          };
          return pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Text(
                        'Laporan Logistik',
                        style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                  ),
                  pw.Image(
                      pw.MemoryImage(imageData),
                      height: 100,
                      width: 100
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              pw.Table(
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                border: pw.TableBorder.all(),
                columnWidths: columnWidths,
                children: [
                  pw.TableRow(
                    children: fieldName.map((fields) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                            fields,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center
                        ),
                      );
                    }).toList(),
                  ),

                  // Data rows
                  ...data.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> row = entry.value;

                    DateTime date = (row['Tanggal Kadaluarsa']).toDate();
                    String formatted = DateFormat('EEEE, d MMMM yyyy').format(date);

                    return pw.TableRow(
                      children: [
                        // 'No' column
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                              (index + 1).toString(),
                              textAlign: pw.TextAlign.center
                          ),
                        ),
                        // Data columns
                        ...fieldContentsFrom.map((fieldName) {
                          final fieldValue = row[fieldName];

                          // Check if the field is a number and convert it to int
                          final formattedValue = fieldValue is num ? fieldValue.toInt().toString() : fieldValue.toString();

                          return pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(formattedValue, textAlign: pw.TextAlign.center),
                          );
                        }).toList(),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(formatted, textAlign: pw.TextAlign.center),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              )
            ]
          );
        },
      ),
    );

    // Save the PDF to Documents directory
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/example.pdf");

    final bytes = await pdf.save(); // Await here to get the actual bytes

    await file.writeAsBytes(bytes);

    // Share the PDF file
    Share.shareFiles([file.path]);
    // Open the PDF using a PDF viewer or implement sharing/saving logic as needed.
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase PDF Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: generatePDF,
          child: Text('Generate PDF from Firebase'),
        ),
      ),
    );
  }
}
