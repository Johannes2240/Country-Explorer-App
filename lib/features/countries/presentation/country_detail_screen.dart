import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../models/country_model.dart';

class CountryDetailScreen extends StatelessWidget {
  const CountryDetailScreen({super.key, required this.country});

  final CountryModel country;

  @override
  Widget build(BuildContext context) {
    final facts = <({String label, String value})>[
      (label: 'Region', value: country.region),
      (label: 'Capital', value: country.capital ?? 'Unavailable'),
      (label: 'Population', value: _formatPopulation(country.population)),
      (label: 'Country Code', value: country.cca2),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(country.commonName)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: country.flagUrl != null
                      ? CachedNetworkImage(
                          imageUrl: country.flagUrl!,
                          fit: BoxFit.cover,
                          errorWidget:
                              (
                                BuildContext context,
                                String url,
                                Object error,
                              ) => _DetailPlaceholder(country: country),
                        )
                      : _DetailPlaceholder(country: country),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: <Widget>[
                        Text(
                          country.flagEmoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                country.commonName,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${country.region} • ${country.capital ?? 'Capital unavailable'}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppTheme.kGlass,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.kGlassBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                'A quick snapshot to help you decide whether this destination belongs in your travel journal.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: facts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.25,
            ),
            itemBuilder: (BuildContext context, int index) {
              final fact = facts[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        fact.label,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        fact.value,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Travel note',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Save this place to track why it matters to you, what you want to experience, and when you hope to go.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/journal-form', extra: country),
            icon: const Icon(Icons.bookmark_add_outlined),
            label: const Text('Add to Journal'),
          ),
        ],
      ),
    );
  }
}

class _DetailPlaceholder extends StatelessWidget {
  const _DetailPlaceholder({required this.country});

  final CountryModel country;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.kSurface,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(country.flagEmoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 8),
          Text(country.cca2, style: Theme.of(context).textTheme.headlineSmall),
        ],
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
