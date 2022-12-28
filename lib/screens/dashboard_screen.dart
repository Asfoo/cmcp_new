import 'dart:io';

import 'package:cmcp/model/user.dart';
import 'package:cmcp/screens/category_screen.dart';
import 'package:cmcp/screens/complain_list_screen.dart';
import 'package:cmcp/screens/phone_verification_screen.dart';
import 'package:cmcp/screens/verification_screen.dart';
import 'package:cmcp/theme_utils/T3Images.dart';
import 'package:cmcp/widgets/mix_widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cmcp/providers/auth.dart';
import 'package:cmcp/widgets/app_bar.dart';
import 'package:cmcp/widgets/app_drawer.dart';
// import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../main_theme/utils/AppWidget.dart';
import '../theme_utils/T3widgets.dart';
import '../theme_utils/colors.dart';

import '../main.dart';

class DashboardScreen extends StatefulWidget {
  static var tag = "/";

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _error = '';

  checkUser(Auth auth) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      await auth.getDashboard();
      checkEmailDialog(auth.user);
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
    var auth = Provider.of<Auth>(context, listen: false);
    print('did work nami');
    if (auth.check) {
      if (_isInit) {
        print('test1');
        checkUser(auth);
      }
    }
    // else {
    //   if (_isInit) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) => checkPhoneDialog());
    //   }
    // }
    // if (auth.checkEmail) {
    //   if (_isInit) {

    //   }
    // }

    _isInit = false;

    super.didChangeDependencies();
  }

  // checkPhoneDialog() {
  //   Get.dialog(
  //       CustomDialog(
  //           image: ic_verify_email,
  //           title: 'Mobile number Verification',
  //           subTitle:
  //               'Respected Citizen, Your mobile number is not verified, please verify your number',
  //           okText: 'VERIFY NUMBER',
  //           cancelText: '',
  //           onPressedCancel: () => Get.back(),
  //           onPressedOk: () {
  //             Navigator.pushNamed(context, PhoneVerificationScreen.tag);
  //           }),
  //       barrierDismissible: false);
  // }

  checkEmailDialog(User user) {
    print('good');
    if (user.emailVerifiedAt.isEmptyOrNull && user.mVerify == '1') {
      print('good sss');
      showDialog(
        context: context,
        builder: (BuildContext acontext) => CustomDialog(
            image: ic_verify_email,
            title: 'Email Verification',
            subTitle:
                'Respected Citizen, Your email is not verified, please verify your email',
            okText: 'VERIFY EMAIL',
            cancelText: 'NOT NOW',
            onPressedCancel: () => Navigator.pop(acontext),
            onPressedOk: () {
              Navigator.pop(acontext);
              Navigator.pushNamed(context, VerificationScreen.tag);
            }),
      );
    }
  }

  @override
  void initState() {
    // FirebaseMessaging messaging = FirebaseMessaging.instance;
    // NotificationSettings settings = await messaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => DashboardScreen()));
      print('Message clicked!');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.transparent);
    var mQuery = MediaQuery.of(context).size;
    var dashboard = Provider.of<Auth>(context).dashboard;
    var auth = Provider.of<Auth>(context, listen: false);
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
                    titleName: 'Dashboard',
                    drawer: true,

                    // IconButton(
                    //   icon: Icon(
                    //     Icons.shopping_cart,
                    //     color: white,
                    //   ),
                    //   onPressed: () {
                    //     Navigator.of(context).pushNamed(CartScreen.tag);
                    //   },
                    // ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 16, right: 16, bottom: 16, top: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: defaultBoxShadow(),
                        color: Color(0xFFfbfbfb),
                      ),
                      padding: EdgeInsets.only(left: 20.0, right: 20),
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : _error.isEmpty
                              ? Consumer<Auth>(
                                  builder: (_, auth, ch) =>
                                      auth.user.mVerify == '0'
                                          ? Center(
                                              child:
                                                  phoneVerficationCol(context))
                                          : SingleChildScrollView(
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                width: double.infinity,
                                                child: Column(
                                                  children: [
                                                    _buildTile(
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(24.0),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                        'TOTAL COMPLAINTS',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.blueAccent)),
                                                                    Text(
                                                                        dashboard
                                                                            .total
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.blueAccent,
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: 34.0))
                                                                  ],
                                                                ),
                                                                Material(
                                                                    color: Colors
                                                                        .blue,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            24.0),
                                                                    child: Center(
                                                                        child: Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          16.0),
                                                                      child: Icon(
                                                                          Icons
                                                                              .timeline,
                                                                          color: Colors
                                                                              .white,
                                                                          size:
                                                                              30.0),
                                                                    )))
                                                              ]),
                                                        ), onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          ComplainListScreen
                                                              .tag,
                                                          arguments: 'Total');
                                                    }).paddingBottom(10),
                                                    _buildTile(
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(24.0),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                        'INPROGRESS',
                                                                        style: TextStyle(
                                                                            color:
                                                                                webWarning)),
                                                                    Text(
                                                                        dashboard
                                                                            .inprogress
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                webWarning,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            fontSize: 34.0))
                                                                  ],
                                                                ),
                                                                Material(
                                                                    color:
                                                                        webWarning,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            24.0),
                                                                    child: Center(
                                                                        child: Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          16.0),
                                                                      child: Icon(
                                                                          Icons
                                                                              .access_time,
                                                                          color: Colors
                                                                              .white,
                                                                          size:
                                                                              30.0),
                                                                    )))
                                                              ]),
                                                        ), onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          ComplainListScreen
                                                              .tag,
                                                          arguments:
                                                              'Inprogess');
                                                    }).paddingBottom(10),
                                                    _buildTile(
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(24.0),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                        'RESOLVED',
                                                                        style: TextStyle(
                                                                            color:
                                                                                webSuccess)),
                                                                    Text(
                                                                        dashboard
                                                                            .resolved
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                webSuccess,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            fontSize: 34.0))
                                                                  ],
                                                                ),
                                                                Material(
                                                                    color:
                                                                        webSuccess,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            24.0),
                                                                    child: Center(
                                                                        child: Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          16.0),
                                                                      child: Icon(
                                                                          Icons
                                                                              .check,
                                                                          color: Colors
                                                                              .white,
                                                                          size:
                                                                              30.0),
                                                                    )))
                                                              ]),
                                                        ), onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          ComplainListScreen
                                                              .tag,
                                                          arguments:
                                                              'Resolved');
                                                    }).paddingBottom(10),
                                                    _buildTile(
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(24.0),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                        'DROPPED',
                                                                        style: TextStyle(
                                                                            color:
                                                                                webDanger)),
                                                                    Text(
                                                                        dashboard
                                                                            .dropp
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                webDanger,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            fontSize: 34.0))
                                                                  ],
                                                                ),
                                                                Material(
                                                                    color:
                                                                        webDanger,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            24.0),
                                                                    child: Center(
                                                                        child: Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          16.0),
                                                                      child: Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color: Colors
                                                                              .white,
                                                                          size:
                                                                              30.0),
                                                                    )))
                                                              ]),
                                                        ), onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          ComplainListScreen
                                                              .tag,
                                                          arguments: 'Dropped');
                                                    }),
                                                  ],
                                                ),
                                              ),
                                            ))
                              : errorContainer(_error, () {
                                  var auth =
                                      Provider.of<Auth>(context, listen: false);
                                  checkUser(auth);
                                }, mQuery.width),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        drawer: AppDrawer(),
        floatingActionButton: Consumer<Auth>(
          builder: (_, auth, ch) => auth.user.mVerify == '0'
              ? Container()
              : FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CategoryScreen.tag);
                  },
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.green,
                ),
        ));
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }
}
