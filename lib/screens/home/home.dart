import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/models/categories.dart';
import 'package:senam/screens/addAds.dart';
import 'package:senam/screens/home/cityFilter.dart';
import 'filters.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/adModel.dart';
import 'package:senam/screens/home/pleaseSignUp.dart';
import 'customDrawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  initState() {
    super.initState();
    bloc.onsearchingChange(false);
    bloc.changeCloseFilters(true);
  }
  dispose(){
                  bloc.onsearchingChange(false);
              bloc.onHomeSearchedAdCardsChange(null);
              bloc.onCTypeChange(null);
              bloc.selectcityIdFilter(null);
              bloc.selectcSortityFilter(null);
              bloc.onDataSearchedCountChange(null); ///////
              bloc.onCSubTypeChange(null);
              bloc.onDataSearchedCountChange(null);

    super.dispose();

  }
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // monitor network fetch
  //   Map<String, List> dataOfHome = await refreshHome();
  // if(mounted)
  //   setState(() {
  //     providers = dataOfHome['providers'];

  //     special = dataOfHome['special'];
  //     used = dataOfHome['used'];
  //   });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  TextEditingController _search = TextEditingController();
  bool _searching = false;
  @override
  Widget build(BuildContext context) {
    _searching = bloc.searching();
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        key: scaffold,
        endDrawer: CustomDrawer(
          scaffold: scaffold,
        ),
        body: SmartRefresher(
        onRefresh: ()async{
          await getHomeData();
              _refreshController.refreshCompleted();

          },
            header: BezierCircleHeader(),
            controller: _refreshController,
            enablePullDown: true,
        child: GestureDetector(
          onTap: () {
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
                  child: Column(
                    children: <Widget>[
                      //app bar
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [primaryAccent, primary]),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            )),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                MaterialButton(
                                  minWidth: 20,
                                  padding: EdgeInsets.all(0),
                                  splashColor: primaryAccent,
                                  onPressed: () {
                                                  bloc.onsearchingChange(false);
              bloc.onHomeSearchedAdCardsChange(null);
              bloc.onCTypeChange(null);
              bloc.selectcityIdFilter(null);
              bloc.selectcSortityFilter(null);
              bloc.onDataSearchedCountChange(null); ///////
              bloc.onCSubTypeChange(null);
              bloc.onDataSearchedCountChange(null);


                                    bloc.currentUser() != null
                                        ? Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => AddAds()))
                                        : showModalBottomSheet(
                                            context: context,
                                            builder: (context) => PleaseSignUp(
                                                  grey: true,
                                                ));
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    "الرئيسية",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                MaterialButton(
                                  minWidth: 20,
                                  padding: EdgeInsets.all(0),
                                  splashColor: primaryAccent,
                                  onPressed: () {
              bloc.onsearchingChange(false);
              bloc.onHomeSearchedAdCardsChange(null);
              bloc.onCTypeChange(null);
              bloc.selectcityIdFilter(null);
              bloc.selectcSortityFilter(null);
              bloc.onDataSearchedCountChange(null); ///////
              bloc.onCSubTypeChange(null);
              bloc.onDataSearchedCountChange(null);

                                    scaffold.currentState.openEndDrawer();
                                  },
                                  child: Icon(
                                    Icons.format_align_right,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 19,
                            ),
                            //////////////// search
                            Container(
                                height: 45,
                                width: bloc.size().width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: TextFormField(
                                  onChanged: (v) {
                                    bloc.sendsearchText(v);
                                    setState(() {
                                      if (v.isEmpty || v == null) {
                                        bloc.selectcityIdFilter(null);
                                        bloc.selectcSortityFilter(null);
                                        bloc.onsearchingChange(false);
                                        bloc.onDataSearchedCountChange(null);
                                      }
                                    });
                                  },
                                  controller: _search,
                                  style: TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                      hintText: "... اكتب هنا",
                                      suffixIcon: _search.text.isEmpty ||
                                              _search.text == null
                                          ? Icon(Icons.search)
                                          : null,
                                      prefixIcon: _search.text.isNotEmpty
                                          ? MaterialButton(
                                              splashColor: primaryAccent,
                                              minWidth: 20,
                                              padding: EdgeInsets.all(0),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15))),
                                              child: Icon(Icons.search),
                                              onPressed: () async {
                                                bloc.onsearchingChange(true);
                                                await search(
                                                    city_id: bloc
                                                        .selectedcityIdFilter(),
                                                    title: _search.text,
                                                    category_id:
                                                        bloc.cSubType(),
                                                    sort: bloc
                                                        .selectedSortFilter());
                                              },
                                            )
                                          : null,
                                      contentPadding: EdgeInsets.only(
                                          left: 10, right: 10, top: 12.5),
                                      border: InputBorder.none),
                                )),
                            /////////// end of serarch
                            Container(
                              alignment: Alignment.center,
                              width: bloc.size().width,
                              height: 20,
                              child: Image.asset(
                                "assets/images/pattern.png",
                                repeat: ImageRepeat.repeat,
                                fit: BoxFit.fill,
                              ),
                            )
                          ],
                        ),
                      ),
                      /////////////////////////// body

                      Expanded(
                        child: Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                _search.text.isEmpty || _search.text == null
                                    ? Column(
                                        children: <Widget>[
                                          Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              width: bloc.size().width,
                                              height: 50,
                                              child: StreamBuilder(
                                                stream: bloc.cTypeStream,
                                                builder: (context, s) =>
                                                    StreamBuilder(
                                                  stream:
                                                      bloc.mainCategoriesStream,
                                                  initialData: [
                                                    LoadingFullScreen()
                                                  ],
                                                  builder: (context,
                                                          snapshot) =>
                                                      ListView(
                                                          reverse: true,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          children:
                                                              snapshot.data),
                                                ),
                                              )),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          StreamBuilder(
                                              stream: bloc.cTypeStream,
                                              builder: (context, snapshot) {
                                                return snapshot.hasData &&
                                                        bloc
                                                                .subC()[snapshot
                                                                    .data]
                                                                .length >
                                                            0
                                                    ? Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20),
                                                        width:
                                                            bloc.size().width,
                                                        height: 50,
                                                        child: ListView.builder(
                                                          reverse: true,
                                                          itemCount: bloc
                                                              .subC()[
                                                                  snapshot.data]
                                                              .length,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemBuilder: (context,
                                                                  i) =>
                                                              HorizontalListSubItem(
                                                            category: bloc
                                                                    .subC()[
                                                                snapshot
                                                                    .data][i],
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox();
                                              }),
                                          StreamBuilder(
                                            stream:
                                                bloc.dataSearchedCountStream,
                                            builder: (context, s) => s.hasData
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        InkWell(
                                                          onTap: () {
                                                            bloc.changeCloseFilters(
                                                                true);
                                                            if (bloc.closeCityFilters ==
                                                                null)
                                                              bloc.changeCloseCityFilters(
                                                                  false);
                                                            bloc.changeCloseCityFilters(
                                                                !bloc
                                                                    .closeCityFilters);
                                                          },
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              StreamBuilder(
                                                                stream: bloc
                                                                    .selectedCityNameFilterStream,
                                                                builder: (context,
                                                                        city) =>
                                                                    Text(
                                                                  city.data !=
                                                                          null
                                                                      ? city
                                                                          .data
                                                                      : "المدينة",
                                                                  textDirection:
                                                                      TextDirection
                                                                          .rtl,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            8),
                                                                child: Icon(
                                                                  Icons
                                                                      .location_on,
                                                                  size: 20,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 15),
                                                          child: Text(
                                                              "عدد النتائج : ${s.data} إعلان"),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            bloc.changeCloseCityFilters(
                                                                true);

                                                            if (bloc.closeFilters ==
                                                                null)
                                                              bloc.changeCloseFilters(
                                                                  false);
                                                            bloc.changeCloseFilters(
                                                                !bloc
                                                                    .closeFilters);
                                                          },
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              StreamBuilder(
                                                                stream: bloc
                                                                    .selectedSortFilterStream,
                                                                builder: (context,
                                                                        sort) =>
                                                                    Text(
                                                                  sort.data !=
                                                                          null
                                                                      ? sort
                                                                          .data
                                                                      : "الترتيب",
                                                                  textDirection:
                                                                      TextDirection
                                                                          .rtl,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            5),
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_drop_down,
                                                                  size: 30,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ),
                                        ],
                                      )
                                    : StreamBuilder(
                                        stream: bloc.dataSearchedCountStream,
                                        builder: (context, s) => s.hasData
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: () {
                                                        bloc.changeCloseFilters(
                                                            true);
                                                        if (bloc.closeCityFilters ==
                                                            null)
                                                          bloc.changeCloseCityFilters(
                                                              false);
                                                        bloc.changeCloseCityFilters(
                                                            !bloc
                                                                .closeCityFilters);
                                                      },
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          StreamBuilder(
                                                            stream: bloc
                                                                .selectedCityNameFilterStream,
                                                            builder: (context,
                                                                    city) =>
                                                                Text(
                                                              city.data != null
                                                                  ? city.data
                                                                  : "المدينة",
                                                              textDirection:
                                                                  TextDirection
                                                                      .rtl,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 8),
                                                            child: Icon(
                                                              Icons.location_on,
                                                              size: 20,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 15),
                                                      child: Text(
                                                          "عدد النتائج : ${s.data} إعلان"),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        bloc.changeCloseCityFilters(
                                                            true);

                                                        if (bloc.closeFilters ==
                                                            null)
                                                          bloc.changeCloseFilters(
                                                              false);
                                                        bloc.changeCloseFilters(
                                                            !bloc.closeFilters);
                                                      },
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          StreamBuilder(
                                                            stream: bloc
                                                                .selectedSortFilterStream,
                                                            builder: (context,
                                                                    sort) =>
                                                                Text(
                                                              sort.data != null
                                                                  ? sort.data
                                                                  : "الترتيب",
                                                              textDirection:
                                                                  TextDirection
                                                                      .rtl,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 5),
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_drop_down,
                                                              size: 30,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : SizedBox(),
                                      ),
                                SizedBox(
                                  height: 10,
                                ),
                                StreamBuilder(
                                  stream: bloc.searchingStream,
                                  builder: (context, searching) {
                                    if (searching.data == true)
                                      return Container(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20, bottom: 20),
                                        child:StreamBuilder(
                                          stream: bloc.homeSearchedAdsStream,
                                          initialData: <Widget>[
                                            LoadingFullScreen()
                                          ],
                                          builder: (context, ss) =>  Column(
                                                children: ss.data ??
                                                    [LoadingFullScreen()]),
                                          ),
                                        
                                      );
                                    else
                                      return Container(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20, bottom: 20),
                                        child: StreamBuilder(
                                          stream: bloc.homeAdsStream,
                                          initialData: <Widget>[
                                            LoadingFullScreen()
                                          ],
                                          builder: (context, s) => Column(
                                              children: s.data ??
                                                  [
                                                    LoadingFullScreen()
                                                  ]), //s.data),
                                        ),
                                      );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<bool>(
                  stream: bloc.closeFiltersStream,
                  initialData: true,
                  builder: (context, s) => AnimatedPositioned(
                      bottom: s.data ? -500 : 0,
                      child: Filter(),
                      duration: mill0Second),
                ),
                StreamBuilder<bool>(
                  stream: bloc.closeCityFiltersStream,
                  initialData: true,
                  builder: (context, s) => AnimatedPositioned(
                      bottom: s.data ? -500 : 0,
                      child: CityFilter(),
                      duration: mill0Second),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class HorizontalListItem extends StatelessWidget {
  Category category;
  HorizontalListItem({this.category});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.cSubTypeStream,
      builder: (context, s) => Container(
        margin: EdgeInsets.only(left: 10),
        padding: EdgeInsets.all(0),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          onTap: () async {
            if (bloc.cType() == category.id) {
              bloc.onsearchingChange(false);
              bloc.onHomeSearchedAdCardsChange(null);
              bloc.onCTypeChange(null);
              bloc.selectcityIdFilter(null);
              bloc.selectcSortityFilter(null);
              bloc.onDataSearchedCountChange(null); ///////
              bloc.onCSubTypeChange(null);
              bloc.onDataSearchedCountChange(null);
            } else {
              if(bloc.homeDatas().subCategory[category.id].length>0)
              bloc.onCTypeChange(category.id);
              else
              {
                            bloc.onsearchingChange(true);
              bloc.onCTypeChange(category.id);
            await search(category_id: category.id);

              }
              
            }
          },
          child: StreamBuilder(
            stream: bloc.cTypeStream,
            builder: (context, s) => Container(
              margin: EdgeInsets.only(
                bottom: 2,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: bloc.cType() == category.id
                      ? accentPrimaryAccent
                      : Colors.white,
                  boxShadow: [BoxShadow(color: hint, offset: Offset(0, 1))]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    category.name,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        color: primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 25,
                    height: 35,
                    child: FadeInImage(
                      placeholder: AssetImage('assets/images/placeholder.gif'),
                      image: NetworkImage(
                         category.image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HorizontalListSubItem extends StatelessWidget {
  Category category;
  HorizontalListSubItem({this.category});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.cSubTypeStream,
      builder: (context, s) => Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.only(left: 10),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          onTap: () async {
            bloc.onsearchingChange(true);
            bloc.onCSubTypeChange(category.id);
            await search(category_id: category.id);
          },
          child: Container(
            margin: EdgeInsets.only(
              bottom: 2,
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: bloc.cSubType() == category.id
                    ? accentPrimaryAccent
                    : Colors.white,
                boxShadow: [BoxShadow(color: hint, offset: Offset(0, 1))]),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text(
                    category.name,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        color: primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: 25,
                  height: 35,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/placeholder.gif'),
                    image: NetworkImage(
                       category.image),
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
