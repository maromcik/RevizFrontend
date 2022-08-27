import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reviz/device.dart';
import 'package:reviz/scannerUtils.dart';
import 'package:reviz/scannerWidget.dart';
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



  @override
  initState() {
    super.initState();
  }
  @override
  void dispose() {
    controllerQrText.dispose();
    controllerDeviceName.dispose();
    super.dispose();
  }

  _searchDevice() async {
      try {
        await Utils.retrieveDevice(
            widget.client, controllerQrText.text)
            .then((value) => lookupDevice = value);
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                UpdateDevice(
                    client: widget.client,
                    editDevice: lookupDevice,
                    facilitiesName: widget.facilitiesName,
                    facilitiesId: widget.facilitiesId)));
        controllerQrText.clear();
      } on HttpException catch (e) {
        print("Exception: $e");
      }
    }

    _createDevice() async {
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
        print(controllerQrText.text);
        Utils.createDevice(widget.client, device);
        controllerDeviceName.clear();
        controllerQrText.clear();
        print("Device successfully created");
      } else {
        print("Device exists");
      }
    }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create or modify device")),
      body: Column(
        children: [
          TextFormField(
            controller: controllerQrText,
            maxLines: 1,
            decoration: const InputDecoration(hintText: "Enter QR ID"),
          ),
          scannerContainer(controllerQrText),
          TextFormField(
            controller: controllerDeviceName,
            maxLines: 1,
            decoration: const InputDecoration(hintText: "Enter device name"),
          ),
          ScannerWidgetContainer(controller: controllerDeviceName,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {_searchDevice();},
                  child: const Text("Search device")),
              ElevatedButton(
                  onPressed: () async {_createDevice();},
                  child: const Text("Create device")),
            ],
          )
        ],
      ),
    );
  }

  Container scannerContainer(TextEditingController controller) {
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
                          onPressed: () async {
                            await Scanner.scanQR().then(
                                    (value) => controller.text = value);
                            _searchDevice();
                          },
                          child: const Text('Start QR scan')),
                      ElevatedButton(
                          onPressed: () async {
                            await Scanner.scanBarcodeNormal().then(
                                (value) => controller.text = value);
                            _searchDevice();
                          },
                          child: const Text('Start barcode scan')),
                    ],
                  ),
                ]));
  }
}
