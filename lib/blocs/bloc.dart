import 'dart:io';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/adModel.dart';
import 'package:senam/models/categories.dart';
import 'package:senam/models/staticData.dart';
import 'package:senam/screens/home/home.dart';
import 'package:senam/screens/login&signUp/confirm.dart';
import 'package:senam/screens/login&signUp/splach.dart';
import 'shared_preferences_helper.dart';
import 'package:senam/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'validators.dart';

class Bloc extends Validators {
  BehaviorSubject<String> _deviceType = BehaviorSubject<String>();
  Function(String) get setDeviceType => _deviceType.sink.add;
  String deviceType() => _deviceType.value;
  BehaviorSubject<String> _deviceToken = BehaviorSubject<String>();
  Function(String) get setDeviceToken => _deviceToken.sink.add;
  String deviceToken() => _deviceToken.value;
  BehaviorSubject<Size> _deviceSize = BehaviorSubject<Size>();
  Function(Size) get setDeviceSize => _deviceSize.sink.add;
  Size size() => _deviceSize.value;
  BehaviorSubject<String> _langCtl = BehaviorSubject<String>();
  Function(String) get sendlang => _langCtl.sink.add;
  String lang() => _langCtl.value;
  // login
  BehaviorSubject<String> _userType = BehaviorSubject<String>();
  Function(String) get setUserType => _userType.sink.add;
  String userType() => _userType.value;
  BehaviorSubject<UserService> _errorUser = BehaviorSubject<UserService>();
  Function(UserService) get sendErrorUser => _errorUser.sink.add;
  UserService errorUser() => _errorUser.value;
///// done message
  BehaviorSubject<String> _donMSG = BehaviorSubject<String>();
  Function(String) get sendDoneMessage => _donMSG.sink.add;
  String doneMSG() => _donMSG.value;

  // user model
  BehaviorSubject<UserService> _userModel = BehaviorSubject<UserService>();
  Function(UserService) get sendNewUser => _userModel.sink.add;
  UserService currentUser() => _userModel.value;
  Stream<UserService> get userStream => _userModel.stream;
  //.transform(emailValidate);
//cites
  BehaviorSubject<List<City>> _cities = BehaviorSubject<List<City>>();
  Function(List<City>) get sendCities => _cities.sink.add;
  List<City> citiesList() => _cities.value;
  BehaviorSubject<String> _searchText = BehaviorSubject<String>();
  Function(String) get sendsearchText => _searchText.sink.add;
  String searchText() => _searchText.value;

//cityId
  BehaviorSubject<int> _cityId = BehaviorSubject<int>();
  Function(int) get oncityIdChange => _cityId.sink.add;
  int cityId() => _cityId.value;
  Stream<int> get cityStream => _cityId.stream;

  //email
  BehaviorSubject<String> _emailCtl = BehaviorSubject<String>();
  Function(String) get onEmailChange => _emailCtl.sink.add;
  String email() => _emailCtl.value;
  Stream<String> get emailStream => _emailCtl.stream.transform(emailValidate);
  //password
  BehaviorSubject<String> _passwordCtrl = BehaviorSubject<String>();
  Function(String) get onPasswordChange => _passwordCtrl.sink.add;
  String password() => _passwordCtrl.value;
  Stream<String> get passwordStream =>
      _passwordCtrl.stream.transform(passwordValidate);
  //password
  BehaviorSubject<String> _oldPasswordCtrl = BehaviorSubject<String>();
  Function(String) get onOldPasswordChange => _oldPasswordCtrl.sink.add;
  String oldPassword() => _oldPasswordCtrl.value;
  Stream<String> get oldPasswordStream =>
      _oldPasswordCtrl.stream.transform(oldPasswordValidate);

  //mobile
  BehaviorSubject<String> _mobile = BehaviorSubject<String>();
  Function(String) get onMobileChange => _mobile.sink.add;
  String mobile() => _mobile.value;
  Stream<String> get mobileStream => _mobile.stream.transform(mobileValidate);
  //name
  BehaviorSubject<String> _name = BehaviorSubject<String>();
  Function(String) get onNameChange => _name.sink.add;
  String name() => _name.value;
  Stream<String> get nameStream => _name.stream.transform(nameValidate);
  //.transform(passwordValidate);
  //web site
  BehaviorSubject<String> _siteCtrl = BehaviorSubject<String>();
  Function(String) get onSiteChange => _siteCtrl.sink.add;
  String site() => _siteCtrl.value;
  Stream<String> get siteStream => _siteCtrl.stream;
  //.transform(passwordValidate);
  //activation code
  BehaviorSubject<String> _codeCtrl = BehaviorSubject<String>();
  Function(String) get onCodeChange => _codeCtrl.sink.add;
  String code() => _codeCtrl.value;
  Stream<String> get codeStream => _codeCtrl.stream;
  //.transform(passwordValidate);
  // house image
  BehaviorSubject<File> _houseImageCtl = BehaviorSubject<File>();
  Function(File) get onHouseImageChange => _houseImageCtl.sink.add;
  File houseImage() => _houseImageCtl.value;
  Stream<File> get houseImageStream => _houseImageCtl.stream;
  //.transform(passwordValidate);
  // user image
  BehaviorSubject<File> _userImageCtl = BehaviorSubject<File>();
  Function(File) get onUserImageChange => _userImageCtl.sink.add;
  File userImage() => _userImageCtl.value;
  Stream<File> get userImageStream => _userImageCtl.stream;
  //.transform(passwordValidate);

  //note
  BehaviorSubject<String> _noteCtrl = BehaviorSubject<String>();
  Function(String) get onNoteChange => _noteCtrl.sink.add;
  String note() => _noteCtrl.value;
  Stream<String> get noteStream => _noteCtrl.stream;
  //.transform(passwordValidate);

  //profile image
  BehaviorSubject<File> _profileImageCtl = BehaviorSubject<File>();
  Function(File) get onProfileImageChange => _profileImageCtl.sink.add;
  File profileImage() => _profileImageCtl.value;
  Stream<File> get profileImageStream => _profileImageCtl.stream;
  //.transform(passwordValidate);

  //package
  BehaviorSubject<String> _selectedPackage = BehaviorSubject<String>();
  Function(String) get selectPackage => _selectedPackage.sink.add;
  String selectedPackage() => _selectedPackage.value;
  Stream<String> get selectedPackageStream => _selectedPackage.stream;
  Stream<bool> get combineMobileandPassword =>
      Rx.combineLatest2(mobileStream, passwordStream, (e, p) => true);
  Stream<bool> get combineSinUpFields => Rx.combineLatest3(
      nameStream, mobileStream, passwordStream, (a, c, e) => true);
  Stream<bool> get combineEditProfileFields => Rx.combineLatest3(
      nameStream, emailStream, mobileStream, (a, b, c) => true);
  Stream<bool> get combineTwoPasswordFields =>
      Rx.combineLatest2(oldPasswordStream, passwordStream, (a, b) => true);

  //.transform(passwordValidate);
  /// static data
  BehaviorSubject<StaticData> _staticData = BehaviorSubject<StaticData>();
  Function(StaticData) get sendStaticData => _staticData.sink.add;
  StaticData staticData() => _staticData.value;

  BehaviorSubject<int> _cType = BehaviorSubject<int>();
  Function(int) get onCTypeChange => _cType.sink.add;
  int cType() => _cType.value;
  Stream<int> get cTypeStream => _cType.stream;
  BehaviorSubject<List<Widget>> _mainCategories =
      BehaviorSubject<List<Widget>>();
  Function(List<Widget>) get onmainCategoriesChange => _mainCategories.sink.add;
  List<Widget> mainCategories() => _mainCategories.value;
  Stream<List<Widget>> get mainCategoriesStream => _mainCategories.stream;
  BehaviorSubject<Map<int, List<Category>>> _subC =
      BehaviorSubject<Map<int, List<Category>>>();
  Function(Map<int, List<Category>>) get onsubCChange => _subC.sink.add;
  Map<int, List<Category>> subC() => _subC.value;
  Stream<Map<int, List<Category>>> get subCStream => _subC.stream;

  BehaviorSubject<int> _cSubType = BehaviorSubject<int>();
  Function(int) get onCSubTypeChange => _cSubType.sink.add;
  int cSubType() => _cSubType.value;
  Stream<int> get cSubTypeStream => _cSubType.stream;
  // BehaviorSubject<List<Category>> _mainCat = BehaviorSubject<List<Category>>();
  // Function(List<Category>) get onmainCatChange => _mainCat.sink.add;
  // List<Category> mainCat() => _mainCat.value;
  // Stream<List<Category>> get mainCatStream => _mainCat.stream;
  // BehaviorSubject<List<Category>> _subCat = BehaviorSubject<List<Category>>();
  // Function(List<Category>) get onsubCatChange => _subCat.sink.add;
  // List<Category> subCat() => _subCat.value;
  // Stream<List<Category>> get subCatStream => _subCat.stream;

  BehaviorSubject<List<Widget>> _homeAds = BehaviorSubject<List<Widget>>();
  Function(List<Widget>) get onHomeAdCardsChange => _homeAds.sink.add;
  List<Widget> homeAds() => _homeAds.value;
  Stream<List<Widget>> get homeAdsStream => _homeAds.stream;
  BehaviorSubject<List<Widget>> _homeSearchedAds =
      BehaviorSubject<List<Widget>>();
  Function(List<Widget>) get onHomeSearchedAdCardsChange =>
      _homeSearchedAds.sink.add;
  List<Widget> homeSearchedAds() => _homeSearchedAds.value;
  Stream<List<Widget>> get homeSearchedAdsStream => _homeSearchedAds.stream;

  BehaviorSubject<int> _dataSearchedCount = BehaviorSubject<int>();
  Function(int) get onDataSearchedCountChange => _dataSearchedCount.sink.add;
  int dataSearchedCount() => _dataSearchedCount.value;
  Stream<int> get dataSearchedCountStream => _dataSearchedCount.stream;

  BehaviorSubject<bool> _searching = BehaviorSubject<bool>();
  Function(bool) get onsearchingChange => _searching.sink.add;
  bool searching() => _searching.value;
  Stream<bool> get searchingStream => _searching.stream;

  BehaviorSubject<int> _selectedFilter = BehaviorSubject<int>();
  Function(int) get selectFilter => _selectedFilter.sink.add;
  int selectedFilter() => _selectedFilter.value;
  Stream<int> get selectFilterStream => _selectedcityFilter.stream;

  BehaviorSubject<int> _selectedcityFilter = BehaviorSubject<int>();
  Function(int) get selectcityFilter => _selectedcityFilter.sink.add;
  int selectedcityFilter() => _selectedcityFilter.value;
  Stream<int> get selectedCityFilterStream => _selectedcityFilter.stream;

  BehaviorSubject<String> _selectedSortFilter = BehaviorSubject<String>();
  Function(String) get selectcSortityFilter => _selectedSortFilter.sink.add;
  String selectedSortFilter() => _selectedSortFilter.value;
  Stream<String> get selectedSortFilterStream => _selectedSortFilter.stream;

  BehaviorSubject<int> _selectedcityIdFilter = BehaviorSubject<int>();
  Function(int) get selectcityIdFilter => _selectedcityIdFilter.sink.add;
  int selectedcityIdFilter() => _selectedcityIdFilter.value;
  Stream<int> get selectedCityIdFilterStream => _selectedcityIdFilter.stream;

  BehaviorSubject<String> _selectedSortText = BehaviorSubject<String>();
  Function(String) get selectcSortTextity => _selectedSortText.sink.add;
  String selectedSortText() => _selectedSortText.value;
  Stream<String> get selectedSortTextStream => _selectedSortText.stream;

  BehaviorSubject<String> _selectedcityNameFilter = BehaviorSubject<String>();
  Function(String) get selectcityNameFilter => _selectedcityNameFilter.sink.add;
  String selectedcityNameFilter() => _selectedcityNameFilter.value;
  Stream<String> get selectedCityNameFilterStream =>
      _selectedcityNameFilter.stream;

  BehaviorSubject<List<Widget>> _fashionCards = BehaviorSubject<List<Widget>>();
  Function(List<Widget>) get updateFasionCards => _fashionCards.sink.add;
  List<Widget> get fashionCards => _fashionCards.value;
  Stream<List<Widget>> get fashionCardsStream => _fashionCards.stream;
  BehaviorSubject<bool> _closeFilters = BehaviorSubject<bool>();
  Function(bool) get changeCloseFilters => _closeFilters.sink.add;
  bool get closeFilters => _closeFilters.value;
  Stream<bool> get closeFiltersStream => _closeFilters.stream;
  BehaviorSubject<bool> _closeCityFilters = BehaviorSubject<bool>();
  Function(bool) get changeCloseCityFilters => _closeCityFilters.sink.add;
  bool get closeCityFilters => _closeCityFilters.value;
  Stream<bool> get closeCityFiltersStream => _closeCityFilters.stream;

  BehaviorSubject<List<AdCard>> _categories = BehaviorSubject<List<AdCard>>();
  Function(List<AdCard>) get getCategories => _categories.sink.add;
  List<AdCard> categories() => _categories.value;

////////////////////////// ad
  BehaviorSubject<String> _adName = BehaviorSubject<String>();
  Function(String) get onadNameChange => _adName.sink.add;
  String adName() => _adName.value;
  Stream<String> get adNameStream => _mobile.stream;
  BehaviorSubject<String> _addCity = BehaviorSubject<String>();
  Function(String) get onaddCityChange => _addCity.sink.add;
  String addCity() => _addCity.value;
  Stream<String> get addCityStream => _addCity;
  //////////////////////////////////////////////////////////////
  BehaviorSubject<int> _mainCategory = BehaviorSubject<int>();
  Function(int) get onmainCategoryChange => _mainCategory.sink.add;
  int mainCategory() => _mainCategory.value;
  Stream<int> get mainCategoryStream => _mainCategory.stream;
  BehaviorSubject<int> _subCategory = BehaviorSubject<int>();
  Function(int) get onsubCategoryChange => _subCategory.sink.add;
  int subCategory() => _subCategory.value;
  Stream<int> get subCategoryStream => _subCategory.stream;
  BehaviorSubject<String> _adNote = BehaviorSubject<String>();
  Function(String) get onadNoteChange => _adNote.sink.add;
  String adNote() => _adNote.value;
  Stream<String> get adNoteStream => _adNote.stream;
  BehaviorSubject<String> _addImages = BehaviorSubject<String>();
  Function(String) get onaddImagesChange => _addImages.sink.add;
  String addImages() => _addImages.value;
  Stream<String> get addImagesStream => _addImages.stream;
  BehaviorSubject<String> _adVideos = BehaviorSubject<String>();
  Function(String) get onadVideosChange => _adVideos.sink.add;
  String adVideos() => _adVideos.value;
  Stream<String> get adVideosStream => _adVideos.stream;
  BehaviorSubject<String> _adLocation = BehaviorSubject<String>();
  Function(String) get onadLocationChange => _adLocation.sink.add;
  String adLocation() => _adLocation.value;
  Stream<String> get adLocationStream => _adLocation.stream;
///////////////////////////////////////////////////////////////////
  BehaviorSubject<Map<int, File>> _adImagesFile =
      BehaviorSubject<Map<int, File>>();
  Function(Map<int, File>) get addNewadImagesFilesMAp => _adImagesFile.sink.add;
  Map<int, File> adImagesFilesMap() => _adImagesFile.value;
  Stream<Map<int, File>> get adImagesFileStream => _adImagesFile.stream;
  BehaviorSubject<Map<int, String>> _adImagesURL =
      BehaviorSubject<Map<int, String>>();
  Function(Map<int, String>) get onadImagesURLChange => _adImagesURL.sink.add;
  Map<int, String> adImagesURL() => _adImagesURL.value;
  Stream<Map<int, String>> get adImagesURLStream => _adImagesURL.stream;
    BehaviorSubject<Map<int, String>> _adVideosURL =
      BehaviorSubject<Map<int, String>>();
  Function(Map<int, String>) get onadVideosURLChange => _adVideosURL.sink.add;
  Map<int, String> adVideosURL() => _adVideosURL.value;
  Stream<Map<int, String>> get adVideosURLStream => _adVideosURL.stream;

  BehaviorSubject<Map<int, Widget>> _adImagesWidget =
      BehaviorSubject<Map<int, Widget>>();
  Function(Map<int, Widget>) get addNewadImagesWidgets =>
      _adImagesWidget.sink.add;
  Map<int, Widget> adImagesWidgets() => _adImagesWidget.value;
  Stream<Map<int, Widget>> get adImagesWidgetStream => _adImagesWidget.stream;
  // BehaviorSubject<GlobalKey<ScaffoldState>> _scaffold = BehaviorSubject<GlobalKey<ScaffoldState>>();
  // Function(GlobalKey<ScaffoldState>) get addScaffoldKey => _scaffold.sink.add;
  // GlobalKey<ScaffoldState> scaffold() => _scaffold.value;
  BehaviorSubject<Map<int, File>> _adVideosFile =
      BehaviorSubject<Map<int, File>>();
  Function(Map<int, File>) get addNewadVideosFilesMAp => _adVideosFile.sink.add;
  Map<int, File> adVideosFilesMap() => _adVideosFile.value;
  Stream<Map<int, File>> get adVideosFileStream => _adVideosFile.stream;
  BehaviorSubject<Map<int, Widget>> _adVideosWidget =
      BehaviorSubject<Map<int, Widget>>();
  Function(Map<int, Widget>) get addNewadVideosWidgets =>
      _adVideosWidget.sink.add;
  Map<int, Widget> adVideosWidgets() => _adVideosWidget.value;
  Stream<Map<int, Widget>> get adVideosWidgetStream => _adVideosWidget.stream;
  BehaviorSubject<LatLng> _adLatlngCTL = BehaviorSubject<LatLng>();
  Function(LatLng) get addAdLatlng => _adLatlngCTL.sink.add;
  LatLng adLatlng() => _adLatlngCTL.value;
  Stream<LatLng> get adLatlngtStream => _adLatlngCTL.stream;

  BehaviorSubject<Map<int, String>> _contactTyp =
      BehaviorSubject<Map<int, String>>();
  Function(Map<int, String>) get addNewcontactTyps => _contactTyp.sink.add;
  Map<int, String> contactTyps() => _contactTyp.value;
  Stream<Map<int, String>> get contactTypStream => _contactTyp.stream;
    BehaviorSubject<HomeData> _homeData =
      BehaviorSubject<HomeData>();
  Function(HomeData) get addNewhomeDatas => _homeData.sink.add;
  HomeData homeDatas() => _homeData.value;
  Stream<HomeData> get homeDataStream => _homeData.stream;

    BehaviorSubject<int> _addDressSelesctedMainCat =
      BehaviorSubject<int>();
  Function(int) get onChangeaddDressSelesctedMainCats => _addDressSelesctedMainCat.sink.add;
  int addDressSelesctedMainCats() => _addDressSelesctedMainCat.value;
  Stream<int> get addDressSelesctedMainCatStream => _addDressSelesctedMainCat.stream;

    BehaviorSubject<int> _addDressSelesctedSubCat =
      BehaviorSubject<int>();
  Function(int) get onChangeaddDressSelesctedSubCats => _addDressSelesctedSubCat.sink.add;
  int addDressSelesctedSubCats() => _addDressSelesctedSubCat.value;
  Stream<int> get addDressSelesctedSubCatStream => _addDressSelesctedSubCat.stream;
    BehaviorSubject<String> _uploadingPercentatge =
      BehaviorSubject<String>();
  Function(String) get onChangeuploadingPercentatge => _uploadingPercentatge.sink.add;
  String uploadingPercentatge() => _uploadingPercentatge.value;
  Stream<String> get uploadingPercentatgeStream => _uploadingPercentatge.stream;

    BehaviorSubject<List<Widget>> _favouriteCards =
      BehaviorSubject<List<Widget>>();
  Function(List<Widget>) get onChangefavouriteCards => _favouriteCards.sink.add;
  List<Widget> favouriteCards() => _favouriteCards.value;
  Stream<List<Widget>> get favouriteCardsStream => _favouriteCards.stream;

  
  dispose() {
    _favouriteCards.close();
    _uploadingPercentatge.close();
    _addDressSelesctedMainCat.close();
    _addDressSelesctedSubCat.close();
    _adLatlngCTL.close();
    _contactTyp.close();
    _selectedcityFilter.close();
    _homeData.close();
    _mainCategories.close();
    _cities.close();
    _homeAds.close();
    _closeCityFilters.close();
    // _mainCat.close();
    // _subCat.close();
    _searching.close();
    _adVideos.close();
    _selectedcityNameFilter.close();
    _selectedSortText.close();
    _adVideosFile.close();
    _adVideosWidget.close();
    _dataSearchedCount.close();
    _adVideosURL.close();
    _adImagesWidget.close();
    _adImagesFile.close();
    _subC.close();
    _homeSearchedAds.close();
    _adImagesURL.close();
    _selectedcityIdFilter.close();
    _addCity.close();
    _addImages.close();
    _adName.close();
    _selectedSortFilter.close();
    _adNote.close();
    _adLocation.close();
    _searchText.close();
    _adVideos.close();
    _cityId.close();
    _addImages.close();
    _mainCategory.close();
    _subCategory.close();
    _selectedFilter.close();
    _categories.close();
    _fashionCards.close();
    _closeFilters.close();
    _cType.close();
    _userType.close();
    _cSubType.close();
    _deviceSize.close();
    _deviceType.close();
    _langCtl.close();
    _deviceToken.close();
    _selectedPackage.close();
    _siteCtrl.close();
    _name.close();
    _staticData.close();
    _passwordCtrl.close();
    _profileImageCtl.close();
    _noteCtrl.close();
    _codeCtrl.close();
    _houseImageCtl.close();
    _userImageCtl.close();
    _emailCtl.close();
    _oldPasswordCtrl.close();
    _mobile.close();
    _userModel.close();
    _errorUser.close();
    _donMSG.close();
  }

  static Future<void> pop({bool animated}) async {
    await SystemChannels.platform
        .invokeMethod<void>('SystemNavigator.pop', animated);
  }

  Future<bool> onClose(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              "هل أنت متأكد؟",
              textDirection: TextDirection.rtl,
            ),
            content: new Text(
              "هل حقاً تريد إغلاق التطبيق؟",
              textDirection: TextDirection.rtl,
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  "لا",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(),
                ),
              ),
              new FlatButton(
                onPressed: () {
                  pop(animated: false);
                  return false;
                },
                child: new Text(
                  "نعم",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}

final bloc = Bloc();
//////////////////////////////////////////////////
chooseScreen(BuildContext context) async {
  await getCities();
  await getHomeData();
  await loginData();
  await staticData();
  bool forget = await getSharedBoolOfKey("forget");
  if (bloc.currentUser() == null)
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Splach()));
  else {
    if (forget != null) {
      if (bloc.currentUser().status == "active")
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      else if (bloc.currentUser().activation_code != null) {
        if (int.tryParse(bloc.currentUser().activation_code) != null) {
      String mob= bloc.currentUser().mobile.substring(4,13);
      bloc.onMobileChange(mob);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Confirm(
                    from: "forget",
                  )));
        }
      } else
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Splach()));
    } else {
      if (bloc.currentUser().status == "active")
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
            else
      if (bloc.currentUser().activation_code != null) {
        if (int.tryParse(bloc.currentUser().activation_code) != null) {
      String mob= bloc.currentUser().mobile.substring(4,13);
      bloc.onMobileChange(mob);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Confirm(
                    from: "signUp",
                  )));
        }
      } else 
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Splach()));
    }
  }
}

loginChooseScreen(BuildContext context) async {
  bool forget = await getSharedBoolOfKey("forget");
  if (bloc.currentUser() == null)
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Splach()));
  else {
    if (forget != null) {
      if (bloc.currentUser().status == "active")
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      else if (int.tryParse(bloc.currentUser().activation_code) != null) {
        bloc.onMobileChange(bloc.currentUser().mobile);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Confirm(
                  from: "signUp",
                )));
      }
    } else {
      if (bloc.currentUser().activation_code != null) {
        if (int.tryParse(bloc.currentUser().activation_code) != null)
          bloc.onMobileChange(bloc.currentUser().mobile);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Confirm(
                  from: "signUp",
                )));
      } else if (bloc.currentUser().status == "active")
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      else
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Splach()));
    }
  }
}

Future updateLocalUser(UserService userService) async {
  await removeSharedOfKey("userData");
  await addSharedListOfString("userData", userService.toListData());
}

//
Future loginData() async {
  List<String> userData = await getSharedListOfStringOfKey("userData");
  if (userData != null) {
    UserService user =  UserService.fromList(userData);
    await bloc.sendNewUser(user);
    String pass=await getSharedStringOfKey("pass");
    if(pass!=null&&user!=null){
      String mob= user.mobile.substring(4,13);
      bloc.onMobileChange(mob);
      bloc.onPasswordChange(pass);
      await loginPost();
      print(bloc.currentUser().mobile);
    }
  }
}

Future clearUserData() async {
  await removeSharedOfKey("userData");
}

Map<String, dynamic> saudiaCities = {
  "مكة المكرمة": {"lat": 21.422510, "lng": 39.826168}, //Mecca, Saudi Arabia
  "المدينة المنورة": {
    "lat": 24.470901,
    "lng": 39.612236
  }, //Medina, Saudi Arabia
  "الرياض": {"lat": 24.774265, "lng": 46.738586}, //Riyadh, Saudi Arabia
  "الدوادمي": {"lat": 24.507143, "lng": 44.408798}, //Al Duwadimi, Saudi Arabia
  "القطيف": {"lat": 26.565191, "lng": 49.996376}, //Al Qatif, Saudi Arabia
  "الظهران": {"lat": 26.288769, "lng": 50.114101}, //Dhahran, Saudi Arabia
  "الدمام": {"lat": 26.399250, "lng": 49.984360}, //Dammam, Saudi Arabia
  "الطائف": {"lat": 21.437273, "lng": 40.512714}, //Taif, Mecca, Saudi Arabia
  "المدينة الصناعية الأولى": {
    "lat": 26.396790,
    "lng": 50.140400
  }, //Industrial city 1, Dammam, Saudi Arabia
  "جازان": {"lat": 16.909683, "lng": 42.567902}, //Jazan, Saudi Arabia
  "جدة": {"lat": 21.543333, "lng": 39.172779}, //Jeddah, Tihamah, Saudi Arabia
  "حائل": {"lat": 27.523647, "lng": 41.696632}, //Hail, Saudi Arabia
  "حفر الباطن": {
    "lat": 28.446959,
    "lng": 45.948944
  }, //Hafar Al Batin, Saudi Arabia
  "حرمة": {
    "lat": 25.994478,
    "lng": 45.318161
  }, //Harmah, Central Region, Saudi Arabia

  "خميس مشيط": {
    "lat": 18.329384,
    "lng": 42.759365
  }, //Khamis Mushait, Asir, Saudi Arabia
  "عنيزة": {
    "lat": 26.094088,
    "lng": 43.973454
  }, //Unayzah, Al Qassim, Saudi Arabia
  "سكاكا": {"lat": 29.953894, "lng": 40.197044}, //Sakaka, Al Jawf, Saudi Arabia
  "عرعر": {"lat": 30.983334, "lng": 41.016666}, //Arar, Saudi Arabia
  "ينبع": {"lat": 24.186848, "lng": 38.026428}, //Yanbu, Saudi Arabia
};
