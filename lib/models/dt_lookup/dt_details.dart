class Transformer {
  int? id;
  String? distributionTransformerCode;
  String? dtLocationName;
  String? zoneName;
  String? circleName;
  String? snDName;
  String? esuName;
  String? substationName;
  String? feederlineName;
  String? poleLeftCode;
  String? poleRightCode;
  double? latitude;
  double? longitude;
  double? transformerKvaRating;
  String? contractNo;
  double? ratedHtVoltage;
  double? ratedLTVoltage;
  double? ratedLTCurrent;
  double? ratedHTCurrent;

  Transformer({
    this.id,
    this.distributionTransformerCode,
    this.dtLocationName,
    this.zoneName,
    this.circleName,
    this.snDName,
    this.esuName,
    this.substationName,
    this.feederlineName,
    this.poleLeftCode,
    this.poleRightCode,
    this.latitude,
    this.longitude,
    this.transformerKvaRating,
    this.contractNo,
    this.ratedHtVoltage,
    this.ratedLTVoltage,
    this.ratedLTCurrent,
    this.ratedHTCurrent,
  });

  // Factory constructor to parse from JSON
  factory Transformer.fromJson(Map<String, dynamic> json) {
    return Transformer(
      id: json['id'],
      distributionTransformerCode: json['distributionTransformerCode'],
      dtLocationName: json['dtLocationName'],
      zoneName: json['zoneName'],
      circleName: json['circleName'],
      snDName: json['snDName'],
      esuName: json['esuName'],
      substationName: json['substationName'],
      feederlineName: json['feederlineName'],
      poleLeftCode: json['poleLeftCode'],
      poleRightCode: json['poleRightCode'],
      latitude: (json['latitude'] != null) ? json['latitude'].toDouble() : null,
      longitude: (json['longitude'] != null) ? json['longitude'].toDouble() : null,
      transformerKvaRating: (json['transformerKvaRating'] != null) ? json['transformerKvaRating'].toDouble() : null,
      contractNo: json['contractNo'],
      ratedHtVoltage: (json['ratedHtVoltage'] != null) ? json['ratedHtVoltage'].toDouble() : null,
      ratedLTVoltage: (json['ratedLTVoltage'] != null) ? json['ratedLTVoltage'].toDouble() : null,
      ratedLTCurrent: (json['ratedLTCurrent'] != null) ? json['ratedLTCurrent'].toDouble() : null,
      ratedHTCurrent: (json['ratedHTCurrent'] != null) ? json['ratedHTCurrent'].toDouble() : null,
    );
  }

  // Convert the model back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'distributionTransformerCode': distributionTransformerCode,
      'dtLocationName': dtLocationName,
      'zoneName': zoneName,
      'circleName': circleName,
      'snDName': snDName,
      'esuName': esuName,
      'substationName': substationName,
      'feederlineName': feederlineName,
      'poleLeftCode': poleLeftCode,
      'poleRightCode': poleRightCode,
      'latitude': latitude,
      'longitude': longitude,
      'transformerKvaRating': transformerKvaRating,
      'contractNo': contractNo,
      'ratedHtVoltage': ratedHtVoltage,
      'ratedLTVoltage': ratedLTVoltage,
      'ratedLTCurrent': ratedLTCurrent,
      'ratedHTCurrent': ratedHTCurrent,
    };
  }
}

// class Transformer {
//   final int id;
//   final String? distributionTransformerCode;
//   final String? dtLocationName;
//   final String zoneName;
//   final String circleName;
//   final String snDName;
//   final String? esuName;
//   final String substationName;
//   final String feederlineName;
//   final String poleLeftCode;
//   final String? poleRightCode;
//   final double latitude;
//   final double longitude;
//   final double? transformerKvaRating;
//   final String? contractNo;
//   final double? ratedHtVoltage;
//   final double? ratedLtVoltage;
//   final double? ratedLtCurrent;
//   final double? ratedHtCurrent;

//   Transformer({
//     required this.id,
//     this.distributionTransformerCode,
//     this.dtLocationName,
//     required this.zoneName,
//     required this.circleName,
//     required this.snDName,
//     this.esuName,
//     required this.substationName,
//     required this.feederlineName,
//     required this.poleLeftCode,
//     this.poleRightCode,
//     required this.latitude,
//     required this.longitude,
//     this.transformerKvaRating,
//     this.contractNo,
//     this.ratedHtVoltage,
//     this.ratedLtVoltage,
//     this.ratedLtCurrent,
//     this.ratedHtCurrent,
//   });

//   factory Transformer.fromJson(Map<String, dynamic> json) {
//     return Transformer(
//       id: json['id'] as int,
//       distributionTransformerCode:
//           json['distributionTransformerCode'] as String?,
//       dtLocationName: json['dtLocationName'] as String?,
//       zoneName: json['zoneName'] as String,
//       circleName: json['circleName'] as String,
//       snDName: json['snDName'] as String,
//       esuName: json['esuName'] as String?,
//       substationName: json['substationName'] as String,
//       feederlineName: json['feederlineName'] as String,
//       poleLeftCode: json['poleLeftCode'] as String,
//       poleRightCode: json['poleRightCode'] as String?,
//       latitude: json['latitude'],
//       longitude: json['longitude'],
//       transformerKvaRating: (json['transformerKvaRating'] as num?)?.toDouble(),
//       contractNo: json['contractNo'] as String?,
//       ratedHtVoltage: (json['ratedHtVoltage'] as num?)?.toDouble(),
//       ratedLtVoltage: (json['ratedLTVoltage'] as num?)?.toDouble(),
//       ratedLtCurrent: (json['ratedLTCurrent'] as num?)?.toDouble(),
//       ratedHtCurrent: (json['ratedHTCurrent'] as num?)?.toDouble(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'distributionTransformerCode': distributionTransformerCode,
//       'dtLocationName': dtLocationName,
//       'zoneName': zoneName,
//       'circleName': circleName,
//       'snDName': snDName,
//       'esuName': esuName,
//       'substationName': substationName,
//       'feederlineName': feederlineName,
//       'poleLeftCode': poleLeftCode,
//       'poleRightCode': poleRightCode,
//       'latitude': latitude,
//       'longitude': longitude,
//       'transformerKvaRating': transformerKvaRating,
//       'contractNo': contractNo,
//       'ratedHtVoltage': ratedHtVoltage,
//       'ratedLTVoltage': ratedLtVoltage,
//       'ratedLTCurrent': ratedLtCurrent,
//       'ratedHTCurrent': ratedHtCurrent,
//     };
//   }
// }
