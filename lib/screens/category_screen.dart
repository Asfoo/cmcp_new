import 'dart:io';
import 'package:cmcp/providers/complains.dart';
import 'package:cmcp/widgets/category_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cmcp/widgets/app_bar.dart';
import 'package:cmcp/widgets/app_drawer.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../main_theme/utils/AppWidget.dart';
import '../theme_utils/T3widgets.dart';
import '../theme_utils/colors.dart';

import '../main.dart';

class CategoryScreen extends StatefulWidget {
  static var tag = "/category";

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _error = '';

  _loadCat1() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      await Provider.of<Complains>(context, listen: false).fetchcat1();
    } on SocketException {
      _error = 'No Internet connection';
    } catch (e) {
      print(e.toString());
      _error = 'Something went wrong!';
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _loadCat1();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.transparent);
    var mQuery = MediaQuery.of(context).size;
    var loadCats = Provider.of<Complains>(context, listen: false).categories;
    return Scaffold(
      body: Container(
        color: appStore.scaffoldBackground,
        child: Stack(
          children: <Widget>[
            Container(
              height: (mQuery.height) / 3.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[t3_colorPrimary, t3_colorPrimaryDark]),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0)),
              ),
            ),
            Column(
              children: <Widget>[
                MyAppBar(
                  titleName: 'Select Category',
                  drawer: false,
                ),
                Expanded(
                  child: Container(
                    margin:
                        EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: defaultBoxShadow(),
                      color: Color(0xFFfffFff),
                    ),
                    padding: EdgeInsets.only(left: 20.0, right: 20),
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : _error.isEmpty
                            ? Container(
                                padding: EdgeInsets.only(top: 10),
                                width: double.infinity,
                                child: GridView(
                                  scrollDirection: Axis.vertical,
                                  physics: ScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                  ),
                                  children: loadCats
                                      .map((dashData) => CategoryItem(
                                            dashData.id,
                                            dashData.title,
                                            dashData.titleUrdu,
                                            dashData.icon,
                                          ))
                                      .toList(),
                                ))
                            : errorContainer(_error, () {
                                _loadCat1();
                              }, mQuery.width),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
