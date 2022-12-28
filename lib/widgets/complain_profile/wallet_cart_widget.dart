import 'package:cmcp/main_theme/utils/AppConstant.dart';
import 'package:cmcp/model/complain.dart';
import 'package:cmcp/screens/complain_track_screen.dart';
import 'package:cmcp/theme_utils/T3widgets.dart';
import 'package:cmcp/theme_utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class WACardComponent extends StatelessWidget {
  static String tag = '/WACardComponent';
  final Complain compModel;

  WACardComponent({this.compModel});
  int fSizeLeft = 12;
  int fSizeRight = 14;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 8),
      decoration: boxDecorationRoundedWithShadow(
        30,
        backgroundColor: Colors.green.shade200,
        blurRadius: 10.0,
        spreadRadius: 4.0,
        shadowColor: t3_colorPrimary.withAlpha(60),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Complaint Code',
                  style: secondaryTextStyle(
                    color: t3_colorPrimary,
                    fontFamily: fontBold,
                    size: fSizeLeft,
                  )),
              Text(compModel.code,
                  style: boldTextStyle(
                    color: t3_colorPrimary,
                    size: fSizeRight,
                  )),
            ],
          ),
          divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Date',
                  style: secondaryTextStyle(
                    color: t3_colorPrimary,
                    fontFamily: fontBold,
                    size: fSizeLeft,
                  )),
              Text(compModel.createdAt,
                  style:
                      boldTextStyle(color: t3_colorPrimary, size: fSizeRight)),
            ],
          ),
          divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 45,
                child: Text('Complaint Related To',
                    style: secondaryTextStyle(
                      color: t3_colorPrimary,
                      fontFamily: fontBold,
                      size: fSizeLeft,
                    )),
              ),
              Expanded(
                flex: 55,
                child: FittedBox(
                  alignment: Alignment.centerRight,
                  fit: BoxFit.scaleDown,
                  child: Text(compModel.cat1,
                      textAlign: TextAlign.right,
                      style: boldTextStyle(
                          color: t3_colorPrimary, size: fSizeRight)),
                ),
              ),
            ],
          ),
          divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Status',
                  style: secondaryTextStyle(
                    color: t3_colorPrimary,
                    fontFamily: fontBold,
                    size: fSizeLeft,
                  )),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: compModel.status == 'In Progress'
                        ? webWarning
                        : compModel.status == 'Dropped'
                            ? webDanger
                            : compModel.status == 'commented'
                                ? webInfo
                                : webSuccess,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  compModel.status,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: fontBold,
                      fontSize: textSizeSMedium),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(ComplaintTrackScreen.tag,
                      arguments: compModel.id);
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: t3_colorPrimary,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'See Track Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: fontRegular,
                      fontSize: textSizeSmall,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ).onTap(() {});
  }
}
