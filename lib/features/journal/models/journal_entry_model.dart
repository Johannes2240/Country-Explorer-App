class JournalEntryModel {
  const JournalEntryModel({
    this.id,
    required this.countryCode,
    required this.countryName,
    this.flagUrl,
    required this.status,
    this.notes,
    required this.addedAt,
    this.isSynced = false,
  });

  final int? id;
  final String countryCode;
  final String countryName;
  final String? flagUrl;
  final String status;
  final String? notes;
  final DateTime addedAt;
  final bool isSynced;

  String get statusLabel {
    switch (status) {
      case 'planning':
        return 'Planning';
      case 'visited':
        return 'Visited';
      default:
        return 'Want to Go';
    }
  }

  JournalEntryModel copyWith({
    int? id,
    String? countryCode,
    String? countryName,
    String? flagUrl,
    String? status,
    String? notes,
    DateTime? addedAt,
    bool? isSynced,
  }) {
    return JournalEntryModel(
      id: id ?? this.id,
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
      flagUrl: flagUrl ?? this.flagUrl,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      addedAt: addedAt ?? this.addedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  factory JournalEntryModel.fromMap(Map<String, dynamic> map) {
    return JournalEntryModel(
      id: map['id'] as int?,
      countryCode: map['country_code'] as String? ?? '',
      countryName: map['country_name'] as String? ?? '',
      flagUrl: map['flag_url'] as String?,
      status: map['status'] as String? ?? 'want_to_go',
      notes: map['notes'] as String?,
      addedAt:
          DateTime.tryParse(map['added_at'] as String? ?? '') ?? DateTime.now(),
      isSynced: (map['is_synced'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'country_code': countryCode,
      'country_name': countryName,
      'flag_url': flagUrl,
      'status': status,
      'notes': notes,
      'added_at': addedAt.toIso8601String(),
      'is_synced': isSynced ? 1 : 0,
    };
  }
}
