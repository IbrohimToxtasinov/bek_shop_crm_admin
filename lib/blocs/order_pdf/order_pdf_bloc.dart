import 'dart:io';
import 'package:bek_shop/utils/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:open_filex/open_filex.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:bek_shop/data/models/order/order_model.dart';

part 'order_pdf_event.dart';

part 'order_pdf_state.dart';

class OrderPdfBloc extends Bloc<OrderPdfEvent, OrderPdfState> {
  OrderPdfBloc() : super(OrderPdfInitial()) {
    on<GenerateAndSharePdfEvent>(_generateAndSharePdf);
  }

  Future<void> _generateAndSharePdf(
    GenerateAndSharePdfEvent event,
    Emitter<OrderPdfState> emit,
  ) async {
    emit(OrderPdfLoading());
    await Future.delayed(Duration(seconds: 2));
    try {
      final filePath = await _generatePDF(event.order);
      emit(OrderPdfGenerated(filePath));

      await Future.delayed(Duration(seconds: 2));
      emit(OrderPdfInitial());
      if (event.share) {
        await Share.shareXFiles([XFile(filePath)], text: "Buyurtma tafsilotlari PDF");
      } else {
        OpenFilex.open(filePath);
      }
    } catch (e) {
      emit(OrderPdfError("PDF yaratishda xatolik yuz berdi!"));
    }
  }

  Future<String> _generatePDF(OrderModel order) async {
    final pdf = pw.Document();

    final qrData =
        "https://www.google.com/maps/search/?api=1&query=${order.latLong.latitude},${order.latLong.longitude}";

    final qrCode = pw.BarcodeWidget(
      barcode: pw.Barcode.qrCode(),
      data: qrData,
      width: 100,
      height: 100,
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build:
            (pw.Context context) => [
              pw.Header(
                level: 0,
                text: "Buyurtma Tafsilotlari",
                textStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24),
              ),
              pw.SizedBox(height: 10),

              _buildDetailRow("Buyurtma ID:", order.orderId),
              _buildDetailRow("Mijoz:", order.clientName),
              _buildDetailRow("Telefon:", order.clientPhoneNumber),
              _buildDetailRow("Manzil:", order.clientAddress),
              _buildDetailRow("Buyurtma vaqti:", AppUtils.formatDate(order.createAt)),

              pw.SizedBox(height: 10),

              pw.Table.fromTextArray(
                headers: ["Mahsulot", "Narxi", "Miqdori", "Jami"],
                data:
                    order.products
                        .map(
                          (product) => [
                            product.productName,
                            "${NumberFormat.decimalPattern('uz_UZ').format(product.productPrice)} so'm",
                            "${product.count} ${product.isCountable ? "dona" : "kg"}",
                            "${NumberFormat.decimalPattern('uz_UZ').format(product.productPrice * product.count)} so'm",
                          ],
                        )
                        .toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.center,
                border: pw.TableBorder.all(color: PdfColors.grey),
                cellPadding: const pw.EdgeInsets.all(5),
              ),

              pw.SizedBox(height: 10),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Jami summa: ${NumberFormat.decimalPattern('uz_UZ').format(order.totalPrice)} so'm",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
                ),
              ),

              pw.SizedBox(height: 20),
              pw.Text(
                "Aloqa uchun:",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
              ),
              pw.SizedBox(height: 5),
              pw.Text("+998 (99) 666-88-89", style: pw.TextStyle(fontSize: 14)),

              pw.SizedBox(height: 20),
              pw.Text("Manzilni QR kod orqali oching:"),
              pw.SizedBox(height: 20),
              qrCode,
            ],
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/Order_ID_${order.orderId}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }
}

pw.Widget _buildDetailRow(String title, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 5),
    child: pw.Row(
      children: [
        pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(width: 5),
        pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.normal)),
      ],
    ),
  );
}
