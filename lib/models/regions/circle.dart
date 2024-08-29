class Circle {
  final int circleId;
  final int zoneId;
  final String circleCode;
  final String circleName;

  Circle({
    required this.circleId,
    required this.zoneId,
    required this.circleCode,
    required this.circleName,
  });

  factory Circle.fromJson(Map<String, dynamic> json) {
    return Circle(
      circleId: json['circleId'],
      zoneId: json['zoneId'],
      circleCode: json['circleCode'],
      circleName: json['circleName'],
    );
  }
}
