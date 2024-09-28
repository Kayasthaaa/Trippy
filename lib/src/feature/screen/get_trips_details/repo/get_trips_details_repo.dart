import 'package:trippy/src/feature/screen/get_trips_details/get_trips_details_api/get_trips_details_api.dart';
import 'package:trippy/src/feature/screen/get_trips_details/get_trips_details_models/created_trips_model.dart';

class GetCreatedTripDetailsRepository {
  final GetCreatedTripDetailsApi _api;

  GetCreatedTripDetailsRepository(this._api);

  Future<CreatedTripDetailsModels> fetchTripDetails(int tripId) {
    return _api.fetchTripDetails(tripId);
  }
}
