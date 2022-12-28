// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cmcp/main_theme/utils/AppConstant.dart';
// import 'package:cmcp/screens/dashboard_screen.dart';
// import 'package:cmcp/widgets/mix_widgets.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:cmcp/providers/auth.dart';
// import 'package:cmcp/theme_utils/T3Images.dart';
// import 'package:cmcp/theme_utils/T3widgets.dart';
// import 'package:cmcp/widgets/app_bar.dart';
// import 'package:cmcp/widgets/app_bar_gradient.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:provider/provider.dart';
// import '../main_theme/utils/AppWidget.dart';
// // import '../theme_utils/T3widgets.dart';
// import '../theme_utils/colors.dart';
// import '../theme_utils/strings.dart';

// class RegistrationScreen extends StatefulWidget {
//   static const String tag = "/Registration";

//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   var _isInit = true;
//   var _isloading = false;
//   var _error = '';

//   // _loadAthlete() async {
//   //   setState(() {
//   //     _isloading = true;
//   //     _error = '';
//   //   });
//   //   try {
//   //     await Provider.of<Athletes>(context, listen: false).fetchAthlete();
//   //   } on SocketException {
//   //     _error = 'No Internet connection';
//   //   } catch (e) {
//   //     print(e.toString());
//   //     _error = 'Something went wrong!';
//   //   }
//   //   setState(() {
//   //     _isloading = false;
//   //   });
//   // }

//   @override
//   void didChangeDependencies() {
//     if (_isInit) {
//       // _loadAthlete();
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   Future<bool> _onWillPop() async {
//     // Provider.of<Athletes>(context, listen: false).clearAll();
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     // final athletes = Provider.of<Athletes>(context).athlete;
//     final auth = Provider.of<Auth>(context, listen: false);
//     changeStatusColor(Colors.transparent);
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         body: Container(
//           color: complain_app_Background,
//           child: Stack(
//             children: <Widget>[
//               gradientAppBarTop(size.height),
//               Column(
//                 children: <Widget>[
//                   SizedBox(
//                     height: size.height * 0.14,
//                   ),
//                   _isloading
//                       ? Expanded(
//                           child: Center(
//                             child: CircularProgressIndicator(),
//                           ),
//                         )
//                       : Expanded(
//                           child: _error.isEmpty
//                               ? SingleChildScrollView(
//                                   child: Container(
//                                       child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       cTextLabel('NAME', 'نام'),
//                                       padTextField(
//                                         child: padTextField(
//                                             child: comEditTextStyle(
//                                           hintText: 'Enter full name here',
//                                         )),
//                                       ),
//                                       Divider(
//                                         thickness: 1,
//                                       ),
//                                       cTextLabel('EMAIL', 'ای میل'),
//                                       padTextField(
//                                         child: padTextField(
//                                             child: comEditTextStyle(
//                                           hintText: 'Enter email here',
//                                         )),
//                                       ),
//                                       cTextLabel('CNIC #', 'شناختی کارڈ نمبر'),
//                                       padTextField(
//                                         child: padTextField(
//                                             child: comEditTextStyle(
//                                           hintText: 'Enter cnic number here',
//                                         )),
//                                       ),
//                                       cTextLabel('GENDER', 'صنف'),
//                                       padTextField(
//                                         child: searchDropDown(
//                                             itemList: [
//                                               'Male',
//                                               'Female',
//                                               'Other',
//                                             ],
//                                             hint: 'Select Gender',
//                                             mode: Mode.MENU,
//                                             showSearch: false),
//                                       ),
//                                       Divider(
//                                         thickness: 1,
//                                       ),
//                                       cTextLabel('ADDRESS', 'پتہ'),
//                                       padTextField(
//                                           child: comEditTextStyle(
//                                         hintText: 'Enter address here',
//                                         maxline: 4,
//                                       )),
//                                       Divider(
//                                         thickness: 1,
//                                       ),
//                                       cTextLabel('DISTRICT', 'ضلع'),
//                                       padTextField(
//                                         child: searchDropDown(itemList: [
//                                           'Quetta',
//                                           'Kharan',
//                                           'Dera Bugti',
//                                         ], hint: 'Select District'),
//                                       ),
//                                       Divider(
//                                         thickness: 1,
//                                       ),
//                                       Padding(
//                                         padding:
//                                             EdgeInsets.fromLTRB(30, 0, 30, 10),
//                                         child: T3AppButton(
//                                             textContent: 'REGISTER',
//                                             onPressed: () {
//                                               toast('Successfully Registered');
//                                               Navigator.pushReplacementNamed(
//                                                   context, DashboardScreen.tag);
//                                             }),
//                                       ),
//                                     ],
//                                   )),
//                                 )
//                               : errorContainer(_error, () {
//                                   // _loadAthlete();
//                                 }, size.width),
//                         ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   MyAppBar(
//                     titleName: 'Registration',

//                     // actions: TextButton.icon(
//                     //   onPressed: () {},
//                     //   icon: Icon(Icons.add),
//                     //   label: Text('Add', style: TextStyle(color: t3White),),
//                     // ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
