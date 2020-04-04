import 'package:flutter/material.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/userModel.dart';
import 'package:senam/screens/login&signUp/forgetPassword.dart';
import 'package:senam/screens/login&signUp/login.dart';
import 'package:senam/screens/login&signUp/splach.dart';

class NewPassword extends StatefulWidget {
  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  @override
  void initState() {
    bloc.onPasswordChange(null);
    super.initState();
  }

  final emailNode = new FocusNode();
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
                              child: Column(

                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 30,),
                                  SmallIconButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgetPassword()));
                                    },
                                    icon: Icons.arrow_forward_ios,
                                  ),
                                  Wrap(
                                    children: <Widget>[
                                      Container(
                                        width: bloc.size().width,
                                        margin: EdgeInsets.only(
                                            top: bloc.size().height / 7),
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              "كلمة المرور الجديدة"  ,textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "قم بإدخال كلمة المرور الجديدة"  ,textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 50,
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
                                                    ? "كلمة المرور يجب أن تكون أكثر من 6 حروف!"
                                                    : null,
                                                value:
                                                    empty ? bloc.password() : "",
                                                unFocus: () {
                                                  setState(() {
                                                    FocusScope.of(context)
                                                        .requestFocus(emailNode);
                                                  });
                                                },
                                                password: true,
                                                focusNode: emailNode,
                                                label:"كلمة المرور",
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
                                                    child: StreamBuilder<Object>(
                                                        stream: bloc.passwordStream,
                                                        builder:
                                                            (context, snapshot) {
                                                          return BumbiButton(
                                                            colored: true,
                                                            text:
                                                                "تأكيد",
                                                            
                                                            onPressed: () async {
                                                              setState(() {
                                                                validate = true;
                                                              });
                                                              if (bloc.password() ==
                                                                      null ||
                                                                  snapshot.hasError)
                                                                setState(() {
                                                                  empty = true;
                                                                });
                                                              else {
                                                                setState(() {
                                                                  loading = true;
                                                                });
                                                                await resetPassword();
                                                                setState(() {
                                                                  loading = false;
                                                                });
                                                                if (bloc
                                                                        .errorUser()
                                                                        .msg !=
                                                                    null){
                                                                       if(bloc.errorUser().response_status==401)
                                                              {
                                                                await clearUserData();
                                                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Splach()));
                                                              }else
                                                                  scaffold
                                                                      .currentState
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(bloc
                                                                        .errorUser()
                                                                        .msg  ,textDirection: TextDirection.rtl,),
                                                                  ));}
                                                                else {
                       
                                                                    Navigator.of(
                                                                            context)
                                                                        .pushReplacement(
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (context) =>
                                                                                  Login()),
                                                                    );
                                                                  } ////
                                                                 
                                                                
                                                              }
                                                            },
                                                          );
                                                        }),
                                                  ),
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
                        ),
                        loading ? LoadingFullScreen() : SizedBox()
                      ],
                    )),
              ),
            ),
          
        );
  }
}
