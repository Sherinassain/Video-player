import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_app/core/constants/color.dart';
import 'package:my_app/presentation/screens/home_screen/controller/home_controller.dart';

class CommonImageView extends StatelessWidget {
  final String? url;
  final String? imagePath;
  final String? svgPath;
  final File? file;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit fit;
  final String placeHolder;

  CommonImageView({
    this.url,
    this.imagePath,
    this.svgPath,
    this.file,
    this.height,
    this.width,
    this.color,
    this.fit = BoxFit.fill,
    this.placeHolder = 'assets/images/img_no_image.png',
  });
    final homeCtrl = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return _buildImageView();
  }

  Widget _buildImageView() {
    if (svgPath != null && svgPath!.isNotEmpty) {
      return Container(
        height: height,
        width: width,
        child: SvgPicture.asset(
          svgPath!,
          height: height,
          width: width,
          fit: fit,
          color: color,
        ),
      );
    } else if (file != null && file!.path.isNotEmpty) {
      return Image.file(
        file!,
        height: height,
        width: width,
        fit: fit,
        color: color,
      );
    } else if (url != null && url!.isNotEmpty) {
      return Image.network(
        url!,
        height: height,
        width: width,
        fit: fit,
        color: color,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(child: Padding(
            padding: const EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ));
        },
        errorBuilder: (context, error, stackTrace) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Obx(()=>
            Image.asset(
                placeHolder,
                height: height,
                width: width,
                fit: fit,
                color: (homeCtrl.isDarkTheme.value == false)?ColorConst.black:ColorConst.white,
              ),
            ),
          );
        },
      );
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      return Image.asset(
        imagePath!,
        height: height,
        width: width,
        fit: fit,
      );
    } else {
      return Image.asset(
        placeHolder,
        height: height,
        width: width,
        fit: fit,
      );
    }
  }
}
