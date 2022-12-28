import 'package:cached_network_image/cached_network_image.dart';
import 'package:cmcp/main_theme/utils/AppConstant.dart';
import 'package:cmcp/widgets/mix_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cmcp/theme_utils/T3widgets.dart';
import 'package:cmcp/widgets/app_bar.dart';
import 'package:cmcp/widgets/app_bar_gradient.dart';
import 'package:nb_utils/nb_utils.dart';
import '../main_theme/utils/AppWidget.dart';
// import '../theme_utils/T3widgets.dart';
import '../theme_utils/colors.dart';
import '../theme_utils/strings.dart';

class ImageViewScreen extends StatefulWidget {
  static const String tag = "/showImage";

  @override
  _ImageViewScreenState createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  var _isInit = true;
  var _isloading = false;
  var _error = '';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final file = ModalRoute.of(context).settings.arguments as String;
    changeStatusColor(Colors.transparent);
    return Scaffold(
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
                                    child: Center(
                                      child: Container(
                                        child: Hero(
                                          tag: file,
                                          child: CachedNetworkImage(
                                            imageUrl: file,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    )),
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
                  titleName: 'Image',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
