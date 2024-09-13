import 'package:trippy/src/constant/app_url.dart';
import 'package:trippy/src/feature/screen/home_screen/api/home_screen_api.dart';
import 'package:trippy/src/feature/screen/home_screen/models/home_screen_models.dart';

class HomeRepository {
  final HomeApiService _apiService;

  HomeRepository(this._apiService);

  Future<HomeModel> getUserList(int page) async {
    final response = await _apiService.get(ApiUrl.kHomePage);
    return HomeModel.fromJson(response.data);
  }
}
