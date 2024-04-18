import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_app/core/constants/color.dart';
import 'package:my_app/presentation/screens/home_screen/controller/home_controller.dart';
import 'package:my_app/presentation/screens/home_screen/view/tabs/offline_videos/offline_videos.dart';
import 'package:my_app/presentation/screens/home_screen/view/tabs/video_list_screen/video_list_screen.dart';
import 'package:my_app/presentation/screens/online_video_screen/online_video_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
    final homeCtrl = Get.put(HomeController());

  static List<Widget> _widgetOptions = <Widget>[
    VideoListScreen(),
    OfflineVideos(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
 Scaffold(
                      backgroundColor: (homeCtrl.isDarkTheme.value == false)?ColorConst.white:ColorConst.black,
      
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items:const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library),
              label: 'Videos List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.download_rounded),
              label: 'Offline Videos',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}












