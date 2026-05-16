import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/country_remote_datasource.dart';
import '../models/country_model.dart';
import 'country_event.dart';
import 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  CountryBloc({required this.remoteDataSource})
    : super(const CountryInitial()) {
    on<LoadCountries>(_onLoadCountries);
    on<SearchCountries>(_onSearchCountries);
  }

  final CountryRemoteDataSource remoteDataSource;
  List<CountryModel> _allCountries = <CountryModel>[];

  Future<void> _onLoadCountries(
    LoadCountries event,
    Emitter<CountryState> emit,
  ) async {
    emit(const CountryLoading());
    try {
      _allCountries = await remoteDataSource.fetchCountries();
      emit(
        CountryLoaded(
          allCountries: _allCountries,
          countries: _allCountries,
          query: '',
        ),
      );
    } catch (_) {
      emit(const CountryError('Unable to load countries right now.'));
    }
  }

  void _onSearchCountries(SearchCountries event, Emitter<CountryState> emit) {
    final query = event.query.trim().toLowerCase();
    final filtered = _allCountries.where((CountryModel country) {
      return country.commonName.toLowerCase().contains(query) ||
          country.region.toLowerCase().contains(query) ||
          (country.capital?.toLowerCase().contains(query) ?? false);
    }).toList();

    emit(
      CountryLoaded(
        allCountries: _allCountries,
        countries: query.isEmpty ? _allCountries : filtered,
        query: event.query,
      ),
    );
  }
}
