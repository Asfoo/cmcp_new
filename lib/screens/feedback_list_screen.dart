import 'dart:io';
import 'package:cmcp/main_theme/utils/AppConstant.dart';
import 'package:cmcp/providers/complains.dart';
import 'package:cmcp/screens/complain_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:cmcp/theme_utils/T3widgets.dart';
import 'package:cmcp/widgets/app_bar.dart';
import 'package:cmcp/widgets/app_bar_gradient.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../main_theme/utils/AppWidget.dart';
// import '../theme_utils/T3widgets.dart';
import '../theme_utils/colors.dart';

class ComplainListScreen extends StatefulWidget {
  static const String tag = "/ComplainList";

  @override
  _ComplainListScreenState createState() => _ComplainListScreenState();
}

class _ComplainListScreenState extends State<ComplainListScreen> {
  var _isInit = true;
  var _isloading = false;
  var _error = '';
  String title;

  _loadComp() async {
    setState(() {
      _isloading = true;
      _error = '';
    });
    try {
      await Provider.of<Complains>(context, listen: false)
          .fetchComplains(title);
    } on SocketException {
      _error = 'No Internet connection';
    } catch (e) {
      print(e.toString());
      _error = 'Something went wrong!';
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      title = ModalRoute.of(context).settings.arguments as String;
      _loadComp();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<bool> _onWillPop() async {
    // Provider.of<Athletes>(context, listen: false).clearAll();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final complains = Provider.of<Complains>(context).complains;
    // final auth = Provider.of<Auth>(context, listen: false);
    changeStatusColor(Colors.transparent);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          color: Banking_app_Background,
          child: Stack(
            children: <Widget>[
              gradientAppBarTop(size.height),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: size.height * 0.14,
                  ),
                  _isloading
                      ? Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Expanded(
                          child: _error.isEmpty
                              ? complains.isEmpty
                                  ? Center(
                                      child: Text('No Feedbacks Available!'),
                                    )
                                  : Container(
                                      margin: EdgeInsets.all(5.0),
                                      decoration: boxDecorationWithShadow(
                                          backgroundColor:
                                              Banking_whitePureColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: ListView.builder(
                                          padding: EdgeInsets.only(bottom: 16),
                                          scrollDirection: Axis.vertical,
                                          itemCount: complains.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Column(children: [
                                              ListTile(
                                                leading: Container(
                                                  width: 55,
                                                  decoration: ShapeDecoration(
                                                    color:
                                                        Colors.green.shade100,
                                                    shape: CircleBorder(),
                                                  ),
                                                  // decoration: BoxDecoration(
                                                  //   image: DecorationImage(
                                                  //     image:
                                                  //         AssetImage(calendar_icon),
                                                  //     fit: BoxFit.cover,
                                                  //   ),
                                                  // ),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      complains[index]
                                                          .createdAt,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: secondaryTextStyle(
                                                          color:
                                                              t3_colorPrimary,
                                                          fontFamily: fontBold,
                                                          size: 12,
                                                          height: 1),
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  complains[index].code,
                                                  style:
                                                      boldTextStyle(size: 15),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      complains[index].subject,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'STATUS ',
                                                          style: boldTextStyle(
                                                              size: 12),
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(4),
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: complains[index]
                                                                              .status ==
                                                                          'In Progress'
                                                                      ? webWarning
                                                                      : complains[index].status ==
                                                                              'Dropped'
                                                                          ? webDanger
                                                                          : complains[index].status ==
                                                                                  'commented'
                                                                              ? webInfo
                                                                              : webSuccess,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                          child: Text(
                                                            complains[index]
                                                                .status,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    fontSemibold,
                                                                fontSize:
                                                                    textSizeSmall),
                                                          ),
                                                        )
                                                        // Chip(
                                                        //   label: Text('Resolved'),
                                                        //   labelStyle: TextStyle(
                                                        //       color: Colors.white),
                                                        //   backgroundColor:
                                                        //       webSuccess,
                                                        // )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                trailing: Container(
                                                  padding: EdgeInsets.all(3),
                                                  height: double.infinity,
                                                  decoration: ShapeDecoration(
                                                    color:
                                                        Colors.green.shade200,
                                                    shape: CircleBorder(),
                                                  ),
                                                  child: Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 15.0,
                                                    color: t3_colorPrimary,
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          ComplaintProfileScreen
                                                              .tag,
                                                          arguments:
                                                              complains[index]
                                                                  .id);
                                                },
                                              ),
                                              Divider(),
                                            ]);
                                          }),
                                    )
                              : errorContainer(_error, () {
                                  _loadComp();
                                }, size.width),
                        ),
                ],
              ),
              Column(
                children: [
                  MyAppBar(
                    titleName: 'Feedbacks',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
