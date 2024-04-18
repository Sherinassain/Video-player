// To parse this JSON data, do
//
//     final videoResData = videoResDataFromJson(jsonString);

import 'dart:convert';

VideoResData videoResDataFromJson(String str) => VideoResData.fromJson(json.decode(str));

String videoResDataToJson(VideoResData data) => json.encode(data.toJson());

class VideoResData {
    List<VideoDatum> videoData;

    VideoResData({
        required this.videoData,
    });

    factory VideoResData.fromJson(Map<String, dynamic> json) => VideoResData(
        videoData: List<VideoDatum>.from(json["videoData"].map((x) => VideoDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "videoData": List<dynamic>.from(videoData.map((x) => x.toJson())),
    };
}

class VideoDatum {
    String id;
    String title;
    String thumbnailUrl;
    String duration;
    String uploadTime;
    String views;
    String author;
    String videoUrl;
    String description;
    String subscriber;
    bool isLive;

    VideoDatum({
        required this.id,
        required this.title,
        required this.thumbnailUrl,
        required this.duration,
        required this.uploadTime,
        required this.views,
        required this.author,
        required this.videoUrl,
        required this.description,
        required this.subscriber,
        required this.isLive,
    });

    factory VideoDatum.fromJson(Map<String, dynamic> json) => VideoDatum(
        id: json["id"],
        title: json["title"],
        thumbnailUrl: json["thumbnailUrl"],
        duration: json["duration"],
        uploadTime: json["uploadTime"],
        views: json["views"],
        author: json["author"],
        videoUrl: json["videoUrl"],
        description: json["description"],
        subscriber: json["subscriber"],
        isLive: json["isLive"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "thumbnailUrl": thumbnailUrl,
        "duration": duration,
        "uploadTime": uploadTime,
        "views": views,
        "author": author,
        "videoUrl": videoUrl,
        "description": description,
        "subscriber": subscriber,
        "isLive": isLive,
    };
}
