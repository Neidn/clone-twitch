import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utils/colors.dart';

import '/providers/user_provider.dart';

import '/screens/feed_screen.dart';
import '/screens/go_live_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const FeedScreen(),
    const GoLiveScreen(),
    const Text('Browse'),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: _currentIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void jumpToPage(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: buttonColor,
        unselectedItemColor: primaryColor,
        backgroundColor: backgroundColor,
        currentIndex: _currentIndex,
        onTap: jumpToPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Following',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_rounded),
            label: 'Go Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.copy),
            label: 'Browse',
          ),
        ],
      ),
    );
  }
}
