class Transformer {
  int id;
  String distributionTransformerCode;
  String? dtLocationName;
  String zoneName;
  String circleName;
  String snDName;
  String? esuName;
  String substationName;
  String feederlineName;
  String poleLeftCode;
  String? poleRightCode;
  double? transformerKvaRating;
  String? contractNo;
  double? ratedHtVoltage;
  double? ratedLtVoltage;
  double? ratedLtCurrent;
  double? ratedHtCurrent;

  Transformer({
    required this.id,
    required this.distributionTransformerCode,
    this.dtLocationName,
    required this.zoneName,
    required this.circleName,
    required this.snDName,
    this.esuName,
    required this.substationName,
    required this.feederlineName,
    required this.poleLeftCode,
    this.poleRightCode,
    this.transformerKvaRating,
    this.contractNo,
    this.ratedHtVoltage,
    this.ratedLtVoltage,
    this.ratedLtCurrent,
    this.ratedHtCurrent,
  });

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
      transformerKvaRating: json['transformerKvaRating'],
      contractNo: json['contractNo'],
      ratedHtVoltage: json['ratedHtVoltage'],
      ratedLtVoltage: json['ratedLTVoltage'],
      ratedLtCurrent: json['ratedLTCurrent'],
      ratedHtCurrent: json['ratedHTCurrent'],
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
      'transformerKvaRating': transformerKvaRating,
      'contractNo': contractNo,
      'ratedHtVoltage': ratedHtVoltage,
      'ratedLTVoltage': ratedLtVoltage,
      'ratedLTCurrent': ratedLtCurrent,
      'ratedHTCurrent': ratedHtCurrent,
    };
  }
}
