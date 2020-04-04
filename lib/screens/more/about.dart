import 'package:flutter/material.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/widgets.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  void initState() {
    super.initState();
  }

  void whatsAppOpen(String mobile) async {
    var whatsappUrl ="whatsapp://send?phone=$mobile";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      await launch("tel:$mobile");
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // String code =Localizations.localeOf(context).languageCode;
    return  WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop();
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
            body: Container(
              width: bloc.size().width,
              height:bloc.size().height,
              child: Stack(
                alignment:Alignment.topRight,
                children: <Widget>[
                    
                     SingleChildScrollView(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.end,
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: <Widget>[
                           Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                             Text(

                             "عن التطبيق",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                          Padding(
                        padding:
                            const EdgeInsets.only(right: 20, top: 10, left: 20),
                        child: Wrap(
                          children: <Widget>[
                            Text(
                              "ما هو سنام",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Wrap(
                          children: <Widget>[
                            Text("${bloc.staticData().about}",
                            // bloc.staticData().about,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SocialIcon(
                            imageSRC: 'assets/images/i.png',
                            onPressed: () async {
                              await _launchURL(bloc.staticData().instagram);
                            },
                          ),
                          SocialIcon(
                            imageSRC: 'assets/images/t.png',
                            onPressed: () async {
                             await _launchURL(bloc.staticData().twitter);
                            },
                          ),
                          // SocialIcon(
                          //   imageSRC: 'assets/images/s.png',
                          //   onPressed: () async {
                          // //    await _launchURL(bloc.staticData().s);
                          //   },
                          // ),
                          SocialIcon(
                            imageSRC: 'assets/images/w.png',
                            onPressed: ()  {
                               whatsAppOpen(bloc.staticData().whatsapp);
                            },
                          )
                        ],
                      )
                       ],),
                     )
                    ],
                  )
              
            ),
          ),
        ),
     
    );
  }
}

class SocialIcon extends StatelessWidget {
  String imageSRC;
  Function onPressed;
  SocialIcon({this.onPressed, this.imageSRC});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 36,
      width: 36,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.all(0),
        onPressed: onPressed,
        child: Image.asset(imageSRC),
      ),
    );
  }
}
