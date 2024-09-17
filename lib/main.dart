import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/route_manager.dart';
import 'package:trippy/src/constant/navigation_service.dart';
import 'package:trippy/src/controller/network_controller.dart';
import 'package:trippy/src/feature/screen/get_profile/api/get_profile_api.dart';
import 'package:trippy/src/feature/screen/get_profile/cubit/get_profile_cubit.dart';
import 'package:trippy/src/feature/screen/get_profile/repo/get_profile_repo.dart';
import 'package:trippy/src/feature/screen/home_screen/api/home_screen_api.dart';
import 'package:trippy/src/feature/screen/home_screen/cubit/home_screen_cubit.dart';
import 'package:trippy/src/feature/screen/home_screen/repo/home_screen_repo.dart';
import 'package:trippy/src/feature/screen/login_screen/cubit/login_cubit.dart';
import 'package:trippy/src/feature/screen/login_screen/login_api/login_api.dart';
import 'package:trippy/src/feature/screen/login_screen/login_repo/login_repo.dart';
import 'package:trippy/src/feature/screen/register_screen/cubit/register_cubit.dart';
import 'package:trippy/src/feature/screen/register_screen/register_api/register_api.dart';
import 'package:trippy/src/feature/screen/register_screen/register_repo/register_repo.dart';
import 'package:trippy/src/feature/screen/trip_details/api/trip_details_api.dart';
import 'package:trippy/src/feature/screen/trip_details/cubit/trip_details_cubit.dart';
import 'package:trippy/src/feature/widgets/app_loading.dart';
import 'package:trippy/src/routes/routes.dart';

import 'src/feature/screen/trip_details/repo/trip_details_repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppBase();
  }
}

class AppBase extends StatelessWidget {
  const AppBase({super.key});

  @override
  Widget build(BuildContext context) {
    final AppRouter appRouter = AppRouter();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserCubit(
            UserRepository(
              ApiService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(
            RegisterRepository(
              RegisterApiService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => HomeCubit(
            HomeRepository(
              HomeApiService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => GetProfileCubit(
            GetProfileRepository(
              GetProfileApiService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => GetTripDetailsCubit(
            GetTripDetailsRepository(
              TripDetailsApi(),
            ),
          ),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: appRouter.onGenerateRoute,
        navigatorKey: NavigationService.navigatorKey,
        builder: (context, navigator) {
          return ConnectivityWrapper(
            //? Return a default widget if navigator is null
            child: Center(child: navigator ?? AppLoading()),
          );
        },
        theme: ThemeData(
          useMaterial3: true,
        ),
      ),
    );
  }
}
