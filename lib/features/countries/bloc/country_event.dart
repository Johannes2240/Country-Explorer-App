abstract class CountryEvent {
  const CountryEvent();
}

class LoadCountries extends CountryEvent {
  const LoadCountries();
}

class SearchCountries extends CountryEvent {
  const SearchCountries(this.query);

  final String query;
}
