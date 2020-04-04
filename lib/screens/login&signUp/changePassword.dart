
import 'package:flutter/material.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/userModel.dart';
import 'package:senam/screens/login&signUp/login.dart';

class ChangePassword extends StatefulWidget {
  String from;
  ChangePassword({this.from});
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  void initState() {
    bloc.onPasswordChange(null);
    bloc.onOldPasswordChange(null);
    super.initState();
  }

  final password1 = new FocusNode();
  final password2 = new FocusNode();
  bool validate = false;
  bool loading = false;
  bool empty = false;
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double safe = MediaQuery.of(context).padding.top;
    bloc.setDeviceSize(Size(size.width, size.height - safe));

    return WillPopScope(
          onWillPop: () {
            
            return Future.value(true);
          },
          child: SafeArea(
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
                                SmallIconButton(
                                  onPressed: () {
                                   Navigator.of(context).pop();
                                  },
                                  icon: Icons.arrow_forward_ios,
                                ),
                                Wrap(
                                  children: <Widget>[
                                    Container(
                                      width: bloc.size().width,
                                      margin: EdgeInsets.only(
                                          top: bloc.size().height / 8),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            "هل تريد تغيير كلمة المرور",
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 30,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          SizedBox(
                                            height: 50,
                                          ),
                                          StreamBuilder<String>(
                                            stream: validate
                                                ? bloc.oldPasswordStream
                                                : null,
                                            builder: (context, s) =>
                                                AtelierTextField(
                                              lang: Localizations.localeOf(
                                                      context)
                                                  .languageCode
                                                  .toString(),
                                              error: s.hasError
                                                  ? "كلمة المرور لا تقل عن 6 أحرف"
                                                  : null,
                                              value:
                                                  empty ? bloc.password() : "",
                                              unFocus: () {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(password1);
                                                });
                                              },
                                              password: true,
                                              focusNode: password1,
                                              label: "كلمة المرور القديمة",
                                              onChanged:
                                                  bloc.onOldPasswordChange,
                                            ),
                                          ),
                                          StreamBuilder<String>(
                                            stream: validate
                                                ? bloc.passwordStream
                                                : null,
                                            builder: (context, s) =>
                                                AtelierTextField(
                                              lang: Localizations.localeOf(
                                                      context)
                                                  .languageCode
                                                  .toString(),
                                              error: s.hasError
                                                  ? "كلمة المرور لا تقل عن 6 أحرف"
                                                  : null,
                                              value:
                                                  empty ? bloc.password() : "",
                                              unFocus: () {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(password2);
                                                });
                                              },
                                              password: true,
                                              focusNode: password2,
                                              label: "كلمة المرور الجديدة",
                                              onChanged: bloc.onPasswordChange,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: BumbiButton(
                                                    colored: false,
                                                    text:"إلغاء",
                                                    
                                                    onPressed: () {
                                                     Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                StreamBuilder<Object>(
                                                    stream: bloc
                                                        .combineTwoPasswordFields,
                                                    builder:
                                                        (context, snapshot) {
                                                      return Expanded(
                                                        child: BumbiButton(
                                                          colored: true,
                                                          text:
                                                             "حفظ",
                                                          
                                                          onPressed: () async {
                                                            setState(() {
                                                              validate = true;
                                                            });
                                                            if (bloc.oldPassword() ==
                                                                    null ||
                                                                bloc.password() ==
                                                                    null)
                                                              setState(() {
                                                                empty = true;
                                                              });
                                                            else if (snapshot
                                                                .hasError)
                                                              setState(() {
                                                                validate = true;
                                                              });
                                                            else {
                                                              //
                                                              setState(() {
                                                                loading = true;
                                                              });
                                                              await updatePassword();
                                                              setState(() {
                                                                loading = false;
                                                              });

                                                              if (bloc
                                                                      .errorUser()
                                                                      .msg !=
                                                                  null){ if(bloc.errorUser().status==401)
                                                            {
                                                              await clearUserData();
                                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Login()));
                                                            }else
                                                                scaffold
                                                                    .currentState
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(bloc
                                                                      .errorUser()
                                                                      .msg),
                                                                ));}
                                                              else {
                                                                Navigator.of(context).pop();
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
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        loading ? LoadingFullScreen() : SizedBox()
                      ],
                    )),
              ),
            ),
          )
    );
  }
}
