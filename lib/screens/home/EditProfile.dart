import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/userModel.dart';
import 'package:senam/screens/home/profilePicture.dart';
import 'package:senam/screens/login&signUp/changePassword.dart';
import 'package:senam/screens/login&signUp/confirm.dart';
import 'package:senam/screens/login&signUp/login.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  initState() {
    String mob = "0${bloc.currentUser().mobile.substring(4)}";
    setState(() {
      mobile.text = mob;
    });
    bloc.onMobileChange(mob);
    bloc.onNameChange(bloc.currentUser().username);
    bloc.oncityIdChange(
        bloc.currentUser().city != null
            ? bloc.currentUser().city.id
            : null);
    for (int i = 0; i < bloc.citiesList().length; i++) {
      setState(() {
        citiesMap[bloc.citiesList()[i].id] = bloc.citiesList()[i].name;
      });
    }
        if( bloc.currentUser().city != null)

    for (int i = 0; i < bloc.citiesList().length; i++) {
      if (bloc.citiesList()[i].id == bloc.currentUser().city.id)
        setState(() {
          _selectedValue = i + 1;
        });
    }

    super.initState();
  }

  File _image;
  File _cropped;

  GlobalKey<ScaffoldState> scaffold = GlobalKey();

  Future getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);

    setState(() {
      _image = image;
    });
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

  Map<int, String> citiesMap = {};
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

  pickImage(GlobalKey<ScaffoldState> scaffold) {
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
                  File i = await getImage(ImageSource.camera);
                  await retrieveLostData();
                  if (_image != null) cropImage(_image);
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
                  await getImage(ImageSource.gallery);
                  await retrieveLostData();
                  if (_image != null) cropImage(_image);
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
  final mobileNode = new FocusNode();
  final nameNode = new FocusNode();
  bool loading = false;

  TextEditingController mobile = TextEditingController();
  TextEditingController name =
      TextEditingController(text: bloc.currentUser().username);

  @override
  Widget build(BuildContext context) {
    List<String> cities = ["المدينة"]..addAll(citiesMap.values.toList());

    setState(() {
      _dropdownMenuItems = buildDropdownMenuItems(cities);
    });

    return WillPopScope(
      onWillPop: () {
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
                Text(
                  "تعديل الملف الشخصي",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      color: primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SmallIconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icons.arrow_forward_ios,
                  color: primary,
                ),
              ],
            ),
          ),
          body: GestureDetector(
            onTap: () {
              nameNode.unfocus();
              mobileNode.unfocus();
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              width: bloc.size().width,
              height: bloc.size().height,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: bloc.size().width,
                    height: bloc.size().height,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          ProfilePicture(
                            cropped: _cropped,
                            icon: Icons.linked_camera,
                            onIconPressed: () {
                              pickImage(scaffold);
                            },
                            imageURL: bloc.currentUser().image,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          StreamBuilder<String>(
                            stream: validate ? bloc.nameStream : null,
                            builder: (context, s) => AtelierTextField(
                              value: empty ? bloc.name() : "",
                              error: s.hasError
                                  ? "الاسم لا يمكن أن يكون فارغاً"
                                  : null,
                              unFocus: () {
                                setState(() {
                                  mobileNode.unfocus();
                                  FocusScope.of(context).requestFocus(nameNode);
                                });
                              },
                              controller: name,
                              password: false,
                              focusNode: nameNode,
                              label: "الاسم",
                              onChanged: bloc.onNameChange,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
//                           //نوع التواصل
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            margin: EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: validate && bloc.cityId() == null
                                    ? Border.all(color: Colors.red)
                                    : null,
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
                                    icon:
                                        Icon(Icons.do_not_disturb_on, size: 0),
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
                            height: 20,
                          ),
                          StreamBuilder<String>(
                            stream: validate ? bloc.mobileStream : null,
                            builder: (context, s) => AtelierTextField(
                              value: empty ? bloc.mobile() : "",
                              error: s.hasError
                                  ? "رقم الهاتف من 10 أرقام ويجب أن يبدأ ب 05"
                                  : null,
                              unFocus: () {
                                setState(() {
                                  nameNode.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(mobileNode);
                                });
                              },
                              controller: mobile,
                              password: false,
                              focusNode: mobileNode,
                              label: "رقم الجوال",
                              onChanged: bloc.onMobileChange,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
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
                                  onPressed: () async {
                                    setState(() {
                                      validate = true;
                                    });
                                    if (name.text.length < 1 ||
                                        mobile.text.length != 10 ||
                                        !mobile.text.startsWith("05") ||
                                        bloc.cityId() == null)
                                      scaffold.currentState.showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "من فضلك أدخل بيانات صحيحة")));
                                    else {
                                      String oldMob = bloc.currentUser().mobile;
                                      setState(() {
                                        loading = true;
                                      });
                                      await updateUserProfile(image: _cropped);
                                      setState(() {
                                        loading = false;
                                      });
                                      if(bloc.errorUser().msg==null){
                                      if (bloc.currentUser().mobile == oldMob) {
                                        Navigator.of(context).pop();
                                      } else {
                                        if (bloc.currentUser().status=="not_active") {
                                          String mo =
                                              "0${bloc.currentUser().mobile.substring(4)}";

                                          bloc.onMobileChange(mo);
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) => Confirm(
                                                        from: "signUp",
                                                      )));
                                        }
                                      }
                                    }
                                    else if(bloc.errorUser().response_status==401){
                                      await clearUserData();
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Login()));
                                    }
                                    else 
                                    scaffold.currentState.showSnackBar(SnackBar(content: 
                                    Text(bloc.errorUser().msg)));
                                    }
                                  },
                                )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            highlightColor: primaryAccent.withOpacity(.1),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChangePassword()));
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "تغيير كلمة المرور",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: hint,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                  loading ? LoadingFullScreen() : SizedBox()
                ],
              ),
            ),
          )),
    );
  }
}
