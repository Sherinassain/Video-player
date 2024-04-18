import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_app/core/constants/color.dart';
import 'package:my_app/presentation/screens/home_screen/controller/home_controller.dart';
import 'package:my_app/presentation/screens/home_screen/view/tabs/offline_videos/offline_videos.dart';
import 'package:my_app/presentation/screens/home_screen/view/tabs/video_list_screen/video_list_screen.dart';
import 'package:my_app/presentation/screens/login_screen/controller/login_controller.dart';
import 'package:my_app/presentation/screens/online_video_screen/online_video_screen.dart';
import 'package:my_app/presentation/screens/user_registration_screen/view/controller/user_registration_controller.dart';

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
    DateTime? lastPressed;

  final loginCtrl = Get.put(LoginController());
  final userRegCtrl = Get.put(UserRegistrationController());
@override
  void initState() {
    loginCtrl.phoneController.clear();
    userRegCtrl.firstNameController.clear();
    userRegCtrl.dobController.clear();
    userRegCtrl.emailController.clear();
    userRegCtrl.phoneController.clear();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
            onWillPop: () async {
        DateTime now = DateTime.now();
        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2)) {
          lastPressed = now;
          Fluttertoast.showToast(
            msg: "Press back again to exit",
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );
          return false;
        }

        ///Exit the app
        FlutterExitApp.exitApp();
        return true; 
      },
      child: Obx(()=>
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
      ),
    );
  }
}












