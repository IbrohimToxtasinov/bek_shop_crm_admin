import 'dart:io';
import 'package:bek_shop/data/models/product/product_model.dart';
import 'package:bek_shop/data/repositories/product_repository.dart';
import 'package:bek_shop/utils/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:open_filex/open_filex.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

part 'products_pdf_event.dart';

part 'products_pdf_state.dart';

class ProductsPdfBloc extends Bloc<ProductsPdfEvent, ProductsPdfState> {
  ProductsPdfBloc(this._productRepository) : super(ProductsPdfInitial()) {
    on<GenerateAndSharePdfEvent>(_generateAndSharePdf);
    on<GenerateAndSharePdfForCategoryEvent>(_generateAndSharePdfForCategory);
  }

  final ProductRepository _productRepository;

  Future<void> _generateAndSharePdf(
    GenerateAndSharePdfEvent event,
    Emitter<ProductsPdfState> emit,
  ) async {
    emit(ProductsPdfLoading());
    try {
      final filePath = await _generatePDF(
        products: await _productRepository.getAllProducts(),
      );
      await Future.delayed(Duration(seconds: 2));
      emit(ProductsPdfGenerated(filePath));

      await Future.delayed(Duration(seconds: 2));
      emit(ProductsPdfInitial());
      if (event.share) {
        await Share.shareXFiles([XFile(filePath)], text: "Barcha productlar");
      } else {
        OpenFilex.open(filePath);
      }
    } catch (e) {
      emit(ProductsPdfError("PDF yaratishda xatolik yuz berdi!"));
    }
  }

  Future<void> _generateAndSharePdfForCategory(
    GenerateAndSharePdfForCategoryEvent event,
    Emitter<ProductsPdfState> emit,
  ) async {
    emit(CategoryProductsPdfLoading());
    try {
      final filePath = await _generatePDF(
        categoryName: event.categoryName,
        products: await _productRepository.getAllProductsByCategoryId(
          categoryId: event.categoryId,
        ),
      );
      await Future.delayed(Duration(seconds: 2));
      emit(CategoryProductsPdfGenerated(filePath));

      await Future.delayed(Duration(seconds: 2));
      emit(ProductsPdfInitial());
      if (event.share) {
        await Share.shareXFiles([
          XFile(filePath),
        ], text: "Barcha productlar: : ${event.categoryName}");
      } else {
        OpenFilex.open(filePath);
      }
    } catch (e) {
      emit(CategoryProductsPdfError("PDF yaratishda xatolik yuz berdi!"));
    }
  }

  Future<String> _generatePDF({
    required List<ProductModel> products,
    String? categoryName,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build:
            (pw.Context context) => [
              pw.Header(
                level: 0,
                text: categoryName ?? "Do'kondagi barcha mahsulotlar",
                textStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              pw.Row(
                children: [
                  pw.Text(
                    "Pdf yaratilgan vaqt:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(width: 5),
                  pw.Text(
                    AppUtils.formatDate(DateTime.now().toString()),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: [
                  "Mahsulot",
                  "Vaqti",
                  "Arzon",
                  "Qimmat",
                  "Tan Narxi",
                  "Miqdori",
                  "Jami",
                ],
                data:
                    products
                        .map(
                          (product) => [
                            product.productName,
                            product.updatedAt.isEmpty
                                ? ""
                                : (AppUtils.formatDateForPdf(
                                  product.updatedAt,
                                )),
                            "${NumberFormat.decimalPattern('uz_UZ').format(product.cheapPrice)} so'm",
                            "${NumberFormat.decimalPattern('uz_UZ').format(product.expensivePrice)} so'm",
                            "${NumberFormat.decimalPattern('uz_UZ').format(product.productPrice)} so'm",
                            "${product.productQuantity.toInt()} ${product.isCountable ? "dona" : "kg"}",
                            "${NumberFormat.decimalPattern('uz_UZ').format(product.productPrice * product.productQuantity)} so'm",
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
                  "Jami summa: ${NumberFormat.decimalPattern('uz_UZ').format(AppUtils.totalPriceForPDF(products))} so'm",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        '${directory.path}/${categoryName == null ? "" : "category_"}products.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }
}
