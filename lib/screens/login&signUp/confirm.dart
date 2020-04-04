import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/shared_preferences_helper.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/userModel.dart';
import 'package:senam/screens/home/home.dart';
import 'package:senam/screens/login&signUp/forgetPassword.dart';
import 'package:senam/screens/login&signUp/login.dart';
import 'package:senam/screens/login&signUp/newPassword.dart';
import 'package:senam/screens/login&signUp/signUp.dart';
import 'package:senam/screens/login&signUp/splach.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

class Confirm extends StatefulWidget {
  String from;
  Confirm({this.from});
  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  initState() {
    super.initState();
    
  }

  bool empty = false;
  bool validate = false;
  bool loading = false;
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  final codeNode = new FocusNode();
  TextEditingController pinCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.from == "logIn")
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Login()));
        else if (widget.from == "signUp")
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SignUp()));
        else
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ForgetPassword()));
        return Future.value(false);
      },
      child: Scaffold(
        key: scaffold,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
              padding: EdgeInsets.only(top: 20),
              width: bloc.size().width,
              height: bloc.size().height,
              child: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SmallIconButton(
                            onPressed: () {
                              if (widget.from == "logIn")
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              else if (widget.from == "signUp")
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()));
                              else
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgetPassword()));
                            },
                            icon: Icons.arrow_forward_ios,
                          ),
                          Container(
                            width: bloc.size().width,
                            margin:
                                EdgeInsets.only(top: bloc.size().height / 6),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "ادخل كود التفعيل",
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
                                  "سوف يتم إرسال كود التفعيل إلى\nرقم الجوال الخاص بك",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                StreamBuilder(
                                  stream: validate ? bloc.codeStream : null,
                                  builder: (context, s) => AtelierTextField(
                                    password: false,
                                    value: empty ? bloc.code() : "",
                                    error: s.hasError
                                        ? "كلمة المرور يجب أن تكون أكثر من 6 حروف!"
                                        : null,
                                    unFocus: () {
                                      setState(() {
                                        FocusScope.of(context)
                                            .requestFocus(codeNode);
                                      });
                                    },
                                    focusNode: codeNode,
                                    label: "كود التفعيل",
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: PinInputTextFormField(
                                        autoFocus: true,
                                        focusNode: codeNode,
                                        onChanged: bloc.onCodeChange,
                                        decoration: UnderlineDecoration(
                                            gapSpace: 20,
                                            enteredColor: primary,
                                            color: hint.withOpacity(0.5),
                                            lineHeight: 1.5),
                                        pinLength: 4,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      width: 400,
                                      height: 40,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: StreamBuilder<Object>(
                                                stream: bloc.codeStream,
                                                builder: (context, snapshot) {
                                                  return BumbiButton(
                                                    colored: true,
                                                    text: "تأكيد",
                                                    onPressed: () async {
                                                      ////////////////// validation
                                                      setState(() {
                                                        validate = true;
                                                      });
                                                      if (bloc.code() == null ||
                                                          bloc.code().length <
                                                              4 ||
                                                          snapshot.hasError) {
                                                        scaffold.currentState
                                                            .showSnackBar(
                                                                SnackBar(
                                                                    content:
                                                                        Text(
                                                          "من فضلك أكمل البيانات المطلوبة بشكل صحيح",
                                                          textDirection:
                                                              TextDirection.rtl,
                                                        )));
                                                        ///////////////////
                                                      } else {
                                                        if (widget.from ==
                                                                "signUp" ||
                                                            widget.from ==
                                                                "logIn") {
                                                          ////////from signup
                                                          if (bloc.code() ==
                                                              bloc
                                                                  .currentUser()
                                                                  .activation_code) {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            await activate();
                                                            setState(() {
                                                              loading = false;
                                                            });
                                                            if (bloc
                                                                    .errorUser()
                                                                    .msg !=
                                                                null) {
                                                              if (bloc
                                                                      .errorUser()
                                                                      .response_status ==
                                                                  401) {
                                                                await clearUserData();
                                                                Navigator.of(
                                                                        context)
                                                                    .pushReplacement(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Splach()));
                                                              } else
                                                                scaffold
                                                                    .currentState
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(
                                                                    bloc
                                                                        .errorUser()
                                                                        .msg,
                                                                    textDirection:
                                                                        TextDirection
                                                                            .rtl,
                                                                  ),
                                                                ));
                                                            } else
                                                              Navigator.of(
                                                                      context)
                                                                  .pushReplacement(
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              Home()));
                                                          } else
                                                            scaffold
                                                                .currentState
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                "هذا الكود غير صحيح",
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl,
                                                              ),
                                                            ));
                                                        } //من التسجيل
                                                        else if (widget.from ==
                                                            "forget") {
                                                          if (bloc.code() ==
                                                              bloc
                                                                  .currentUser()
                                                                  .activation_code) {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            await activate();
                                                            setState(() {
                                                              loading = false;
                                                            });
                                                            if (bloc
                                                                    .errorUser()
                                                                    .msg !=
                                                                null) {
                                                              if (bloc
                                                                      .errorUser()
                                                                      .status ==
                                                                  401) {
                                                                await clearUserData();
                                                                Navigator.of(
                                                                        context)
                                                                    .pushReplacement(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Splach()));
                                                              } else
                                                                scaffold
                                                                    .currentState
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(
                                                                    bloc
                                                                        .errorUser()
                                                                        .msg,
                                                                    textDirection:
                                                                        TextDirection
                                                                            .rtl,
                                                                  ),
                                                                ));
                                                            } else
                                                              Navigator.of(
                                                                      context)
                                                                  .pushReplacement(
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              NewPassword()));
                                                          } else
                                                            scaffold
                                                                .currentState
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                "هذا الكود غير صحيح",
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl,
                                                              ),
                                                            ));
                                                        }
                                                        setState(() {
                                                          loading = false;
                                                        });
                                                      }
                                                      await removeSharedOfKey(
                                                          "forget");
                                                    },
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: 400,
                                      height: 40,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: BumbiButton(
                                              colored: false,
                                              text: "إعادة إرسال",
                                              onPressed: () async {
                                                setState(() {
                                                  loading = true;
                                                });

                                                await resendCode();
                                                setState(() {
                                                  loading = false;
                                                });
                                                if (int.tryParse(bloc
                                                        .currentUser()
                                                        .activation_code) !=
                                                    null) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        new AlertDialog(
                                                      title: new Text(
                                                        "هذه الرسالة تجريبية ",
                                                        textDirection:
                                                            TextDirection.rtl,
                                                      ),
                                                      content: new Text(
                                                        "هذه الرسالة بها كود التفعيل في حال عدم وصول الكود أو الرغبة بتجربة إيميلات غير حقيقية\nكود التفعيل \n ${bloc.currentUser().activation_code.toString()}",
                                                        textDirection:
                                                            TextDirection.rtl,
                                                      ),
                                                      actions: <Widget>[
                                                        new FlatButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                            child: new Text(
                                                              "إلغاء",
                                                              textDirection:
                                                                  TextDirection
                                                                      .rtl,
                                                            )),
                                                        new FlatButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: new Text(
                                                            "حسناً",
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  print(bloc
                                                      .currentUser()
                                                      .activation_code);
                                                }
                                                if (bloc.errorUser().msg !=
                                                    null) {
                                                  if (bloc.errorUser().status ==
                                                      401) {
                                                    // await clearUserData();
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Login()));
                                                  } else
                                                    scaffold.currentState
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          bloc.errorUser().msg),
                                                    ));
                                                } else
                                                  scaffold.currentState
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                      "تم إرسال الكود بنجاح",
                                                      textDirection:
                                                          TextDirection.rtl,
                                                    ),
                                                  ));
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                  loading ? LoadingFullScreen() : SizedBox()
                ],
              )),
        ),
      ),
    );
  }
}
