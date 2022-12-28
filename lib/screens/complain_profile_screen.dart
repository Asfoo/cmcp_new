import 'package:cmcp/main_theme/utils/AppConstant.dart';
import 'package:cmcp/providers/complains.dart';
import 'package:cmcp/screens/new_feedback_screen.dart';
import 'package:cmcp/widgets/complain_profile/wallet_cart_widget.dart';
import 'package:cmcp/widgets/mix_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cmcp/theme_utils/T3widgets.dart';
import 'package:cmcp/widgets/app_bar.dart';
import 'package:cmcp/widgets/app_bar_gradient.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../main_theme/utils/AppWidget.dart';
// import '../theme_utils/T3widgets.dart';
import '../theme_utils/colors.dart';
import '../theme_utils/strings.dart';

class ComplaintProfileScreen extends StatefulWidget {
  static const String tag = "/ComplaintProfile";

  @override
  _ComplaintProfileScreenState createState() => _ComplaintProfileScreenState();
}

class _ComplaintProfileScreenState extends State<ComplaintProfileScreen> {
  var _isInit = true;
  var _isloading = false;
  var _error = '';

  // _loadAthlete() async {
  //   setState(() {
  //     _isloading = true;
  //     _error = '';
  //   });
  //   try {
  //     await Provider.of<Athletes>(context, listen: false).fetchAthlete();
  //   } on SocketException {
  //     _error = 'No Internet connection';
  //   } catch (e) {
  //     print(e.toString());
  //     _error = 'Something went wrong!';
  //   }
  //   setState(() {
  //     _isloading = false;
  //   });
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // _loadAthlete();
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
    final title = ModalRoute.of(context).settings.arguments as int;
    final compId =
        ModalRoute.of(context).settings.arguments as int; // is the id!
    final loadedComp = Provider.of<Complains>(
      context,
    ).findById(compId);
    changeStatusColor(Colors.transparent);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          color: complain_app_Background,
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
                              ? SingleChildScrollView(
                                  child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    decoration: boxDecorationWithShadow(
                                        backgroundColor: Banking_whitePureColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        WACardComponent(
                                          compModel: loadedComp,
                                        ),
                                        cTextNLabel('SUBJECT', 'مضمون',
                                            loadedComp.subject),
                                        cTextNLabel('CATEGORY', 'زمرہ',
                                            loadedComp.cat2),
                                        cTextNLabel('CATEGORY TWO', 'زمرہ',
                                            loadedComp.cat3),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 47,
                                              child: cTextNLabel('DISTRICT',
                                                  'ضلع', loadedComp.district),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: VerticalDivider(
                                                thickness: 2,
                                                color: gray,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 47,
                                              child: cTextNLabel('TEHSIL',
                                                  'تحصیل', loadedComp.tehsil),
                                            ),
                                          ],
                                        ),
                                        cTextNLabel(
                                            'COMPLAINT DETAILS',
                                            'شکایت کی تفصیلات',
                                            loadedComp.detail),
                                        cTextNLabel('COMPLAINT ADDRESS',
                                            'شکایت کا پتہ', loadedComp.address),
                                        cTextNLabel('GPS LOCATION', '',
                                            loadedComp.gpsLocation),
                                        Text(
                                          'ATTACHMENTS',
                                          style: TextStyle(
                                              color: t3_colorPrimary,
                                              fontFamily: fontBold,
                                              fontSize: textSizeSmall),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: loadedComp.attach.isEmptyOrNull
                                              ? mediaIcons(
                                                  color: white,
                                                  icon: Icons.file_present,
                                                  text: 'No Attachments found',
                                                  iconSIze: 50,
                                                  iconColor: Colors.red)
                                              : Row(
                                                  children: [
                                                    ...loadedComp.attach
                                                        .split(',')
                                                        .map((file_path) =>
                                                            attachPreview(
                                                                file:
                                                                    '$user_attach_path/$file_path',
                                                                size: size,
                                                                context:
                                                                    context))
                                                        .toList()
                                                  ],
                                                ),
                                        ).paddingBottom(10),
                                        if (loadedComp.status == 'Resolved' &&
                                            loadedComp.feedbackStatus == 0)
                                          T3AppButton(
                                            textContent: 'FEEDBACK',
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                  NewFeedbackScreen.tag,
                                                  arguments: loadedComp.id);
                                            },
                                          ),
                                      ],
                                    ).paddingOnly(left: 15, right: 15),
                                  ),
                                )
                              : errorContainer(_error, () {
                                  // _loadAthlete();
                                }, size.width),
                        ),
                ],
              ),
              Column(
                children: [
                  MyAppBar(
                    titleName: 'Complaints Details',
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

Widget cTextNLabel(String eng, String urd, String text) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            eng,
            style: TextStyle(
                color: t3_colorPrimary,
                fontFamily: fontBold,
                fontSize: textSizeSmall),
          ),
          Text(
            urd,
            style: TextStyle(
                color: t3_colorPrimary,
                fontFamily: fontBold,
                fontSize: textSizeSmall),
          ),
        ],
      ),
      Text(
        text,
        textAlign: TextAlign.justify,
        style: secondaryTextStyle(color: gray_text_color),
      ).paddingOnly(top: 2, bottom: 2),
      Divider()
    ],
  );
}
