import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/adModel.dart';
import 'package:senam/screens/login&signUp/login.dart';
import 'package:senam/screens/login&signUp/signUp.dart';

class RateProvider extends StatefulWidget {
  bool grey;
  int id;

  RateProvider({this.grey,this.id});
  @override
  _RateProviderState createState() => _RateProviderState();
}

class _RateProviderState extends State<RateProvider> {
  bool delete = false;
  bool empty = false;
  bool loading=false;
  double rate=0;
  String reason = "";
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          color: widget.grey != null ? Color(0xff353535) : Color(0xff737373),
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
                            "تقييم صاحب الإعلان",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontSize: 20,
                                color: blackAccent,
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 50,
                              horizontal: 20,
                            ),
                            child: RatingBar(onRatingUpdate: (v){
                              setState(() {
                                rate=v;
                              });
                            }
                            ,
                            itemCount: 5,
                            initialRating: rate,
                            allowHalfRating: true,
                            glow: false,
                            itemBuilder: (context,s)=>Icon(Icons.star,color: Colors.amber,),
                            ),
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
                                    text: "تقييم",
                                    onPressed: ()async {
                                      setState(() {
                                        delete=true;
                                      
                                      });
                                      await rateUser(widget.id,rate.toString());
                                      setState(() {
                                        delete=false;
                                      
                                      });
                                      Navigator.of(context).pop();
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
        loading?LoadingFullScreen():SizedBox()
      ],
    );
  }
}
