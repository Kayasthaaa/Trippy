// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:trippy/src/constant/app_spaces.dart';
import 'package:trippy/src/constant/colors.dart';
import 'package:trippy/src/feature/screen/create_trips/page/create_trips.dart';
import 'package:trippy/src/feature/screen/home_screen/cubit/home_screen_cubit.dart';
import 'package:trippy/src/feature/screen/home_screen/cubit/home_screen_state.dart';
import 'package:trippy/src/feature/screen/home_screen/widgets/home_screen_card.dart';
import 'package:trippy/src/feature/screen/home_screen/widgets/sliders.dart';
import 'package:trippy/src/feature/widgets/app_bar.dart';
import 'package:trippy/src/feature/widgets/app_loading.dart';
import 'package:trippy/src/feature/widgets/app_texts.dart';
import 'package:trippy/src/feature/widgets/containers.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    final homeCubit = context.read<HomeCubit>();
    if (homeCubit.state.userList == null) {
      homeCubit.fetchUserList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      appBar: const CustomAppBar(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: AppLoading());
          } else if (state.error != null) {
            return Center(child: Texts(texts: state.error!));
          } else if (state.userList != null) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Containers(
                    margin: const EdgeInsets.symmetric(horizontal: 15.0),
                    width: maxWidth(context),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          SizedBox(width: 8),
                          Texts(
                            texts: 'Search for Trips',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Containers(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    width: maxWidth(context),
                    child: const Texts(
                      texts: 'About Us',
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      SizedBox(
                        height: 180,
                        child: PageView(
                          controller: _pageController,
                          children: [
                            buildSliderItem(
                                'images/imgtwo.jpg', 'Exciting Adventures'),
                            buildSliderItem(
                                'images/guide.jpg', 'Guide Services'),
                            buildSliderItem('images/pok.jpg', 'Pokhara Trips'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 3,
                        effect: const WormEffect(
                          dotColor: Colors.grey,
                          activeDotColor: Colors.blue,
                          dotHeight: 8,
                          dotWidth: 8,
                          spacing: 8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Containers(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    width: maxWidth(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Texts(
                          texts: 'Past Events',
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        Containers(
                          onTap: () {
                            Get.to(() => const TripPlannerPage());
                          },
                          width: 110,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromRGBO(56, 183, 255, 1),
                                Color.fromRGBO(131, 165, 255, 1),
                              ],
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(width: 2),
                              Texts(
                                texts: 'Create trips',
                                fontSize: 4,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 2),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 320,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final List<String> images = [
                          'purple.jpg',
                          'pink.jpg',
                          'mustang.jpg',
                          'pok.jpg',
                          'orange.jpg',
                        ];
                        final List<String> titles = [
                          'Badamalika',
                          'Mardi Trek',
                          'Mustang',
                          'Pokhara',
                          'Chitlang'
                        ];
                        final List<String> prices = [
                          '15000',
                          '20000',
                          '25000',
                          '20000',
                          '25000'
                        ];
                        final List<String> durations = [
                          '3 days',
                          '4 days',
                          '5 days',
                          '4 days',
                          '5 days'
                        ];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            height: 310,
                            width: 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  child: Image.asset(
                                    'images/${images[index]}',
                                    height: 310,
                                    width: 220,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Positioned price on the top left of the image
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'NPR \n${prices[index]}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 25,
                                  left: 15,
                                  right: 15,
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Texts(
                                          texts: titles[index],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                        Texts(
                                          texts: durations[index],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                              255, 202, 201, 201),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Containers(
                    margin: const EdgeInsets.symmetric(horizontal: 18.0),
                    width: maxWidth(context),
                    child: const Texts(
                      texts: 'Upcoming Trips',
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.userList!.data.trips.length,
                    itemBuilder: (context, index) {
                      final user = state.userList!.data.trips[index];
                      return Card_3D(
                        imageUrl: user.tripName,
                        title: user.tripName,
                        desc: user.arrivalPlace,
                        price: user.tripPrice,
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          } else {
            return const Center(child: Texts(texts: 'No data available'));
          }
        },
      ),
    );
  }
}
