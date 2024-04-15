import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/app_config.dart';
import 'package:my_app/presentation/screens/login_screen/view/login_screen.dart';
import 'package:my_app/presentation/screens/network_error_screen/view/network_error_screen.dart';
import 'package:my_app/core/utiles/app_utils.dart';

// import 'package:rentpe_saas/core/utils/app_utils.dart';
// import 'package:rentpe_saas/routes.dart';
import 'api_response.dart';

class APIHelper {
  static bool isRequestSucceeded(int statusCode) {
    if (statusCode == 401) {
      // AppUtils.oneTimeSnackBar("Login session Expired! , Login again to continue.",bgColor: Colors.red,time: 3);
      // Routes.router.navigator!.context.replace('/LoginScreen');
      // Get.toNamed("/LogInScreen");
      // checkTokenValidity();
      // Routes.router.routerDelegate.navigatorKey.currentState!.context.go("/SignInScreen");
      AppUtils.oneTimeSnackBar(
          "Session Expired ! , Please re-login to continue",
          bgColor: Colors.red,
          time: 3);

      Get.offAll(LoginScreen());
    }

    ///if 402 ie. subscription expired
    if (statusCode == 402) {
      // Routes.router.routerDelegate.navigatorKey.currentState!.context.go("/SubscriptionRequiredScreen");
      // AppUtils.oneTimeSnackBar("Subscription Expired !",bgColor: Colors.red,time: 3);
    }

    ///todo : need to handle in other way
    // return statusCode >= 200 && statusCode < 401||statusCode==500;
    return (statusCode >= 200) && (statusCode <= 404 || statusCode == 500);
  }

  static Map<String, String> getApiHeader({String? access, String? dbName}) {
    AppUtils.logger.d("Access : Bearer $access");

    if (access != null) {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access'
      };
    } else if (dbName != null) {
      return {'Content-Type': 'application/json', 'dbName': dbName};
    } else {
      return {
        'Content-Type': 'application/json',
      };
    }
  }

  ///try catch inside get was removed later since 500 is added in status code now it may required! //todo:
  ///for get methode
  ///if final url is null then only other urls applied
  static getData(
      {required String endPoint,
      required Map<String, String> header,
      String? finalUrl}) async {
    if (await AppUtils.isOnline()) {
      final uri = Uri.parse(finalUrl ?? (AppConfig.finalUrl + endPoint));
      AppUtils.logger.i(uri);
      final res = await http.get(uri, headers: header);
      AppUtils().printData('getData res ${utf8.decode(res.bodyBytes)}');
      if (isRequestSucceeded(res.statusCode)) {
        var resBody = json.decode(utf8.decode(res.bodyBytes));
        if (res.statusCode == 200 || res.statusCode == 201) {
          return APIResponse(data: resBody, error: false, errorMessage: '');
        } else {
          return APIResponse(
              data: resBody,
              error: true,
              errorMessage: resBody['message'] ?? 'Something went wrong!');
        }
      } else {
        return APIResponse(
            data: '', error: true, errorMessage: 'Something went wrong!');
      }
    } else {
      Get.offAll(NetworkErrorScreen());
      return APIResponse(
          data: '', error: true, errorMessage: 'No Internet Connection!');
    }
  }

  //for post
  ///endpoint is applied olny if finalUrl is empty
  static Future<APIResponse> postData(
      {required String endPoint,
      required Map<String, String> header,
      required Map<String, dynamic> body,
      String? finalUrl}) async {
    AppUtils().printData('$body');
    AppUtils().printData('postData');
    AppUtils().printData('header $header');
    if (await AppUtils.isOnline()) {
      // try{
      final uri = Uri.parse(finalUrl ?? AppConfig.finalUrl + endPoint);
      AppUtils.logger.i(uri);
      // AppUtils().printData(header);
      final res = await http.post(uri, headers: header, body: jsonEncode(body));
      AppUtils().printData(res.body);
      if (isRequestSucceeded(res.statusCode)) {
        var resBody = json.decode(utf8.decode(res.bodyBytes));
        AppUtils().printData('post resBody');
        AppUtils().printData(resBody);
        if (resBody['_id'] != null) {
          return APIResponse(data: resBody, error: false, errorMessage: '');
        } else {
          AppUtils.oneTimeSnackBar(resBody['message'].toString());
          return APIResponse(
              data: resBody,
              error: true,
              errorMessage:
                  resBody['message'].toString() ?? 'Something went wrong!');
        }
      } else {
        AppUtils.oneTimeSnackBar('Something went wrong!');
        return APIResponse(
            data: res.body, error: true, errorMessage: 'Something went wrong!');
      }
      // }catch(e){
      //   return APIResponse(
      //       data: '', error: true, errorMessage: 'Could\'t reach server');
      // }
    } else {
      Get.offAll(NetworkErrorScreen());

      return APIResponse(
          data: '', error: true, errorMessage: 'No Internet Connection');
    }
  }

  //patch
  static Future<APIResponse> patchData(
      {required String endPoint,
      required Map<String, String> header,
      required Map<String, dynamic> body}) async {
    if (await AppUtils.isOnline()) {
      AppUtils().printData('$body');
      AppUtils().printData('patch body above');
      // try{
      final uri = Uri.parse(AppConfig.finalUrl + endPoint);
      AppUtils.logger.i(uri);
      // AppUtils().printData(header);
      final res =
          await http.patch(uri, headers: header, body: jsonEncode(body));
      AppUtils().printData(res.body);
      if (isRequestSucceeded(res.statusCode)) {
        var resBody = json.decode(utf8.decode(res.bodyBytes));
        AppUtils().printData('post resBody');
        AppUtils().printData(resBody);
        if (resBody['status'] == 'ok') {
          return APIResponse(data: resBody, error: false, errorMessage: '');
        } else {
          AppUtils.oneTimeSnackBar(
              resBody['message'] ?? 'Something went wrong!');
          return APIResponse(
              data: resBody,
              error: true,
              errorMessage:
                  resBody['message'].toString() ?? 'Something went wrong!');
        }
      } else {
        return APIResponse(
            data: res.body, error: true, errorMessage: 'Something went wrong!');
      }
      // }catch(e){
      //   AppUtils().printError('patchData() in api helper $e');
      //   AppUtils.throwError(e);
      //   return APIResponse(
      //       data: '', error: true, errorMessage: 'Could\'t reach server');
      // }
    } else {
      return APIResponse(
          data: '', error: true, errorMessage: 'No internet connection!');
    }
  }

  //for put

  static Future<APIResponse> putData(
      {required String endPoint,
      required Map<String, String> header,
      required Map<String, dynamic> body}) async {
    AppUtils().printData('$body');
    AppUtils().printData('putData');
    AppUtils().printData('header $header');
    if (await AppUtils.isOnline()) {
      // try{
      final uri = Uri.parse(AppConfig.finalUrl + endPoint);
      AppUtils.logger.i(uri);
      // AppUtils().printData(header);
      final res = await http.put(uri, headers: header, body: jsonEncode(body));
      AppUtils().printData(res.body);
      if (isRequestSucceeded(res.statusCode)) {
        var resBody = json.decode(utf8.decode(res.bodyBytes));
        AppUtils().printData('post resBody');
        AppUtils().printData(resBody);
        print('Status code ${res.statusCode}');
        if (resBody == 'password updated') {
          print('resbody $resBody');
          return APIResponse(data: resBody, error: false, errorMessage: '');
        } else {
          AppUtils.oneTimeSnackBar(
              resBody['message'] ?? 'Something went wrong!');
          return APIResponse(
              data: resBody,
              error: true,
              errorMessage:
                  resBody['message'].toString() ?? 'Something went wrong!');
        }
      } else {
        AppUtils.oneTimeSnackBar('Something went wrong!');
        return APIResponse(
            data: res.body, error: true, errorMessage: 'Something went wrong!');
      }
      // }catch(e){
      //   return APIResponse(
      //       data: '', error: true, errorMessage: 'Could\'t reach server');
      // }
    } else {
      Get.offAll(NetworkErrorScreen());
      return APIResponse(
          data: '', error: true, errorMessage: 'Something went wrong!');
    }
  }

  static Future<APIResponse> customPut(
      {required String endPoint,
      required Map<String, String> header,
      required Map<String, dynamic> body}) async {
    AppUtils().printData('$body');
    AppUtils().printData('deleteData');
    AppUtils().printData('header $header');
    if (await AppUtils.isOnline()) {
      // try{
      final uri = Uri.parse(AppConfig.finalUrl + endPoint);
      AppUtils.logger.i(uri);
      // AppUtils().printData(header);
      final res = await http.put(uri, headers: header, body: jsonEncode(body));
      AppUtils().printData(res.body,
          info:
              'delete res body${res.statusCode}${isRequestSucceeded(res.statusCode)}');
      if (isRequestSucceeded(res.statusCode)) {
        // var resBody = json.decode(utf8.decode(res.bodyBytes));
        ///since the delete function doesn't return any data
        if (res.statusCode == 200) {
          return APIResponse(data: 'no body', error: false, errorMessage: '');
        } else {
          var resBody = json.decode(utf8.decode(res.bodyBytes));

          AppUtils.oneTimeSnackBar(
              resBody['message'] ?? 'Something went wrong!');
          return APIResponse(
              data: 'no body',
              error: true,
              errorMessage: resBody['message'].toString());
        }
        // AppUtils().printData('post resBody');
        // AppUtils().printData(resBody);
        // if (resBody['status'] == 'ok') {
        //   return APIResponse(
        //       data: resBody, error: false, errorMessage: '');
        // }else{
        //   AppUtils.oneTimeSnackBar(resBody['message']??'Something went wrong!');
        //   return APIResponse(
        //       data: resBody, error: true, errorMessage: resBody['message']??'Something went wrong!');
        // }
      } else {
        AppUtils.oneTimeSnackBar('Something went wrong!');
        return APIResponse(
            data: res.body, error: true, errorMessage: 'Something went wrong!');
      }
      // }catch(e){
      //   return APIResponse(
      //       data: '', error: true, errorMessage: 'Could\'t reach server');
      // }
    } else {
      Get.offAll(NetworkErrorScreen());

      return APIResponse(
          data: '', error: true, errorMessage: 'No Internet Connection');
    }
  }

  ///check toekn validity
  ///if valid  ie. no admin not approved, so go to pending for aproval screen
  ///if invalid token expired, so go to login screen
  static checkTokenValidity() async {
    AppUtils().printData('object accesss');
    AppUtils().printData(getApiHeader(access: await AppUtils.getAccessToken()));
    if (await AppUtils.isOnline()) {
      final uri = Uri.parse(AppConfig.finalUrl + '/auth/token/verify/');
      final res = await http
          .post(uri, body: {"token": await AppUtils.getAccessToken()});
      AppUtils().printData('res.statusCode');
      AppUtils().printData(res.statusCode);
      if (res.statusCode == 200) {
        // var resBody = json.decode(utf8.decode(res.bodyBytes));
        // if (resBody['status'] == 'ok') {
        //   return true;
        // }else{
        //   return false;
        // }
        //todo :
        // Get.offAllNamed("/PendingApprovalScreen");
      } else {
        // navigate to signinscreen

        // Get.offAllNamed("/SignInScreen");
        AppUtils.oneTimeSnackBar(
            "Login session Expired! , Login again to continue.",
            bgColor: Colors.red,
            time: 3);
      }
    } else {
      Get.offAll(NetworkErrorScreen());
    }
  }

  /*static Future<APIResponse> postData({required String endPoint,required Map<String,String> header,required Map<String,String> body})async{

    try{
      final uri=Uri.parse(AppConfig.finalUrl+endPoint);
      AppUtils.logger.i(uri);
      AppUtils().printData(header);
      final res=await http.post(uri,headers:header,body:jsonEncode(body) );
      if(isRequestSucceeded(res.statusCode)){
        var resBody = json.decode(utf8.decode(res.bodyBytes));
        if (resBody['status'] == 'ok') {
          return APIResponse(
              data: res.body, error: false, errorMessage: '');
        }else{
          return APIResponse(
              data: res.body, error: true, errorMessage: resBody['message']??'Something went wrong!');
        }
      }else{
        return APIResponse(
            data: '', error: true, errorMessage: 'Something went wrong!');
      }
    }catch(e){
      return APIResponse(
          data: '', error: true, errorMessage: 'Something went wrong!');
    }

  }*/

//       ///data stores to temp start
//       file.writeAsStringSync(utf8.decode(res.bodyBytes), flush: true, mode: FileMode.write);
//       ///data stores to temp end
//
//       return APIResponse(
//           data: res.body, error: false, errorMessage: '');
//     } else {
//       return APIResponse(data:"", error: true, errorMessage: 'error');
//     }
  static locationGet(String searchText, String apiKey) async {
    if (await AppUtils.isOnline()) {
      Uri uri =
          Uri.https("maps.googleapis.com", 'maps/api/place/autocomplete/json', {
        "input": searchText,
        "key": apiKey,
      });
      // AppUtils.logger.i(uri);
      final res = await http.get(
        uri,
      );
      AppUtils().printData('getData res ${utf8.decode(res.bodyBytes)}');
      if (isRequestSucceeded(res.statusCode)) {
        var resBody = json.decode(utf8.decode(res.bodyBytes));
        if (res.statusCode == 200) {
          return APIResponse(data: resBody, error: false, errorMessage: '');
        } else {
          return APIResponse(
              data: resBody,
              error: true,
              errorMessage: resBody['message'] ?? 'Something went wrong!');
        }
      } else {
        return APIResponse(
            data: '', error: true, errorMessage: 'Something went wrong!');
      }
    } else {
      Get.offAll(NetworkErrorScreen());
      return APIResponse(
          data: '', error: true, errorMessage: 'No Internet Connection!');
    }
  }

  //for post
  ///endpoint is applied olny if finalUrl is empty
  static Future<APIResponse> postDataNoSnackBar(
      {required String endPoint,
      required Map<String, String> header,
      required Map<String, dynamic> body,
      String? finalUrl}) async {
    AppUtils().printData('$body');
    AppUtils().printData('postData');
    AppUtils().printData('header $header');
    if (await AppUtils.isOnline()) {
      // try{
      final uri = Uri.parse(finalUrl ?? AppConfig.finalUrl + endPoint);
      AppUtils.logger.i(uri);
      // AppUtils().printData(header);
      final res = await http.post(uri, headers: header, body: jsonEncode(body));
      AppUtils().printData(res.body);
      if (isRequestSucceeded(res.statusCode)) {
        var resBody = json.decode(utf8.decode(res.bodyBytes));
        AppUtils().printData('post resBody');
        AppUtils().printData(resBody);
        if (resBody['status'] == 'ok') {
          return APIResponse(data: resBody, error: false, errorMessage: '');
        } else {
          // AppUtils.oneTimeSnackBar(resBody['message'].toString());
          return APIResponse(
              data: resBody,
              error: true,
              errorMessage:
                  resBody['message'].toString() ?? 'Something went wrong!');
        }
      } else {
        // AppUtils.oneTimeSnackBar('Something went wrong!');
        return APIResponse(
            data: res.body, error: true, errorMessage: 'Something went wrong!');
      }
      // }catch(e){
      //   return APIResponse(
      //       data: '', error: true, errorMessage: 'Could\'t reach server');
      // }
    } else {
      Get.offAll(NetworkErrorScreen());

      return APIResponse(
          data: '', error: true, errorMessage: 'No Internet Connection');
    }
  }

  ///Custom put data
  static Future<APIResponse> customPutData(
      {required String endPoint,
      required Map<String, String> header,
      required Map<String, dynamic> body}) async {
    AppUtils().printData('$body');
    AppUtils().printData('putdata');
    AppUtils().printData('header $header');
    if (await AppUtils.isOnline()) {
      // try{
      final uri = Uri.parse(AppConfig.finalUrl + endPoint);
      AppUtils.logger.i(uri);
      // AppUtils().printData(header);
      final res = await http.put(uri, headers: header, body: jsonEncode(body));
      AppUtils().printData(res.body,
          info:
              'put res body${res.statusCode}${isRequestSucceeded(res.statusCode)}');
      if (isRequestSucceeded(res.statusCode)) {
        // var resBody = json.decode(utf8.decode(res.bodyBytes));
        ///since the delete function doesn't return any data
        if (res.statusCode == 200 ||
            res.statusCode == 201 ||
            res.statusCode == 204) {
          return APIResponse(data: 'no body', error: false, errorMessage: '');
        } else {
          var resBody = json.decode(utf8.decode(res.bodyBytes));

          AppUtils.oneTimeSnackBar(
              resBody['message'] ?? 'Something went wrong!');
          return APIResponse(
              data: 'no body',
              error: true,
              errorMessage: resBody['message'].toString());
        }
      } else {
        AppUtils.oneTimeSnackBar('Something went wrong!');
        return APIResponse(
            data: res.body, error: true, errorMessage: 'Something went wrong!');
      }
    } else {
      Get.offAll(NetworkErrorScreen());

      return APIResponse(
          data: '', error: true, errorMessage: 'No Internet Connection');
    }
  }

  ///Custom logout

  static Future<APIResponse> customLogout(
      {required String endPoint,
      required Map<String, String> header,
      String? finalUrl}) async {
    AppUtils().printData('postData');
    AppUtils().printData('header $header');
    if (await AppUtils.isOnline()) {
      // try{
      final uri = Uri.parse(finalUrl ?? AppConfig.finalUrl + endPoint);
      AppUtils.logger.i(uri);
      // AppUtils().printData(header);
      final res = await http.post(
        uri,
        headers: header,
      );
      AppUtils().printData(res.body);
      if (isRequestSucceeded(res.statusCode)) {
        var resBody = json.decode(utf8.decode(res.bodyBytes));
        AppUtils().printData('post resBody');
        AppUtils().printData(resBody);
        if (resBody['status'] == 'ok') {
          return APIResponse(data: resBody, error: false, errorMessage: '');
        } else {
          AppUtils.oneTimeSnackBar(resBody['message'].toString());
          return APIResponse(
              data: resBody,
              error: true,
              errorMessage:
                  resBody['message'].toString() ?? 'Something went wrong!');
        }
      } else {
        AppUtils.oneTimeSnackBar('Something went wrong!');
        return APIResponse(
            data: res.body, error: true, errorMessage: 'Something went wrong!');
      }
      // }catch(e){
      //   return APIResponse(
      //       data: '', error: true, errorMessage: 'Could\'t reach server');
      // }
    } else {
      Get.offAll(NetworkErrorScreen());

      return APIResponse(
          data: '', error: true, errorMessage: 'No Internet Connection');
    }
  }
}
