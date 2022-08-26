import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reviz/device.dart';
import 'package:reviz/scanner.dart';
import 'package:reviz/update.dart';
import 'package:reviz/urls.dart';
import 'dart:async';

import 'facility.dart';

class CreateDevice extends StatefulWidget {
  final Client client;
  final Map<String, Facility> facilitiesName;
  final Map<int, Facility> facilitiesId;
  final int facility;
  const CreateDevice({
    Key? key,
    required this.client, required this.facility, required this.facilitiesName, required this.facilitiesId
  }) : super(key: key);

  @override
  State<CreateDevice> createState() => _CreateDeviceState();
}

class _CreateDeviceState extends State<CreateDevice> {
  TextEditingController controllerDeviceName = TextEditingController();
  TextEditingController controllerQrText = TextEditingController();
  late Device lookupDevice;


  Future<Device> _retrieveDevices(String qr) async {
    var response = json.decode((await widget.client.get(getDeviceUrl(qr))).body);
    return Device.fromMap(response);
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Create or modify device")),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
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
                      ],
                    ),
                  ])),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () {
                Device device = Device(facility: widget.facility, deviceName: controllerDeviceName.text, qrText: controllerQrText.text);
                widget.client.post(createUrl(),headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',},
                  body: json.encode(device.toMap()));
                Navigator.pop(context);
                }, child: const Text("Create device")),
              ElevatedButton(onPressed: () async {
                await _retrieveDevices(controllerQrText.text).then((value) => lookupDevice = value);
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UpdateDevice(
                        client: widget.client,
                        editDevice: lookupDevice,
                        facilitiesName: widget.facilitiesName,
                        facilitiesId: widget.facilitiesId)));
                controllerQrText.clear();
              }, child: const Text("Search device")),
            ],
          )
        ],
      ),
    );
  }
}
