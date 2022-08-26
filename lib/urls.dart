String ip = "192.168.1.52";

Uri getUrl() {
  return Uri.http("$ip:8000", "/audit/get_devices/");
}

Uri getDeviceUrl(String qr) {
  return Uri.http("$ip:8000", "/audit/$qr/get/");
}

Uri getDevicesByFacilityUrl(String facilityName) {
  return Uri.http("$ip:8000", "/audit/get_devices_by_facility/$facilityName/");
}

Uri deleteUrl(String qr) {
  return Uri.http("$ip:8000", "/audit/$qr/delete/");
}

Uri updateUrl(String qr) {
  return Uri.http("$ip:8000", "/audit/$qr/update/");
}

Uri createUrl() {
  return Uri.http("$ip:8000", "/audit/create_device/");
}

getFacilitiesUrl() {
  return Uri.http("$ip:8000", "/audit/get_facilities/");
}

getFacilitiesByNameUrl(facilityName) {
  return Uri.http("$ip:8000", "/audit/get_facility_by_name/$facilityName/");
}