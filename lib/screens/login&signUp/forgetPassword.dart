import 'package:flutter/material.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/shared_preferences_helper.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/userModel.dart';
import 'package:senam/screens/login&signUp/confirm.dart';
import 'package:senam/screens/login&signUp/login.dart';
import 'package:senam/screens/login&signUp/splach.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final mobileNode = new FocusNode();
  bool validate = false;
  bool empty = false;
  bool loading = false;
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  @override
  void initState() {
    bloc.sendErrorUser(UserService(status: null, msg: null));
    bloc.onMobileChange(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Login()));
          return Future.value(false);
        },
        child: Scaffold(
          key: scaffold,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
                width: bloc.size().width,
                height: bloc.size().height,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    Container(
                      width: bloc.size().width,
                      height: bloc.size().height,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          padding: EdgeInsets.only(top: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SmallIconButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                },
                                icon: Icons.arrow_forward_ios,
                              ),
                              Container(
                                width: bloc.size().width,
                                margin: EdgeInsets.only(
                                    top: bloc.size().height / 6),
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "ادخل رقم الجوال",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "برجاء إدخال رقم الجوال الخاص بك\nلنتمكن من إرسال كود التفعيل",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    StreamBuilder<String>(
                                      stream:
                                          validate ? bloc.mobileStream : null,
                                      builder: (context, s) => AtelierTextField(
                                        // controller: mobile,
                                        value: empty ? bloc.mobile() : "",
                                        lang: Localizations.localeOf(context)
                                            .languageCode
                                            .toString(),
                                        error: s.hasError
                                            ? "رقم الهاتف من 10 أرقام ويجب أن يبدأ ب 05"
                                            : null,
                                        type: TextInputType.number,
                                        unFocus: () {
                                          setState(() {
                                            FocusScope.of(context)
                                                .requestFocus(mobileNode);
                                          });
                                        },
                                        password: false,
                                        focusNode: mobileNode,
                                        label: "رقم الجوال",
                                        onChanged: bloc.onMobileChange,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      width: 400,
                                      height: 40,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          StreamBuilder<Object>(
                                              stream: bloc.mobileStream,
                                              builder: (context, snapshot) {
                                                return Expanded(
                                                  child: BumbiButton(
                                                    colored: true,
                                                    text: "تأكيد",
                                                    onPressed: () async {
                                                      setState(() {
                                                        validate = true;
                                                      });
                                                      if (bloc.mobile() ==
                                                          null) {
                                                        setState(() {
                                                          empty = true;
                                                        });
                                                        scaffold.currentState
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                            "من فضلك أكمل البيانات المطلوبة بشكل صحيح",
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                          ),
                                                        ));
                                                      } 
                                                      else {
                                                        setState(() {
                                                          loading = true;
                                                        });
                                                        await resendCode();

                                                        setState(() {
                                                          loading = false;
                                                        });
                                                        if (bloc
                                                                .errorUser()
                                                                .msg ==
                                                            null) {
                                                          print(bloc.currentUser().activation_code);
                                                          await addSharedBool("forget",true);
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          Confirm(
                                                                            from:
                                                                                "forget",
                                                                          )));
                                                        } else {
                                                          if (bloc
                                                                  .errorUser()
                                                                  .response_status ==
                                                              401) {
                                                            await clearUserData();
                                                            Navigator.of(
                                                                    context)
                                                                .pushReplacement(
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Splach()));
                                                          } else
                                                            scaffold
                                                                .currentState
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text(
                                                              bloc
                                                                  .errorUser()
                                                                  .msg,
                                                              textDirection:
                                                                  TextDirection
                                                                      .rtl,
                                                            )));
                                                        }
                                                      }
                                                    },
                                                  ),
                                                );
                                              }),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    loading ? LoadingFullScreen() : SizedBox()
                  ],
                )),
          ),
        ));
  }
}
