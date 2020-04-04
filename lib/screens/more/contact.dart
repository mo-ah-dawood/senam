import 'package:senam/blocs/design.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:flutter/material.dart';
import 'package:senam/blocs/bloc.dart';
import 'dart:async';

import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:senam/models/staticData.dart';
import 'package:senam/screens/login&signUp/splach.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  void initState() {
    getTyps();
    setState(() {
      
    });

    super.initState();
  }
getTyps()async{
  Map<int,String>m=await getContactTyps();
  setState(() {
    typs=m;
  });
}
  final ScrollController controller = ScrollController();
  TextEditingController message = TextEditingController();
  final messageNode = new FocusNode();
  String messageText;
  bool empty = false;
  List<DropdownMenuItem> _dropdownMenuItems;
  bool loading = false;
  List<DropdownMenuItem> buildDropdownMenuItems(List typs) {
    List<DropdownMenuItem> items = List();
    for (int i = 0; i < typs.length; i++) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                typs[i],
                textDirection: TextDirection.rtl,
                style: TextStyle(
                    fontWeight: _selectedValue == i
                        ? FontWeight.bold
                        : FontWeight.normal),
              )),
        ),
      );
    }
    return items;
  }

  int _selectedValue = 0;
  onChangeDropdownItem(int selectedType) {
    setState(() {
      _selectedValue = selectedType;
    });
  }
    Map<int,String> typs = {};

  @override
  Widget build(BuildContext context) {
            setState(() {
      _dropdownMenuItems = buildDropdownMenuItems(typs.values.toList());
    });

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
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
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "تواصل معنا",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 20, top: 10, left: 20),
                      child: Wrap(
                        children: <Widget>[
                          Text(
                            "كيف يمكننا مساعدتك؟",
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Wrap(
                        children: <Widget>[
                          Text(
                            "يسعدنا تواصلك معنا",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 20, top: 30, bottom: 5, left: 20),
                      child: Text(
                        "نوع التواصل",
                        style: TextStyle(fontSize: 14, color: hint),
                      ),
                    ),
                    Container(
                      //نوع التواصل
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
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
                              iconSize: 0,
                              underline: SizedBox(),
                              isExpanded: true,
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
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: AtelierTextField(
                        controller: message,
                        value: empty ? messageText : "",
                        error: empty ? "الرسالة فارغة" : null,
                        unFocus: () {
                          setState(() {
                            FocusScope.of(context).requestFocus(messageNode);
                          });
                        },
                        password: false,
                        focusNode: messageNode,
                        label: "نص الرسالة",
                        descrip: true,
                        onChanged: (v) {
 messageText = v;
                          setState(() {
                            if (messageText.length > 0)
                            setState(() {
                              empty = false;
                            });
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 40,
                      margin: EdgeInsets.all(20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: BumbiButton(
                            text: "إرسال",
                            colored: true,
                            onPressed: () async {
                             
                              if (messageText != null) {
                                        if(messageText.isNotEmpty ){
                                        setState(() {
                                          loading = true;
                                        });
                                        var a =
                                            await contactUs(typs.keys.toList()[_selectedValue], messageText);
                                        setState(() {
                                          loading = false;
                                        });
                                        if (int.tryParse(a) == null) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      child: Text(
                                                        a,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ));
                                              });
                                        } else {
                                          await clearUserData();
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Splach()));
                                        }}
                                      }
                            },
                          ))
                        ],
                      ),
                    )
                  ],
                )),
                loading ? LoadingFullScreen() : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
