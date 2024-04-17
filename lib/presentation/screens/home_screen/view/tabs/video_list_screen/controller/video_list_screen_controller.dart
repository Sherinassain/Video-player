import 'package:get/get.dart';
import 'package:my_app/presentation/screens/online_video_screen/res_model/video_res_data.dart';
import 'package:my_app/presentation/screens/online_video_screen/res_model/video_res_model.dart';

class VideoListScreenController extends GetxController {
    List<VideoDatum> videoDataResList = [];

var isLoading = true.obs;
dataConversion(){
  videoDataResList.clear();
    List<dynamic> videoDataList = jsonResponse['videoData'];

         for (var video in videoDataList) {
    videoDataResList.add(VideoDatum.fromJson(video));
    
  }
  isLoading.value= false;
        }

}
