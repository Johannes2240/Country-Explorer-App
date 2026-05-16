import '../models/country_model.dart';

abstract class CountryState {
  const CountryState();
}

class CountryInitial extends CountryState {
  const CountryInitial();
}

class CountryLoading extends CountryState {
  const CountryLoading();
}

class CountryLoaded extends CountryState {
  const CountryLoaded({
    required this.allCountries,
    required this.countries,
    required this.query,
  });

  final List<CountryModel> allCountries;
  final List<CountryModel> countries;
  final String query;
}

class CountryError extends CountryState {
  const CountryError(this.message);

  final String message;
}
