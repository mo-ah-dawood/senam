import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/adModel.dart';
import 'package:senam/screens/home/rate.dart';
import 'package:senam/models/userModel.dart';
import 'package:senam/screens/login&signUp/signUp.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProviderPage extends StatefulWidget {
  UserService user;
  ProviderPage({this.user});
  @override
  _ProviderPageState createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  @override
  void initState() {
    _getMyAds();
    super.initState();
  }
_getMyAds()async{
  List<Widget> ads=await getUserAds(widget.user);
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
                Text(
                  "صاحب الإعلان",
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
            child: Stack(
              children: <Widget>[
                Container(
                  width: bloc.size().width,
                  height: bloc.size().height,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Colors.white),
                          child: AdOwner(
                            here: true,
                            user: widget.user,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Wrap(
                            children: <Widget>[
                              Text(
                                "الإعلانات",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: hint,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: adCards,
                        ),
                        SizedBox(
                          height: 60,
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 20,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 40,
                        width: bloc.size().width,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: BumbiButton(
                              text: "تقييم",
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => RateProvider(id: widget.user.id,));
                              },
                              colored: true,
                            ))
                          ],
                        )))
              ],
            ),
          )),
    );
  }
}
