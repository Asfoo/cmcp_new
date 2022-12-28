import 'package:cmcp/widgets/contact_us/contact_us_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../main_theme/utils/AppWidget.dart';
import '../theme_utils/colors.dart';

class ContactUsScreen extends StatefulWidget {
  static var tag = "/contact_us";
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.transparent);
    var mQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Banking_app_Background,
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            30.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.arrow_back, size: 30, color: Banking_blackColor)
                    .onTap(
                  () {
                    finish(context);
                  },
                ),
                30.height,
                Text('Contact Us',
                    style: boldTextStyle(
                        size: 30, color: Banking_TextColorPrimary)),
              ],
            ),
            20.height,
            SingleChildScrollView(child: ContactUsDetail())
          ],
        ),
      ),
    );
  }
}
