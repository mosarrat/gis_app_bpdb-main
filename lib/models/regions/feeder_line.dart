class FeederLine {
  final int feederLineId;
  final int sourceSubstationId;
  final int? destinationSubstationId;
  final String feederLineCode;
  final String feederlineName;

  FeederLine({
    required this.feederLineId,
    required this.sourceSubstationId,
    this.destinationSubstationId,
    required this.feederLineCode,
    required this.feederlineName,
  });

  factory FeederLine.fromJson(Map<String, dynamic> json) {
    return FeederLine(
      feederLineId: json['feederLineId'],
      sourceSubstationId: json['sourceSubstationId'],
      destinationSubstationId: json['destinationSubstationId'],
      feederLineCode: json['feederLineCode'],
      feederlineName: json['feederlineName'],
    );
  }
}
