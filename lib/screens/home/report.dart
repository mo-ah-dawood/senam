import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/adModel.dart';
import 'package:senam/screens/login&signUp/login.dart';
import 'package:senam/screens/login&signUp/signUp.dart';
import 'package:senam/screens/login&signUp/splach.dart';

class Report extends StatefulWidget {
  bool grey;
  int id;
  Report({this.grey, this.id});
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  bool delete = false;
  bool empty = false;
  bool loading = false;
  double rate = 0;
  String reason;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          child: SingleChildScrollView(
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
                            Text(
                              "إبلاغ عن إساءة",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: blackAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "برجاء توضيح السبب",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: blackAccent,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 12,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  color: backGround),
                              child: TextFormField(
                                onChanged: (v) {
                                  setState(() {
                                    reason = v;
                                  });
                                },
                                cursorColor: primary,
                                textDirection: TextDirection.rtl,
                                maxLines: 3,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(10)),
                              ),
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
                                      text: "إلغاء",
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: BumbiButton(
                                      colored: true,
                                      text: "تأكيد",
                                      onPressed: () async {
                                        if (reason != null) {
                                          if (reason.isNotEmpty) {
                                            setState(() {
                                              loading = true;
                                            });
                                            var a = await reportAd(
                                                widget.id, reason);
                                            setState(() {
                                              loading = false;
                                            });
                                            if (int.tryParse(a) == null) {

                                            await  showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20))),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15),
                                                          child: Text(
                                                            a,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ));
                                                  });
                                                                                                Navigator.of(context).pop();

                                            } else {
                                              await clearUserData();
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Splach()));
                                            }
                                          }
                                        }
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
        ),
        loading ? LoadingFullScreen() : SizedBox()
      ],
    );
  }
}
