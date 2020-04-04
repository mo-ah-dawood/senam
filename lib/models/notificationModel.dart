import 'dart:async';
import 'package:senam/blocs/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:senam/models/userModel.dart';
import 'package:senam/screens/home/adPage.dart';
import 'dart:convert';
import 'adModel.dart';
import 'package:senam/screens/notifications.dart';

const String apiUrl = "https://snam.sa/api/v1";

class NotificationModel {
  int id;
  String title;
  AdModel adModel;
  String note;
  NotificationModel({this.id, this.note, this.title, this.adModel});
  factory NotificationModel.fromJson(Map<String, dynamic> notification) {
    try {
      return NotificationModel(
        id: notification['id'],
        title: notification['title'],
        note: notification['note'],
        adModel: AdModel.fromJson(notification['ad']),
      );
    } catch (e) {
      print(e);
      return NotificationModel();
    }
  }
}

Future<Map<String, dynamic>> getAllNotifications() async {
  http.Response response = await http.get("$apiUrl/notification",
      headers: {"apiToken": "sa3d01${bloc.currentUser().apiToken}"});
  final notification = json.decode(response.body);
  return notification;
}

Future<List<Widget>> getNotificationCards(BuildContext context) async {
  List<NotificationCard> notificationCards = [];
  List<NotificationModel> notiModel = [];
  Map<String, dynamic> allNotifications = await getAllNotifications();
  if (allNotifications['status'] == 200) {
    for (int i = 0; i < allNotifications['data'].length; i++) {
      notiModel.add(NotificationModel.fromJson(allNotifications['data'][i]));
    }
    for (int i = 0; i < notiModel.length; i++) {
      notificationCards.add(NotificationCard(
        text: notiModel[i].title,
        event: notiModel[i].note ?? "",
        onPressed: () {
          if (notiModel[i].adModel != null)
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AdPage(
                      adModel: notiModel[i].adModel,
                      user: notiModel[i].adModel.user,
                    )));
          // if (bloc.currentUser().type == "user") {
          //   if (notiModel[i].order.status == "waiting")
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => NewOrderPage(
          //               order: notiModel[i].order,
          //             )));
          //   else if (notiModel[i].order.status == "done")
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => AcceptedOrderPage(
          //               order: notiModel[i].order,
          //             )));
          //   else if (notiModel[i].order.status == "cancelled")
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => RejectedOrderPage(
          //               order: notiModel[i].order,
          //             )));
          // } else if (bloc.currentUser().type == "provider") {

          //    if (notiModel[i].order.status == "waiting")
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => ProviderNewOrderPage(
          //               order: notiModel[i].order,
          //             )));
          //   else if (notiModel[i].order.status == "done")
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => ProviderAcceptedOrderPage(
          //               order: notiModel[i].order,
          //             )));
          //   else if (notiModel[i].order.status == "cancelled")
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => ProviderRejectedOrderPage(
          //               order: notiModel[i].order,
          //             )));
          // }
        },
      ));
    }
    return notificationCards;
  } else
    return notificationCards;
}
