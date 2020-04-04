import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/shared_preferences_helper.dart';
import 'package:senam/models/userModel.dart';
import 'package:senam/screens/home/home.dart';
import 'package:senam/screens/login&signUp/confirm.dart';
import 'package:senam/screens/login&signUp/signUp.dart';
import 'package:senam/screens/login&signUp/splach.dart';
import 'package:flutter/material.dart';
import 'package:senam/blocs/widgets.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void initState() {
    super.initState();
    bloc.sendErrorUser(UserService(status: null, msg: null));
    // bloc.onMobileChange(null);
    // bloc.onPasswordChange(null);
  }

  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  bool validate = false;
  bool empty = false;
  final mobileNode = new FocusNode();
  final passwordNode = new FocusNode();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double safe = MediaQuery.of(context).padding.top;
    bloc.setDeviceSize(Size(size.width, size.height - safe));

    TextEditingController mobile = TextEditingController(
      text: bloc.mobile()
      );
    TextEditingController password =
        TextEditingController(
          text: bloc.password()
          );
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Splach()));
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
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          SmallIconButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => Splach()));
                            },
                            icon: Icons.arrow_forward_ios,
                          ),
                          Container(
                            width: bloc.size().width,
                            margin:
                                EdgeInsets.only(top: bloc.size().height / 7),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "مرحباً بعودتك",
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
                                  "قم بإدخال البيانات المطلوبة",
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
                                  stream: validate ? bloc.mobileStream : null,
                                  builder: (context, s) => AtelierTextField(
                                    value: empty ? bloc.mobile() : "",
                                    error: s.hasError
                                        ? "رقم الهاتف من 10 أرقام ويجب أن يبدأ ب 05"
                                        : null,
                                    unFocus: () {
                                      setState(() {
                                        passwordNode.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(mobileNode);
                                      });
                                    },
                                    controller: mobile,
                                    password: false,
                                    focusNode: mobileNode,
                                    label: "رقم الجوال",
                                    onChanged: bloc.onMobileChange,
                                  ),
                                ),
                                StreamBuilder(
                                  stream: validate ? bloc.passwordStream : null,
                                  builder: (context, s) => AtelierTextField(
                                    value: empty ? bloc.password() : "",
                                    lang: Localizations.localeOf(context)
                                        .languageCode
                                        .toString(),
                                    error: s.hasError
                                        ? "من فضلك أدخل كلمة مرور صحيحة"
                                        : null,
                                    controller: password,
                                    unFocus: () {
                                      setState(() {
                                        mobileNode.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(passwordNode);
                                      });
                                    },
                                    focusNode: passwordNode,
                                    label: "كلمة المرور",
                                    onChanged: bloc.onPasswordChange,
                                    password: true,
                                    forget: "نسيت كلمة المرور؟",
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 40,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: StreamBuilder(
                                          stream: bloc.combineMobileandPassword,
                                          builder: (context, s) => BumbiButton(
                                            colored: true,
                                            text: "تسجيل دخول",
                                            onPressed: () async {
                                              setState(() {
                                                validate = true;
                                              });
                                              if (bloc.mobile() == null ||
                                                  bloc.password() == null ||
                                                  s.hasError) {
                                                scaffold.currentState
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                  "من فضلك أكمل البيانات المطلوبة بشكل صحيح",
                                                  textDirection:
                                                      TextDirection.rtl,
                                                )));
                                                setState(() {
                                                  empty = true;
                                                });
                                              } else {
                                                /// code login
                                                setState(() {
                                                  loading = true;
                                                });
                                                await loginPost();
                                                setState(() {
                                                  loading = false;
                                                });
                                                if (bloc.errorUser().msg !=
                                                    null) {
                                                  if (bloc
                                                          .errorUser()
                                                          .response_status ==
                                                      401) {
                                                    await clearUserData();
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Splach()));
                                                  } else
                                                    scaffold.currentState
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                        bloc.errorUser().msg,
                                                        textDirection:
                                                            TextDirection.rtl,
                                                      ),
                                                    ));
                                                } else {
                                                  await addSharedString("pass",bloc.password());
                                                  if (bloc
                                                          .currentUser()
                                                          .status ==
                                                      "not_active"){
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Confirm(
                                                                          from:
                                                                              "logIn",
                                                                        )));
                                                                        }
                                                  else
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Home()));
                                                }
                                              
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      highlightColor:
                                          primaryAccent.withOpacity(.1),
                                      onTap: () {
                                            bloc.onNameChange(null);
    bloc.onMobileChange(null);
    bloc.onCodeChange(null);
    bloc.onPasswordChange(null);

                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignUp()));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "ليس لديك حساب؟ اشترك الآن",
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                              color: hint,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                      ),
                                    )
                                  ],
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
