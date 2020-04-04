import 'package:flutter/material.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/staticData.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

class Commision extends StatefulWidget {
  @override
  _CommisionState createState() => _CommisionState();
}

class _CommisionState extends State<Commision> {
  @override
  void initState() {
    getBanks();
    super.initState();
  }
  getBanks()async{
    List<Widget>b=await getBanksData();
    setState(() {
      banks=b;
    });
  }
List<Widget>banks=[];
  double cost;
  String commision;
  bool numError = false;
  FocusNode costNode = FocusNode();
  TextEditingController costCTL = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              costNode.unfocus();
            },
            child: Container(
                width: bloc.size().width,
                height: bloc.size().height,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "حساب العمولة",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
                            padding: const EdgeInsets.only(
                                right: 20, top: 10, left: 20),
                            child: Wrap(
                              children: <Widget>[
                                Text(
                                  "ما هي العمولة",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Wrap(
                              children: <Widget>[
                                Text(
                                  bloc.staticData().percent??"",
                                  // bloc.staticData().about,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20, top: 10, left: 20),
                            child: Wrap(
                              children: <Widget>[
                                Text(
                                  "لمعرفة نسبة التطبيق",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Wrap(
                              children: <Widget>[
                                Text(
                                  "ادخل قيمة المنتج", // bloc.staticData().about,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: AtelierTextField(
                              value: cost.toString(),
                              error: numError
                                  ? "قيمة المنتج مكونة من أرقام فقط"
                                  : null,
                              maxlength: 8,
                              unFocus: () {
                                setState(() {
                                  costNode.requestFocus();
                                });
                              },
                              controller: costCTL,
                              password: false,
                              focusNode: costNode,
                              label: "القمية بالريال السعودي",
                              type: TextInputType.number,
                              onChanged: (v) {
                                if (v == null || v.isEmpty) {
                                  setState(() {
                                    numError = false;
                                    commision = null;
                                  });
                                } else if (double.tryParse(v) != null &&
                                    v != null &&
                                    v != "")
                                  setState(() {
                                    numError = false;
                                    commision = (double.parse(v) * (bloc.staticData().percent_ratio/100))
                                        .toStringAsFixed(1);
                                  });
                                else
                                  setState(() {
                                    numError = true;
                                  });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20, top: 10, left: 20),
                            child: Wrap(
                              children: <Widget>[
                                Text(
                                  "نسبة التطبيق",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  child: Container(
                                      width: bloc.size().width / 1.5,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: hint.withOpacity(.3),
                                                spreadRadius: .5,
                                                blurRadius: 0,
                                                offset: Offset(0, 2)),
                                            BoxShadow(
                                                color: Colors.transparent,
                                                spreadRadius: 0,
                                                blurRadius: 1,
                                                offset: Offset(0, 1))
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                          left: 20, right: 20, top: 15),
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "ر.س",
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: primaryAccent,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            commision ?? "0.0",
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                fontSize: 56,
                                                color: primaryAccent,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20, top: 10, left: 20),
                            child: Wrap(
                              children: <Widget>[
                                Text(
                                  "الحسابات البنكية",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: banks,
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
class BankCard extends StatelessWidget {
 String bankImage;
 String bankName;
 String bankNumber;
 BankCard({this.bankImage,this.bankName,this.bankNumber});
  @override
  Widget build(BuildContext context) {
    return Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                            bankName,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600
                                                ,color: blackAccent
                                              ),
                                              textDirection: TextDirection.rtl,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                             bankNumber,
                                              style: TextStyle(
                                                color: hint,
                                                fontSize: 14
                                              ),
                                              textDirection: TextDirection.rtl,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        FadeInImage(
                            placeholder:
                                AssetImage('assets/images/placeholder.gif'),
                            image: NetworkImage(bankImage),
                            width: 100,
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                                      ],
                                    ),
                                  ))
                                ],
                              );
  }
}