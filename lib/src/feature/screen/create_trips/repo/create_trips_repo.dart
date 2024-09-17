// import 'package:trippy/src/feature/screen/create_trips/api/create_trips_api.dart';

// class PostTripRepository {
//   final PostTripApiService _apiService;

//   PostTripRepository(this._apiService);

//   Future<void> submitTripData({
//     required String tripName,
//     required String tripDescription,
//     required double tripPrice,
//     required String startDate,
//     required String endDate,
//     required String arrivalTime,
//     required String meansOfTransport,
//     required bool isPrivate,
//     required String startLoc,
//     required String startLocName,
//     required String endLoc,
//     required String endLocName,
//     required List<String> locations,
//   }) async {
//     final tripData = {
//       'trip_name': tripName,
//       'trip_description': tripDescription,
//       'trip_price': tripPrice,
//       'start_date': startDate,
//       'end_date': endDate,
//       'arrival_time': arrivalTime,
//       'means_of_transport': meansOfTransport,
//       'is_private': isPrivate,
//       'start_loc': startLoc,
//       'start_loc_name': startLocName,
//       'end_loc': endLoc,
//       'end_loc_name': endLocName,
//       'location': locations,
//     };

//     await _apiService.postTrip(tripData);
//   }
// }
