import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_app/presentation/screens/home_screen/controller/home_controller.dart';

void showThemeBottomSheet(BuildContext context) {
    final homeCtrl = Get.put(HomeController());

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return  Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading:const Icon(Icons.brightness_5), // Light theme icon
                title:const Text('Light Theme'),
                onTap: () {
                  homeCtrl.isDarkTheme.value = false;
                  Get.changeTheme(ThemeData.light());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading:const Icon(Icons.brightness_2), // Dark theme icon
                title:const Text('Dark Theme'),
                onTap: () {
                                    homeCtrl.isDarkTheme.value = true;

                  Get.changeTheme(ThemeData.dark());
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
