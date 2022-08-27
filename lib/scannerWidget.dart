import 'package:flutter/material.dart';
import 'package:reviz/scannerUtils.dart';

class ScannerWidgetContainer extends StatelessWidget {
  const ScannerWidgetContainer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Scanner.scanQR().then(
                                (value) => controller.text = value);
                      },
                      child: const Text('Start QR scan')),
                  ElevatedButton(
                      onPressed: () {
                        Scanner.scanBarcodeNormal().then(
                                (value) => controller.text = value);
                      },
                      child: const Text('Start barcode scan')),
                ],
              ),
            ]));
  }
}
