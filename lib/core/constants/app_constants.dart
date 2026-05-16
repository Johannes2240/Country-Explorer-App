class AppConstants {
  static const String appName = 'Country Explorer';
  static const String countriesUrl =
      'https://restcountries.com/v3.1/all?fields=name,flags,capital,region,population,cca2,flag';
  static const String journalBaseUrl = 'https://dummyjson.com/posts';
  static const String journalTable = 'journal_entries';

  static const List<String> journalFilters = <String>[
    'all',
    'want_to_go',
    'planning',
    'visited',
  ];
}
