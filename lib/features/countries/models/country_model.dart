class CountryModel {
  const CountryModel({
    required this.cca2,
    required this.commonName,
    required this.flagEmoji,
    this.flagUrl,
    this.capital,
    required this.region,
    required this.population,
  });

  final String cca2;
  final String commonName;
  final String flagEmoji;
  final String? flagUrl;
  final String? capital;
  final String region;
  final int population;

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> name =
        json['name'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> flags =
        json['flags'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final List<dynamic> capitalList =
        json['capital'] as List<dynamic>? ?? <dynamic>[];

    // Try to get flag emoji from 'flag' or calculate from cca2
    String emoji = (json['flag'] ?? '') as String;
    if (emoji.isEmpty && (json['cca2'] as String?)?.length == 2) {
      final cca2 = json['cca2'] as String;
      final int firstChar = cca2.codeUnitAt(0) - 0x41 + 0x1F1E6;
      final int secondChar = cca2.codeUnitAt(1) - 0x41 + 0x1F1E6;
      emoji = String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
    }

    return CountryModel(
      cca2: (json['cca2'] ?? '') as String,
      commonName: (name['common'] ?? 'Unknown') as String,
      flagEmoji: emoji.isNotEmpty ? emoji : '🏳️',
      flagUrl: (flags['png'] ?? flags['svg']) as String?,
      capital: capitalList.isEmpty ? null : capitalList.first as String,
      region: (json['region'] ?? 'Other') as String,
      population: (json['population'] as num?)?.toInt() ?? 0,
    );
  }
}
