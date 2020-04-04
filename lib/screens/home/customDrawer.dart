import 'package:flutter/material.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/models/userModel.dart';
import 'package:senam/screens/addAds.dart';
import 'package:senam/screens/article.dart';
import 'package:senam/screens/home/pleaseSignUp.dart';
import 'package:senam/screens/home/profile.dart';
import 'package:senam/screens/home/video.dart';
import 'package:senam/screens/login&signUp/login.dart';
import 'package:senam/screens/login&signUp/splach.dart';
import 'package:senam/screens/more/about.dart';
import 'package:senam/screens/more/commision.dart';
import 'package:senam/screens/more/contact.dart';
import 'package:senam/screens/more/fav.dart';
import 'package:senam/screens/notifications.dart';
const String apiUrl="https://snam.sa/api/v1";

class CustomDrawer extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffold;
  CustomDrawer({this.scaffold});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        height: bloc.size().height,
        constraints: BoxConstraints(
          maxWidth: bloc.size().width,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50))),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                      Container(
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(colors: [primaryAccent, primary]),
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      minWidth: 20,
                      padding: EdgeInsets.all(0),
                      splashColor: primaryAccent,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  MaterialButton(
                      padding: EdgeInsets.all(0),
                      splashColor: primaryAccent,
                      onPressed: () {

                        bloc.currentUser()!=null?Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Profile())):
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => PleaseSignUp(
                                  grey: true,
                                ));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth: bloc.size().width / 2.3),
                                child: Wrap(
                                  children: <Widget>[
                                    Text(
                                     bloc.currentUser()!=null?bloc.currentUser().username: "الملف الشخصي",
                                      textDirection: TextDirection.rtl,
                                      maxLines: 2,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                         bloc.currentUser()!=null?     Container(
                                margin: EdgeInsets.only(top: 6),
                                constraints: BoxConstraints(
                                    maxWidth: bloc.size().width / 2.3 ),
                                child: Wrap(
                                  
                                  children: <Widget>[
                                   Text(
                                   bloc.currentUser()!=null?bloc.currentUser().mobile:   "",
                                      textDirection: TextDirection.ltr,
                                      
                                      maxLines: 2,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                        
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ):SizedBox(),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(17)),
                            ),
                            width: 72,
                            height: 82,
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(13)),
                                child:bloc.currentUser()!=null? FadeInImage(
                            placeholder:
                                AssetImage('assets/images/placeholder.gif'),
                            image: NetworkImage(bloc.currentUser().image),
                            fit: BoxFit.fill,
                          ):Image.asset(
                                  'assets/images/avatar.png',
                                  fit: BoxFit.fill,
                                )),
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      )),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: bloc.size().width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [primaryAccent, primary]),
                    borderRadius: BorderRadius.only()),
                constraints: BoxConstraints(
                ),
                child: SingleChildScrollView(
                  child: Container(
                    width: bloc.size().width / 1.5,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                    bloc.currentUser()!=null?    MaterialButton(
                          padding: EdgeInsets.all(0),
                          splashColor: primaryAccent,
                          onPressed: () {
                             Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Notifications()));
                               
                          },
                          child: ListTile(
                            trailing: Image.asset(
                              "assets/images/notification.png",
                              width: 50,
                              height: 50,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "الإشعارات",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ):SizedBox(),
                     bloc.currentUser()!=null?   MaterialButton(
                          padding: EdgeInsets.all(0),
                          splashColor: primaryAccent,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Favourites()));
                               
                          },
                          child: ListTile(
                            trailing: Image.asset(
                              "assets/images/fav.png",
                              width: 50,
                              height: 50,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "المفضلة",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ):SizedBox(),
                      MaterialButton(
                          padding: EdgeInsets.all(0),
                          splashColor: primaryAccent,
                          onPressed: () {
                           bloc.currentUser()!=null?
                             Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddAds())):
                                    showModalBottomSheet(
                            context: context,
                            builder: (context) => PleaseSignUp(
                                  grey: true,
                                ));
                               
                          },
                          child: ListTile(
                            trailing: Image.asset(
                              "assets/images/add.png",
                              width: 50,
                              height: 50,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "إضافة إعلان",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                       MaterialButton(
                          padding: EdgeInsets.all(0),
                          splashColor: primaryAccent,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Article(
                                      title: "الإبل في القرآن",
                                      articleURL:
                                          "$apiUrl/page/quran",
                                    )));
                          },
                          child: ListTile(
                            trailing: Image.asset(
                              "assets/images/quran.png",
                              width: 50,
                              height: 50,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "الإبل في القرآن",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        MaterialButton(
                          padding: EdgeInsets.all(0),
                          splashColor: primaryAccent,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Article(
                                      title: "الإبل في الحديث",
                                      articleURL:
                                          "$apiUrl/page/hadeth",
                                    )));
                          },
                          child: ListTile(
                            trailing: Image.asset(
                              "assets/images/hadeth.png",
                              width: 50,
                              height: 50,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "الإبل في الحديث",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        MaterialButton(
                          padding: EdgeInsets.all(0),
                          splashColor: primaryAccent,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Article(
                                      title: "ما قيل في الإبل",
                                      articleURL:
                                          "$apiUrl/page/talk_about",
                                    )));
                          },
                          child: ListTile(
                            trailing: Image.asset(
                              "assets/images/inkwell.png",
                              width: 50,
                              height: 50,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "ما قيل في الإبل",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        MaterialButton(
                          padding: EdgeInsets.all(0),
                          splashColor: primaryAccent,
                          onPressed: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => About()));
                          },
                          child: ListTile(
                            trailing: Image.asset(
                              "assets/images/aboutus.png",
                              width: 50,
                              height: 50,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "عن التطبيق",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        MaterialButton(
                          padding: EdgeInsets.all(0),
                          splashColor: primaryAccent,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Commision()));
                          },
                          child: ListTile(
                            trailing: Image.asset(
                              "assets/images/commission.png",
                              width: 50,
                              height: 50,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "حساب العمولة",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        MaterialButton(
                          padding: EdgeInsets.all(0),
                          splashColor: primaryAccent,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Article(
                                      title: "إعلانات ممنوعة",
                                      articleURL: "$apiUrl/page/block",
                                    )));
                          },
                          child: ListTile(
                            trailing: Image.asset(
                              "assets/images/unallowed.png",
                              width: 50,
                              height: 50,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "إعلانات ممنوعة",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        MaterialButton(
                          padding: EdgeInsets.all(0),
                          splashColor: primaryAccent,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Article(
                                      title: "الشروط والأحكام",
                                      articleURL: "$apiUrl/page/licence",
                                    )));
                          },
                          child: ListTile(
                            trailing: Image.asset(
                              "assets/images/terms.png",
                              width: 50,
                              height: 50,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "الشروط والأحكام",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                     MaterialButton(
                          padding: EdgeInsets.all(0),
                          splashColor: primaryAccent,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Contact()));
                          },
                          child: ListTile(
                            trailing: Image.asset(
                              "assets/images/contactus.png",
                              width: 50,
                              height: 50,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "تواصل معنا",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        MaterialButton(
                          padding: EdgeInsets.all(0),
                          splashColor: primaryAccent,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Article(
                                      title: "فعاليات ومهرجانات",
                                      articleURL: "$apiUrl/page/festival",
                                    )));
                          },
                          child: ListTile(
                            trailing: Image.asset(
                              "assets/images/festival.png",
                              width: 50,
                              height: 50,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "فعاليات ومهرجانات",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
                  ],
                ),
              ),
            ),
          
            Container(
              width: bloc.size().width,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: bloc.currentUser()==null
                  ? MaterialButton(
                      padding: EdgeInsets.all(0),
                      splashColor: primaryAccent.withOpacity(0.2),
                      onPressed: () {

                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: ListTile(
                        trailing: Image.asset(
                          "assets/images/login.png",
                          width: 50,
                          height: 50,
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "تسجيل دخول",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )
                  : MaterialButton(
                      padding: EdgeInsets.all(0),
                      splashColor: primaryAccent.withOpacity(0.2),
                      onPressed: ()async {

                        await logOutService();
                        await clearUserData();
                                          bloc.onsearchingChange(false);
              bloc.onHomeSearchedAdCardsChange(null);
              bloc.onCTypeChange(null);
              bloc.selectcityIdFilter(null);
              bloc.selectcSortityFilter(null);
              bloc.onDataSearchedCountChange(null); ///////
              bloc.onCSubTypeChange(null);
              bloc.onDataSearchedCountChange(null);

                        bloc.sendNewUser(null);
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Splach()));
                      },
                      child: ListTile(
                        trailing: Image.asset(
                          "assets/images/logout.png",
                          width: 50,
                          height: 50,
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "تسجيل خروج",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
