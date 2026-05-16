import '../../../core/constants/app_constants.dart';
import '../../../core/network/dio_client.dart';
import '../models/journal_entry_model.dart';

class JournalRemoteDataSource {
  Future<void> addEntry(JournalEntryModel entry) async {
    final response = await DioClient.instance.post<dynamic>(
      '${AppConstants.journalBaseUrl}/add',
      data: <String, dynamic>{
        'title': 'Travel journal for ${entry.countryName}',
        'body': entry.notes ?? '',
        'userId': 1,
      },
    );

    if ((response.statusCode ?? 500) < 200 ||
        (response.statusCode ?? 500) >= 300) {
      throw Exception('Unable to create journal entry');
    }
  }

  Future<void> updateEntry(JournalEntryModel entry) async {
    final response = await DioClient.instance.put<dynamic>(
      '${AppConstants.journalBaseUrl}/${entry.id ?? 1}',
      data: <String, dynamic>{
        'title': 'Travel journal for ${entry.countryName}',
        'body': entry.notes ?? '',
      },
    );

    if ((response.statusCode ?? 500) < 200 ||
        (response.statusCode ?? 500) >= 300) {
      throw Exception('Unable to update journal entry');
    }
  }

  Future<void> deleteEntry(int id) async {
    final response = await DioClient.instance.delete<dynamic>(
      '${AppConstants.journalBaseUrl}/$id',
    );

    if ((response.statusCode ?? 500) < 200 ||
        (response.statusCode ?? 500) >= 300) {
      throw Exception('Unable to delete journal entry');
    }
  }
}
