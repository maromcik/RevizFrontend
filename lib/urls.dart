String ip = "192.168.1.15";
String port = "";

Uri getUrl() {
  return Uri.https("$ip:$port", "/audit/get_devices/");
}

Uri getDeviceUrl(String qr) {
  return Uri.https("$ip:$port", "/audit/$qr/get/");
}

Uri getDevicesByFacilityUrl(String facilityName) {
  return Uri.https("$ip:$port", "/audit/get_devices_by_facility/$facilityName/");
}

Uri deleteUrl(String qr) {
  return Uri.https("$ip:$port", "/audit/$qr/delete/");
}

Uri updateUrl(String qr) {
  return Uri.https("$ip:$port", "/audit/$qr/update/");
}

Uri createUrl() {
  return Uri.https("$ip:$port", "/audit/create_device/");
}

getFacilitiesUrl() {
  return Uri.https("$ip:$port", "/audit/get_facilities/");
}

getFacilitiesByNameUrl(facilityName) {
  return Uri.https("$ip:$port", "/audit/get_facility_by_name/$facilityName/");
}