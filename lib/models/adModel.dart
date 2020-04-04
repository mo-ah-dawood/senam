import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:mime/mime.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/categories.dart';
import 'package:senam/models/userModel.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:async';

import 'package:senam/screens/home/home.dart';
import 'package:senam/screens/login&signUp/splach.dart';

const String apiUrl = "https://snam.sa/api/v1";

class Ad {
  String title;
  String image;
  String city;
  String time;
  Ad({this.city, this.time, this.title, this.image});
}

class AdModel {
  int id;
  String title;
  String note;
  List images;
  List videos;
  bool is_favourite;
  var lat;
  var lng;
  String status;
  UserService user;
  City city;
  Category category;
  List<AdModel> similar_ads;
  String url;
  String published;
  List comments;
  Category parent_category;
  AdModel(
      {this.id,
      this.similar_ads,
      this.title,
      this.note,
      this.is_favourite,
      this.images,
      this.videos,
      this.lat,
      this.lng,
      this.status,
      this.user,
      this.city,
      this.category,
      this.url,
      this.published,
      this.comments,
      this.parent_category});
  factory AdModel.fromJson(Map<String, dynamic> ad) {
    List<AdModel> similar = [];
    if (ad['similar_ads'] != null) {
      for (int i = 0; i < ad['similar_ads'].length; i++) {
        similar.add(AdModel.fromJson(ad['similar_ads'][i]));
      }
    }
    return AdModel(
        id: ad['id'],
        title: ad['title'],
        note: ad['note'],
        similar_ads: similar,
        images: ad['images'],
        videos: ad['videos'],
        is_favourite: ad['is_favourite'],
        lat: ad['lat'].toString(),
        lng: ad['lng'].toString(),
        status: ad['status'],
        user: UserService.fromAdJson(ad['user']),
        city: ad['city'] != null ? City.fromJson(ad['city']) : null,
        category: Category.fromJsonSub(ad['category']),
        url: ad['url'],
        published: ad['published'],
        comments: ad['comments'],
        parent_category: Category.fromJsonSub(ad['parent_category']));
  }
}

class HomeData {
  List<Category> categories = [];
  Map<int, List<Category>> subCategory = {};
  List<AdModel> randomAds = [];
  HomeData({this.categories, this.subCategory, this.randomAds});
  factory HomeData.fromJson(Map<String, dynamic> homeJson) {
    Map<int, List<Category>> subCategories = {};
    List<Category> mainCategories = [];
    List<AdModel> ads = [];
    for (int i = 0; i < homeJson['data'].length; i++) {
      Category c = Category.fromJsonMain(homeJson['data'][i]);
      mainCategories.add(c);
      subCategories[c.id] = c.sub_categories;
    }
    for (int i = 0; i < homeJson['ads'].length; i++) {
      AdModel ad = AdModel.fromJson(homeJson['ads'][i]);
      ads.add(ad);
    }

    return HomeData(
        randomAds: ads, categories: mainCategories, subCategory: subCategories);
  }
}

Future getHomeData() async {
  http.Response response = await http.get("$apiUrl/category", headers: {
    "apiToken": bloc.currentUser() != null
        ? "sa3d01${bloc.currentUser().apiToken}"
        : null
  });
  final homeJson = json.decode(response.body);
  if (homeJson['status'] == 200) {
    HomeData homeData = await HomeData.fromJson(homeJson);
    bloc.addNewhomeDatas(homeData);
    Map<int, String> mainC = {};
    for (int i = 0; i < homeData.categories.length; i++) {
      mainC[homeData.categories[i].id] = homeData.categories[i].name;
    }

    List<Widget> mainCat = [];
    List<Widget> mainAds = [];
    for (int i = 0; i < homeData.categories.length; i++)
      mainCat.add(HorizontalListItem(
        category: homeData.categories[i],
      ));
    bloc.onmainCategoriesChange(mainCat);
    for (int i = 0; i < homeData.randomAds.length; i++)
      mainAds.add(AdCard(
        adModel: homeData.randomAds[i],
      ));
    bloc.onHomeAdCardsChange(mainAds);
    bloc.onsubCChange(homeData.subCategory);
  }
}

Future search({int category_id, String title, int city_id, String sort}) async {
  bloc.onHomeSearchedAdCardsChange([LoadingFullScreen()]);
  http.Response response = await http.get(
      "$apiUrl/ad?category_id=${category_id ?? ""}&title=${title ?? ""}&city_id=${city_id ?? ""}&sort=${sort ?? ""}",
      headers: bloc.currentUser() != null
          ? {"apiToken": "sa3d01${bloc.currentUser().apiToken}"}
          : null);
  final searchJson = json.decode(response.body);
  if (searchJson['status'] == 200) {
    bloc.onDataSearchedCountChange(searchJson['data'].length);
    List<Widget> mainAds = [];
    for (int i = 0; i < searchJson['data'].length; i++)
      mainAds.add(AdCard(
        adModel: AdModel.fromJson(searchJson['data'][i]),
      ));

    bloc.onHomeSearchedAdCardsChange(mainAds);
  }
}

Future addToFavourite(int id) async {
  http.Response response = await http.post("$apiUrl/favourite",
      body: {"ad_id": id.toString()},
      headers: {"apiToken": "sa3d01${bloc.currentUser().apiToken}"});
  final searchJson = json.decode(response.body);
  List<Widget> ads = [];

  if (searchJson['status'] == 200) {
    bool isFav = false;
    for (int i = 0; i < searchJson['data'].length; i++) {
      AdModel ad = AdModel.fromJson(searchJson['data'][i]);
      if (ad.id == id) isFav = true;

      ads.add(AdCard(
        adModel: ad,
        favourite: true,
      ));
    }
    bloc.onChangefavouriteCards(ads);

    return isFav;
  } else if (searchJson['status'] == 401)
    return 401;
  else
    return searchJson['msg'];
}

Future reportAd(int id, String report) async {
  http.Response response = await http.post("$apiUrl/report",
      body: {"ad_id": id.toString(), "report": report},
      headers: {"apiToken": "sa3d01${bloc.currentUser().apiToken}"});
  final searchJson = json.decode(response.body);
  if (searchJson['status'] == 200) {
    return "تم إرسال بلاغك للإدارة";
  } else if (searchJson['status'] == 401)
    return 401;
  else
    return searchJson['msg'];
}

getSingleAd(int id) async {
  http.Response response;
  if (bloc.currentUser() != null)
    response = await http.get("$apiUrl/ad/$id",
        headers: {"apiToken": "sa3d01${bloc.currentUser().apiToken}"});
  else
    response = await http.get("$apiUrl/ad/$id", headers: {});

  final adJson = json.decode(response.body);
  if (adJson['status'] == 200) {
    AdModel ad = AdModel.fromJson(adJson['data']);
    return ad;
  }
}

getFavouriteAds({Function onPop}) async {
  http.Response response = await http.get("$apiUrl/favourite",
      headers: {"apiToken": "sa3d01${bloc.currentUser().apiToken}"});
  final adJson = json.decode(response.body);
  List<Widget> ads = [];
  if (adJson['status'] == 200) {
    for (int i = 0; i < adJson['data'].length; i++) {
      AdModel ad = AdModel.fromJson(adJson['data'][i]);
      ads.add(AdCard(
        adModel: ad,
        favourite: true,
      ));
    }
  }
  return ads;
}

Future sendNewAd({File image}) async {
  final mimeTypeData =
      lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
  final imageUploadRequest =
      http.MultipartRequest('POST', Uri.parse("$apiUrl/user/1"))
        ..fields.addAll({
          "username": bloc.name(),
          "city_id": bloc.cityId().toString(),
          "mobile": bloc.mobile(),
        })
        ..headers['apiToken'] = "sa3d01${bloc.currentUser().apiToken}";
  final file = await http.MultipartFile.fromPath('image', image.path,
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
  imageUploadRequest.files.add(file);
  try {
    final streamedResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamedResponse);
    final signUpJson = json.decode(response.body);
    UserService newUser = UserService.fromJson(signUpJson);
    if (newUser.response_status == 200) {
      bloc.sendNewUser(newUser);

      bloc.sendErrorUser(UserService(status: null, msg: null));
      await updateLocalUser(newUser);
    } else
      bloc.sendErrorUser(newUser);
  } catch (e) {
    print(e);
  }
}

Future<Response> sendFiles(Map<String, File> files) async {
  String url = "$apiUrl/upload_files";
  Map<String, dynamic> data = {};
  Map<String, MultipartFile> fileMap = {};

  for (MapEntry fileEntry in files.entries) {
    File file = fileEntry.value;
    String fileName = basename(file.path);
    fileMap[fileEntry.key] =
        MultipartFile(file.openRead(), await file.length(), filename: fileName);
  }
  data.addAll(fileMap);
  var formData = FormData.fromMap(data);
  Dio dio = new Dio();
  bloc.onChangeuploadingPercentatge("0.0");
  return await dio.post(url,
      data: formData, options: Options(contentType: 'multipart/form-data'),
      onSendProgress: (s, t) {
    bloc.onChangeuploadingPercentatge(((s / t) * 100).toStringAsFixed(0));
  });
}

uploadAdImages() async {
  Map<String, File> files = {};
  if (bloc.adImagesFilesMap() != null && bloc.adImagesFilesMap().length > 0) {
    for (int i = 0; i < bloc.adImagesFilesMap().length; i++) {
      files["file[$i]"] = bloc.adImagesFilesMap().values.toList()[i];
    }
    Response response = await sendFiles(files);
    return response.data['data'];
  }
}

uploadAdVideos() async {
  Map<String, File> files = {};
  if (bloc.adVideosFilesMap() != null && bloc.adVideosFilesMap().length > 0) {
    for (int i = 0; i < bloc.adVideosFilesMap().length; i++) {
      files["file[$i]"] = bloc.adVideosFilesMap().values.toList()[i];
    }
    Response response = await sendFiles(files);
    return response.data['data'];
  }
}

addNewAd(
    {BuildContext context,
    GlobalKey<ScaffoldState> scaffold,
    String title,
    String note,
    int category_id,
    int city_id,
    double lat,
    double lng,
    List images,
    List videos}) async {
  Map body = {};
  body["title"] = title;
  body["note"] = note;
  body["category_id"] = category_id.toString();
  body["city_id"] = city_id.toString();
  if (lat != null) {
    body["lat"] = lat.toString();
    body["lng"] = lng.toString();
  }
  for (int i = 0; i < images.length; i++) body["images[$i]"] = images[i];
  if (videos != null) {
    if (videos.length > 0)
      for (int i = 0; i < videos.length; i++) body["videos[$i]"] = videos[i];
  }
  http.Response response = await http.post("$apiUrl/ad",
      body: body,
      headers: {"apiToken": "sa3d01${bloc.currentUser().apiToken}"});
  final addAd = json.decode(response.body);
  if (addAd['status'] == 200) {
    Navigator.of(context).pop();
  } else if (addAd['status'] == 401) {
    await clearUserData();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Splach()));
  } else
    scaffold.currentState.showSnackBar(SnackBar(content: Text(addAd['msg'])));
}

updateAd(
    {int id,
    BuildContext context,
    GlobalKey<ScaffoldState> scaffold,
    String title,
    String note,
    int category_id,
    int city_id,
    double lat,
    double lng,
    List images,
    List videos}) async {
  Map body = {};
  body["title"] = title;
  body["note"] = note;
  body["category_id"] = category_id.toString();
  body["city_id"] = city_id.toString();
  if (lat != null) {
    body["lat"] = lat.toString();
    body["lng"] = lng.toString();
  }
  for (int i = 0; i < images.length; i++) body["images[$i]"] = images[i];
  if (videos != null) {
    if (videos.length > 0)
      for (int i = 0; i < videos.length; i++) body["videos[$i]"] = videos[i];
  }
  http.Response response = await http.post("$apiUrl/ad/$id",
      body: body,
      headers: {"apiToken": "sa3d01${bloc.currentUser().apiToken}"});
  final addAd = json.decode(response.body);
  if (addAd['status'] == 200) {
    Navigator.of(context).pop(Navigator.of(context).pop());
  } else if (addAd['status'] == 401) {
    await clearUserData();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Splach()));
  } else
    scaffold.currentState.showSnackBar(SnackBar(content: Text(addAd['msg'])));
}

rateUser(int id, String rate) async {
  http.Response response = await http.post("$apiUrl/rate", body: {
    "rated_id": id.toString(),
    "rate": rate
  }, headers: {
    "apiToken": bloc.currentUser() != null
        ? "sa3d01${bloc.currentUser().apiToken}"
        : null
  });
  final adJson = json.decode(response.body);
  if (adJson['status'] == 200) {
    print("done");
  }
}

deletAd(int id) async {
  http.Response response = await http.delete("$apiUrl/ad/$id", headers: {
    "apiToken": bloc.currentUser() != null
        ? "sa3d01${bloc.currentUser().apiToken}"
        : null
  });
  final adJson = json.decode(response.body);
  print(adJson.toString());
  if (adJson['status'] == 200) {
    print("done");
  }
}
