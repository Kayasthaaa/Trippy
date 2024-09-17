import 'package:trippy/src/feature/screen/trip_details/api/trip_details_api.dart';
import 'package:trippy/src/feature/screen/trip_details/models/trip_details_models.dart';

class GetTripDetailsRepository {
  final TripDetailsApi _apiService;

  GetTripDetailsRepository(this._apiService);

  Future<TripDetailsModels> getTripDetails(String tripId) async {
    final response = await _apiService.get('/trip/details/$tripId');

    return TripDetailsModels.fromJson(response.data);
  }
}
