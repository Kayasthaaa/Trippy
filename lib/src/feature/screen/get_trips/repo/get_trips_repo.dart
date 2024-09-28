import 'package:trippy/src/feature/screen/get_trips/api/get_trips_api.dart';
import 'package:trippy/src/feature/screen/get_trips/models/get_trips_model_class.dart';

class GetTripRepository {
  final GetTripApiService _apiService;

  GetTripRepository(this._apiService);

  Future<TripResponse> getTrips() async {
    final response = await _apiService.getTrips();
    return TripResponse.fromJson(response.data);
  }
}
