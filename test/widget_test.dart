import 'package:flutter_test/flutter_test.dart';

import 'package:country_explorer_app/features/journal/models/journal_entry_model.dart';

void main() {
  test('journal entry serializes to local map', () {
    final addedAt = DateTime(2026, 1, 2);
    final entry = JournalEntryModel(
      id: 4,
      countryCode: 'JP',
      countryName: 'Japan',
      flagUrl: 'https://flagcdn.com/jp.png',
      status: 'planning',
      notes: 'Cherry blossom season',
      addedAt: addedAt,
      isSynced: true,
    );

    final map = entry.toMap();

    expect(map['country_code'], 'JP');
    expect(map['status'], 'planning');
    expect(map['is_synced'], 1);
    expect(map['added_at'], addedAt.toIso8601String());
  });
}
