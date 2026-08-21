class Report {
  final int? id;
  final String scamType;
  final String description;
  final String suspectContact;
  final String? evidenceUrl;
  final String region;
  final String status;
  final bool isAnonymous;
  final DateTime? createdAt;

  Report({
    this.id,
    required this.scamType,
    required this.description,
    required this.suspectContact,
    this.evidenceUrl,
    required this.region,
    this.status = 'pending',
    this.isAnonymous = false,
    this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      scamType: json['scam_type'],
      description: json['description'],
      suspectContact: json['suspect_contact'] ?? '',
      evidenceUrl: json['evidence'],
      region: json['region'],
      status: json['status'] ?? 'pending',
      isAnonymous: json['is_anonymous'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scam_type': scamType,
      'description': description,
      'suspect_contact': suspectContact,
      'region': region,
      'is_anonymous': isAnonymous,
    };
  }
}