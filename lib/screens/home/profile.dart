import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/adModel.dart';
import 'package:senam/models/userModel.dart';
import 'package:senam/screens/addAds.dart';
import 'package:senam/screens/home/EditProfile.dart';
import 'package:senam/screens/home/profilePicture.dart';
import 'package:senam/screens/login&signUp/signUp.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    getMyAds();
    super.initState();
  }
getMyAds()async{
  List<Widget> ads=await getUserAds(bloc.currentUser());
  setState(() {
    adCards=ads;
  });
}
List<Widget>adCards=[LoadingFullScreen()];

  final Completer<WebViewController> _completer =
      Completer<WebViewController>();
  _onWebViewCreated(WebViewController controller) {
    _completer.complete(controller);
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double safe = MediaQuery.of(context).padding.top;
    bloc.setDeviceSize(Size(size.width, size.height - safe));
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: backGround,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(icon: Icon(Icons.add,color: primary,),padding: EdgeInsets.all(0), onPressed:(){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddAds()));
                }),
                Spacer(),
                Text(
                  "الملف الشخصي",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      color: primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SmallIconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icons.arrow_forward_ios,
                  color: primary,
                ),
              ],
            ),
          ),
          body: Container(
            width: bloc.size().width,
            height: bloc.size().height,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  ProfilePicture(
                    icon: Icons.settings,
                    onIconPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditProfile()));
                    },
                    imageURL: bloc.currentUser().image,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 5,),
                      Text(bloc.currentUser().username,textDirection: TextDirection.rtl,style: TextStyle(
                        color: primary,fontSize: 20,fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: 5,),
                      Text(bloc.currentUser().mobile,textDirection: TextDirection.ltr,style: TextStyle(
                        color: hint,fontSize: 16,fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: 12,),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                                      "إعلاناتي",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          color: hint,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                      ),
                      
                      Column(children:adCards,),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
