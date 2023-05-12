import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:read_me_a_story/book_home.dart';
import 'package:read_me_a_story/favourtes_screen.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final PersistentTabController _controller = PersistentTabController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return PersistentTabView(
      context,
      controller: _controller,
      navBarHeight: size.height * 0.08,
      screens: [
        BooksHome(),
        FavouratesScreen(),
      ],
      items: [
        PersistentBottomNavBarItem(
          title: 'Home',
          activeColorPrimary: CupertinoColors.activeOrange,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          iconSize: 30,
          icon: Icon(
            Icons.home_outlined,
          ),
        ),
        PersistentBottomNavBarItem(
          title: 'Favourites',
          activeColorPrimary: CupertinoColors.activeOrange,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          iconSize: 30,
          icon: Icon(
            Icons.favorite_outline,
          ),
        ),
      ],
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    );

    // CupertinoTabScaffold(
    //   // child: BooksHome(),
    //   tabBuilder: (context, index) => CupertinoTabView(
    //     builder: (context) => index == 0 ? BooksHome() : FavouratesScreen(),
    //   ),
    //   tabBar: CupertinoTabBar(
    //     height: 80,
    //     items: [
    //       BottomNavigationBarItem(
    //         icon: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Icon(
    //               CupertinoIcons.home,
    //               size: 50,
    //             ),
    //             Text(
    //               'Home',
    //               style: TextStyle(fontSize: 18),
    //             ),
    //           ],
    //         ),
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Icon(
    //               CupertinoIcons.heart_fill,
    //               size: 50,
    //             ),
    //             Text(
    //               'Favoutrites',
    //               style: TextStyle(fontSize: 18),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
