import 'package:cached_network_image/cached_network_image.dart';
import 'package:cmcp/main_theme/utils/AppConstant.dart';
import 'package:cmcp/screens/complain_screen.dart';
import 'package:cmcp/theme_utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:url_launcher/url_launcher.dart';

class CategoryItem extends StatelessWidget {
  final int id;
  final String icon;
  final String title_1;
  final String title_2;

  CategoryItem(this.id, this.title_1, this.title_2, this.icon);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ComplainScreen.tag,
            arguments: {'id': id.toString(), 'title': title_1});
      },
      // borderRadius: BorderRadius.circular(15),
      child: Container(
        // padding: EdgeInsets.only(left: 16, right: 16),
        // margin: EdgeInsets.only(left: 5, right: 5),
        // decoration: BoxDecoration(
        //   color: appStore.scaffoldBackground,
        //   boxShadow: defaultBoxShadow(
        //     shadowColor: shadowColorGlobal,
        //     blurRadius: 10.0,
        //   ),
        //   border: Border.all(color: Colors.white),
        //   borderRadius: BorderRadius.all(
        //     Radius.circular(16),
        //   ),
        // ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
                backgroundImage: CachedNetworkImageProvider('$cat1_icon/$icon'),
                radius: 30),
            // SvgPicture.asset(
            //   icon,
            //   color: t3_colorPrimary,
            //   width: width / 6,
            //   height: width / 6,
            // ),
            SizedBox(height: 5),
            Text(
              title_1,
              style: secondaryTextStyle(size: 12, fontFamily: fontMedium),
              textAlign: TextAlign.center,
            ),
            Text(
              title_2,
              style: secondaryTextStyle(size: 12, fontFamily: fontMedium),
              textAlign: TextAlign.center,
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
