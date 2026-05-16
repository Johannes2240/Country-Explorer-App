import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../bloc/country_bloc.dart';
import '../bloc/country_event.dart';
import '../bloc/country_state.dart';
import '../models/country_model.dart';

class CountryListScreen extends StatelessWidget {
  const CountryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (int index) {
          if (index == 1) {
            context.go('/journal');
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
        child: BlocBuilder<CountryBloc, CountryState>(
          builder: (BuildContext context, CountryState state) {
            if (state is CountryLoading || state is CountryInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CountryError) {
              return _CountryError(message: state.message);
            }

            final loaded = state as CountryLoaded;
            final featured = loaded.countries.isNotEmpty
                ? loaded.countries.first
                : null;
            final uniqueRegions = loaded.countries
                .map((CountryModel country) => country.region)
                .toSet()
                .length;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<CountryBloc>().add(const LoadCountries());
              },
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: <Widget>[
                  _ExplorerHero(
                    countryCount: loaded.countries.length,
                    regionCount: uniqueRegions,
                    onOpenJournal: () => context.go('/journal'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (String value) {
                      context.read<CountryBloc>().add(SearchCountries(value));
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: 'Search countries',
                      hintText: 'Japan, Africa, Rome...',
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (featured != null) _FeaturedCountryCard(country: featured),
                  if (featured != null) const SizedBox(height: 20),
                  Text(
                    'Explore all destinations',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  if (loaded.countries.isEmpty)
                    const _EmptyCountryState()
                  else
                    ...loaded.countries.map(
                      (CountryModel country) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _CountryListCard(country: country),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeaturedCountryCard extends StatelessWidget {
  const _FeaturedCountryCard({required this.country});

  final CountryModel country;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/country', extra: country),
      borderRadius: BorderRadius.circular(24),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 230,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              if (country.flagUrl != null)
                CachedNetworkImage(
                  imageUrl: country.flagUrl!,
                  fit: BoxFit.cover,
                  errorWidget:
                      (BuildContext context, String url, Object error) =>
                          _FlagPlaceholder(country: country, size: 80),
                )
              else
                _FlagPlaceholder(country: country, size: 80),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '${country.flagEmoji} ${country.commonName}',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${country.region} • ${country.capital ?? 'Capital unavailable'}',
                      style: Theme.of(context).textTheme.bodyLarge,
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

class _CountryListCard extends StatelessWidget {
  const _CountryListCard({required this.country});

  final CountryModel country;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/country', extra: country),
      borderRadius: BorderRadius.circular(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 80,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: country.flagUrl != null
                      ? CachedNetworkImage(
                          imageUrl: country.flagUrl!,
                          fit: BoxFit.cover,
                          errorWidget:
                              (
                                BuildContext context,
                                String url,
                                Object error,
                              ) => _FlagPlaceholder(country: country),
                        )
                      : _FlagPlaceholder(country: country),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${country.flagEmoji} ${country.commonName}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${country.region} • ${country.capital ?? 'No capital listed'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Population ${_formatPopulation(country.population)}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppTheme.kGlass,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Text(
                        country.cca2,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlagPlaceholder extends StatelessWidget {
  const _FlagPlaceholder({required this.country, this.size = 32});

  final CountryModel country;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.kSurface,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(country.flagEmoji, style: TextStyle(fontSize: size * 0.6)),
          const SizedBox(height: 4),
          Text(country.cca2, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}

class _ExplorerHero extends StatelessWidget {
  const _ExplorerHero({
    required this.countryCount,
    required this.regionCount,
    required this.onOpenJournal,
  });

  final int countryCount;
  final int regionCount;
  final VoidCallback onOpenJournal;

  @override
  Widget build(BuildContext context) {
    final stats = <({String label, String value, IconData icon})>[
      (label: 'Countries', value: countryCount.toString(), icon: Icons.public),
      (
        label: 'Regions',
        value: regionCount.toString(),
        icon: Icons.map_outlined,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF11314A), Color(0xFF1B5B84)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.kGlassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Atlas explorer',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Browse countries, capitals, and regions, then save the places you want to remember.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onOpenJournal,
                icon: const Icon(Icons.auto_stories_outlined),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: stats.map((card) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(card.icon, color: AppTheme.kAccent),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            card.value,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            card.label,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _CountryError extends StatelessWidget {
  const _CountryError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.travel_explore, size: 48, color: AppTheme.kAccent),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () =>
                  context.read<CountryBloc>().add(const LoadCountries()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCountryState extends StatelessWidget {
  const _EmptyCountryState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            const Icon(Icons.map_outlined, size: 52, color: AppTheme.kAccent),
            const SizedBox(height: 12),
            Text(
              'No destinations match that search.',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

String _formatPopulation(int population) {
  final value = population.toString();
  final buffer = StringBuffer();
  for (int index = 0; index < value.length; index++) {
    final reversedIndex = value.length - index;
    buffer.write(value[index]);
    if (reversedIndex > 1 && reversedIndex % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
