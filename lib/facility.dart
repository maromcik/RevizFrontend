class Facility {
  int id;
  String facilityName;
  String facilityLocation;

//<editor-fold desc="Data Methods">

  Facility({
    required this.id,
    required this.facilityName,
    required this.facilityLocation,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Facility &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          facilityName == other.facilityName &&
          facilityLocation == other.facilityLocation);

  @override
  int get hashCode =>
      id.hashCode ^ facilityName.hashCode ^ facilityLocation.hashCode;

  @override
  String toString() {
    return 'Facility{' +
        ' id: $id,' +
        ' facilityName: $facilityName,' +
        ' facilityLocation: $facilityLocation,' +
        '}';
  }

  Facility copyWith({
    int? id,
    String? facilityName,
    String? facilityLocation,
  }) {
    return Facility(
      id: id ?? this.id,
      facilityName: facilityName ?? this.facilityName,
      facilityLocation: facilityLocation ?? this.facilityLocation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'facilityName': this.facilityName,
      'facilityLocation': this.facilityLocation,
    };
  }

  factory Facility.fromMap(Map<String, dynamic> map) {
    return Facility(
      id: map['id'] as int,
      facilityName: map['facilityName'] as String,
      facilityLocation: map['facilityLocation'] as String,
    );
  }

//</editor-fold>
}