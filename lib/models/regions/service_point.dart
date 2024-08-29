class ServicePoint {
  final int servicesPointId;
  final String servicePointCode;
  final int poleDetailsId;

  ServicePoint({
    required this.servicesPointId,
    required this.servicePointCode,
    required this.poleDetailsId,
  });

  factory ServicePoint.fromJson(Map<String, dynamic> json) {
    return ServicePoint(
      servicesPointId: json['servicesPointId'],
      servicePointCode: json['servicePointCode'],
      poleDetailsId: json['poleDetailsId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'servicesPointId': servicesPointId,
      'servicePointCode': servicePointCode,
      'poleDetailsId': poleDetailsId,
    };
  }
}
