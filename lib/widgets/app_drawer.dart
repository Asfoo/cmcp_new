import 'package:cmcp/screens/change_password_screen.dart';
import 'package:cmcp/screens/contact_us_screen.dart';
import 'package:cmcp/screens/profile_screen.dart';
import 'package:cmcp/screens/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cmcp/providers/auth.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../theme_utils/T3Images.dart';
import '../theme_utils/colors.dart';
import '../theme_utils/strings.dart';
import '../main.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppDrawerState();
  }
}

class AppDrawerState extends State<AppDrawer> {
  var selectedItem = -1;

  @override
  Widget build(BuildContext context) {
    // var user = Provider.of<Auth>(context).user;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height,
      child: Observer(
        builder: (_) => Drawer(
            elevation: 8,
            child:
                //  user != null ?
                Container(
              color: appStore.scaffoldBackground,
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: appStore.scaffoldBackground,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 70, right: 20),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                          decoration: BoxDecoration(
                              color: t3_colorPrimary,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(24.0),
                                  topRight: Radius.circular(24.0))),
                          /*User Profile*/
                          // child: Row(
                          //   children: <Widget>[
                          //     CircleAvatar(
                          //         backgroundImage: CachedNetworkImageProvider(
                          //           t3_profile,
                          //         ),
                          //         radius: 40),
                          //     SizedBox(width: 16),
                          //     Expanded(
                          //       child: Container(
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: <Widget>[
                          //             Text('CMDU',
                          //                 style: boldTextStyle(
                          //                     color: white, size: 20)),
                          //             SizedBox(height: 8),
                          //             Text('contact@cmdu.gob.pk',
                          //                 style:
                          //                     primaryTextStyle(color: white)),
                          //           ],
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // ),
                          child: Consumer<Auth>(
                            builder: (_, auth, ch) => Row(
                              children: <Widget>[
                                CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        '$user_image_path/${auth.user.avatar}'),
                                    radius: 40),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(auth.userName,
                                            style: boldTextStyle(
                                                color: white, size: 20)),
                                        SizedBox(height: 8),
                                        Text(auth.user.email,
                                            style:
                                                primaryTextStyle(color: white)),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      getDrawerItem(
                          t3_ic_user, t3_lbl_profile, 1, EditProfileScreen.tag),
                      getDrawerItem(ic_password, 'Change Password', 2,
                          ChangePasswordScreen.tag),
                      Consumer<Auth>(
                          builder: (_, auth, ch) =>
                              auth.user.emailVerifiedAt.isEmptyOrNull
                                  ? Row(
                                      children: [
                                        getDrawerItem(ic_mail, 'Verification',
                                            3, VerificationScreen.tag),
                                        Icon(
                                          Icons.error,
                                          color: redColor,
                                        )
                                      ],
                                    )
                                  : Container()),
                      getDrawerItem(
                          ic_contact_us, 'Contact Us', 4, ContactUsScreen.tag),
                      // getDrawerItem(t3_report, t3_lbl_report, 3),
                      // getDrawerItem(t3_settings, t3_lbl_settings, 4),
                      getDrawerItem(t3_logout, 'Sign Out', 4, ''),
                      SizedBox(height: 30),
                      Divider(color: t3_view_color, height: 1),
                      SizedBox(height: 30),
                      // getDrawerItem(t3_share, t3_lbl_share_and_invite, 6),
                      // getDrawerItem(t3_help, t3_lbl_help_and_feedback, 7),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            )
            // : Container(),
            ),
      ),
    );
  }

  Widget getDrawerItem(String icon, String name, int pos, String tag) {
    return GestureDetector(
      onTap: () {
        if (name == 'Sign Out') {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed('/');
          Provider.of<Auth>(context, listen: false).logout();
        } else {
          Navigator.of(context).popAndPushNamed(tag);
          print('good');
          setState(() {
            selectedItem = pos;
          });
        }
      },
      child: Container(
        color: selectedItem == pos
            ? t3_colorPrimary_light
            : appStore.scaffoldBackground,
        padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(icon,
                width: 20, height: 20, color: appStore.iconColor),
            SizedBox(width: 20),
            Text(name,
                style: primaryTextStyle(
                    color: selectedItem == pos
                        ? t3_colorPrimary
                        : appStore.textPrimaryColor,
                    size: 18))
          ],
        ),
      ),
    );
  }
}
