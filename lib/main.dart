import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/countries/bloc/country_bloc.dart';
import 'features/countries/bloc/country_event.dart';
import 'features/countries/data/country_remote_datasource.dart';
import 'features/countries/models/country_model.dart';
import 'features/countries/presentation/country_detail_screen.dart';
import 'features/countries/presentation/country_list_screen.dart';
import 'features/journal/bloc/journal_bloc.dart';
import 'features/journal/bloc/journal_event.dart';
import 'features/journal/data/journal_local_datasource.dart';
import 'features/journal/data/journal_remote_datasource.dart';
import 'features/journal/models/journal_entry_model.dart';
import 'features/journal/presentation/journal_detail_screen.dart';
import 'features/journal/presentation/journal_form_screen.dart';
import 'features/journal/presentation/journal_list_screen.dart';
import 'features/journal/repository/journal_repository.dart';

void main() {
  runApp(const CountryExplorerApp());
}

class CountryExplorerApp extends StatelessWidget {
  const CountryExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<CountryBloc>(
          create: (_) =>
              CountryBloc(remoteDataSource: CountryRemoteDataSource())
                ..add(const LoadCountries()),
        ),
        BlocProvider<JournalBloc>(
          create: (_) => JournalBloc(
            repository: JournalRepository(
              remoteDataSource: JournalRemoteDataSource(),
              localDataSource: JournalLocalDataSource(),
            ),
          )..add(const LoadJournal()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Country Explorer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkGlassTheme,
        routerConfig: _router,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const CountryListScreen();
      },
    ),
    GoRoute(
      path: '/journal',
      builder: (BuildContext context, GoRouterState state) {
        return const JournalListScreen();
      },
    ),
    GoRoute(
      path: '/country',
      builder: (BuildContext context, GoRouterState state) {
        final country = state.extra as CountryModel?;
        if (country == null) {
          return const _MissingScreen(
            message: 'Choose a destination from Explore to see details.',
          );
        }
        return CountryDetailScreen(country: country);
      },
    ),
    GoRoute(
      path: '/entry',
      builder: (BuildContext context, GoRouterState state) {
        final entry = state.extra as JournalEntryModel?;
        if (entry == null) {
          return const _MissingScreen(
            message: 'Open a journal card to see the saved travel note.',
          );
        }
        return JournalDetailScreen(entry: entry);
      },
    ),
    GoRoute(
      path: '/journal-form',
      builder: (BuildContext context, GoRouterState state) {
        final extra = state.extra;
        if (extra is CountryModel) {
          return JournalFormScreen(country: extra);
        }
        if (extra is JournalEntryModel) {
          return JournalFormScreen(entry: extra);
        }
        return const _MissingScreen(
          message: 'Open this form from a country or journal entry.',
        );
      },
    ),
  ],
);

class _MissingScreen extends StatelessWidget {
  const _MissingScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unavailable')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
