import '../../../core/constants/app_constants.dart';
import '../../../core/network/dio_client.dart';
import '../models/country_model.dart';

class CountryRemoteDataSource {
  Future<List<CountryModel>> fetchCountries() async {
    final response = await DioClient.instance.get<dynamic>(
      AppConstants.countriesUrl,
    );
    final List<dynamic> data = response.data as List<dynamic>? ?? <dynamic>[];
    final countries =
        data
            .map(
              (dynamic item) =>
                  CountryModel.fromJson(item as Map<String, dynamic>),
            )
            .where((CountryModel item) => item.cca2.isNotEmpty)
            .toList()
          ..sort(
            (CountryModel a, CountryModel b) => a.commonName
                .toLowerCase()
                .compareTo(b.commonName.toLowerCase()),
          );
    return countries;
  }
}
