// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:trippy/src/constant/colors.dart';
import 'package:trippy/src/feature/screen/enrolled_trips/page/enrolled_trips.dart';
import 'package:trippy/src/feature/screen/get_profile/page/get_profile_page.dart';
import 'package:trippy/src/feature/screen/get_trips/page/get_trips_page.dart';
import 'package:trippy/src/feature/screen/home_screen/page/home_scree.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Home(),
    const EnrolledTripsPage(),
    const TripPage(),
    const ProfilePage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 3,
          selectedItemColor: AppColor.appThemeColor,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: 28,
              ),
              activeIcon: Icon(
                Icons.home,
                size: 28,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bookmark,
                size: 28,
              ),
              activeIcon: Icon(
                Icons.bookmark,
                size: 28,
              ),
              label: 'Enrolled Trips',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.explore,
                size: 28,
              ),
              activeIcon: Icon(
                Icons.explore,
                size: 28,
              ),
              label: 'My Trips',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
                size: 28,
              ),
              activeIcon: Icon(
                Icons.person,
                size: 28,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
