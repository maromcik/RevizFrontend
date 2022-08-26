import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reviz/device.dart';
import 'package:reviz/facility.dart';
import 'package:reviz/urls.dart';

class UpdateDevice extends StatefulWidget {
  final Client client;
  final Device editDevice;
  final Map<String, Facility> facilities;
  const UpdateDevice({
    Key? key,
    required this.client, required this.editDevice, required this.facilities
  }) : super(key: key);

  @override
  State<UpdateDevice> createState() => _UpdateDeviceState();
}

class _UpdateDeviceState extends State<UpdateDevice> {
  TextEditingController controllerDeviceName = TextEditingController();
  String qrText = "";
  Map<String, Facility> facilities = HashMap();
  late String facility;
  initState() {
    controllerDeviceName.text = widget.editDevice.deviceName;
    qrText = widget.editDevice.qrText;
    facilities = widget.facilities;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Update device")),
      body: Column(
        children: [
          DropdownButtonFormField<String>(items: facilities.keys.toList().map((String value){
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),);
          }).toList(),
            onChanged: (value) {
            setState(() {
              facility = value ?? "";
            });
          },),
          TextFormField(controller: controllerDeviceName, maxLines: 1,),
          ElevatedButton(onPressed: () {
            Device newDevice = Device(facility: facilities[facility]!.id, deviceName: controllerDeviceName.text, qrText: qrText);
            widget.client.put(updateUrl(qrText),headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',},
                body: json.encode(newDevice.toMap()));
            Navigator.pop(context);
          }, child: Text("Update device"))
        ],
      ),
    );
  }
}
