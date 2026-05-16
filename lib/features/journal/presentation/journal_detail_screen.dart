import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../bloc/journal_bloc.dart';
import '../bloc/journal_event.dart';
import '../models/journal_entry_model.dart';

class JournalDetailScreen extends StatelessWidget {
  const JournalDetailScreen({super.key, required this.entry});

  final JournalEntryModel entry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.countryName),
        actions: <Widget>[
          IconButton(
            onPressed: () => context.push('/journal-form', extra: entry),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: SizedBox(
              height: 240,
              child: entry.flagUrl != null
                  ? CachedNetworkImage(
                      imageUrl: entry.flagUrl!,
                      fit: BoxFit.cover,
                      errorWidget:
                          (BuildContext context, String url, Object error) =>
                              const _JournalHeaderFallback(),
                    )
                  : const _JournalHeaderFallback(),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              Chip(label: Text(entry.statusLabel)),
              if (!entry.isSynced) const Chip(label: Text('Pending sync')),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            entry.countryName,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Added ${entry.addedAt.toLocal().toString().split(' ').first}',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Your note',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    entry.notes?.trim().isNotEmpty == true
                        ? entry.notes!
                        : 'No travel note added yet.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/journal-form', extra: entry),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _delete(context),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _delete(BuildContext context) async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete journal entry?'),
          content: Text('Remove ${entry.countryName} from your journal?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (approved != true || !context.mounted) {
      return;
    }

    final id = entry.id;
    if (id != null) {
      context.read<JournalBloc>().add(DeleteEntry(id));
    }
    context.pop();
  }
}

class _JournalHeaderFallback extends StatelessWidget {
  const _JournalHeaderFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.kSurface,
      alignment: Alignment.center,
      child: const Icon(Icons.public, size: 72, color: AppTheme.kAccent),
    );
  }
}
