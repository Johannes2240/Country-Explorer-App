import 'package:sqflite/sqflite.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/db/database_helper.dart';
import '../models/journal_entry_model.dart';

class JournalLocalDataSource {
  Future<List<JournalEntryModel>> fetchEntries() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      AppConstants.journalTable,
      orderBy: 'added_at DESC',
    );
    return rows.map(JournalEntryModel.fromMap).toList();
  }

  Future<JournalEntryModel> upsertEntry(JournalEntryModel entry) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert(
      AppConstants.journalTable,
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return entry.copyWith(id: entry.id ?? id);
  }

  Future<void> deleteEntry(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      AppConstants.journalTable,
      where: 'id = ?',
      whereArgs: <Object>[id],
    );
  }
}
