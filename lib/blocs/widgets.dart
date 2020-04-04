import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:senam/models/adModel.dart';
import 'package:senam/screens/home/adPage.dart';
import 'package:senam/screens/home/myAd.dart';
import 'package:senam/screens/home/profile.dart';
import 'package:senam/screens/home/providerPage.dart';
import 'package:senam/models/userModel.dart';
import 'package:senam/screens/login&signUp/forgetPassword.dart';
import 'bloc.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'design.dart';

class BumbiButton extends StatelessWidget {
  String text;
  Function onPressed;
  BoxDecoration boxDecoration;
  Widget child;
  bool expanded;
  bool colored;
  BumbiButton(
      {this.onPressed,
      this.text,
      this.expanded,
      this.boxDecoration,
      this.child,
      this.colored});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: colored
              ? LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [primary, primaryAccent])
              : null,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        highlightColor: colored
            ? Colors.transparent.withOpacity(.5)
            : primaryAccent.withOpacity(.1),
        colorBrightness: Brightness.light,
        padding: EdgeInsets.all(0),
        child: Container(
            height: 40,
            alignment: Alignment.center,
            child: child != null
                ? child
                : Text(
                    text,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        fontSize: 14,
                        color: colored ? Colors.white : primary,
                        fontWeight: FontWeight.bold),
                  )),
        onPressed: onPressed,
      ),
    );
  }
}

// gloabl button in the application
class primaryButton extends StatelessWidget {
  String text;
  Function onPressed;
  BoxDecoration boxDecoration;
  Widget child;
  bool expanded;
  bool colored;
  primaryButton(
      {this.onPressed,
      this.text,
      this.expanded,
      this.boxDecoration,
      this.child,
      this.colored});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: MaterialButton(
      color: colored ? primary : null,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      highlightColor: colored
          ? Colors.redAccent.withOpacity(.5)
          : primaryAccent.withOpacity(.5),
      splashColor: Colors.red[50],
      colorBrightness: Brightness.light,
      padding: EdgeInsets.all(0),
      child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: boxDecoration != null
              ? boxDecoration
              : BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
          child: child != null
              ? child
              : Text(
                  text,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      fontSize: 14,
                      color: colored ? Colors.white : primary,
                      fontWeight: FontWeight.bold),
                )),
      onPressed: onPressed,
    ));
  }
}

//// Icon button
class primaryIconButton extends StatelessWidget {
  Function onPressed;
  IconData iconData;
  Widget child;
  Color color;
  double width;
  primaryIconButton(
      {this.iconData, this.child, this.color, this.onPressed, this.width});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      highlightColor: primaryAccent.withOpacity(.5),
      splashColor: Colors.red[100],
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: color != null ? color : primaryAccent,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: child != null
            ? child
            : Icon(
                iconData,
                color: primary,
                size: width != null ? width : 22,
              ),
      ),
    );
  }
}

///
/// back button

class SmallIconButton extends StatelessWidget {
  IconData icon;
  EdgeInsets padding;
  Color color;
  Function onPressed;
  SmallIconButton({this.icon, this.onPressed, this.color, this.padding});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding != null ? padding : EdgeInsets.all(15),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white),
          child: Icon(
            icon,
            color: color ?? blackAccent,
            size: 20,
          ),
        ),
      ),
    );
  }
}

/////
/// text field

class AtelierTextField extends StatefulWidget {
  String label;
  Function unFocus;
  bool password;
  FocusNode focusNode;
  BuildContext context;
  Function onChanged;
  String error;
  bool descrip;
  String value;
  TextEditingController controller;
  String forget;
  int maxlength;
  String lang;
  Widget child;
  TextInputType type;

  AtelierTextField(
      {this.label,
      this.lang,
      this.controller,
      this.type,
      this.descrip,
      this.maxlength,
      this.value,
      this.onChanged,
      this.password,
      this.child,
      this.focusNode,
      this.error,
      this.forget,
      this.unFocus});
  @override
  _AtelierTextFieldState createState() => _AtelierTextFieldState();
}

class _AtelierTextFieldState extends State<AtelierTextField> {
  bool visiable = true;
  bool tapped = false;
  BuildContext context;
  String data;
  @override
  void initState() {
    visiable = widget.password ? false : true;
    context = widget.context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        AnimatedDefaultTextStyle(
          duration: mill0Second,
          style: TextStyle(
              fontFamily: "Tajawal",
              color: widget.error != null ? Colors.red : hint,
              fontWeight: FontWeight.w600,
              fontSize: widget.focusNode.hasPrimaryFocus || widget.error != null
                  ? 15
                  : 0),
          child: Text(
            widget.label,
            textDirection: TextDirection.rtl,
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          height: widget.descrip != null ? null : 45,
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: widget.child != null
              ? widget.child
              : TextFormField(
                  maxLength: widget.maxlength,
                  minLines: 1,
                  maxLines: widget.descrip != null ? 4 : 1,
                  textAlign: TextAlign.right,
                  controller:
                      widget.controller != null ? widget.controller : null,
                  onTap: () {
                    widget.unFocus();
                    setState(() {
                      FocusScope.of(context).requestFocus(widget.focusNode);
                    });
                  },
                  keyboardType:
                      widget.type != null ? widget.type : TextInputType.text,
                  cursorColor: widget.error != null ? Colors.red : primary,
                  onChanged: widget.onChanged,
                  focusNode: widget.focusNode,
                  obscureText: visiable ? false : true,
                  style: TextStyle(
                      color: blackAccent,
                      fontWeight: FontWeight.w700,
                      fontSize: 15),
                  decoration: InputDecoration(
                    counterText: "",
                    hintStyle: TextStyle(
                        color: widget.error != null ? Colors.red : hint,
                        fontWeight: FontWeight.w600,
                        fontSize: widget.focusNode.hasPrimaryFocus ||
                                widget.error == null
                            ? 15
                            : 0),
                    hintText:
                        widget.error != null || widget.focusNode.hasPrimaryFocus
                            ? ""
                            : widget.label,
                    prefixIcon: widget.password
                        ? InkWell(
                            child: !visiable
                                ? Icon(
                                    Icons.visibility,
                                    size: 20,
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    size: 20,
                                  ),
                            onTap: () {
                              setState(() {
                                visiable = !visiable;
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                  ),
                ),
          decoration: BoxDecoration(
              border: widget.error != null || widget.value == null
                  ? Border.all(color: Colors.red)
                  : null,
              boxShadow: widget.focusNode.hasPrimaryFocus
                  ? [
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
                    ]
                  : null,
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
        widget.error != null
            ? Container(
                padding: EdgeInsets.only(
                  right: 15,
                ),
                child: AnimatedDefaultTextStyle(
                  duration: mill0Second,
                  style: TextStyle(
                      color: widget.error != null ? Colors.red : hint,
                      fontWeight: FontWeight.w600,
                      fontSize: widget.focusNode.hasPrimaryFocus ||
                              widget.error != null
                          ? 11
                          : 0),
                  child: Text(
                    widget.error,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              )
            : SizedBox(),
        (widget.password && widget.forget != null)
            ? Align(
                alignment: Alignment.bottomLeft,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  highlightColor: primaryAccent.withOpacity(.1),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ForgetPassword()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      widget.forget,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          color: hint,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }
}

///// bottom bar item button

class LoadingFullScreen extends StatelessWidget {
  Stream stream;
  LoadingFullScreen({this.stream});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backGround.withOpacity(.3),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Theme(
                data: ThemeData(accentColor: primary),
                child: CircularProgressIndicator()),
          ),
          SizedBox(
            height: 20,
          ),
          stream != null
              ? StreamBuilder(
                  stream: stream,
                  builder: (context, s) => Center(
                        child: Text(
                          s.data ?? "0.0",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ))
              : SizedBox()
        ],
      ),
    );
  }
}

////////////////////

////////////////

///////////////////
class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius - 5);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}

/////////// order card

///////////////// تتحط جوا كولوم بتتكون من مربع فيه اي حاجة وفوقه بوتوم شييت له هيدر وبودي
class DetailsWithCustomBottomSheet extends StatefulWidget {
  Widget detailsBody;
  Widget headerBottomSheet;
  Widget bodyBottomSheet;
  double spaceForHeader;
  DetailsWithCustomBottomSheet(
      {this.bodyBottomSheet,
      this.detailsBody,
      this.headerBottomSheet,
      this.spaceForHeader});
  @override
  _DetailsWithCustomBottomSheetState createState() =>
      _DetailsWithCustomBottomSheetState();
}

class _DetailsWithCustomBottomSheetState
    extends State<DetailsWithCustomBottomSheet> {
  GlobalKey bottomSheetBodyKey = GlobalKey();
  GlobalKey bottomSheetHeaderKey = GlobalKey();
  Size bottomSheetBodySize;
  Size bottomSheetHeaderSize;
  double bottom = 0;
  double bodyBottom = -500;
  double start = 0;
  double current = 0;
  double end = 0;
  setBottomSheetSizes() async {
    final RenderBox body = bottomSheetBodyKey.currentContext.findRenderObject();
    final RenderBox header =
        bottomSheetHeaderKey.currentContext.findRenderObject();
    // final positionBottom =
    //     body.localToGlobal(Offset.zero);
    final bodySize = body.size;
    final headerSize = header.size;
    setState(() {
      bottomSheetBodySize = bodySize;
      bottomSheetHeaderSize = headerSize;
    });
  }

  double height = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      overflow: Overflow.visible,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Color(0xffF9F9F9),
                child: widget.detailsBody),
            Stack(
              children: <Widget>[
                widget.headerBottomSheet,
                Positioned.fill(
                    child: Container(
                  color: backGround,
                ))
              ],
            )
          ],
        ),
        ///////////////////
        AnimatedPositioned(
          child: GestureDetector(
            onVerticalDragStart: (d) {
              setBottomSheetSizes();
              setState(() {
                bottom = end;
                start = d.globalPosition.dy;
                bodyBottom = bottom - bottomSheetBodySize.height;
              });
            },
            onVerticalDragUpdate: (d) {
              setState(() {
                current = end + (start - d.globalPosition.dy);
                if (current > bottomSheetBodySize.height || current < 0) {
                  bodyBottom = bottom - bottomSheetBodySize.height;
                } else {
                  bottom = current;
                  bodyBottom = bottom - bottomSheetBodySize.height;
                }
              });
            },
            onVerticalDragEnd: (d) {
              setState(() {
                if (bottom - end >= 50) {
                  bottom = bottomSheetBodySize.height;
                  bodyBottom = bottom - bottomSheetBodySize.height;

                  end = bottom;
                } else if (bottom - end <= -50) {
                  bottom = 0;
                  bodyBottom = bottom - bottomSheetBodySize.height;

                  end = bottom;
                } else {
                  bottom = end;
                  bodyBottom = bottom - bottomSheetBodySize.height;
                }
              });
            },
            child: Container(
                key: bottomSheetHeaderKey,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(45),
                      topLeft: Radius.circular(45)),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: bloc.size().width,
                child: widget.headerBottomSheet),
          ),
          duration: mill000Second,
          bottom: bottom,
        ),
        AnimatedPositioned(
            bottom: bodyBottom,
            child: GestureDetector(
              onVerticalDragStart: (d) {
                setBottomSheetSizes();
                setState(() {
                  bottom = end;
                  start = d.globalPosition.dy;
                  bodyBottom = bottom - bottomSheetBodySize.height;
                });
              },
              onVerticalDragUpdate: (d) {
                setState(() {
                  current = end + (start - d.globalPosition.dy);
                  if (current > bottomSheetBodySize.height || current < 0) {
                    bodyBottom = bottom - bottomSheetBodySize.height;
                  } else {
                    bottom = current;
                    bodyBottom = bottom - bottomSheetBodySize.height;
                  }
                });
              },
              onVerticalDragEnd: (d) {
                setState(() {
                  if (bottom - end >= 50) {
                    bottom = bottomSheetBodySize.height;
                    bodyBottom = bottom - bottomSheetBodySize.height;

                    end = bottom;
                  } else if (bottom - end <= -50) {
                    bottom = 0;
                    bodyBottom = bottom - bottomSheetBodySize.height;

                    end = bottom;
                  } else {
                    bottom = end;
                    bodyBottom = bottom - bottomSheetBodySize.height;
                  }
                });
              },
              child: Container(
                  color: Colors.white,
                  alignment: Alignment.topRight,
                  ///////////// body
                  key: bottomSheetBodyKey,
                  child: widget.bodyBottomSheet),
            ),
            duration: mill000Second)
      ],
    );
  }
}

class AdCard extends StatelessWidget {
  AdModel adModel;
  bool favourite;
  UserService user;
  bool fav;
  bool mine;
  AdCard({this.favourite, this.fav, this.user, this.mine, this.adModel});
  GlobalKey card = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 120,
      margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
      child: MaterialButton(
        splashColor: primaryAccent.withOpacity(0.2),
        padding: EdgeInsets.all(0),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        // height: 120,
        onPressed: ()async {
          mine!=null?
 Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MyAd(
                        adModel: adModel,
                        user: user,
                        fromFav: fav != null ? true : null,
                      ))):
               Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AdPage(
                        adModel: adModel,
                        user: user,
                        fromFav: fav != null ? true : null,
                      )));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // image
            favourite != null
                ? Container(
                    padding: EdgeInsets.only(top: 10, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      ],
                    ),
                  )
                : SizedBox(),
            //
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      children: <Widget>[
                        Text(adModel.title,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                color: blackAccent,
                                fontSize: 15,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Wrap(
                              children: <Widget>[
                                Text(adModel.city.name,
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: blackAccent,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.location_on,
                          color: primary,
                          size: 20,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: bloc.size().width-60,
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        children: <Widget>[
                          Text(adModel.published,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  color: hint,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(
                      left: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    width: 100,
                    // height: 100,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            child: FadeInImage(
                                placeholder:
                                    AssetImage('assets/images/placeholder.gif'),
                                image: NetworkImage(
                                  adModel.images[0],
                                ),
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill),
                          ),
                        ),
                        Positioned(
                          right: 3,
                          bottom: 3,
                          child: Container(
                            width: 35,
                            height: 18,
                            child: Image.asset('assets/images/logomarker.png'),
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BumbiIconButton extends StatelessWidget {
  Function onPressed;
  IconData iconData;
  Widget child;
  Color color;
  Color iconColor;
  double width;
  BumbiIconButton(
      {this.iconData,
      this.iconColor,
      this.child,
      this.color,
      this.onPressed,
      this.width});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      highlightColor: primaryAccent.withOpacity(.2),
      splashColor: Colors.red[100],
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: color != null ? color : primaryAccent,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: child != null
            ? child
            : Icon(
                iconData,
                color: iconColor ?? primary,
                size: width != null ? width : 22,
              ),
      ),
    );
  }
}

////////////// adOwner
class AdOwner extends StatelessWidget {
  bool here;
  UserService user;
  AdOwner({this.user,this.here});
  _launchCaller(String mobile) async {
    String url = "tel:$mobile";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("e");
    }
  }

  _whatsAppOpen(String mobile) async {
    var whatsappUrl = "whatsapp://send?phone=$mobile";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      print("e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // image
          //
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Wrap(
                    children: <Widget>[
                      Text(user.username ?? "",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              color: blackAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RatingBar(
                    onRatingUpdate: (r) {},
                    glow: false,
                    itemCount: 5,
                    itemBuilder: (context, s) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    initialRating:
                        double.tryParse(user.total_rating.toString()) ?? 0,
                    allowHalfRating: true,
                    direction: Axis.horizontal,
                    itemSize: 15,
                    ignoreGestures: true,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Wrap(
                            children: <Widget>[
                              Text(user.city != null ? user.city.name : "",
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: blackAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.location_on,
                        color: primary,
                        size: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await _whatsAppOpen(user.mobile);
                          },
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            height: 35,
                            child: Image.asset('assets/images/whatsapp.png'),
                            decoration: BoxDecoration(
                                color: primaryAccent
                                    .withOpacity(0.2), //Color(0xff0926B840),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await _launchCaller(user.mobile);
                          },
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            height: 35,
                            child: Image.asset('assets/images/call.png'),
                            decoration: BoxDecoration(
                                color: primaryAccent
                                    .withOpacity(0.2), //Color(0xff0926B840),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(
                    left: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  width: 120,
                  height: 130,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        onTap: () {
                          if (here==null){
                          if(bloc.currentUser()!=null){
                          if(user.id==bloc.currentUser().id)
                                                      Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Profile()));
                              else
                                                        Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProviderPage(user: user)));


                          }else
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProviderPage(user: user)));
                          }  },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          width: 120,
                          height: 130,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            child: FadeInImage(
                              placeholder:
                                  AssetImage('assets/images/placeholder.gif'),
                              image: NetworkImage(user.image),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 3,
                        bottom: 3,
                        child: Container(
                          width: 35,
                          height: 18,
                          child: Image.asset('assets/images/logomarker.png'),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
