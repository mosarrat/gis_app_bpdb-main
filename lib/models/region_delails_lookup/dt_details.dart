// class Transformer {
//   int id;
//   String distributionTransformerCode;
//   String? dtLocationName;
//   String zoneName;
//   String circleName;
//   String snDName;
//   String? esuName;
//   String substationName;
//   String feederlineName;
//   String poleLeftCode;
//   String? poleRightCode;
//   double? transformerKvaRating;
//   String? contractNo;
//   double? ratedHtVoltage;
//   double? ratedLtVoltage;
//   double? ratedLtCurrent;
//   double? ratedHtCurrent;

//   Transformer({
//     required this.id,
//     required this.distributionTransformerCode,
//     this.dtLocationName,
//     required this.zoneName,
//     required this.circleName,
//     required this.snDName,
//     this.esuName,
//     required this.substationName,
//     required this.feederlineName,
//     required this.poleLeftCode,
//     this.poleRightCode,
//     this.transformerKvaRating,
//     this.contractNo,
//     this.ratedHtVoltage,
//     this.ratedLtVoltage,
//     this.ratedLtCurrent,
//     this.ratedHtCurrent,
//   });

//   factory Transformer.fromJson(Map<String, dynamic> json) {
//     return Transformer(
//       id: json['id'],
//       distributionTransformerCode: json['distributionTransformerCode'],
//       dtLocationName: json['dtLocationName'],
//       zoneName: json['zoneName'],
//       circleName: json['circleName'],
//       snDName: json['snDName'],
//       esuName: json['esuName'],
//       substationName: json['substationName'],
//       feederlineName: json['feederlineName'],
//       poleLeftCode: json['poleLeftCode'],
//       poleRightCode: json['poleRightCode'],
//       transformerKvaRating: json['transformerKvaRating'],
//       contractNo: json['contractNo'],
//       ratedHtVoltage: json['ratedHtVoltage'],
//       ratedLtVoltage: json['ratedLTVoltage'],
//       ratedLtCurrent: json['ratedLTCurrent'],
//       ratedHtCurrent: json['ratedHTCurrent'],
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
//       'transformerKvaRating': transformerKvaRating,
//       'contractNo': contractNo,
//       'ratedHtVoltage': ratedHtVoltage,
//       'ratedLTVoltage': ratedLtVoltage,
//       'ratedLTCurrent': ratedLtCurrent,
//       'ratedHTCurrent': ratedHtCurrent,
//     };
//   }
// }
class Transformer {
  final int id;
  final String? distributionTransformerCode;
  final String? dtLocationName;
  final String zoneName;
  final String circleName;
  final String snDName;
  final String? esuName;
  final String substationName;
  final String feederlineName;
  final String poleLeftCode;
  final String? poleRightCode;
  final double latitude;
  final double longitude;
  final double? transformerKvaRating;
  final String? contractNo;
  final double? ratedHtVoltage;
  final double? ratedLtVoltage;
  final double? ratedLtCurrent;
  final double? ratedHtCurrent;

  Transformer({
    required this.id,
    this.distributionTransformerCode,
    this.dtLocationName,
    required this.zoneName,
    required this.circleName,
    required this.snDName,
    this.esuName,
    required this.substationName,
    required this.feederlineName,
    required this.poleLeftCode,
    this.poleRightCode,
    required this.latitude,
    required this.longitude,
    this.transformerKvaRating,
    this.contractNo,
    this.ratedHtVoltage,
    this.ratedLtVoltage,
    this.ratedLtCurrent,
    this.ratedHtCurrent,
  });

  factory Transformer.fromJson(Map<String, dynamic> json) {
    return Transformer(
      id: json['id'] as int,
      distributionTransformerCode:
          json['distributionTransformerCode'] as String?,
      dtLocationName: json['dtLocationName'] as String?,
      zoneName: json['zoneName'] as String,
      circleName: json['circleName'] as String,
      snDName: json['snDName'] as String,
      esuName: json['esuName'] as String?,
      substationName: json['substationName'] as String,
      feederlineName: json['feederlineName'] as String,
      poleLeftCode: json['poleLeftCode'] as String,
      poleRightCode: json['poleRightCode'] as String?,
      latitude: json['latitude'],
      longitude: json['longitude'],
      transformerKvaRating: (json['transformerKvaRating'] as num?)?.toDouble(),
      contractNo: json['contractNo'] as String?,
      ratedHtVoltage: (json['ratedHtVoltage'] as num?)?.toDouble(),
      ratedLtVoltage: (json['ratedLTVoltage'] as num?)?.toDouble(),
      ratedLtCurrent: (json['ratedLTCurrent'] as num?)?.toDouble(),
      ratedHtCurrent: (json['ratedHTCurrent'] as num?)?.toDouble(),
    );
  }

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
      'ratedLTVoltage': ratedLtVoltage,
      'ratedLTCurrent': ratedLtCurrent,
      'ratedHTCurrent': ratedHtCurrent,
    };
  }
}
