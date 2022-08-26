import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:reviz/device.dart';
import 'package:reviz/scanner.dart';
import 'package:reviz/update.dart';
import 'package:reviz/urls.dart';

class Utils {

  static Future<bool> existDevice(Client client, String qr) async {
    Response response = await client.get(getDeviceUrl(qr));
    if (response.statusCode == 404) {
      return false;
    }
    return true;
  }

  static Future<Device> retrieveDevice(Client client, String qr) async {
    Response response = await client.get(getDeviceUrl(qr));
    if (response.statusCode == 404) {
      throw HttpException("Device $qr not found");
    }
    var decodedResponse = jsonDecode(response.body);
    return Device.fromMap(decodedResponse);
  }

  static Future<Response> createDevice(Client client, Device device) async {
    return await client.post(createUrl(),headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',},
        body: json.encode(device.toMap()));
  }

}


