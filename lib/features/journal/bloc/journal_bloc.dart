import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/journal_entry_model.dart';
import '../repository/journal_repository.dart';
import 'journal_event.dart';
import 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  JournalBloc({required this.repository}) : super(const JournalInitial()) {
    on<LoadJournal>(_onLoadJournal);
    on<AddEntry>(_onAddEntry);
    on<UpdateEntry>(_onUpdateEntry);
    on<DeleteEntry>(_onDeleteEntry);
    on<FilterByStatus>(_onFilterByStatus);
  }

  final JournalRepository repository;
  List<JournalEntryModel> _allEntries = <JournalEntryModel>[];
  String _selectedFilter = 'all';

  Future<void> _onLoadJournal(
    LoadJournal event,
    Emitter<JournalState> emit,
  ) async {
    emit(const JournalLoading());
    try {
      _allEntries = await repository.fetchEntries();
      emit(_buildLoadedState());
    } catch (_) {
      emit(const JournalError('Unable to load your journal right now.'));
    }
  }

  Future<void> _onAddEntry(AddEntry event, Emitter<JournalState> emit) async {
    try {
      await repository.addEntry(event.entry);
      _allEntries = await repository.fetchEntries();
      emit(
        JournalSuccess(
          message: 'Added to your travel journal.',
          entries: _filteredEntries,
          selectedFilter: _selectedFilter,
        ),
      );
    } catch (_) {
      emit(const JournalError('Unable to save this journal entry.'));
    }
  }

  Future<void> _onUpdateEntry(
    UpdateEntry event,
    Emitter<JournalState> emit,
  ) async {
    try {
      await repository.updateEntry(event.entry);
      _allEntries = await repository.fetchEntries();
      emit(
        JournalSuccess(
          message: 'Journal entry updated.',
          entries: _filteredEntries,
          selectedFilter: _selectedFilter,
        ),
      );
    } catch (_) {
      emit(const JournalError('Unable to update this journal entry.'));
    }
  }

  Future<void> _onDeleteEntry(
    DeleteEntry event,
    Emitter<JournalState> emit,
  ) async {
    try {
      await repository.deleteEntry(event.id);
      _allEntries = await repository.fetchEntries();
      emit(
        JournalSuccess(
          message: 'Journal entry removed.',
          entries: _filteredEntries,
          selectedFilter: _selectedFilter,
        ),
      );
    } catch (_) {
      emit(const JournalError('Unable to remove this journal entry.'));
    }
  }

  void _onFilterByStatus(FilterByStatus event, Emitter<JournalState> emit) {
    _selectedFilter = event.status;
    emit(_buildLoadedState());
  }

  List<JournalEntryModel> get _filteredEntries {
    if (_selectedFilter == 'all') {
      return _allEntries;
    }
    return _allEntries
        .where((JournalEntryModel entry) => entry.status == _selectedFilter)
        .toList();
  }

  JournalLoaded _buildLoadedState() {
    return JournalLoaded(
      entries: _filteredEntries,
      selectedFilter: _selectedFilter,
    );
  }
}
