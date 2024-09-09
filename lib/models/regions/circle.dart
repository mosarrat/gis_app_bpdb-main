class Circles {
  final int circleId;
  final int zoneId;
  final String circleCode;
  final String circleName;

  Circles({
    required this.circleId,
    required this.zoneId,
    required this.circleCode,
    required this.circleName,
  });

  factory Circles.fromJson(Map<String, dynamic> json) {
    return Circles(
      circleId: json['circleId'],
      zoneId: json['zoneId'],
      circleCode: json['circleCode'],
      circleName: json['circleName'],
    );
  }
}
