import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cmcp/theme_utils/T3Images.dart';
import 'package:cmcp/theme_utils/colors.dart';
import 'package:cmcp/theme_utils/fontsSize.dart';

class ContactUsDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithShadow(
          backgroundColor: Banking_whitePureColor,
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Chief Minister Delivery Unit",
              style: primaryTextStyle(size: 18, fontFamily: fontMedium)),
          20.height,
          Row(
            children: [
              Icon(
                Icons.email_outlined,
                color: Banking_blueLightColor,
              ),
              15.width,
              Text('support@cmdu.gob.pk',
                  style: primaryTextStyle(
                      color: Banking_TextColorSecondary,
                      size: 16,
                      fontFamily: fontRegular)),
            ],
          ),
          15.height,
          Row(
            children: [
              Image.asset(Banking_ic_Call,
                  height: 20, width: 20, color: Banking_RedColor),
              15.width,
              Text('081-9203195',
                  style: primaryTextStyle(
                      color: Banking_TextColorSecondary,
                      size: 16,
                      fontFamily: fontRegular)),
            ],
          ),
          15.height,
          Row(
            children: [
              Image.asset(Banking_ic_Website,
                  height: 20, width: 20, color: Banking_blueColor),
              15.width,
              Text('cmdu.gob.pk',
                  style: primaryTextStyle(
                      color: Banking_TextColorSecondary,
                      size: 16,
                      fontFamily: fontRegular)),
            ],
          ),
          15.height,
          Row(
            children: [
              Image.asset(Banking_ic_Pin,
                  height: 20, width: 20, color: Banking_palColor),
              15.width,
              Flexible(
                child: Text('CM Secretariat Quetta, Balochistan',
                    maxLines: 2,
                    style: primaryTextStyle(
                        color: Banking_TextColorSecondary,
                        size: 16,
                        fontFamily: fontRegular)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
