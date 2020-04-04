import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/screens/login&signUp/signUp.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Article extends StatefulWidget {
  String title;
  String articleURL;
  Article({ this.title, this.articleURL, });
  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  @override
  void initState() {
    super.initState();
  }

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
          automaticallyImplyLeading: false,
          backgroundColor: backGround,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                widget.title,
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
        body: WebView(
          gestureRecognizers: Set()
            ..add(Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer())),
          debuggingEnabled: true,
          onWebViewCreated: _onWebViewCreated,
          initialUrl: widget.articleURL,
          javascriptMode: JavascriptMode.unrestricted,
        ),
       
      ),
    );
  }
}
