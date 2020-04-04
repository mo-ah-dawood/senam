import 'package:flutter/material.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/shared_preferences_helper.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/userModel.dart';
import 'package:senam/screens/article.dart';
import 'package:senam/screens/login&signUp/confirm.dart';
import 'package:senam/screens/login&signUp/login.dart';
import 'package:senam/screens/login&signUp/splach.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    for (int i = 0; i < bloc.citiesList().length; i++) {
      setState(() {
        citiesMap[bloc.citiesList()[i].id] = bloc.citiesList()[i].name;
      });
    }
    bloc.sendErrorUser(UserService(status: null, msg: null));
    super.initState();
    bloc.onNameChange(null);
    bloc.onMobileChange(null);
    bloc.onCodeChange(null);
    bloc.onPasswordChange(null);
  }

  List<DropdownMenuItem> _dropdownMenuItems;
  List<DropdownMenuItem> buildDropdownMenuItems(List typs) {
    List<DropdownMenuItem> items = List();
    for (int i = 0; i < typs.length; i++) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Container(
              padding: EdgeInsets.only(right: 10),
              alignment: Alignment.centerRight,
              child: Text(
                typs[i],
                textDirection: TextDirection.rtl,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: i == 0 ? hint : blackAccent,
                    fontSize: 15,
                    fontWeight: _selectedValue == i && i != 0
                        ? FontWeight.bold
                        : FontWeight.w500),
              )),
        ),
      );
    }
    return items;
  }

  int _selectedValue = 0;
  onChangeDropdownItem(int selectedType) {
    setState(() {
      if (selectedType > 0) {
        _selectedValue = selectedType;
        bloc.oncityIdChange(bloc.citiesList()[selectedType - 1].id);
      }
    });
  }

  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  final nameNode = new FocusNode();
  final mobileNode = new FocusNode();
  final passwordNode = new FocusNode();
  bool empty = false;
  bool agreed = false;
  bool rulesError = false;
  bool validate = false;
  bool loading = false;
  Map<int, String> citiesMap = {};

  @override
  Widget build(BuildContext context) {
    List<String> cities = ["المدينة"]..addAll(citiesMap.values.toList());
    setState(() {
      _dropdownMenuItems = buildDropdownMenuItems(cities);
    });

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
                padding: EdgeInsets.only(top: 30),
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
                              icon: Icons.arrow_forward_ios,
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => Splach()));
                              },
                            ),
                            Container(
                              width: bloc.size().width,
                              margin: EdgeInsets.only(top: 70),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "انضم إلينا الآن",
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
                                  // named field
                                  StreamBuilder<String>(
                                    stream: validate ? bloc.nameStream : null,
                                    builder: (context, s) => AtelierTextField(
                                      // controller: name,
                                      value: empty ? bloc.name() : "",
                                      error: s.hasError
                                          ? "الاسم لا يمكن أن يكون فارغاً"
                                          : null,
                                      unFocus: () {
                                        setState(() {
                                          mobileNode.unfocus();
                                          passwordNode.unfocus();
                                          FocusScope.of(context)
                                              .requestFocus(nameNode);
                                        });
                                      },
                                      password: false,
                                      focusNode: nameNode,
                                      label: "الاسم",
                                      onChanged: bloc.onNameChange,
                                    ),
                                  ),
                                  //email field
                                  Container(
//                           //نوع التواصل
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    margin: EdgeInsets.symmetric(vertical: 6),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border:
                                            validate && bloc.cityId() == null
                                                ? Border.all(color: Colors.red)
                                                : null,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.grey,
                                        ),
                                        Spacer(),
                                        Container(
                                          width: bloc.size().width - 120,
                                          child: DropdownButton(
                                            underline: SizedBox(),
                                            isExpanded: true,
                                            icon: Icon(Icons.do_not_disturb_on,
                                                size: 0),
                                            value: _selectedValue,
                                            items: _dropdownMenuItems,
                                            onChanged: (v) {
                                              onChangeDropdownItem(v);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //mobile field
                                  StreamBuilder<String>(
                                    stream: validate ? bloc.mobileStream : null,
                                    builder: (context, s) => AtelierTextField(
                                      // controller: mobile,
                                      value: empty ? bloc.mobile() : "",
                                      error: s.hasError
                                          ? "رقم الهاتف من 10 أرقام ويجب أن يبدأ ب 05"
                                          : null,
                                      type: TextInputType.number,
                                      unFocus: () {
                                        setState(() {
                                          nameNode.unfocus();
                                          passwordNode.unfocus();
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

                                  //password field
                                  StreamBuilder(
                                    stream:
                                        validate ? bloc.passwordStream : null,
                                    builder: (context, s) => AtelierTextField(
                                      // controller: password,
                                      value: empty ? bloc.password() : "",
                                      error: s.hasError ||
                                              (validate &&
                                                  bloc.password() == null)
                                          ? "كلمة المرور يجب أن تكون أكثر من 6 حروف!"
                                          : null,
                                      unFocus: () {
                                        setState(() {
                                          nameNode.unfocus();
                                          mobileNode.unfocus();
                                          FocusScope.of(context)
                                              .requestFocus(passwordNode);
                                        });
                                      },
                                      focusNode: passwordNode,
                                      label: "كلمة المرور",
                                      onChanged: bloc.onPasswordChange,
                                      password: true,
                                    ),
                                  ),
                                  // rules and conditions
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Article(
                                                              title:
                                                                  "الشروط والأحكام",
                                                              articleURL:
                                                                 "$apiUrl/page/licence",
                                                            )));
                                          },
                                          child: Text(
                                              ".الموافقة على الشروط والأحكام",
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  color: rulesError
                                                      ? Colors.red
                                                      : hint,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15)),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          onTap: () {
                                            setState(() {
                                              agreed = !agreed;
                                              if (agreed) rulesError = false;
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            child: agreed
                                                ? Icon(
                                                    Icons.check,
                                                    size: 20,
                                                    color: Colors.white,
                                                  )
                                                : SizedBox(),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: rulesError
                                                        ? Colors.red
                                                        : primary,
                                                    width: 1),
                                                color: agreed
                                                    ? primary
                                                    : Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: bloc.size().width,
                                    height: 40,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        StreamBuilder<Object>(
                                            stream: bloc.combineSinUpFields,
                                            builder: (context, snapshot) {
                                              return Expanded(
                                                child: BumbiButton(
                                                  colored: true,
                                                  text: "اشترك الآن",
                                                  onPressed: () async {
                                                    setState(() {
                                                      validate = true;
                                                    });
                                                    if (agreed == false)
                                                      setState(() {
                                                        rulesError = true;
                                                      });

                                                    if (bloc.mobile() == null ||
                                                        bloc.name() == null ||
                                                        bloc.cityId() == null ||
                                                        rulesError == true ||
                                                        bloc.password() ==
                                                            null ||
                                                        snapshot.hasError) {
                                                      scaffold.currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                          "من فضلك أكمل البيانات المطلوبة بشكل صحيح",
                                                          textDirection:
                                                              TextDirection.rtl,
                                                        ),
                                                      ));
                                                      setState(() {
                                                        empty = true;
                                                      });
                                                    } else {
                                                      //ok
                                                      setState(() {
                                                        loading = true;
                                                      });
                                                      await signUpUser();
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                      if (bloc
                                                              .errorUser()
                                                              .msg ==
                                                          null) {
                                                        await addSharedString(
                                                            "pass",
                                                            bloc.password());

                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Confirm(
                                                                              from: "signUp",
                                                                            )));
                                                      } else {
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
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      InkWell(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        highlightColor:
                                            primaryAccent.withOpacity(.1),
                                        onTap: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Login()));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "لديك حساب بالفعل؟ تسجيل دخول",
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
          )),
    );
  }
}
