import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/adModel.dart';
import 'package:senam/models/userModel.dart';
import 'package:senam/screens/addAds.dart';
import 'package:senam/screens/home/adPage.dart';
import 'package:senam/screens/home/providerPage.dart';
import 'package:senam/screens/home/report.dart';
import 'package:senam/screens/home/video.dart';
import 'package:senam/screens/more/fav.dart';
import 'package:video_player/video_player.dart';

class MyAd extends StatefulWidget {
  AdModel adModel;
  bool fromFav;
  UserService user;
  MyAd({this.adModel, this.user, this.fromFav});

  @override
  _MyAdState createState() => _MyAdState();
}

class _MyAdState extends State<MyAd> {
  initState() {
    ad = widget.adModel;
    setModel();
    super.initState();
  }

  bool loading = false;
  AdModel ad;
  setModel() async {
    AdModel model = await getSingleAd(widget.adModel.id);
    setState(() {
      if (model != null) ad = model;
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
  bool fav = false;
  @override
  Widget build(BuildContext context) {
    creatMarker(context);
    if (double.tryParse(ad.lat) != null)
      markers.add(Marker(
          infoWindow: InfoWindow(title: "الموقع الجغرافي"),
          markerId: MarkerId("1"),
          position: LatLng(double.tryParse(ad.lat), double.tryParse(ad.lng)),
          icon: customIcon,
          draggable: false));

    return WillPopScope(
      onWillPop: () async {
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
              Container(
                width: 40,
                height: 40,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  onTap: () async {
                    var alrt = AlertDialog(
                      title: Text("هل تريد حذف هذا الإعلان ؟",textDirection: TextDirection.rtl,),
                      actions: <Widget>[
                        FlatButton(onPressed: ()async {
                                              setState(() {
                      loading = true;
                    });
                    await deletAd(widget.adModel.id);

                    setState(() {
                      loading = false;
                    });
                    Navigator.of(context).pop(Navigator.of(context).pop(Navigator.of(context).pop()));

                        }, child: Text("نعم")),
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("لا"))
                      ],
                    );
await showDialog(context: context,builder: (context)=>alrt);
                  },
                  child: Icon(
                    Icons.delete,
                    color: primary,
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white),
              ),
              Spacer(),
              SmallIconButton(
                onPressed: () {
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
          child: Stack(
            children: <Widget>[
              Container(
                width: bloc.size().width,
                height: bloc.size().height,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 20, top: 10, left: 20),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
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
                            ad.images.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                        children: List.generate(
                                            ad.images.length, (int i) {
                                      return AdImage(
                                        imageUrl: ad.images[i],
                                      );
                                    })),
                                  )
                                : SizedBox(),
                            ad.videos != null
                                ? Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                        children: List.generate(
                                            //widget.adModel.videos.length
                                            ad.videos.length, (int i) {
                                      return AdVideo(
                                        controller:VideoPlayerController.network(ad.videos[i]),
                                      );
                                    })))
                                : SizedBox(),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
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
                                                      double.tryParse(ad.lat) ??
                                                          0,
                                                      double.tryParse(
                                                          ad.lng)) ??
                                                  0,
                                              zoom: 13),
                                          mapType: MapType.terrain,
                                        ),
                                      ))
                                  : SizedBox(),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              margin: EdgeInsets.symmetric(vertical: 40),
                              width: bloc.size().width,
                              height: 40,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: BumbiButton(
                                    text: "إلغاء",
                                    colored: false,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: BumbiButton(
                                    text: "تعديل",
                                    colored: true,
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                              builder: (context) => AddAds(
                                                    ad: ad,
                                                  )));
                                    },
                                  ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ), /////////////////////////////////////////////////
                    ],
                  ),
                ),
              ),
              loading ? LoadingFullScreen() : SizedBox()
            ],
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
                )),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Image.asset(
              "assets/images/logomarke.png",
              width: 60,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}
