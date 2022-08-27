import 'package:flutter/material.dart';

class ScannerWidget extends StatelessWidget {
  TextEditingController controllerDeviceName;

  ScannerWidget({Key? key, required this.controllerDeviceName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllerDeviceName,
      maxLines: 1,
      decoration: const InputDecoration(hintText: "Enter device name"),
    );
  }
}
