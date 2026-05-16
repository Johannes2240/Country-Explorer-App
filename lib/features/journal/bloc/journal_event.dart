import '../models/journal_entry_model.dart';

abstract class JournalEvent {
  const JournalEvent();
}

class LoadJournal extends JournalEvent {
  const LoadJournal();
}

class AddEntry extends JournalEvent {
  const AddEntry(this.entry);

  final JournalEntryModel entry;
}

class UpdateEntry extends JournalEvent {
  const UpdateEntry(this.entry);

  final JournalEntryModel entry;
}

class DeleteEntry extends JournalEvent {
  const DeleteEntry(this.id);

  final int id;
}

class FilterByStatus extends JournalEvent {
  const FilterByStatus(this.status);

  final String status;
}
