import 'package:cached_network_image/cached_network_image.dart';
import 'package:cmcp/main_theme/utils/AppWidget.dart';
import 'package:cmcp/model/keyValue.dart';
import 'package:cmcp/screens/image_view_screen.dart';
import 'package:cmcp/screens/phone_verification_screen.dart';
import 'package:cmcp/theme_utils/colors.dart';
import 'package:cmcp/theme_utils/fontsSize.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

// text widget english and urdu
Widget cTextLabel(String eng, String urd, {bool required = true}) {
  return Padding(
    padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              eng,
              style: TextStyle(
                  color: t3_colorPrimary,
                  fontFamily: fontBold,
                  fontSize: textSizeSmall),
            ),
            if (required)
              Text(
                ' *',
                style: TextStyle(
                    color: redColor,
                    fontFamily: fontBold,
                    fontSize: textSizeSmall),
              ),
          ],
        ),
        Text(
          urd,
          style: TextStyle(
              color: t3_colorPrimary, fontFamily: fontBold, fontSize: 13.0),
        ),
      ],
    ),
  );
}

Padding padTextField({Widget child}) {
  return Padding(
      padding: EdgeInsets.only(left: 12, right: 12, bottom: 3, top: 0),
      child: child);
}

// dropdown seachable feild
Widget searchDropDown(
    {List<KeyValueModel> itemList,
    String hint,
    Function value,
    Function validator,
    KeyValueModel selectedItem,
    Mode mode = Mode.DIALOG,
    bool showSearch = true,
    Key key = null}) {
  return DropdownSearch<KeyValueModel>(
    key: key == null ? DropdownSearch().key : key,
    mode: mode,
    items: itemList,
    onChanged: value,
    selectedItem:
        selectedItem == null ? DropdownSearch().selectedItem : selectedItem,
    validator: validator,
    showSearchBox: showSearch,
    dropdownSearchDecoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(26, 2, 4, 2),
      hintText: hint,
      hintStyle: secondaryTextStyle(),
      filled: true,
      fillColor: white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: t11_edit_text_color, width: 0.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: t11_edit_text_color, width: 0.0),
      ),
    ),
  );
}

Container attachPreview({String file, var size, BuildContext context}) {
  String ext = file.split('.').last;
  return Container(
    key: UniqueKey(),
    margin: const EdgeInsets.only(left: 10),
    width: 70,
    child: Stack(
      children: [
        Container(
          height: size.height * 0.12,
          width: size.width * 0.25,
          child: (ext == 'jpg' || ext == 'png')
              ? FittedBox(
                  fit: BoxFit.fill,
                  child: Hero(
                    tag: file,
                    child: CachedNetworkImage(
                      imageUrl: file,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                )
              : (ext == 'doc' || ext == 'docx' || ext == 'pdf' || ext == 'xlsx')
                  ? const Icon(Icons.insert_drive_file,
                      size: 60, color: Colors.grey)
                  : const Icon(Icons.video_collection,
                      size: 60, color: Colors.grey),
        ).onTap(() {
          launchURL(file, context);
        }),
      ],
    ),
  );
}

showLoading() {
  Get.defaultDialog(
    title: '',
    content: Padding(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Please wait....",
              style: primaryTextStyle(color: textPrimaryColor)),
        ],
      ),
    ),
    barrierDismissible: false,
  );
}

showGetDialog() {
  Get.defaultDialog(
    title: '',
    content: Padding(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Please wait....",
              style: primaryTextStyle(color: textPrimaryColor)),
        ],
      ),
    ),
    barrierDismissible: false,
  );
}

launchURL(String url, BuildContext context) async {
  String ext = url.split('.').last;
  if (ext == 'jpg' || ext == 'png') {
    Navigator.of(context).pushNamed(ImageViewScreen.tag, arguments: url);
  } else {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      toast('Could not open', textColor: redColor);
    }
  }
}

// groupbuttons

class ButtonGroup extends StatelessWidget {
  static const double _radius = 10.0;
  static const double _outerPadding = 2.0;

  final int current;
  final List<String> titles;
  final ValueChanged<int> onTab;
  final Color color;
  final Color secondaryColor;

  const ButtonGroup({
    Key key,
    this.titles,
    this.onTab,
    int current,
    Color color,
    Color secondaryColor,
  })  : assert(titles != null),
        current = current ?? 0,
        color = color ?? Colors.blue,
        secondaryColor = secondaryColor ?? Colors.white,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(_radius),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(_outerPadding),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_radius - _outerPadding),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _buttonList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buttonList() {
    final buttons = <Widget>[];
    for (int i = 0; i < titles.length; i++) {
      buttons.add(_button(titles[i], i));
      buttons.add(
        VerticalDivider(
          width: 1.0,
          color: (i == current || i + 1 == current) ? color : secondaryColor,
          thickness: 1.5,
          indent: 5.0,
          endIndent: 5.0,
        ),
      );
    }
    buttons.removeLast();
    return buttons;
  }

  Widget _button(String title, int index) {
    if (index == this.current)
      return Expanded(child: _activeButton(title));
    else
      return Expanded(child: _inActiveButton(title, index));
  }

  Widget _activeButton(String title) => TextButton(
        style: TextButton.styleFrom(
          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          disabledBackgroundColor: secondaryColor,
          disabledForegroundColor: color,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
        onPressed: null,
      );

  Widget _inActiveButton(String title, int index) => TextButton(
        style: TextButton.styleFrom(
          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          if (onTab != null) onTab(index);
        },
      );
}

Container validationError(String error) {
  return Container(
    padding: EdgeInsets.only(left: 35, top: 5),
    child: Text(
      error,
      style: TextStyle(color: webDanger, fontSize: textSizeSmall),
    ),
  );
}

Column phoneVerficationCol(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Text('Mobile number Verification',
          style: boldTextStyle(color: redColor, size: 18)),
      16.height,
      Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Text(
            'Respected Citizen, Your mobile number is not verified, please verify your number',
            style: secondaryTextStyle(color: errorColor)),
      ),
      16.height,
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration:
                    boxDecoration(bgColor: t3_colorPrimaryDark, radius: 8),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        // WidgetSpan(
                        //     child: Padding(
                        //         padding: EdgeInsets.only(right: 8.0),
                        //         child: Icon(Icons.check,
                        //             color: Colors.white, size: 18))),
                        TextSpan(
                            text: 'VERIFY NUMBER',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontFamily: fontRegular)),
                      ],
                    ),
                  ),
                ),
              ).onTap(() {
                Navigator.pushNamed(context, PhoneVerificationScreen.tag);
              }),
            )
          ],
        ),
      ),
      16.height,
    ],
  );
}
