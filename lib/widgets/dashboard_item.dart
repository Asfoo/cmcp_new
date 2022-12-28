import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../theme_utils/colors.dart';

class DashboardItem extends StatelessWidget {
  String icon;
  String title_1;
  String title_2;
  String url;

  DashboardItem(this.title_1, this.title_2, this.icon, this.url);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        if (title_1 == 'Website') {
          // _launchURL(context);
        } else {
          Navigator.of(context).pushNamed(url);
        }
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        // padding: EdgeInsets.only(left: 16, right: 16),
        // margin: EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
          color: appStore.scaffoldBackground,
          boxShadow: defaultBoxShadow(
            shadowColor: shadowColorGlobal,
            blurRadius: 10.0,
          ),
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              icon,
              color: t3_colorPrimary,
              width: width / 6,
              height: width / 6,
            ),
            SizedBox(height: 5),
            Text(
              title_1,
              style: primaryTextStyle(
                size: 14,
                weight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  // _launchURL(BuildContext ctx) async {
  //   String url = Provider.of<Auth>(ctx, listen: false).website;
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}
