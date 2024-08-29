class TransformerDetails {
  int id;
  String? distributionTransformerCode;
  int? poleDetailsLeftId;
  int? poleDetailsRightId;

  TransformerDetails({
    required this.id,
    this.distributionTransformerCode,
    this.poleDetailsLeftId,
    this.poleDetailsRightId,
  });

  // Factory constructor to create a TransformerDetails instance from JSON
  factory TransformerDetails.fromJson(Map<String, dynamic> json) {
    return TransformerDetails(
      id: json['id'],
      distributionTransformerCode: json['distributionTransformerCode'],
      poleDetailsLeftId: json['poleDetailsLeftId'],
      poleDetailsRightId: json['poleDetailsRightId'],
    );
  }

  // Method to convert a TransformerDetails instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'distributionTransformerCode': distributionTransformerCode,
      'poleDetailsLeftId': poleDetailsLeftId,
      'poleDetailsRightId': poleDetailsRightId,
    };
  }
}
