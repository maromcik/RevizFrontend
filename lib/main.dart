import 'dart:collection';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:reviz/facility.dart';

import 'device.dart';
import 'create.dart';
import 'update.dart';
import 'urls.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reviz',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Reviz'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Client client = http.Client();
  List<Device> devices = [];
  String facility = "--all--";
  List<String> facilitiesNames = ['--all--'];
  final Map<String, Facility> facilitiesName = HashMap();
  final Map<int, Facility> facilitiesId = HashMap();

  @override
  void initState() {
    _retrieveDevices();
    _getFacilities();
    super.initState();
  }

  _processResponseDevice(List response) {
    response.forEach((element) {
      devices.add(Device.fromMap(element));
    });
    setState(() {});
  }

  _processResponseFacilities(List response) {
    response.forEach((element) {
      Facility facility = Facility.fromMap(element);
      facilitiesName.addAll({facility.facilityName: facility});
      facilitiesId.addAll({facility.id: facility});
    });
    facilitiesNames.addAll(facilitiesName.keys.toList());
    setState(() {});
  }

  int _getFacilityId(String fac) {
    if (fac == "") {
      showAlertDialog(context);
      return -1;
    }
    if (!facilitiesName.containsKey(fac)) {
      showAlertDialog(context);
    }
    return facilitiesName[facility]!.id;
  }

  _retrieveDevices() async {
    devices = [];
    List response = json.decode((await client.get(getUrl())).body);
    _processResponseDevice(response);
  }

  _retrieveDevicesByFacility(String facilityName) async {
    devices = [];
    if (facilityName == "--all--") {
      List response = json.decode((await client.get(getUrl())).body);
      _processResponseDevice(response);
    } else {
      List response = json.decode(
          (await client.get(getDevicesByFacilityUrl(facilityName))).body);
      _processResponseDevice(response);
    }
  }

  void _deleteDevice(String qr) async {
    await client.delete(deleteUrl(qr));
    _retrieveDevicesByFacility(facility);
  }

  _getFacilities() async {
    facilitiesName.clear();
    List response = json.decode((await client.get(getFacilitiesUrl())).body);
    _processResponseFacilities(response);
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: Text("This is my message."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _retrieveDevicesByFacility(facility);
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                items: facilitiesNames.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    facility = value ?? "--all--";
                  });
                  _retrieveDevicesByFacility(facility);
                },
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: devices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                          "Device name: ${devices[index].deviceName}\nFacility: ${facilitiesId[devices[index].facility]!.facilityName}\nDevice QR ID: ${devices[index].qrText}"),
                      onTap: () async {
                        print("navigating away");
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UpdateDevice(
                                client: client,
                                editDevice: devices[index],
                                facilitiesName: facilitiesName,
                                facilitiesId: facilitiesId)));
                        print("navigating back, retrieving");
                        _retrieveDevicesByFacility(facility);
                        print("retrieved");
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteDevice(devices[index].qrText),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("navigating away");
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateDevice(
                  client: client,
                  facility: facilitiesName[facility]!.id,
                  facilitiesName: facilitiesName,
                  facilitiesId: facilitiesId)));
          print("navigating back, retrieving");
          _retrieveDevicesByFacility(facility);
          print("retrieved");
        },
        tooltip: 'Create new device',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
