import 'package:flutter/material.dart';
import 'package:senam/models/adModel.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
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
                      FiltersButtons(
                        ["الكل"],
                      )
                    ],
                  ))),
        ),
      ],
    );
  }
}

class FiltersButtons extends StatefulWidget {
  List<String> filters;
  FiltersButtons(this.filters);

  @override
  _FiltersButtonsState createState() => _FiltersButtonsState();
}

class _FiltersButtonsState extends State<FiltersButtons> {
  List<Widget> filters = [];
  List<Widget> filtersWidgets = [];
  List<Widget> fashionCard = [];

  refreshFiltersColumn() {
    setState(() {
      List<String> filt = [];
      List<String> filt_en = [];

      filt = ["الكل", "الأحدث","التقييم"];
      filt_en = ["all", "new","rate"];

      filters.clear();
      for (int i = 0; i < filt.length; i++) {
        filters.add(Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: InkWell(
            onTap: () async {
              bloc.selectFilter(i);

              if (i > 0) {
                bloc.selectcSortityFilter(filt_en[i]);
              await  bloc.selectcSortityFilter(filt[i]);
              } else {
                bloc.selectcSortityFilter(null);
              await  bloc.selectcSortityFilter("الكل");
              }

              await search(
                  city_id: bloc.selectedcityIdFilter(),
                  title: bloc.searchText(),
                  category_id: bloc.cSubType(),
                  sort: bloc.selectedSortFilter());

              bloc.changeCloseFilters(!bloc.closeFilters);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(filt[i],
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: bloc.selectedFilter() == i
                            ? FontWeight.bold
                            : FontWeight.w600)),
                SizedBox(
                  width: 6,
                ),
                StreamBuilder(
                  stream: bloc.selectFilterStream,
                  builder:(context,ssss)=> Icon(
                   bloc.selectedFilter() == i
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: primary,
                    size: 20,
                  ),
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
    return Column(
      children: filtersWidgets,
    );
  }
}
