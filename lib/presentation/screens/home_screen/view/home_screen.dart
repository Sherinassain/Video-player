import 'package:flutter/material.dart';
import 'package:my_app/presentation/screens/home_screen/view/tabs/offline_videos/offline_videos.dart';
import 'package:my_app/presentation/screens/home_screen/view/tabs/video_list_screen/video_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
    return Scaffold(

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
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
    );
  }
}












