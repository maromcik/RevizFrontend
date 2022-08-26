class Device {
  int facility;
  String deviceName;
  String qrText;

//<editor-fold desc="Data Methods">

  Device({
    required this.facility,
    required this.deviceName,
    required this.qrText,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Device &&
          runtimeType == other.runtimeType &&
          facility == other.facility &&
          deviceName == other.deviceName &&
          qrText == other.qrText);

  @override
  int get hashCode => facility.hashCode ^ deviceName.hashCode ^ qrText.hashCode;

  @override
  String toString() {
    return 'Device{ facility: $facility, deviceName: $deviceName, qrText: $qrText,}';
  }

  Device copyWith({
    int? facility,
    String? deviceName,
    String? qrText,
  }) {
    return Device(
      facility: facility ?? this.facility,
      deviceName: deviceName ?? this.deviceName,
      qrText: qrText ?? this.qrText,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'facility': this.facility,
      'deviceName': this.deviceName,
      'qrText': this.qrText,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      facility: map['facility'] as int,
      deviceName: map['deviceName'] as String,
      qrText: map['qrText'] as String,
    );
  }

//</editor-fold>
}