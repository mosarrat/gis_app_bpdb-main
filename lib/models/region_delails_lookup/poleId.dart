class PoleDetailByID {
  final int poleId;
  final int poleTypeId;
  final String poleTypeName;
  final int poleConditionId;
  final String conditionName;
  final DateTime surveyDate;
  final String surveyorName;
  final double latitude;
  final double longitude;
  final int? noOfWireHt;
  final int? noOfWireLt;
  final String msjNo;
  final String sleeveNo;
  final String twistNo;
  final bool streetLight;
  final bool transformerExist;
  final bool commonPole;
  final bool tap;
  final String? poleNumber;
  final double? poleHeight;
  final int? noOfLine11Kv;
  final int? noOfLineP4Kv;
  final int? noOfLine33Kv;

  PoleDetailByID({
    required this.poleId,
    required this.poleTypeId,
    required this.poleTypeName,
    required this.poleConditionId,
    required this.conditionName,
    required this.surveyDate,
    required this.surveyorName,
    required this.latitude,
    required this.longitude,
    this.noOfWireHt,
    this.noOfWireLt,
    required this.msjNo,
    required this.sleeveNo,
    required this.twistNo,
    required this.streetLight,
    required this.transformerExist,
    required this.commonPole,
    required this.tap,
    this.poleNumber,
    this.poleHeight,
    this.noOfLine11Kv,
    this.noOfLineP4Kv,
    this.noOfLine33Kv,
  });

  factory PoleDetailByID.fromJson(Map<String, dynamic> json) {
    return PoleDetailByID(
      poleId: json['poleId'],
      poleTypeId: json['poleTypeId'],
      poleTypeName: json['poleTypeName'],
      poleConditionId: json['poleConditionId'],
      conditionName: json['conditionName'],
      surveyDate: DateTime.parse(json['surveyDate']),
      surveyorName: json['surveyorName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      noOfWireHt: json['noOfWireHt'],
      noOfWireLt: json['noOfWireLt'],
      msjNo: json['msjNo'],
      sleeveNo: json['sleeveNo'],
      twistNo: json['twistNo'],
      streetLight: json['streetLight'],
      transformerExist: json['transformerExist'],
      commonPole: json['commonPole'],
      tap: json['tap'],
      poleNumber: json['poleNumber'],
      poleHeight: json['poleHeight'],
      noOfLine11Kv: json['noOfLine11Kv'],
      noOfLineP4Kv: json['noOfLineP4Kv'],
      noOfLine33Kv: json['noOfLine33Kv'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poleId': poleId,
      'poleTypeId': poleTypeId,
      'poleTypeName': poleTypeName,
      'poleConditionId': poleConditionId,
      'conditionName': conditionName,
      'surveyDate': surveyDate.toIso8601String(),
      'surveyorName': surveyorName,
      'latitude': latitude,
      'longitude': longitude,
      'noOfWireHt': noOfWireHt,
      'noOfWireLt': noOfWireLt,
      'msjNo': msjNo,
      'sleeveNo': sleeveNo,
      'twistNo': twistNo,
      'streetLight': streetLight,
      'transformerExist': transformerExist,
      'commonPole': commonPole,
      'tap': tap,
      'poleNumber': poleNumber,
      'poleHeight': poleHeight,
      'noOfLine11Kv': noOfLine11Kv,
      'noOfLineP4Kv': noOfLineP4Kv,
      'noOfLine33Kv': noOfLine33Kv,
    };
  }
}
