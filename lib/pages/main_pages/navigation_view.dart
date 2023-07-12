import 'package:globe/constants.dart';

import 'find_users_page.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomePage(),
          FindUsersPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: transparent,
          highlightColor: transparent,
          brightness: Brightness.dark,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house_fill),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.search,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_crop_circle),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: grey,
          selectedItemColor: mainColor,
          iconSize: 25,
          selectedIconTheme: const IconThemeData(size: 31),
          elevation: 0,
          backgroundColor: transparent,
          enableFeedback: false,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
