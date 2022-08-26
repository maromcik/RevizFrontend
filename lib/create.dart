import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reviz/device.dart';
import 'package:reviz/scanner.dart';
import 'package:reviz/urls.dart';
import 'dart:async';

class CreateDevice extends StatefulWidget {
  final Client client;
  final int facility;
  const CreateDevice({
    Key? key,
    required this.client, required this.facility
  }) : super(key: key);

  @override
  State<CreateDevice> createState() => _CreateDeviceState();
}

class _CreateDeviceState extends State<CreateDevice> {
  TextEditingController controllerDeviceName = TextEditingController();
  TextEditingController controllerQrText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Create device")),
      body: Column(
        children: [
          TextFormField(controller: controllerDeviceName, maxLines: 1,decoration: const InputDecoration(hintText: "Enter device name"),),
          TextFormField(controller: controllerQrText,maxLines: 1,decoration: const InputDecoration(hintText: "Enter QR ID"),),
          Container(
              alignment: Alignment.center,
              child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          Scanner.scanBarcodeNormal().then((value) => controllerQrText.text = value);
                        },
                        child: Text('Start barcode scan')),
                    ElevatedButton(
                        onPressed: () {
                          Scanner.scanQR().then((value) => controllerQrText.text = value);
                        },
                        child: Text('Start QR scan')),
                  ])),
          ElevatedButton(onPressed: () {
            Device device = Device(facility: widget.facility, deviceName: controllerDeviceName.text, qrText: controllerQrText.text);
            // String facility = controllerFacility.text;
            // String deviceName = controllerDeviceName.text;
            // String qrText = controllerQrText.text;
            // String request = "\{\"facility\":\"$facility\", \"deviceName\":\"$deviceName\", \"qrText\":\"$qrText\"\}";
            widget.client.post(createUrl(),headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',},
              body: json.encode(device.toMap()));
            Navigator.pop(context);
            }, child: const Text("Create device"))
        ],
      ),
    );
  }
}
