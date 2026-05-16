import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/journal_bloc.dart';
import '../bloc/journal_event.dart';
import '../bloc/journal_state.dart';
import '../models/journal_entry_model.dart';

class JournalListScreen extends StatelessWidget {
  const JournalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JournalBloc, JournalState>(
      listener: (BuildContext context, JournalState state) {
        if (state is JournalSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
          context.read<JournalBloc>().add(FilterByStatus(state.selectedFilter));
        }
      },
      builder: (BuildContext context, JournalState state) {
        final entries = switch (state) {
          JournalLoaded loaded => loaded.entries,
          JournalSuccess success => success.entries,
          _ => <JournalEntryModel>[],
        };

        final selectedFilter = switch (state) {
          JournalLoaded loaded => loaded.selectedFilter,
          JournalSuccess success => success.selectedFilter,
          _ => 'all',
        };

        return Scaffold(
          bottomNavigationBar: NavigationBar(
            selectedIndex: 1,
            onDestinationSelected: (int index) {
              if (index == 0) {
                context.go('/');
              }
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(icon: Icon(Icons.public), label: 'Explore'),
              NavigationDestination(
                icon: Icon(Icons.bookmark_outline),
                label: 'Journal',
              ),
            ],
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<JournalBloc>().add(const LoadJournal());
              },
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: <Widget>[
                  Text(
                    'My travel journal',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keep a beautiful record of destinations you want to visit, places already explored, and notes worth remembering.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: AppConstants.journalFilters.map((String filter) {
                      return ChoiceChip(
                        label: Text(_statusChipLabel(filter)),
                        selected: selectedFilter == filter,
                        onSelected: (_) {
                          context.read<JournalBloc>().add(
                            FilterByStatus(filter),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  if (state is JournalLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (state is JournalError)
                    _JournalError(message: state.message)
                  else if (entries.isEmpty)
                    const _EmptyJournalState()
                  else
                    ...entries.map(
                      (JournalEntryModel entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _JournalCard(entry: entry),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _JournalCard extends StatelessWidget {
  const _JournalCard({required this.entry});

  final JournalEntryModel entry;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/entry', extra: entry),
      borderRadius: BorderRadius.circular(22),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 82,
                  height: 82,
                  child: entry.flagUrl != null
                      ? CachedNetworkImage(
                          imageUrl: entry.flagUrl!,
                          fit: BoxFit.cover,
                          errorWidget:
                              (
                                BuildContext context,
                                String url,
                                Object error,
                              ) => const _JournalPlaceholder(),
                        )
                      : const _JournalPlaceholder(),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      entry.countryName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      entry.statusLabel,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry.notes?.trim().isNotEmpty == true
                          ? entry.notes!
                          : 'No notes added yet. Open the entry to add your story.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JournalPlaceholder extends StatelessWidget {
  const _JournalPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.kSurface,
      alignment: Alignment.center,
      child: const Icon(Icons.flight_takeoff, color: AppTheme.kAccent),
    );
  }
}

class _JournalError extends StatelessWidget {
  const _JournalError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: <Widget>[
            const Icon(Icons.error_outline, color: AppTheme.kAccent, size: 42),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _EmptyJournalState extends StatelessWidget {
  const _EmptyJournalState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.menu_book_outlined,
              size: 54,
              color: AppTheme.kAccent,
            ),
            const SizedBox(height: 12),
            Text(
              'Your journal is empty.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Start from the Explore tab and save a country that inspires you.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Explore Countries'),
            ),
          ],
        ),
      ),
    );
  }
}

String _statusChipLabel(String value) {
  switch (value) {
    case 'want_to_go':
      return 'Want to Go';
    case 'planning':
      return 'Planning';
    case 'visited':
      return 'Visited';
    default:
      return 'All';
  }
}
