class Pole {
  final int poleDetailsId;
  final String poleCode;
  final int feederLineId;
  final int poleId;
  final String poleUniqueCode;

  Pole({
    required this.poleDetailsId,
    required this.poleCode,
    required this.feederLineId,
    required this.poleId,
    required this.poleUniqueCode,
  });

  factory Pole.fromJson(Map<String, dynamic> json) {
    return Pole(
      poleDetailsId: json['poleDetailsId'],
      poleCode: json['poleCode'],
      feederLineId: json['feederLineId'],
      poleId: json['poleId'],
      poleUniqueCode: json['poleUniqueCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poleDetailsId': poleDetailsId,
      'poleCode': poleCode,
      'feederLineId': feederLineId,
      'poleId': poleId,
      'poleUniqueCode': poleUniqueCode,
    };
  }
}
