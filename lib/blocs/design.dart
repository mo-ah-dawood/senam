import 'package:flutter/material.dart';
Color primary=Color(0xff000547);
Color hint=Color(0xffA2A5A9);
Color blackAccent=Color(0xff101010);
Color backGround =Color(0xffF9F9F9);
Color whiteGrey=Color(0xff0000001A);
Color hintAccent=Color(0xffF9F9F9);
Color primaryAccent=Color(0xff0926B8);
Color accentPrimaryAccent=Color(0xffCDD2ED);
Duration mill2Second=Duration(milliseconds: 2000);
Duration mill1Second=Duration(milliseconds: 1000);
Duration mill0Second=Duration(milliseconds: 500);
Duration mill000Second=Duration(milliseconds:5);

getBoxDecoration() {
  return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      boxShadow: [
        new BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 1.0,
            spreadRadius: 1.0)
      ]);
}