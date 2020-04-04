import 'package:flutter/material.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/models/notificationModel.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';

class Notifications extends StatefulWidget {
  String from;
  Notifications({this.from});
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: backGround,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "الإشعارات",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      color: blackAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SmallIconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icons.arrow_forward_ios,
                ),
              ],
            ),
          ),
          body: Container(
            width: bloc.size().width,
            height: bloc.size().height,
            child: SingleChildScrollView(
              child: FutureBuilder(
                  future: getNotificationCards(context),
                  initialData: <Widget>[LoadingFullScreen()],
                  builder: (context, s) {
                    return Column(
                      children: [
                       
                        Column(
                          children:s.data
                          //  <Widget>[
                          //   NotificationCard(
                          //     text: "مبروووك جالك ولد",
                          //     event: "هتسميه إيه ؟",
                          //     onPressed: () {},
                          //   ),
                          //   NotificationCard(
                          //     text: "مبروووك جالك ولد",
                          //     event: "هتسميه إيه ؟",
                          //     onPressed: () {},
                          //   )
                          // ],
                        )
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatefulWidget {
  String text;
  String event;
  Function onPressed;
  NotificationCard({this.event, this.text, this.onPressed});
  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool notifi = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: blackAccent,
                offset: Offset(-2, 2),
                spreadRadius: -2,
                blurRadius: 2),
            BoxShadow(color: Colors.white, blurRadius: 2)
          ],
          borderRadius: BorderRadius.all(Radius.circular(15))),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: MaterialButton(
        padding: EdgeInsets.all(0),
        splashColor: primaryAccent.withOpacity(0.2),
        onPressed: () async {
          // await getAllNotifications();
          setState(() {
            notifi = false;
          });
          widget.onPressed();
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text(widget.event,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w900)),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.text,
                      textDirection: TextDirection.rtl,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 50,
                height: 50,
                child: Image.asset('assets/images/notifi.png'),
              )
             
            ],
          ),
        ),
      ),
    );
  }
}
