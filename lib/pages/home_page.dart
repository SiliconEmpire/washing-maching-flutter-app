import 'package:flutter/material.dart';
import 'package:washing_machine_app_v2/pages/main_page.dart';
import 'package:washing_machine_app_v2/style/style.dart';

import 'component/fab_comp.dart';
import 'conifguration_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final List<Widget> pages = [
      MainPage(height: height, width: width),
      ConfigPage(height: height, width: width),
    ];
    return Scaffold(
      body: pages[currentIndex],
      floatingActionButton: FAButton(size: size),
      // floatingActionButtonLocation: FloatingActionButtonLocation.start,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configure',
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: color10,
        unselectedItemColor: Colors.grey.shade500,
        type: BottomNavigationBarType.fixed,
        // iconSize: size.width * 0.08,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      backgroundColor: color60,
    );
  }
}
