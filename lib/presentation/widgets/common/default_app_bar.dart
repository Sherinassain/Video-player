import 'package:flutter/material.dart';
import 'package:my_app/core/constants/textstyle.dart';

import '../../../core/constants/color.dart';


AppBar defaultAppBar(BuildContext context,Function callbackAction) {
  return AppBar(
    elevation: 2,
    backgroundColor: Colors.blue,
    titleSpacing: 0,centerTitle: true,
    automaticallyImplyLeading: true,
    title:Center(
      child: Text('Video player',style: TextStyleClass.poppinsRegular(size: 15.00),)
    ),
    actions: [
      InkWell(
        child: Icon(Icons.person,color: ColorConst.white,size: 25,),onTap: (){
        callbackAction();
      },
      ),
      SizedBox(width: 20,)
    ],
  );
}