import 'dart:io';

import 'package:cmcp/main_theme/utils/AppConstant.dart';
import 'package:cmcp/main_theme/utils/custom_stepper.dart';
import 'package:cmcp/providers/complains.dart';
import 'package:cmcp/theme_utils/strings.dart';
import 'package:cmcp/widgets/mix_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cmcp/theme_utils/T3widgets.dart';
import 'package:cmcp/widgets/app_bar.dart';
import 'package:cmcp/widgets/app_bar_gradient.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../main_theme/utils/AppWidget.dart';
import '../theme_utils/colors.dart';

class ComplaintTrackScreen extends StatefulWidget {
  static const String tag = "/ComplaintTrack";

  @override
  _ComplaintTrackScreenState createState() => _ComplaintTrackScreenState();
}

class _ComplaintTrackScreenState extends State<ComplaintTrackScreen> {
  var _isInit = true;
  var _isloading = false;
  var _error = '';
  int currStep = 0;
  int trackId;
  _loadTrack() async {
    setState(() {
      _isloading = true;
      _error = '';
    });
    try {
      await Provider.of<Complains>(context, listen: false).fetchTrack(trackId);
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
      trackId = ModalRoute.of(context).settings.arguments as int;
      _loadTrack();
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
    var tracks = Provider.of<Complains>(context, listen: false).tracks;
    List<CustomStep> steps2 = tracks
        .asMap()
        .map((i, track) => MapEntry(
              i,
              CustomStep(
                  title: Row(
                    children: [
                      Text(
                        track.createdAt,
                        style: boldTextStyle(color: t3_colorPrimary, size: 14),
                      ),
                      10.width,
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: track.status == 'In Progress'
                                ? webWarning
                                : track.status == 'Dropped'
                                    ? webDanger
                                    : track.status == 'Forwarded'
                                        ? webInfo
                                        : track.status == 'Commented'
                                            ? webInfo
                                            : webSuccess,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          track.status,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: fontSemibold,
                              fontSize: textSizeSmall),
                        ),
                      )
                    ],
                  ),
                  subtitle: Text(track.dept,
                      style:
                          primaryTextStyle(color: textPrimaryColor, size: 14)),
                  content: !track.remarks.isEmptyOrNull
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'REMARKS',
                              style: TextStyle(
                                  color: t3_colorPrimary,
                                  fontFamily: fontBold,
                                  fontSize: textSizeSmall),
                            ),
                            Text(
                              track.remarks,
                              style:
                                  secondaryTextStyle(color: textSecondaryColor),
                            ),
                            8.height,
                            if (!track.attach.isEmptyOrNull)
                              Text(
                                'ATTACHMENTS',
                                style: TextStyle(
                                    color: t3_colorPrimary,
                                    fontFamily: fontBold,
                                    fontSize: textSizeSmall),
                              ),
                            if (!track.attach.isEmptyOrNull)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ...track.attach
                                      .split(',')
                                      .map((file_path) => attachPreview(
                                          file: '$track_attach_path/$file_path',
                                          size: size,
                                          context: context))
                                      .toList()
                                ],
                              ).paddingTop(8),
                          ],
                        )
                      : Container(
                          child: mediaIcons(
                              color: white,
                              icon: Icons.hourglass_bottom,
                              text: 'Be Patient',
                              iconSIze: 50,
                              iconColor: Colors.grey),
                        ),
                  state: CustomStepState.indexed,
                  isActive: currStep == i),
            ))
        .values
        .toList();
    List<CustomStep> steps = [
      CustomStep(
          title: Row(
            children: [
              Text(
                "11 Nov 2021",
                style: boldTextStyle(color: t3_colorPrimary, size: 14),
              ),
              10.width,
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: webWarning, borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'In Progress',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: fontSemibold,
                      fontSize: textSizeSmall),
                ),
              )
            ],
          ),
          subtitle: Text("Director, Metropolitan",
              style: primaryTextStyle(color: textPrimaryColor, size: 14)),
          isActive: currStep == 0,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'REMARKS',
                style: TextStyle(
                    color: t3_colorPrimary,
                    fontFamily: fontBold,
                    fontSize: textSizeSmall),
              ),
              Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                style: secondaryTextStyle(color: textSecondaryColor),
              ),
              8.height,
              Text(
                'ATTACHMENTS',
                style: TextStyle(
                    color: t3_colorPrimary,
                    fontFamily: fontBold,
                    fontSize: textSizeSmall),
              ),
            ],
          ),
          state: CustomStepState.indexed),
      CustomStep(
          title: Row(
            children: [
              Text(
                "10 Nov 2021",
                style: boldTextStyle(color: t3_colorPrimary, size: 14),
              ),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: webPrimary, borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'Forwared',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: fontSemibold,
                      fontSize: textSizeSmall),
                ),
              )
            ],
          ),
          subtitle: Text("DC Complain, CMDU",
              style: primaryTextStyle(color: textPrimaryColor, size: 14)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'REMARKS',
                style: TextStyle(
                    color: t3_colorPrimary,
                    fontFamily: fontBold,
                    fontSize: textSizeSmall),
              ),
              Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                  style: secondaryTextStyle(color: textSecondaryColor)),
            ],
          ),
          state: CustomStepState.indexed,
          isActive: currStep == 1),
    ];
    // final compId =
    //     ModalRoute.of(context).settings.arguments as int; // is the id!
    // final loadedComp = Provider.of<Complains>(
    //   context,
    // ).findById(compId);
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
                              ? Container(
                                  margin: EdgeInsets.all(5.0),
                                  decoration: boxDecorationWithShadow(
                                      backgroundColor: Banking_whitePureColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: CustomStepper(
                                    steps: steps2,
                                    physics: BouncingScrollPhysics(),
                                    type: CustomStepperType.vertical,
                                    currentStep: this.currStep,
                                    controlsBuilder: ( context,
                                       details) {
                                      return Row(
                                        children: <Widget>[
                                          SizedBox(),
                                          SizedBox(),

                                        ], // <Widget>[]
                                      ); //
                                    },
                                    onStepContinue: () {
                                      setState(() {
                                        if (currStep < steps.length - 1) {
                                          currStep = currStep + 1;
                                        } else {
                                          //currStep = 0;
                                          finish(context);
                                        }
                                      });
                                    },
                                    onStepCancel: () {
                                      setState(() {
                                        if (currStep > 0) {
                                          currStep = currStep - 1;
                                        } else {
                                          currStep = 0;
                                        }
                                      });
                                    },
                                    onStepTapped: (step) {
                                      setState(() {
                                        currStep = step;
                                      });
                                    },
                                  ),
                                )
                              : errorContainer(_error, () {
                                  _loadTrack();
                                }, size.width),
                        ),
                ],
              ),
              Column(
                children: [
                  MyAppBar(
                    titleName: 'Complaints Track',
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
