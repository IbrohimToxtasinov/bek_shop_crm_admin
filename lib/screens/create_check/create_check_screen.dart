import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bek_shop/data/models/order/order_model.dart';
import 'package:bek_shop/screens/widgets/app_bar/custom_appbar.dart';
import 'package:bek_shop/screens/widgets/buttons/main_action_button.dart';
import 'package:bek_shop/screens/widgets/overlay/overlays.dart';
import 'package:bek_shop/utils/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';

class CreateCheckScreen extends StatefulWidget {
  final OrderModel orderModel;

  const CreateCheckScreen({super.key, required this.orderModel});

  @override
  State<CreateCheckScreen> createState() => _CreateCheckScreenState();
}

class _CreateCheckScreenState extends State<CreateCheckScreen> {
  ReceiptController? controller;

  Future<Uint8List> generateQrCodeImage(String data) async {
    final qrValidationResult = QrValidator.validate(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );
    final qrCode = qrValidationResult.qrCode;

    final painter = QrPainter.withQr(
      qr: qrCode!,
      color: const Color(0xFF000000),
      emptyColor: const Color(0xFFFFFFFF),
      gapless: true,
    );

    final image = await painter.toImage(200);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    final qrLink =
        "https://www.google.com/maps/search/?api=1&query=${widget.orderModel.latLong.latitude},${widget.orderModel.latLong.longitude}";
    return Scaffold(
      appBar: CustomAppBar(title: "Chek yaratish"),
      body: Receipt(
        builder:
            (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'BEK SHOP',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text('BUYURTMA CHEKI', style: TextStyle(fontSize: 28)),
                ),
                SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Buyurtma ID: ',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: widget.orderModel.orderId,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Mijoz: ',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: widget.orderModel.clientName,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Tel: ',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: widget.orderModel.clientPhoneNumber,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Manzil: ',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: widget.orderModel.clientAddress,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Vaqt: ',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: AppUtils.formatDateForPdf(
                          widget.orderModel.createAt,
                        ),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),
                Divider(thickness: 3, color: Colors.black),
                Text(
                  'Mahsulotlar:',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Divider(thickness: 3, color: Colors.black),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.orderModel.products[index].productName,
                                  style: TextStyle(fontSize: 28),
                                ),
                              ),
                              SizedBox(width: 50),
                              Text(
                                "${widget.orderModel.products[index].count} x ${NumberFormat.decimalPattern('uz_UZ').format(widget.orderModel.products[index].isExpensive ? widget.orderModel.products[index].productPrice + widget.orderModel.products[index].expensivePrice : widget.orderModel.products[index].productPrice + widget.orderModel.products[index].cheapPrice)}",
                                style: TextStyle(fontSize: 28),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "= ${NumberFormat.decimalPattern('uz_UZ').format(widget.orderModel.products[index].isExpensive ? (widget.orderModel.products[index].productPrice + widget.orderModel.products[index].expensivePrice) * widget.orderModel.products[index].count : (widget.orderModel.products[index].productPrice + widget.orderModel.products[index].cheapPrice) * widget.orderModel.products[index].count)} so'm",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(height: 10),
                        DashedLine(height: 3, color: Colors.black),
                        SizedBox(height: 10),
                      ],
                    );
                  },
                  itemCount: widget.orderModel.products.length,
                ),
                Divider(thickness: 3, color: Colors.black),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Umumiy: ${NumberFormat.decimalPattern('uz_UZ').format(widget.orderModel.totalPrice)} so'm",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: Text(
                    'YANA KELIB TURING!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Joylashuv (QR):",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        FutureBuilder<Uint8List>(
                          future: generateQrCodeImage(qrLink),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: Image.memory(
                                  snapshot.data!,
                                  height: 120,
                                  width: 120,
                                ),
                              );
                            } else {
                              return Text(
                                'QR yuklanmoqda...',
                                style: TextStyle(fontSize: 22),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(width: 30),
                    Column(
                      children: [
                        Text(
                          "Aloqa uchun:",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "+998 (99) 666-88-89",
                          style: TextStyle(fontSize: 26),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
        onInitialized: (ctrl) {
          ctrl.paperSize = PaperSize.mm80;
          controller = ctrl;
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: MainActionButton(
          onTap: () async {
            final address = await FlutterBluetoothPrinter.selectDevice(context);
            if (address != null) {
              bool isConnected = await FlutterBluetoothPrinter.connect(
                address.address,
              );

              if (isConnected) {
                await controller?.print(
                  address: address.address,
                  keepConnected: true,
                  addFeeds: 4,
                );
                showOverlayMessage(
                  context,
                  status: OverlayStatus.success,
                  text:
                      "Muvaffaqiyatli chop etish", // Success message for printing
                );
              } else {
                showOverlayMessage(
                  context,
                  status: OverlayStatus.failed,
                  text:
                      "Qurilmaga ulanishda xato", // Error message if Bluetooth connection failed
                );
              }
            } else {
              showOverlayMessage(
                context,
                text:
                    "Muvaffaqiyatsiz chop etish: hech qanday qurilma tanlanmagan", // Error message if no device selected
              );
            }
          },
          label: "Printer tanlash & Chop etish",
        ),
      ),
    );
  }
}

class DashedLine extends StatelessWidget {
  final double height;
  final Color color;

  const DashedLine({this.height = 1, this.color = Colors.black, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:
          (context, constraints) => Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              (constraints.constrainWidth() / 10).floor(),
              (_) => SizedBox(
                width: 5,
                height: height,
                child: DecoratedBox(decoration: BoxDecoration(color: color)),
              ),
            ),
          ),
    );
  }
}
