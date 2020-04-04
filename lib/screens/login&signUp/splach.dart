import 'package:flutter/material.dart';
import 'dart:async';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/screens/home/home.dart';
import 'package:senam/screens/login&signUp/login.dart';
import 'package:senam/screens/login&signUp/signUp.dart';

class Splach extends StatefulWidget {
  @override
  _SplachState createState() => _SplachState();
}

class _SplachState extends State<Splach> {
  bool up = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 10), () {
      setState(() {
        up = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return bloc.onClose(context);
      },
      child: Scaffold(
          body: Container(
        width: bloc.size().width,
        height: bloc.size().height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
                height: bloc.size().height,
                width: bloc.size().width,
                child: Image.asset(
                  'assets/images/background.png',
                  fit: BoxFit.fill,
                )),
            splachButtons(context, up),
          ],
        ),
      )),
    );
  }
}

splachButtons(BuildContext context, bool up) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        // color: backGround,
        width: 130,
        height: 53,
        child: Image.asset('assets/images/logo.png'),
      ),
      AnimatedContainer(
        duration: mill0Second,
        height: up ? 120 : 0,
      ),
      Container(
        margin: EdgeInsets.only(bottom: 20),
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: BumbiButton(
          colored: true,
          text: "تسجيل دخول",
          onPressed: () {
            bloc.onMobileChange(null);
            bloc.onPasswordChange(null);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Login()));
          },
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 20),
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: BumbiButton(
          colored: true,
          text: "اشترك الآن",
          onPressed: () {
            bloc.onMobileChange(null);
            bloc.onPasswordChange(null);
            bloc.oncityIdChange(null);
            bloc.onNameChange(null);

            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SignUp()));
          },
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 20),
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: BumbiButton(
          colored: false,
          text: "تخطي",
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Home()));
          },
        ),
      ),
    ],
  );
}
