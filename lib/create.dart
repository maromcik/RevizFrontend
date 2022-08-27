import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reviz/device.dart';
import 'package:reviz/scanner.dart';
import 'package:reviz/update.dart';
import 'package:reviz/urls.dart';
import 'dart:async';
import 'utils.dart';
import 'facility.dart';

class CreateDevice extends StatefulWidget {
  final Client client;
  final Map<String, Facility> facilitiesName;
  final Map<int, Facility> facilitiesId;
  final int facility;

  const CreateDevice(
      {Key? key,
      required this.client,
      required this.facility,
      required this.facilitiesName,
      required this.facilitiesId})
      : super(key: key);

  @override
  State<CreateDevice> createState() => _CreateDeviceState();
}

class _CreateDeviceState extends State<CreateDevice> {
  TextEditingController controllerDeviceName = TextEditingController();
  TextEditingController controllerQrText = TextEditingController();
  late Device lookupDevice;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create or modify device")),
      body: Column(
        children: [
          TextFormField(
            controller: controllerDeviceName,
            maxLines: 1,
            decoration: const InputDecoration(hintText: "Enter device name"),
          ),
          TextFormField(
            controller: controllerQrText,
            maxLines: 1,
            decoration: const InputDecoration(hintText: "Enter QR ID"),
          ),
          Container(
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
                              Scanner.scanBarcodeNormal().then(
                                  (value) => controllerQrText.text = value);
                            },
                            child: Text('Start barcode scan')),
                        ElevatedButton(
                            onPressed: () {
                              Scanner.scanQR().then(
                                  (value) => controllerQrText.text = value);
                            },
                            child: Text('Start QR scan')),
                      ],
                    ),
                  ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    Device device = Device(
                        facility: widget.facility,
                        deviceName: controllerDeviceName.text,
                        qrText: controllerQrText.text);
                    bool exist = false;
                    await Utils.existDevice(
                            widget.client, controllerQrText.text)
                        .then((value) {
                      exist = value;
                    });
                    if (!exist) {
                      print('KOKOT');
                      print(exist);
                      print(controllerQrText.text);
                      Utils.createDevice(widget.client, device);
                      Navigator.pop(context);
                    } else {
                      print("Device exists");
                    }
                  },
                  child: const Text("Create device")),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      await Utils.retrieveDevice(
                              widget.client, controllerQrText.text)
                          .then((value) => lookupDevice = value);
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UpdateDevice(
                              client: widget.client,
                              editDevice: lookupDevice,
                              facilitiesName: widget.facilitiesName,
                              facilitiesId: widget.facilitiesId)));
                      controllerQrText.clear();
                    } on HttpException catch (e) {
                      print("Exception: $e");
                    }
                  },
                  child: const Text("Search device")),
            ],
          )
        ],
      ),
    );
  }
}
