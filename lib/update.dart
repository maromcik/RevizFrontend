import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reviz/device.dart';
import 'package:reviz/facility.dart';
import 'package:reviz/urls.dart';
import 'package:reviz/utils.dart';
import 'package:reviz/scannerWidget.dart';

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

  String facility = "";

  @override
  initState() {
    controllerDeviceName.text = widget.editDevice.deviceName;
    controllerQrText.text = widget.editDevice.qrText;
    facility = widget.facilitiesId[widget.editDevice.facility]!.facilityName;
    super.initState();
  }

  @override
  void dispose() {
    controllerQrText.dispose();
    controllerDeviceName.dispose();
    super.dispose();
  }

  _updateDevice() async {
    Device newDevice = Device(
        facility: widget.facilitiesName[facility]!.id,
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
            hint: Text(
                widget.facilitiesId[widget.editDevice.facility]!.facilityName),
            items: widget.facilitiesName.keys.toList().map((String value) {
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
          const Text("Device QR"),
          TextFormField(
            controller: controllerQrText,
            maxLines: 1,
          ),
          ScannerWidgetContainer(controller: controllerQrText),
          const Text("Device name"),
          TextFormField(
            controller: controllerDeviceName,
            maxLines: 1,
          ),
          ScannerWidgetContainer(controller: controllerDeviceName),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Utils.deleteDevice(widget.client, controllerQrText.text);
                    Navigator.pop(context);
                  },
                  child: const Text("Delete device")),
              ElevatedButton(
                  onPressed: () {
                    _updateDevice();
                  },
                  child: const Text("Update device")),
            ],
          )
        ],
      ),
    );
  }
}
