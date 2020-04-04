import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:senam/blocs/widgets.dart';
import 'dart:convert';
import 'dart:async';

import 'package:senam/models/adModel.dart';
const String apiUrl="https://snam.sa/api/v1";

class City {
  int id;
  String name;
  City({this.id, this.name});
  factory City.fromJson(Map city) {
    return City(id: city['id'], name: city['name']);
  }
}

class UserService {
  String msg;
  var activation_code;
  String apiToken;
  int id;

  String username;
  String status;
  String approved;
  int response_status;
  City city;
  String online;
  var total_rating;

  String mobile;
  String image;
//// construct
  UserService({
    this.status,
    this.total_rating,
    this.username,
    this.online,
    this.response_status,
    this.approved,
    this.city,
    this.msg,
    this.id,
    this.mobile,
    this.image,
    this.activation_code,
    this.apiToken,
  });

  factory UserService.fromJson(Map<String, dynamic> user) {
    try {
      if (user['status'] == 200) {
        Map<String, dynamic> userData = user['data'];
        return UserService(
            status:userData['status']==null?null: userData['status'],
            response_status:user['status']==null?null: user['status'],
            activation_code:userData['activation_code']==null?"null": userData['activation_code'],
           city:userData['city']==null||userData['city']==""?null: City.fromJson(userData['city']),
            apiToken:userData['apiToken']==null?null: userData['apiToken'],
           online: userData['online']==null?null:userData['online'],
            id:userData['id']==null?null: userData["id"],
           username:userData['username']==null?null: userData['username'],
            approved:userData['approved']==null?null: userData['approved'],
           msg:user['msg']==null?null: user['msg'],
           mobile:userData['mobile']==null?null: userData['mobile'],
           image:userData['image']==null?null: userData['image'],
           total_rating:userData['total_rating']==null?null: userData['total_rating'],);
      } else
        return UserService(response_status: user['status'], msg: user['msg']);
    } catch (e) {
      print(e.toString());
      return UserService(msg: e.toString());
    }
  }
  factory UserService.fromAdJson(Map<String, dynamic> userData) {
    try {
      
        return UserService(
            status:userData['status']==null?null: userData['status'],
            activation_code:userData['activation_code']==null?"null": userData['activation_code'],
           city:userData['city']==null||userData['city']==""?null: City.fromJson(userData['city']),
            apiToken:userData['apiToken']==null?null: userData['apiToken'],
           online: userData['online']==null?null:userData['online'],
            id:userData['id']==null?null: userData["id"],
           username:userData['username']==null?null: userData['username'],
            approved:userData['approved']==null?null: userData['approved'],
           mobile:userData['mobile']==null?null: userData['mobile'],
           image:userData['image']==null?null: userData['image'],
           total_rating:userData['total_rating']==null?null: userData['total_rating'],);
    } catch (e) {
      print(e.toString());
      return UserService(msg: e.toString());
    }
  }
  List<String> toListData() {
    return [
     status!=null? status: "null",
     activation_code!=null?activation_code : "null",
     city!=null? city.id.toString(): "null",
     city!=null? city.name: "null",
     apiToken!=null? apiToken: "null",
      online!=null?online: "null",
     id!=null? id.toString(): "null",
      username!=null?username: "null",
      approved!=null?approved: "null",
      mobile!=null?mobile: "null",
      image!=null?image: "null",
      total_rating!=null?total_rating.toString(): "null",
    ];
  }

  factory UserService.fromList(List<String> userData) {
    try {
     
        return UserService(
          status: userData[0]=="null"?null:userData[0],
          activation_code: userData[1]=="null"?null:userData[1],
          city:userData[2]!="null"&&userData[3]!="null"?City(id:int.parse(userData[2]),name:userData[3] ):null,
          apiToken:userData[4]=="null"?null:userData[4],
          online: userData[5]=="null"?null:userData[5],
          id: int.parse(userData[6]),
          username:userData[7]=="null"?null:userData[7],
          approved: userData[8]=="null"?null:userData[8],
          mobile: userData[9]=="null"?null:userData[9],
          image: userData[10]=="null"?null:userData[10],
          total_rating:userData[11]!="null"? int.parse(userData[11]):null
        );
    
    } catch (e) {

      print(e);
      return UserService(msg: e.toString());
    }
  }
}

Future loginPost() async {
  http.Response response =
      await http.post("$apiUrl/user/login", body: {
    "mobile": bloc.mobile(),
    "password": bloc.password(),
    "device_token": bloc.deviceToken(),
    "device_type": bloc.deviceType(),
  });
  final loginJson = json.decode(response.body);
  if (loginJson['status'] == 200) {
    UserService newUser = UserService.fromJson(loginJson);
    bloc.sendNewUser(newUser);
    bloc.sendErrorUser(UserService(response_status: null,msg: null));
    await updateLocalUser(newUser);
  } else {
    UserService newUser = UserService.fromJson(loginJson);
    bloc.sendErrorUser(newUser);
  }
}

Future signUpUser() async {
  http.Response response =
      await http.post("$apiUrl/user", body: {
    "username": bloc.name(),
    "password": bloc.password(),
    "mobile": bloc.mobile(),
    "device_token": bloc.deviceToken(),
    "device_type": bloc.deviceType(),
    "city_id": bloc.cityId().toString() ////////////////////////////
  });
  final signUpJson = json.decode(response.body);
  UserService newUser = UserService.fromJson(signUpJson);
  if (signUpJson['status'] == 200) {
    bloc.sendNewUser(newUser);
    bloc.sendErrorUser(UserService(response_status: null,msg: null));
    await updateLocalUser(newUser);
  } else
    bloc.sendErrorUser(newUser);
}


Future resendCode() async {
  http.Response response = await http
      .post("$apiUrl/user/resend_code", body: {
    "mobile": bloc.mobile(),
  });
  final resendJson = json.decode(response.body);
  UserService newUser = UserService.fromJson(resendJson);
  if (resendJson['status'] == 200) {
    bloc.sendNewUser(newUser);
    bloc.sendErrorUser(UserService(response_status: null,msg: null));
    await updateLocalUser(newUser);
  } else
    bloc.sendErrorUser(newUser);
}
Future logOutService() async {
  http.Response response = await http
      .post("$apiUrl/user/logout", body: {
    "device_token": bloc.deviceToken(),
  }
  ,headers: {
    "apiToken":"sa3d01${bloc.currentUser().apiToken}"
  }
  );
  return response;
}


Future updatePassword() async {
  http.Response response = await http
      .post("$apiUrl/user/update_password", body: {
    "old_pass": bloc.oldPassword(),
    "new_pass": bloc.password()
  }, headers: {
    "apiToken": "sa3d01${bloc.currentUser().apiToken}",
  });
  final resendJson = json.decode(response.body);
  UserService newUser = UserService.fromJson(resendJson);
  if (resendJson['status']  == 200) {
    bloc.sendNewUser(newUser);
    bloc.sendErrorUser(UserService(response_status: null,msg: null));
    await updateLocalUser(newUser);
  } else
    bloc.sendErrorUser(newUser);
}

Future resetPassword() async {
  http.Response response = await http
      .post("$apiUrl/user/resetPassword", body: {
        "mobile":bloc.mobile(),
    "password": bloc.password(),
  });
  final resendJson = json.decode(response.body);
  UserService newUser = UserService.fromJson(resendJson);
  if (resendJson['status']  == 200) {
    bloc.sendNewUser(newUser);

    bloc.sendErrorUser(UserService(response_status: null,msg: null));
    await updateLocalUser(newUser);
  } else
    bloc.sendErrorUser(newUser);
}

Future activate() async {
  http.Response response =
      await http.post("$apiUrl/user/active", body: {
    "activation_code": bloc.code(),
  }, headers: {
    "apiToken": "sa3d01${bloc.currentUser().apiToken}",
  });
  final resendJson = json.decode(response.body);
  UserService newUser = UserService.fromJson(resendJson);
  if (resendJson['status'] == 200) {
    await updateLocalUser(newUser);
    bloc.sendNewUser(newUser);
    bloc.sendErrorUser(UserService(response_status: null,msg: null));
  } else
    bloc.sendErrorUser(newUser);
}

Future getProfile(int id) async {
  http.Response response = await http
      .get("$apiUrl/user/$id",);
  final profileJson = json.decode(response.body);
  UserService newUser = UserService.fromJson(profileJson);
  if (profileJson['status'] == 200) {
return newUser;
  } else
    return null;
}

Future getCities() async {
  http.Response response = await http
      .get("$apiUrl/city",);
  final cityJson = json.decode(response.body);
  if (cityJson['status'] == 200) {
    List cities=cityJson['data'];
    List<City> citiesData=[];
    for(int i=0;i<cities.length;i++)
    {
      citiesData.add(City.fromJson(cities[i]));
    }
  bloc.sendCities(citiesData);   
}
}

Future getUserAds(UserService user) async {
  http.Response response = await http
      .get("$apiUrl/user/${user.id}/ad",);
  final userAds = json.decode(response.body);
      List<Widget> adCards=[];
  if (userAds['status'] == 200) {
    List ads=userAds['data'];
    for(int i=0;i<ads.length;i++)
    {if(bloc.currentUser()!=null)
      adCards.add(AdCard(adModel: AdModel.fromJson(ads[i]),user:user,mine: user.id==bloc.currentUser().id?true:null,));
  else
        adCards.add(AdCard(adModel: AdModel.fromJson(ads[i]),user:user));

    }
}
return adCards;
}


Future updateUserProfile({File image}) async {
  if (image != null) {
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])
            .split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST', Uri.parse("$apiUrl/user/1"))
      ..fields.addAll({
        "username": bloc.name(),
        "city_id":bloc.cityId().toString(),
        "mobile": bloc.mobile(),
      })
      ..headers['apiToken'] = "sa3d01${bloc.currentUser().apiToken}";
    final file = await http.MultipartFile.fromPath(
        'image', image.path,
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
  } else {
    http.Response response =
        await http.post("$apiUrl/user/1", body: {
        "username": bloc.name(),
        "city_id":bloc.cityId().toString(),
        "mobile": bloc.mobile(),
    }, headers: {
      "apiToken": "sa3d01${bloc.currentUser().apiToken}",
    });
    final providerJson = json.decode(response.body);
    UserService newUser = UserService.fromJson(providerJson);
    if (newUser.response_status == 200) {
      bloc.sendNewUser(newUser);
      bloc.sendErrorUser(UserService(status: null, msg: null));
      await updateLocalUser(newUser);
    } else
      bloc.sendErrorUser(newUser);
  }
}
