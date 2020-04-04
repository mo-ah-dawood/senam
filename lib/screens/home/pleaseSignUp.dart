import 'package:flutter/material.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/screens/login&signUp/login.dart';
import 'package:senam/screens/login&signUp/signUp.dart';

class PleaseSignUp extends StatefulWidget {
  bool grey;
  PleaseSignUp({this.grey});
  @override
  _PleaseSignUpState createState() => _PleaseSignUpState();
}

class _PleaseSignUpState extends State<PleaseSignUp> {
  bool delete = false;
  bool empty = false;
  String reason = "";
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          color:widget.grey!=null? Color(0xff353535):Color(0xff737373),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                              width: 60.5,
                              height: 120,
                              child: Image.asset('assets/images/illustration.png')),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "برجاء تسجيل الدخول أولاً"                                ,textDirection: TextDirection.rtl,

                            style: TextStyle(
                                fontSize: 20,
                                color: blackAccent,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                         
                          Container(
                            height: 40,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                              
                                Expanded(
                                  child: BumbiButton(
                                    colored: false,
                                    text: "إشترك الآن",
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignUp()));
                                    },
                                  ),
                                )
                                , SizedBox(
                                  width: 10,
                                ),
                                  Expanded(
                                  child: BumbiButton(
                                    colored: true,
                                    text: "تسجيل دخول",
                                    onPressed: ()  {
                                                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Login()));

                                    },
                                  ),
                                ),
                               
                              ],
                            ),
                          )
                        ],
                      ),
                      delete
                          ? Positioned.fill(
                              child: LoadingFullScreen(),
                            )
                          : SizedBox(),
                    ],
                  ))),
        ),
      ],
    );
  }
}
