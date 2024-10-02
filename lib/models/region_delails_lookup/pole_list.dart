class PoleList {
  final int zoneId;
  final int circleId;
  final int sndId;
  final int? esuId; // Nullable field
  final int poleId;
  final String poleTypeName;
  final String conditionName;
  final double? poleHeight; // Nullable field

  PoleList({
    required this.zoneId,
    required this.circleId,
    required this.sndId,
    this.esuId,
    required this.poleId,
    required this.poleTypeName,
    required this.conditionName,
    this.poleHeight,
  });

  // Factory constructor for creating a PoleList object from JSON
  factory PoleList.fromJson(Map<String, dynamic> json) {
    return PoleList(
      zoneId: json['zoneId'],
      circleId: json['circleId'],
      sndId: json['sndId'],
      esuId: json['esuId'], // This can be null
      poleId: json['poleId'],
      poleTypeName: json['poleTypeName'],
      conditionName: json['conditionName'],
      poleHeight: json['poleHeight'] != null ? json['poleHeight'].toDouble() : null, // Handle null
    );
  }

  // Method to convert a PoleList object to JSON
  Map<String, dynamic> toJson() {
    return {
      'zoneId': zoneId,
      'circleId': circleId,
      'sndId': sndId,
      'esuId': esuId,
      'poleId': poleId,
      'poleTypeName': poleTypeName,
      'conditionName': conditionName,
      'poleHeight': poleHeight,
    };
  }
}

