import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reviz/device.dart';
import 'package:reviz/facility.dart';
import 'package:reviz/scannerUtils.dart';
import 'package:reviz/urls.dart';
import 'package:reviz/utils.dart';

class UpdateDevice extends StatefulWidget {
  final Client client;
  final Device editDevice;
  final Map<String, Facility> facilitiesName;
  final Map<int, Facility> facilitiesId;

  const UpdateDevice(
      {Key? key,
      required this.client,
      required this.editDevice,
      required this.facilitiesName,
      required this.facilitiesId})
      : super(key: key);

  @override
  State<UpdateDevice> createState() => _UpdateDeviceState();
}

class _UpdateDeviceState extends State<UpdateDevice> {
  TextEditingController controllerDeviceName = TextEditingController();
  TextEditingController controllerQrText = TextEditingController();

  Map<String, Facility> facilitiesName = HashMap();
  Map<int, Facility> facilitiesId = HashMap();
  String facility = "";

  @override
  initState() {
    controllerDeviceName.text = widget.editDevice.deviceName;
    controllerQrText.text = widget.editDevice.qrText;
    facilitiesName = widget.facilitiesName;
    facilitiesId = widget.facilitiesId;
    facility = facilitiesId[widget.editDevice.facility]!.facilityName;
    super.initState();
  }

  _updateDevice() async {
    Device newDevice = Device(
        facility: facilitiesName[facility]!.id,
        deviceName: controllerDeviceName.text,
        qrText: controllerQrText.text);
    widget.client.put(updateUrl(widget.editDevice.qrText),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(newDevice.toMap()));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update device")),
      body: Column(
        children: [
          DropdownButtonFormField<String>(
            hint: Text(facilitiesId[widget.editDevice.facility]!.facilityName),
            items: facilitiesName.keys.toList().map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                facility = value ?? "";
              });
            },
          ),
          TextFormField(
            controller: controllerDeviceName,
            maxLines: 1,
          ),
          TextFormField(
            controller: controllerQrText,
            maxLines: 1,
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
                  onPressed: () {
                    _updateDevice();
                  },
                  child: Text("Update device")),
              ElevatedButton(
                  onPressed: () {
                    Utils.deleteDevice(widget.client, controllerQrText.text);
                    Navigator.pop(context);
                  },
                  child: Text("Delete device")),
            ],
          )
        ],
      ),
    );
  }
}
