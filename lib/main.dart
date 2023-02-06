import 'dart:collection';
import 'dart:convert';
import 'dart:io';
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
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
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
    for (var element in response) {
      devices.add(Device.fromMap(element));
    }
    setState(() {});
  }

  _processResponseFacilities(List response) {
    for (var element in response) {
      Facility facility = Facility.fromMap(element);
      facilitiesName.addAll({facility.facilityName: facility});
      facilitiesId.addAll({facility.id: facility});
    }
    facilitiesNames.addAll(facilitiesName.keys.toList());
    setState(() {});
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

  _getFacilities() async {
    facilitiesName.clear();
    List response = json.decode((await client.get(getFacilitiesUrl())).body);
    _processResponseFacilities(response);
  }

  _createDevice() async {
    if (!facilitiesName.containsKey(facility)) {
      print("Facility must be set");
      return;
    }
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateDevice(
            client: client,
            facility: facilitiesName[facility]!.id,
            facilitiesName: facilitiesName,
            facilitiesId: facilitiesId)));
    _retrieveDevicesByFacility(facility);
  }

  _updateDevice(int index) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UpdateDevice(
            client: client,
            editDevice: devices[index],
            facilitiesName: facilitiesName,
            facilitiesId: facilitiesId)));
    _retrieveDevicesByFacility(facility);
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
                      onTap: () {
                        _updateDevice(index);
                      },
                      // trailing: IconButton(
                      //   icon: const Icon(Icons.delete),
                      //   onPressed: () => _deleteDevice(devices[index].qrText),
                      // ),
                    );
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createDevice();
        },
        tooltip: 'Create new device',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
