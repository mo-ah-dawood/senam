import 'package:chewie/chewie.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/adModel.dart';
import 'package:senam/models/userModel.dart';
import 'package:senam/screens/home/home.dart';
import 'package:senam/screens/home/providerPage.dart';
import 'package:senam/screens/home/report.dart';
import 'package:senam/screens/home/video.dart';
import 'package:senam/screens/login&signUp/login.dart';
import 'package:senam/screens/more/fav.dart';
import 'package:video_player/video_player.dart';

class AdPage extends StatefulWidget {
  AdModel adModel;
  UserService user;
  bool fromFav;
  AdPage({this.adModel, this.user, this.fromFav});

  @override
  _AdPageState createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
  initState() {
    ad = widget.adModel;
    setModel();
    fav = ad.is_favourite == true ? true : false;

    super.initState();
  }


  AdModel ad;
  setModel() async {
    AdModel model = await getSingleAd(widget.adModel.id);
    setState(() {
      if (model != null) ad = model;
      fav = ad.is_favourite;
    });
  }

  List<Marker> markers = [];
  void creatMarker(context) {
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    BitmapDescriptor.fromAssetImage(configuration, 'assets/images/marker.png')
        .then((icon) {
      setState(() {
        customIcon = icon;
      });
    });
  }

  GoogleMapController mapController;
  BitmapDescriptor customIcon;
  void onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  bool fav;
  bool tap = true;
  bool create = true;

  @override
  Widget build(BuildContext context) {
    if (create) {
      creatMarker(context);

      double.tryParse(ad.lat) != null
          ? markers.add(Marker(
              infoWindow: InfoWindow(title: "الموقع الجغرافي"),
              markerId: MarkerId("1"),
              position: LatLng(double.parse(ad.lat), double.parse(ad.lng)),
              icon: customIcon,
              draggable: false))
          : true;
      setState(() {
        create = false;
      });
    }
    return WillPopScope(
      onWillPop: () {
        if (widget.fromFav != null) {
          Navigator.of(context).pop(Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Favourites())));
        } else
          Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
        key: scaffold,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: backGround,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      onTap: tap
                          ? () async {
                              setState(() {
                                tap = false;
                              });
                              var r = await addToFavourite(ad.id);
                              // if( bloc.dataSearchedCount()!=null)
                              //   await search();
                              //   else
                              //   {
                              //   await getHomeData();
                              //   }

                              if (r == true)
                                scaffold.currentState.showSnackBar(SnackBar(
                                    content: Text(
                                  "تمت إضافة الإعلان إلى المفضلة",
                                  textAlign: TextAlign.end,
                                )));
                              else if (r == false)
                                scaffold.currentState.showSnackBar(SnackBar(
                                    content: Text(
                                  "تمت حذف الإعلان من المفضلة",
                                  textAlign: TextAlign.end,
                                )));
                              else if (r == 401) {
                                await clearUserData();

                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              } else
                                scaffold.currentState.showSnackBar(
                                    SnackBar(content: Text(r.toString())));
                                                                  setState(() {
                                fav = r;
                                tap = true;
                              });

                            }
                          : null,
                      child: fav == true
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.grey,
                            ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      onTap: () {
                        scaffold.currentState
                            .showBottomSheet((context) => Report(
                                  id: ad.id,
                                ));
                      },
                      child: Icon(
                        Icons.report,
                        color: primary,
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white),
                  )
                ],
              ),
              Spacer(),
              SmallIconButton(
                onPressed: () {
                  if (widget.fromFav != null) {
                    Navigator.of(context).pop(Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(
                            builder: (context) => Favourites())));
                  } else
                    Navigator.of(context).pop();
                },
                icon: Icons.arrow_forward_ios,
              ),
            ],
          ),
        ),
        //////////////////////////////////// body /////////////////////////////
        body: Container(
          width: bloc.size().width,
          height: bloc.size().height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 10, left: 20),
                  child: Wrap(
                    children: <Widget>[
                      Text(
                        ad.title,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 26,
                            color: primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Wrap(
                    children: <Widget>[
                      Text(
                        
                        "${ad.parent_category.name} , ${ad.category.name}",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 5),
                  child: Wrap(
                    children: <Widget>[
                      Text(
                        "الوصف",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            color: hint,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    children: <Widget>[
                      Text(
                        "${ad.note}", // bloc.staticData().about,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ), ////////////////////////////////////
                SizedBox(
                  height: 5,
                ),

                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      )),
                  child: Column(
                    //////////////////////////////////////////////
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                            children: ad.images != null
                                ? List.generate(ad.images.length, (int i) {
                                    return AdImage(
                                      imageUrl: ad.images[i],
                                    );
                                  })
                                : []),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                            children: ad.videos != null
                                ? List.generate(ad.videos.length,
                                    (int i) {
                                    return AdVideo(controller: VideoPlayerController.network(ad.videos[i]));
                                    // SenamVideoPlayer(
                                    //   videoUrl: ad.videos[i],
                                    //   width: bloc.size().width,
                                    //   height: 300,
                                      
                                    // );
                                  })
                                : []),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Wrap(
                          children: <Widget>[
                            Text(
                              "العنوان",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  color: hint,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: double.tryParse(ad.lat) != null &&
                                double.tryParse(ad.lng) != null
                            ? Container(
                                width: bloc.size().width,
                                height: 200,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  child: GoogleMap(
                                    zoomGesturesEnabled: false,
                                    rotateGesturesEnabled: false,
                                    scrollGesturesEnabled: false,
                                    mapToolbarEnabled: false,
                                    trafficEnabled: false,
                                    tiltGesturesEnabled: false,
                                    onMapCreated: onMapCreated,
                                    markers: Set.from(markers),
                                    initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                                double.tryParse(ad.lat) ?? 0,
                                                double.tryParse(ad.lng)) ??
                                            0,
                                        zoom: 13),
                                    mapType: MapType.terrain,
                                  ),
                                ))
                            : SizedBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Wrap(
                          children: <Widget>[
                            Text(
                              "بيانات صاحب الإعلان",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  color: hint,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: AdOwner(
                          user: widget.user ?? ad.user,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        color: Colors.white,
                        child: Container(
                          width: bloc.size().width,
                          decoration: BoxDecoration(
                              color: backGround,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, right: 20),
                                child: Wrap(
                                  children: <Widget>[
                                    Text(
                                      "إعلانات مشابهة",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          color: hint,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                width: bloc.size().width,
                                height: 120,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    reverse: true,
                                    children: ad.similar_ads != null
                                        ? List.generate(ad.similar_ads.length,
                                            (i) {
                                            return Column(
                                              children: <Widget>[
                                                Container(
                                                  width: bloc.size().width - 60,
                                                  child: AdCard(
                                                      adModel: ad.similar_ads[i]),
                                                ),
                                              ],
                                            );
                                          })
                                        : <Widget>[]),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ), /////////////////////////////////////////////////
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdImage extends StatelessWidget {
  String imageUrl;
  AdImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: bloc.size().width,
      height: 150,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: FadeInImage(
                placeholder: AssetImage('assets/images/placeholder.gif'),
                image: NetworkImage(imageUrl),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Image.asset(
              "assets/images/logomarke.png",
              width: 60,
              height: 30,
            ),
          )
        ],
      ),
    );
  }
}

class AdVideo extends StatefulWidget {
  final VideoPlayerController controller;
  final bool looping;
  AdVideo({@required this.controller, this.looping});

  @override
  _AdVideoState createState() => _AdVideoState();
}

class _AdVideoState extends State<AdVideo> {
  ChewieController _controller;
  initState() {
    _controller = ChewieController(
      autoPlay: false,
      videoPlayerController: widget.controller,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      looping: widget.looping,
      errorBuilder: (context, msg) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            color: Colors.black,
            child: Text(
              msg,
              overflow: TextOverflow.visible,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool viewBtton;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: bloc.size().width,
      height: 180,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Chewie(
              controller: _controller,
            ),
          ),
        ],
      ),
    );
  }
}
