import '../models/journal_entry_model.dart';

abstract class JournalState {
  const JournalState();
}

class JournalInitial extends JournalState {
  const JournalInitial();
}

class JournalLoading extends JournalState {
  const JournalLoading();
}

class JournalLoaded extends JournalState {
  const JournalLoaded({required this.entries, required this.selectedFilter});

  final List<JournalEntryModel> entries;
  final String selectedFilter;
}

class JournalError extends JournalState {
  const JournalError(this.message);

  final String message;
}

class JournalSuccess extends JournalState {
  const JournalSuccess({
    required this.message,
    required this.entries,
    required this.selectedFilter,
  });

  final String message;
  final List<JournalEntryModel> entries;
  final String selectedFilter;
}
