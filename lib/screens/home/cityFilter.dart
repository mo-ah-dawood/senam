import 'package:flutter/material.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';
import 'package:senam/models/adModel.dart';

class CityFilter extends StatefulWidget {
  @override
  _CityFilterState createState() => _CityFilterState();
}

class _CityFilterState extends State<CityFilter> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: bloc.size().width,
          color: Colors.transparent,
          child: Container(
              width: bloc.size().width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(45),
                      topLeft: Radius.circular(45))),
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Center(
                          child: Text("ترتيب حسب",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))),
                      SizedBox(
                        height: 10,
                      ),
                      CityFiltersButtons()
                    ],
                  ))),
        ),
      ],
    );
  }
}

class CityFiltersButtons extends StatefulWidget {
  @override
  _CityFiltersButtonsState createState() => _CityFiltersButtonsState();
}

class _CityFiltersButtonsState extends State<CityFiltersButtons> {
  List<Widget> filters = [];
  List<Widget> filtersWidgets = [];
  List<Widget> fashionCard = [];
  refreshFiltersColumn() {
    setState(() {
      List<String> filt = [];
      filt.clear();
      filt.add("الكل");
      for (int i = 0;
          i < bloc.citiesList().length; //bloc.categories().length;
          i++) {
        filt.add(bloc.citiesList()[i].name
            //bloc.categories()[i].ad.title
            );
      }
      filters.clear();
      for (int i = 0; i < filt.length; i++) {
        filters.add(Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: InkWell(
            onTap: () async {
              setState(() {
                bloc.selectcityFilter(i);
                if (i > 0) {
                  bloc.selectcityIdFilter(bloc.citiesList()[i - 1].id);
                  bloc.selectcityNameFilter(bloc.citiesList()[i - 1].name);
                } else {
                  bloc.selectcityIdFilter(null);
                  bloc.selectcityNameFilter("الكل");
                }
              });
              await search(
                  city_id: bloc.selectedcityIdFilter(),
                  category_id: bloc.cSubType(),
                  title: bloc.searchText(),
                  sort: bloc.selectedSortFilter());
              bloc.changeCloseCityFilters(true);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(filt[i],
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: bloc.selectedcityFilter() == i
                            ? FontWeight.bold
                            : FontWeight.w600)),
                SizedBox(
                  width: 6,
                ),
                Icon(
                  bloc.selectedcityFilter() == i
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ));
        filtersWidgets = filters;
      }
    });
  }

  @override
  void initState() {
    refreshFiltersColumn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      filtersWidgets.clear();
      refreshFiltersColumn();
    });
    return Container(
      width: bloc.size().width,
      height: 200,
      child: SingleChildScrollView(
        child: Column(
          children: filtersWidgets,
        ),
      ),
    );
  }
}
