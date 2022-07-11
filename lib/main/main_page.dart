import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const FaIcon(
          FontAwesomeIcons.plus,
          size: 25,
        ),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: customBottomAppBar(),
      body: Container(),
    );
  }

  BottomAppBar customBottomAppBar() {
    return BottomAppBar(
      color: Colors.green,
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  _currentPage = 0;
                });
              },
              icon: Icon(
                _currentPage == 0 ? Icons.home_rounded : Icons.home_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  _currentPage = 1;
                });
              },
              icon: Icon(
                _currentPage == 1
                    ? FontAwesomeIcons.magnifyingGlass
                    : Icons.search,
                color: Colors.white,
                size: 30,
              ),
            ),
            const Spacer(
              flex: 3,
            ),
            IconButton(
              enableFeedback: true,
              onPressed: () {
                setState(() {
                  _currentPage = 2;
                });
              },
              icon: Icon(
                _currentPage == 2
                    ? Icons.notifications
                    : Icons.notifications_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  _currentPage = 3;
                });
              },
              icon: Icon(
                _currentPage == 3 ? Icons.person : Icons.person_outline,
                color: Colors.white,
                size: 30,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
