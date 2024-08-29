class Zone {
  final int zoneId;
  final String zoneCode;
  final String zoneName;

  Zone({
    required this.zoneId,
    required this.zoneCode,
    required this.zoneName,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      zoneId: json['zoneId'],
      zoneCode: json['zoneCode'],
      zoneName: json['zoneName'],
    );
  }
}
