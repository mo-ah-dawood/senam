import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/adModel.dart';
import 'package:senam/screens/home/video.dart';
import 'package:video_player/video_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';

const String GoogleApiKey = "AIzaSyBpaajYhsHX6V-tnOKK6PAZQssUIDYQbsE";

class AddAds extends StatefulWidget {
  AdModel ad;
  AddAds({this.ad});
  @override
  _AddAdsState createState() => _AddAdsState();
}

class _AddAdsState extends State<AddAds> {
  List<DropdownMenuItem> _dropdownCityItems;
  int _selectedCityValue = 0;
  onChangeDropdownItem(int selectedType) {
    setState(() {
      if (selectedType > 0) {
        _selectedCityValue = selectedType;
        bloc.oncityIdChange(citiesMap.keys.toList()[selectedType - 1]);
      }
    });
  }

  Map<int, String> citiesMap = {};
  viewAdOldImages() {
    if (widget.ad.images != null) {
      Map<int, String> oldImageUrlMap = {};
      Map<int, Widget> oldImageWidgets = {};

      for (int i = 0; i < widget.ad.images.length; i++) {
        oldImageUrlMap[i] = widget.ad.images[i];
        oldImageWidgets[i] = AssetCard(
          imageURL: widget.ad.images[i],
          index: i,
        );
      }
      bloc.onadImagesURLChange(oldImageUrlMap);
      bloc.addNewadImagesWidgets(oldImageWidgets);
    }
  }

  viewAdOldVideos() async {
    if (widget.ad.videos != null) {
      Map<int, Widget> ow = {};
      Map<int, String> ou = {};
      for (int i = 0; i < widget.ad.videos.length; i++) {
        ou[i] = widget.ad.videos[i];
        ow[i] = SenamVideoPlayer(
          videoUrl: widget.ad.videos[i],
          index: i,
        );
      }
      bloc.addNewadVideosWidgets(ow);
      bloc.onadVideosURLChange(ou);
    }
  }

  initState() {
    if (widget.ad != null) {
      bloc.onadNoteChange(widget.ad.note);
      bloc.onadNameChange(widget.ad.title);
      bloc.onChangeaddDressSelesctedSubCats(widget.ad.category.id);
      bloc.onChangeaddDressSelesctedMainCats(widget.ad.parent_category.id);
      bloc.oncityIdChange(widget.ad.city.id);
      bloc.onadImagesURLChange({});
      bloc.addNewadImagesFilesMAp({});
      bloc.addNewadImagesWidgets({});
      bloc.addNewadVideosFilesMAp({});
      bloc.addNewadVideosWidgets({});
      if (double.tryParse(widget.ad.lat) != null)
        bloc.addAdLatlng(LatLng(
            double.tryParse(widget.ad.lat), double.tryParse(widget.ad.lng)));
    } else {
      bloc.onadNoteChange(null);
      bloc.onadNameChange(null);
      bloc.onChangeaddDressSelesctedSubCats(null);
      bloc.onChangeaddDressSelesctedMainCats(null);
      bloc.oncityIdChange(null);
      bloc.onadImagesURLChange({});
      bloc.addNewadImagesFilesMAp({});
      bloc.addNewadImagesWidgets({});
      bloc.addNewadVideosFilesMAp({});
      bloc.addNewadVideosWidgets({});
      bloc.addAdLatlng(null);
    }
    for (int i = 0; i < bloc.citiesList().length; i++) {
      setState(() {
        citiesMap[bloc.citiesList()[i].id] = bloc.citiesList()[i].name;
      });
    }

    bloc.onChangeaddDressSelesctedMainCats(null);
    bloc.onChangeaddDressSelesctedSubCats(null);
    for (int i = 0; i < bloc.homeDatas().categories.length; i++) {
      setState(() {
        mainC[bloc.homeDatas().categories[i].id] =
            bloc.homeDatas().categories[i].name;
      });
    }
    if (widget.ad != null) {
      ///
      if (double.tryParse(widget.ad.lat) != null &&
          double.tryParse(widget.ad.lng) != null)
        bloc.addAdLatlng(
            LatLng(double.parse(widget.ad.lat), double.parse(widget.ad.lng)));

      ///
      for (int i = 0; i < mainC.length; i++) {
        if (mainC.keys.toList()[i] == widget.ad.parent_category.id)
          onChangeMainCategoryItem(i + 1);
      }
      if(bloc.homeDatas()
                    .subCategory[bloc.addDressSelesctedMainCats()].length>0)
      for (int i = 0; i < subC.length; i++)
        if (subC.keys.toList()[i] == widget.ad.category.id) {
          onChangeSubCategoryItem(i + 1);
        }

      ///
      for (int i = 0; i < citiesMap.length; i++) {
        if (widget.ad.city.id == citiesMap.keys.toList()[i])
          onChangeDropdownItem(i + 1);
      }

      setState(() {
        adNameCTL = TextEditingController(text: widget.ad.title);
        adCityCTL = TextEditingController(text: widget.ad.city.name);
        adNoteCTL = TextEditingController(text: widget.ad.note);
      });

    }
    if(widget.ad!=null){
                viewAdOldImages();
    if(widget.ad.videos!=null)
    viewAdOldVideos();

    }

    super.initState();
  }

  Map<int, String> mainC = {};
  bool hasSub=false;
  Map<int, String> subC = {};
  int _selectedMainCategory = 0;
  int _selectedSubCategory = 0;
  onChangeMainCategoryItem(int selectedType) {
    if (selectedType > 0)
      setState(() {
        _selectedMainCategory = selectedType;
        bloc.onChangeaddDressSelesctedMainCats(
            mainC.keys.toList()[selectedType - 1]);
        _selectedSubCategory = 0;
        bloc.onChangeaddDressSelesctedSubCats(null);

       subC = {};
        for (int i = 0;
            i <
                bloc
                    .homeDatas()
                    .subCategory[bloc.addDressSelesctedMainCats()]
                    .length;
            i++) {
          subC[bloc
                  .homeDatas()
                  .subCategory[bloc.addDressSelesctedMainCats()][i]
                  .id] =
              bloc
                  .homeDatas()
                  .subCategory[bloc.addDressSelesctedMainCats()][i]
                  .name;
        }
      if(subC.length>0)
      hasSub=true;
      else{
      hasSub=false;
              bloc.onChangeaddDressSelesctedSubCats(
            null);

      }
      });
  }

  onChangeSubCategoryItem(int selectedType) {
    if (selectedType > 0)
      setState(() {
        _selectedSubCategory = selectedType;
        bloc.onChangeaddDressSelesctedSubCats(
            subC.keys.toList()[selectedType - 1]);
          
      });
  }

  bool viewMap = false;
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

  Future<LatLng> _getUserLocation() async {
    // GeolocationStatus status =
    //     await Geolocator().checkGeolocationPermissionStatus();
    // if (status == GeolocationStatus.granted) {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    return LatLng(position.latitude, position.longitude);
    // }
    // return null;
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void moveOnMap(LatLng position) {
    setState(() {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 13)));
    });
  }

  List<DropdownMenuItem> _cityMenuItems;

  int _selectedCity = 0;
  onChangeCity(int selectedType) {
    setState(() {
      _selectedCity = selectedType;
      moveOnMap(LatLng(saudiaCities.values.toList()[selectedType - 1]['lat'],
          saudiaCities.values.toList()[selectedType - 1]['lng']));
    });
  }

  File _image;
  File _cropped;
  VideoPlayerController _videoPlayerController;
  File _video;
  GlobalKey<ScaffoldState> scaffold = GlobalKey();

  Future getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);

    setState(() {
      _image = image;
    });
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.type == RetrieveType.video) {
          // _handleVideo(response.file);
        } else {
          setState(() {
            _image = response.file;
          });
        }
      });
    } else {
      print(response.exception);
    }
  }

  Future cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: "حدد الجزء المراد عرضه",
            toolbarColor: Colors.white,
            toolbarWidgetColor: primary,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      _cropped = croppedFile;
    });
  }

  picImage() async {
    adNote.unfocus();
    adName.unfocus();

    Map<int, File> oldImageFileMap = bloc.adImagesFilesMap();
    Map<int, Widget> oldImageWidgets = bloc.adImagesWidgets();

    int index;
    if (bloc.adImagesURL() != null) {
        index = bloc.adImagesURL().length+bloc.adImagesFilesMap().length;
    } else
      index = bloc.adImagesFilesMap().length == 0
          ? 0
          : bloc.adImagesFilesMap().keys.toList().last + 4;

    scaffold.currentState.showSnackBar(SnackBar(
        content: Container(
      alignment: Alignment.center,
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              BumbiIconButton(
                iconColor: Colors.white,
                iconData: Icons.linked_camera,
                onPressed: () async {
                  setState(() {
                    _cropped = null;
                    _image = null;
                  });
                  await getImage(ImageSource.camera);
                  // await retrieveLostData();
                  if (_image != null) {
                    await cropImage(_image);
                    if (_cropped != null) {
                      oldImageFileMap[index] = _cropped;
                      await bloc.addNewadImagesFilesMAp(oldImageFileMap);
                      oldImageWidgets[index] = AssetCard(
                        file: bloc.adImagesFilesMap()[index],
                        index: index,
                      );
                      bloc.addNewadImagesWidgets(oldImageWidgets);
                    }
                  }
                },
              ),
              Text("بواسطة الكاميرا"),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: VerticalDivider(
              color: hint,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              BumbiIconButton(
                iconColor: Colors.white,
                iconData: Icons.image,
                onPressed: () async {
                  setState(() {
                    _cropped = null;
                    _image = null;
                  });

                  await getImage(ImageSource.gallery);
                  await retrieveLostData();
                  if (_image != null) {
                    await cropImage(_image);
                    if (_cropped != null) {
                      oldImageFileMap[index] = _cropped;
                      await bloc.addNewadImagesFilesMAp(oldImageFileMap);
                      oldImageWidgets[index] = AssetCard(
                        file: bloc.adImagesFilesMap()[index],
                        index: index,
                      );
                      bloc.addNewadImagesWidgets(oldImageWidgets);
                    }
                  }
                },
              ),
              Text("من المعرض"),
            ],
          )
        ],
      ),
    )));
  }

  pickVideo() async {
    adNote.unfocus();
    adName.unfocus();

    Map<int, File> oldVideoFileMap = bloc.adVideosFilesMap();
    Map<int, Widget> oldVideoWidgets = bloc.adVideosWidgets();
    int index;
        if (bloc.adVideosURL() != null) {
        index = bloc.adVideosURL().length+bloc.adVideosFilesMap().length;
    } else
      index = bloc.adVideosFilesMap().length == 0
          ? 0
          : bloc.adVideosFilesMap().keys.toList().last + 4;

    scaffold.currentState.showSnackBar(SnackBar(
        content: Container(
      alignment: Alignment.center,
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              BumbiIconButton(
                iconColor: Colors.white,
                iconData: Icons.linked_camera,
                onPressed: () async {
                  setState(() {
                    _video = null;
                  });

                  File video =
                      await ImagePicker.pickVideo(source: ImageSource.camera);
                  if (video != null) {
                    if (video.lengthSync() <= 5242880) {
                      setState(() {
                        _video = video;
                        _videoPlayerController =
                            VideoPlayerController.file(_video);
                      });

                      oldVideoFileMap[index] = _video;
                      await bloc.addNewadVideosFilesMAp(oldVideoFileMap);
                      oldVideoWidgets[index] = SenamVideoPlayer(
                        // width: 100,
                        // height: 110,
                        file: bloc.adVideosFilesMap()[index],
                        index: index,
                      );
                      bloc.addNewadVideosWidgets(oldVideoWidgets);
                    } else
                      scaffold.currentState.showSnackBar(SnackBar(
                        content: Text("حجم الفيديو يجب أن لا يزيد عن 5 ميجا"),
                      ));
                  }
                },
              ),
              Text("بواسطة الكاميرا"),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: VerticalDivider(
              color: hint,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              BumbiIconButton(
                iconColor: Colors.white,
                iconData: Icons.image,
                onPressed: () async {
                  setState(() {
                    _video = null;
                  });

                  File video =
                      await ImagePicker.pickVideo(source: ImageSource.gallery);
                  if (video != null) {
                    if (video.lengthSync() <= 5242880) {
                      setState(() {
                        _video = video;
                        _videoPlayerController =
                            VideoPlayerController.file(_video);
                      });
                      oldVideoFileMap[index] = _video;
                      await bloc.addNewadVideosFilesMAp(oldVideoFileMap);
                      oldVideoWidgets[index] = SenamVideoPlayer(
                        width: 100,
                        height: 110,
                        file: bloc.adVideosFilesMap()[index],
                        index: index,
                      );
                      bloc.addNewadVideosWidgets(oldVideoWidgets);
                    } else
                      scaffold.currentState.showSnackBar(SnackBar(
                        content: Text("حجم الفيديو يجب أن لا يزيد عن 5 ميجا"),
                      ));
                  }
                },
              ),
              Text("من المعرض"),
            ],
          )
        ],
      ),
    )));
  }

  bool validate = false;
  bool empty = false;
  bool loading = false;
  List<DropdownMenuItem> _mainCategoriesMenuItems;
  List<DropdownMenuItem> _subCategoriesMenuItems;

  List<DropdownMenuItem> buildDropdownMenuItems(List typs, int selectedValue) {
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
                    fontSize: 15,
                    color: i == 0 ? hint : blackAccent,
                    fontWeight: selectedValue == i && i != 0
                        ? FontWeight.bold
                        : FontWeight.w500),
              )),
        ),
      );
    }
    return items;
  }

  bool agreed = false;
  bool rulesError = false;
  FocusNode adName = FocusNode();
  FocusNode adCity = FocusNode();
  FocusNode adNote = FocusNode();
  TextEditingController adNameCTL = TextEditingController();
  TextEditingController adCityCTL = TextEditingController();
  TextEditingController adNoteCTL = TextEditingController();
  @override
  Widget build(BuildContext context) {
    creatMarker(context);
    List<String> city = ["المدينة"]..addAll(citiesMap.values.toList());
    List<String> main = ["التصنيف الرئيسي"]..addAll(mainC.values.toList());
    List<String> sub = ["التصنيف الفرعي"]..addAll(subC.values.toList());
    List<String> cities = ["المدينة"]..addAll(saudiaCities.keys.toList());

    setState(() {
      _mainCategoriesMenuItems =
          buildDropdownMenuItems(main, _selectedMainCategory);
      _subCategoriesMenuItems =
          buildDropdownMenuItems(sub, _selectedSubCategory);
      _cityMenuItems = buildDropdownMenuItems(cities, _selectedCity);
      _dropdownCityItems = buildDropdownMenuItems(city, _selectedCityValue);
    });

    return Scaffold(
      key: scaffold,
      body: Container(
        width: bloc.size().width,
        height: bloc.size().height,
        child: Stack(
          children: <Widget>[
            Container(
                width: bloc.size().width,
                height: bloc.size().height,
                child: GestureDetector(
                  onTap: () {
                    adCity.unfocus();
                    adName.unfocus();
                    adNote.unfocus();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              widget.ad != null
                                  ? "تعديل الإعلان"
                                  : "إضافة إعلان",
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
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Wrap(
                          children: <Widget>[
                            Text(
                              "أضف بيانات إعلانك",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            // named field
                            StreamBuilder<String>(
                              stream: validate ? bloc.adNameStream : null,
                              builder: (context, s) => AtelierTextField(
                                controller: adNameCTL,
                                value: empty ? bloc.adName() : "",
                                error: s.hasError ||
                                        (empty &&
                                            (bloc.adName() == null ||
                                                bloc.adName().length < 1))
                                    ? "الاسم لا يمكن أن يكون فارغاً"
                                    : null,
                                unFocus: () {
                                  setState(() {
                                    adNote.unfocus();
                                    adCity.unfocus();
                                    FocusScope.of(context).requestFocus(adName);
                                  });
                                },
                                password: false,
                                focusNode: adName,
                                label: "اسم الإعلان",
                                onChanged: bloc.onadNameChange,
                              ),
                            ),
                            StreamBuilder(
                              stream: bloc.addDressSelesctedMainCatStream,
                              builder: (context, s) => Container(
//                           //نوع التواصل
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                margin: EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                    border: empty && !s.hasData
                                        ? Border.all(color: Colors.red)
                                        : null,
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
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
                                        value: _selectedMainCategory,
                                        items: _mainCategoriesMenuItems,
                                        onChanged: (v) {
                                          onChangeMainCategoryItem(v);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            StreamBuilder(
                              stream: bloc.addDressSelesctedSubCatStream,
                              builder: (context, ss) =>hasSub? Container(
//                           //نوع التواصل
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                margin: EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                    border: empty && !ss.hasData
                                        ? Border.all(color: Colors.red)
                                        : null,
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
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
                                        value: _selectedSubCategory,
                                        items: _subCategoriesMenuItems,
                                        onChanged: (v) {
                                          onChangeSubCategoryItem(v);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ):SizedBox(),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            //
                            // named field
                            StreamBuilder(
                              stream: bloc.cityStream,
                              builder: (context, cc) => Container(
//                           //نوع التواصل
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                margin: EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                    border: empty && !cc.hasData
                                        ? Border.all(color: Colors.red)
                                        : null,
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
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
                                        value: _selectedCityValue,
                                        items: _dropdownCityItems,
                                        onChanged: (v) {
                                          onChangeDropdownItem(v);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),

                            StreamBuilder<String>(
                              stream: validate ? bloc.adNoteStream : null,
                              builder: (context, s) => AtelierTextField(
                                controller: adNoteCTL,
                                value: empty ? bloc.adNote() : "",
                                error: s.hasError ||
                                        (empty &&
                                            (bloc.adNote() == null ||
                                                bloc.adNote().length < 1))
                                    ? "الوصف لا يمكن أن يكون فارغاً"
                                    : null,
                                unFocus: () {
                                  setState(() {
                                    adName.unfocus();
                                    adCity.unfocus();
                                    FocusScope.of(context).requestFocus(adNote);
                                  });
                                },
                                password: false,
                                focusNode: adNote,
                                label: "تفاصيل الإعلان",
                                descrip: true,
                                onChanged: bloc.onadNoteChange,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "الصور",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: hint,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            StreamBuilder<Map<int, Widget>>(
                              stream: bloc.adImagesWidgetStream,
                              initialData: {},
                              builder: (context, w) => Container(
                                width: bloc.size().width,
                                height: w.data.length == 0 ? 0 : 120,
                                child: ListView(
                                  reverse: true,
                                  scrollDirection: Axis.horizontal,
                                  children: w.data.values.toList(),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  border: (empty &&
                                          (bloc.adImagesFilesMap().length > 0 ||
                                              bloc.adImagesURL().length > 0))
                                      ? null
                                      : Border.all(
                                          color: empty
                                              ? Colors.red
                                              : Colors.transparent)),
                              child: addAssetButton(
                                  onPressed: picImage, text: "إضافة صورة"),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "الفيديو  ( إختياري )",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: hint,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            StreamBuilder<Map<int, Widget>>(
                              stream: bloc.adVideosWidgetStream,
                              initialData: {},
                              builder: (context, w) => Container(
                                width: bloc.size().width,
                                height: w.data.length == 0 ? 0 : 120,
                                child: ListView(
                                  reverse: true,
                                  scrollDirection: Axis.horizontal,
                                  children: w.data.values.toList(),
                                ),
                              ),
                            ),
                            addAssetButton(
                                onPressed: pickVideo, text: "إضافة فيديو"),
                            StreamBuilder(
                              stream: bloc.adLatlngtStream,
                              builder: (context, s) => s.hasData
                                  ? viewMap
                                      ? SizedBox()
                                      : Container(
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
                                              initialCameraPosition:
                                                  CameraPosition(
                                                      target: s.data, zoom: 15),
                                              mapType: MapType.terrain,
                                            ),
                                          ))
                                  : Container(),
                            ),
                            addAssetButton(
                                onPressed: () {
                                  setState(() {
                                    viewMap = true;
                                  });
                                },
                                text: "إضافة موقع جغرافي  ( إختياري )"),

                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: bloc.size().width,
                              height: 40,
                              child: widget.ad != null
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: BumbiButton(
                                            colored: false,
                                            text: "إلغاء",
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        StreamBuilder<Object>(
                                            stream:
                                                bloc.combineEditProfileFields,
                                            builder: (context, snapshot) {
                                              return Expanded(
                                                child: BumbiButton(
                                                  colored: true,
                                                  text: "تعديل",
                                                  onPressed: () async {
                                                    setState(() {
                                                      validate = true;
                                                    });
                                                    if (bloc.adName() == null ||
                                                        bloc.adNote() == null ||
                                                        bloc.adNote().length <
                                                            1 ||
                                                        bloc.adName().length <
                                                            1 ||
                                                        bloc.cityId() == null ||
                                                        bloc.addDressSelesctedMainCats() ==
                                                            null ||(
                                                              bloc.homeDatas().subCategory[bloc.addDressSelesctedMainCats()].length>0&&
                                                        bloc.addDressSelesctedSubCats() ==null)||
                                                        (bloc.adImagesFilesMap() ==
                                                                null &&
                                                            bloc.adImagesURL() ==
                                                                null)) {
                                                      setState(() {
                                                        empty = true;
                                                      });
                                                      scaffold.currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                        "من فضلك أكمل البيانات الأساسية بشكل صحيح",
                                                        textDirection:
                                                            TextDirection.rtl,
                                                      )));
                                                    } else {
                                                      setState(() {
                                                        loading = true;
                                                      });
                                                      List images = bloc
                                                          .adImagesURL()
                                                          .values
                                                          .toList();
                                                      List imagesUrl =
                                                          await uploadAdImages();
                                                      if (imagesUrl != null) {
                                                        for (var i in imagesUrl)
                                                          images.add(i);
                                                      }
                                                      List videos=[];
                                                      if(bloc.adVideosURL()!=null)
                                                       videos=  bloc
                                                            .adVideosURL()
                                                            .values
                                                            .toList();
                                                      
                                                      List videosUrl =
                                                          await uploadAdVideos();
                                                      if (videosUrl != null) {
                                                        for (var i in videosUrl)
                                                          videos.add(i);
                                                      }

                                                      bloc.adLatlng() != null
                                                          ? await updateAd(
                                                              context: context,
                                                              scaffold:
                                                                  scaffold,
                                                              id: widget.ad.id,
                                                              images: images,
                                                              videos: videos,
                                                              category_id: bloc
                                                                  .addDressSelesctedSubCats()??bloc.addDressSelesctedMainCats(),
                                                              city_id:
                                                                  bloc.cityId(),
                                                              lat: bloc
                                                                  .adLatlng()
                                                                  .latitude,
                                                              lng: bloc
                                                                  .adLatlng()
                                                                  .longitude,
                                                              title:
                                                                  bloc.adName(),
                                                              note:
                                                                  bloc.adNote(),
                                                            )
                                                          : await updateAd(
                                                              id: widget.ad.id,
                                                              context: context,
                                                              scaffold:
                                                                  scaffold,
                                                              images: images,
                                                              videos: videos,
                                                              category_id: bloc
                                                                  .addDressSelesctedSubCats()??bloc.addDressSelesctedMainCats(),
                                                              city_id:
                                                                  bloc.cityId(),
                                                              title:
                                                                  bloc.adName(),
                                                              note:
                                                                  bloc.adNote(),
                                                            );
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                    }
                                                  },
                                                ),
                                              );
                                            }),
                                      ],
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        StreamBuilder<Object>(
                                            stream:
                                                bloc.combineEditProfileFields,
                                            builder: (context, snapshot) {
                                              return Expanded(
                                                child: BumbiButton(
                                                  colored: true,
                                                  text: "إضافة الإعلان",
                                                  onPressed: () async {
                                                    setState(() {
                                                      validate = true;
                                                    });
                                                    if (bloc.adName() == null ||
                                                        bloc.adNote() == null ||
                                                        bloc.adNote().length <
                                                            1 ||
                                                        bloc.adName().length <
                                                            1 ||
                                                        bloc.cityId() == null ||
                                                        bloc.addDressSelesctedMainCats() ==
                                                            null ||(
                                                              bloc.homeDatas().subCategory[bloc.addDressSelesctedMainCats()].length>0&&
                                                        bloc.addDressSelesctedSubCats() ==null)||
                                                        bloc.adImagesFilesMap() ==
                                                            null) {
                                                      setState(() {
                                                        empty = true;
                                                      });
                                                      scaffold.currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                        "من فضلك أكمل البيانات الأساسية بشكل صحيح",
                                                        textDirection:
                                                            TextDirection.rtl,
                                                      )));
                                                    } else {
                                                      setState(() {
                                                        loading = true;
                                                      });
                                                      List images =
                                                          await uploadAdImages();
                                                      List videos =
                                                          await uploadAdVideos();
                                                      bloc.adLatlng() != null
                                                          ? await addNewAd(
                                                              context: context,
                                                              scaffold:
                                                                  scaffold,
                                                              images: images,
                                                              videos: videos,
                                                              category_id: bloc
                                                                  .addDressSelesctedSubCats()??bloc.addDressSelesctedMainCats(),
                                                              city_id:
                                                                  bloc.cityId(),
                                                              lat: bloc
                                                                  .adLatlng()
                                                                  .latitude,
                                                              lng: bloc
                                                                  .adLatlng()
                                                                  .longitude,
                                                              title:
                                                                  bloc.adName(),
                                                              note:
                                                                  bloc.adNote(),
                                                            )
                                                          : await addNewAd(
                                                              context: context,
                                                              scaffold:
                                                                  scaffold,
                                                              images: images,
                                                              videos: videos,
                                                              category_id: bloc
                                                                  .addDressSelesctedSubCats()??bloc.addDressSelesctedMainCats(),
                                                              city_id:
                                                                  bloc.cityId(),
                                                              title:
                                                                  bloc.adName(),
                                                              note:
                                                                  bloc.adNote(),
                                                            );
                                                      setState(() {
                                                        loading = false;
                                                      });
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
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
                )),
            AnimatedPositioned(
                top: viewMap
                    ? bloc.size().height - bloc.size().height / 1.2
                    : bloc.size().height * 2,
                child: Container(
                  width: bloc.size().width,
                  height: bloc.size().height / 1.2,
                  color: backGround,
                  child: Stack(
                    children: <Widget>[
                      viewMap
                          ? ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              child: GoogleMap(
                                onMapCreated: onMapCreated,
                                markers: Set.from(markers),
                                initialCameraPosition: CameraPosition(
                                    target: bloc.adLatlng() ??
                                        LatLng(saudiaCities['الرياض']['lat'],
                                            saudiaCities['الرياض']['lng']),
                                    zoom: 13),
                                mapType: MapType.terrain,
                                onTap: (pos) {
                                  setState(() {
                                    markers.clear();
                                  });
                                  markers.add(Marker(
                                      infoWindow:
                                          InfoWindow(title: "الموقع الجغرافي"),
                                      markerId: MarkerId("1"),
                                      position:
                                          LatLng(pos.latitude, pos.longitude),
                                      icon: customIcon,
                                      draggable: true));
                                  bloc.addAdLatlng(
                                      LatLng(pos.latitude, pos.longitude));
                                },
                              ),
                            )
                          : Positioned.fill(child: Container()),
                      Positioned(
                        child: Container(
                          width: bloc.size().width - 12,
                          height: 50,
//                           //نوع التواصل
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          margin:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                          decoration: BoxDecoration(
                              border: Border.all(color: primary, width: 2),
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
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
                                  icon: Icon(Icons.do_not_disturb_on, size: 0),
                                  value: _selectedCity,
                                  items: _cityMenuItems,
                                  onChanged: (v) {
                                    if (v != 0) {
                                      onChangeCity(v);
                                      setState(() {
                                        markers.clear();
                                      });
                                      markers.add(Marker(
                                          infoWindow: InfoWindow(
                                              title: "الموقع الجغرافي"),
                                          markerId: MarkerId("1"),
                                          position: LatLng(
                                              saudiaCities.values
                                                  .toList()[v - 1]['lat'],
                                              saudiaCities.values
                                                  .toList()[v - 1]['lng']),
                                          icon: customIcon,
                                          draggable: true));
                                      bloc.addAdLatlng(LatLng(
                                          saudiaCities.values.toList()[v - 1]
                                              ['lat'],
                                          saudiaCities.values.toList()[v - 1]
                                              ['lng']));
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          right: 0,
                          top: 60,
                          child: IconButton(
                              icon: Icon(
                                Icons.my_location,
                                color: primary,
                                size: 30,
                              ),
                              onPressed: () async {
                                LatLng myLocation = await _getUserLocation();
                                if (myLocation != null) moveOnMap(myLocation);
                                setState(() {
                                  markers.clear();
                                });
                                markers.add(Marker(
                                    infoWindow:
                                        InfoWindow(title: "الموقع الجغرافي"),
                                    markerId: MarkerId("1"),
                                    position: myLocation,
                                    icon: customIcon,
                                    draggable: true));
                                bloc.addAdLatlng(myLocation);
                              })),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          color: backGround,
                          padding: EdgeInsets.all(5),
                          height: 50,
                          width: bloc.size().width,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: BumbiButton(
                                text: "إلغاء",
                                colored: false,
                                onPressed: () {
                                  setState(() {
                                    viewMap = false;
                                    _selectedCity = 0;
                                    bloc.addAdLatlng(null);
                                    markers.clear();
                                  });
                                },
                              )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: StreamBuilder(
                                stream: bloc.adLatlngtStream,
                                builder: (context, s) => BumbiButton(
                                  text: "تأكيد",
                                  colored: true,
                                  onPressed: s.hasData
                                      ? () {
                                          setState(() {
                                            viewMap = false;
                                          });
                                        }
                                      : null,
                                ),
                              ))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                duration: mill1Second),
            loading
                ? LoadingFullScreen(
                    stream: bloc.uploadingPercentatgeStream,
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Container addAssetButton({String text, Function onPressed}) {
    return Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(
          vertical: 5,
        ),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          splashColor: primaryAccent.withOpacity(0.3),
          onTap: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              Text(
                text,
                textDirection: TextDirection.rtl,
                style: TextStyle(color: primary, fontSize: 14),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white),
                  child: Icon(
                    Icons.add,
                    color: primary,
                  ))
            ],
          ),
        ));
  }
}

class AssetCard extends StatelessWidget {
  int index;
  File file;
  String imageURL;
  Function onPressed;
  AssetCard({this.file, this.index, this.imageURL, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        onTap: onPressed,
        child: Container(
            width: 100,
            height: 110,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: file != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Image.file(
                            file,
                            fit: BoxFit.fill,
                          ))
                      : ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Image.network(
                            imageURL,
                            fit: BoxFit.fill,
                          )),
                ),
                Positioned.fill(
                    child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.white.withOpacity(0.2)),
                )),
                Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white),
                    child: InkWell(
                        child: Icon(
                          Icons.close,
                          size: 15,
                          color: primary,
                        ),
                        onTap: () {
                          Map<int, File> oldImageFileMap =
                              bloc.adImagesFilesMap();
                          Map<int, String> oldImageUrlMap = bloc.adImagesURL();

                          Map<int, Widget> oldImageWidgets =
                              bloc.adImagesWidgets();
                          if (file != null) oldImageFileMap.remove(index);
                          oldImageWidgets.remove(index);
                          if (imageURL != null) oldImageUrlMap.remove(index);
                          bloc.onadImagesURLChange(oldImageUrlMap);
                      
                          bloc.addNewadImagesFilesMAp(oldImageFileMap);
                          bloc.addNewadImagesWidgets(oldImageWidgets);
                        }))
              ],
            )),
      ),
    );
  }
}

// class VideoCard extends StatelessWidget {
//   int index;
//   File file;
//   String videoUrl;
//   Function onPressed;
//   VideoCard({this.file, this.index, this.videoUrl, this.onPressed});
//   VideoPlayerController _videoPlayerController;

//   @override
//   Widget build(BuildContext context) {
//     _videoPlayerController = videoUrl != null
//         ? VideoPlayerController.network(videoUrl)
//         : VideoPlayerController.file(file);

//     _videoPlayerController.initialize().then((_) {
//       _videoPlayerController.setVolume(0);
//       _videoPlayerController.play();
//     });
//     return Padding(
//       padding: EdgeInsets.only(left: 10),
//       child: InkWell(
//         borderRadius: BorderRadius.all(Radius.circular(15)),
//         onTap: onPressed,
//         child: Container(
//             width: 100,
//             height: 110,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(15)),
//                 color: Colors.white),
//             child: Stack(
//               children: <Widget>[
//                 Positioned.fill(
//                     child: file != null
//                         ? ClipRRect(
//                             borderRadius: BorderRadius.all(Radius.circular(15)),
//                             child: AspectRatio(
//                               aspectRatio:
//                                   _videoPlayerController.value.aspectRatio,
//                               child: VideoPlayer(_videoPlayerController),
//                             ),
//                           )
//                         : ClipRRect(
//                             borderRadius: BorderRadius.all(Radius.circular(15)),
//                             child: AspectRatio(
//                               aspectRatio:
//                                   _videoPlayerController.value.aspectRatio,
//                               child: VideoPlayer(_videoPlayerController),
//                             ),
//                           )),
//                 Positioned.fill(
//                     child: Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(15)),
//                       color: Colors.white.withOpacity(0.2)),
//                 )),
//                 Container(
//                     margin: EdgeInsets.all(10),
//                     padding: EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(5)),
//                         color: Colors.white),
//                     child: InkWell(
//                         child: Icon(
//                           Icons.close,
//                           size: 15,
//                           color: primary,
//                         ),
//                         onTap: () {
//                           Map<int, File> oldVideoFileMap =
//                               bloc.adVideosFilesMap();
//                           Map<int, Widget> oldVideoWidgets =
//                               bloc.adVideosWidgets();
//                           oldVideoFileMap.remove(index);
//                           oldVideoWidgets.remove(index);
//                           bloc.addNewadVideosFilesMAp(oldVideoFileMap);
//                           bloc.addNewadVideosWidgets(oldVideoWidgets);
//                         }))
//               ],
//             )),
//       ),
//     );
//   }
// }
