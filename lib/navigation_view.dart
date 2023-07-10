import 'package:globe/constants.dart';
import 'package:globe/pages/main_pages/find_users_page.dart';
import 'package:globe/pages/main_pages/home_page.dart';
import 'package:globe/pages/main_pages/profile_page.dart';
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
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
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
          unselectedItemColor: CupertinoColors.systemGrey,
          selectedItemColor: mainColor,
          iconSize: 25,
          selectedIconTheme: const IconThemeData(size: 32),
          elevation: 0,
          backgroundColor: Colors.transparent,
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

