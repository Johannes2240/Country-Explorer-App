import '../data/journal_local_datasource.dart';
import '../data/journal_remote_datasource.dart';
import '../models/journal_entry_model.dart';

class JournalRepository {
  const JournalRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final JournalRemoteDataSource remoteDataSource;
  final JournalLocalDataSource localDataSource;

  Future<List<JournalEntryModel>> fetchEntries() {
    return localDataSource.fetchEntries();
  }

  Future<JournalEntryModel> addEntry(JournalEntryModel entry) async {
    try {
      await remoteDataSource.addEntry(entry);
      return localDataSource.upsertEntry(entry.copyWith(isSynced: true));
    } catch (_) {
      return localDataSource.upsertEntry(entry.copyWith(isSynced: false));
    }
  }

  Future<JournalEntryModel> updateEntry(JournalEntryModel entry) async {
    try {
      await remoteDataSource.updateEntry(entry);
      return localDataSource.upsertEntry(entry.copyWith(isSynced: true));
    } catch (_) {
      return localDataSource.upsertEntry(entry.copyWith(isSynced: false));
    }
  }

  Future<void> deleteEntry(int id) async {
    try {
      await remoteDataSource.deleteEntry(id);
    } catch (_) {
      // Continue with local delete so the journal still reflects user intent.
    }

    await localDataSource.deleteEntry(id);
  }
}
