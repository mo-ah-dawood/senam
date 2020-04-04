import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/adModel.dart';
import 'package:senam/screens/login&signUp/signUp.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  void initState() {
    getAds();
    super.initState();
  }
getAds()async{
  List<Widget>ad=await getFavouriteAds();
  bloc.onChangefavouriteCards(ad);
}
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();
  _onWebViewCreated(WebViewController controller) {
    _completer.complete(controller);
  }
List<Widget>ads=[LoadingFullScreen()];
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
                Text(
                  "المفضلة",
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child:  StreamBuilder(
                stream: bloc.favouriteCardsStream,
initialData: <Widget>[LoadingFullScreen()],
                builder:(context,s)=> Column(
                    children: s.data
                  ),
              ),
              
            ),
          )),
    );
  }
}
