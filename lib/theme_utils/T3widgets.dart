import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:nb_utils/nb_utils.dart';
import '../theme_utils/fontsSize.dart';
import 'package:cmcp/main_theme/utils/AppWidget.dart';
import 'T3Images.dart';
import 'colors.dart';

TextFormField quizEditTextStyle(
    {var hintText,
    Function validator,
    Function value,
    var initValue = '',
    isPassword = true,
    TextInputType textInputType = TextInputType.text,
    int maxline = 1,
    List<TextInputFormatter> inputFormatters = const [],
    Key key = null}) {
  return TextFormField(
    key: key,
    maxLines: maxline,
    initialValue: initValue,
    style: TextStyle(fontSize: textSizeMedium, fontFamily: fontRegular),
    obscureText: isPassword,
    keyboardType: textInputType,
    inputFormatters: inputFormatters,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(16, 22, 16, 22),
      hintText: hintText,
      border: InputBorder.none,
      hintStyle: TextStyle(color: quiz_textColorSecondary),
    ),
    validator: validator,
    onSaved: value,
  );
}

//  textfield
Widget comEditTextStyle({
  var hintText,
  Function validator,
  Function value,
  String initValue = '',
  isPassword = false,
  TextInputType textInputType = TextInputType.text,
  int maxline = 1,
  List<TextInputFormatter> inputFormatters = const [],
  TextInputAction textInputAction = TextInputAction.next,
  int maxLength = 200,
  bool showCounter = false,
  bool enabled = true,
  TextCapitalization textCapitalization = TextCapitalization.sentences,
  Key key = null,
  TextEditingController controller = null,
}) {
  return TextFormField(
    key: key == null ? TextFormField().key : key,
    controller: controller == null ? TextFormField().controller : controller,
    textCapitalization: textCapitalization,
    enabled: enabled,
    keyboardType: textInputType,
    textInputAction: textInputAction,
    validator: validator,
    onSaved: value,
    obscureText: isPassword,
    inputFormatters: inputFormatters,
    maxLines: maxline,
    maxLength: maxLength,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(26, 14, 4, 14),
      counterText: showCounter ? InputDecoration().counterText : '',
      hintText: hintText,
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

Widget comEditTextInit({
  var hintText,
  Function validator,
  Function value,
  String initValue = '',
  isPassword = false,
  TextInputType textInputType = TextInputType.text,
  int maxline = 1,
  List<TextInputFormatter> inputFormatters = const [],
  TextInputAction textInputAction = TextInputAction.next,
  TextCapitalization textCapitalization = TextCapitalization.sentences,
  Key key = null,
}) {
  return TextFormField(
    key: key == null ? TextFormField().key : key,
    initialValue:
        initValue.isEmptyOrNull ? TextFormField().initialValue : initValue,
    textCapitalization: textCapitalization,
    keyboardType: textInputType,
    textInputAction: textInputAction,
    validator: validator,
    onSaved: value,
    obscureText: isPassword,
    inputFormatters: inputFormatters,
    maxLines: maxline,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(26, 14, 4, 14),
      hintText: hintText,
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

Widget comEditTextPass(
    {var hintText,
    Function validator,
    Function value,
    var initValue = '',
    isPassword = false,
    TextInputType textInputType = TextInputType.text,
    int maxline = 1,
    List<TextInputFormatter> inputFormatters = const [],
    TextInputAction textInputAction = TextInputAction.next,
    bool confirmPass = false,
    TextEditingController controller,
    Widget suffix}) {
  return TextFormField(
    controller: confirmPass ? controller : TextFormField().controller,
    keyboardType: textInputType,
    textInputAction: textInputAction,
    validator: validator,
    onSaved: value,
    obscureText: isPassword,
    inputFormatters: inputFormatters,
    maxLines: maxline,
    decoration: InputDecoration(
      suffix: suffix ?? InputDecoration().suffix,
      contentPadding: EdgeInsets.fromLTRB(26, 14, 4, 14),
      hintText: hintText,
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

Widget comEditTextPrefix(
    {var hintText,
    Function validator,
    Function value,
    var initValue = '',
    isPassword = false,
    TextInputType textInputType = TextInputType.text,
    int maxline = 1,
    List<TextInputFormatter> inputFormatters = const [],
    TextInputAction textInputAction = TextInputAction.next,
    Widget prefixWidget,
    int maxLength = 200,
    bool showCounter = false,
    bool enabled = true,
    TextEditingController controller = null}) {
  return TextFormField(
    controller: controller == null ? TextFormField().controller : controller,
    maxLength: maxLength,
    keyboardType: textInputType,
    textInputAction: textInputAction,
    validator: validator,
    onSaved: value,
    obscureText: isPassword,
    inputFormatters: inputFormatters,
    maxLines: maxline,
    enabled: enabled,
    decoration: InputDecoration(
      counterText: showCounter ? InputDecoration().counterText : '',
      prefixIcon: prefixWidget,
      contentPadding: EdgeInsets.fromLTRB(26, 14, 4, 14),
      hintText: hintText,
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

Widget t11EditTextStyle(var hintText, TextFieldType keyboardType) {
  return AppTextField(
    textFieldType: keyboardType,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(26, 14, 4, 14),
      hintText: hintText,
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

Divider quizDivider() {
  return Divider(
    height: 1,
    color: t8_view_color,
    thickness: 1,
  );
}

class quizButton extends StatefulWidget {
  var textContent;

  //   var icon;
  VoidCallback onPressed;

  quizButton({
    @required this.textContent,
    @required this.onPressed,
    //   @required this.icon,
  });

  @override
  quizButtonState createState() => quizButtonState();
}

class quizButtonState extends State<quizButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
          decoration: boxDecoration(bgColor: quiz_colorPrimary, radius: 16),
          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Center(
                child: text(widget.textContent,
                    textColor: t8_white,
                    fontFamily: fontMedium,
                    textAllCaps: false),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: quiz_colorPrimaryDark),
                  width: 35,
                  height: 35,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_forward,
                      color: t8_white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

Padding t3EditTextField(
    {var hintText,
    Function validator,
    List<TextInputFormatter> inputFormatters = const [],
    Function onChanged,
    Function value,
    TextEditingController controller,
    isPassword = true,
    TextInputType textInputType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next}) {
  return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: TextFormField(
        inputFormatters: inputFormatters,
        controller: controller,
        textInputAction: textInputAction,
        style: primaryTextStyle(size: 18),
        obscureText: isPassword,
        keyboardType: textInputType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(26, 18, 4, 18),
          hintText: hintText,
          filled: true,
          fillColor: t3_edit_background,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: t3_edit_background, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: t3_edit_background, width: 0.0),
          ),
        ),
        validator: validator,
        onChanged: onChanged,
        onSaved: value,
      ));
}

// ignore: must_be_immutable
class T3AppButton extends StatefulWidget {
  var textContent;
  VoidCallback onPressed;

  T3AppButton({@required this.textContent, @required this.onPressed});

  @override
  State<StatefulWidget> createState() {
    return T3AppButtonState();
  }
}

class T3AppButtonState extends State<T3AppButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: t3_white,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          padding: EdgeInsets.all(0.0),
        ),
        onPressed: widget.onPressed,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: <Color>[t3_colorPrimary, t3_colorPrimaryDark]),
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                widget.textContent,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ));
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}

// ignore: must_be_immutable
class T3AppBar extends StatefulWidget {
  var titleName;
  final drawer;
  final profile;
  final isProfile;

  T3AppBar(this.titleName,
      [this.drawer = false, this.profile = false, this.isProfile = false]);
  @override
  State<StatefulWidget> createState() {
    return T3AppBarState();
  }
}

class T3AppBarState extends State<T3AppBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 60,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon:
                      widget.drawer ? Icon(Icons.menu) : Icon(Icons.arrow_back),
                  color: t3_white,
                  onPressed: () {
                    widget.drawer
                        ? Scaffold.of(context).openDrawer()
                        : finish(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Center(
                    child: Text(
                      widget.titleName,
                      maxLines: 2,
                      style: boldTextStyle(size: 22, color: t3_white),
                    ),
                  ),
                )
              ],
            ),
            if (widget.profile)
              Container(
                margin: EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(t3_ic_profile),
                  radius: 16,
                ),
              ),
            if (widget.isProfile)
              PopupMenuButton(
                onSelected: (value) {
                  value == 'edit'
                      ? Navigator.of(context).pushNamed('/')
                      : Navigator.of(context).pushNamed('/');
                },
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                      title: Text('Edit'),
                    ),
                    value: 'edit',
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(
                        Icons.security,
                        color: Colors.black,
                      ),
                      title: Text('Change Password'),
                    ),
                    value: 'password',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return null;
  }
}

Widget divider({Color color = t3_view_color, dynamic height = 16.0}) {
  return Padding(
    padding: EdgeInsets.only(left: 16.0, right: 16),
    child: Divider(
      color: color,
      height: height,
    ),
  );
}

void showErrorDialog(String title, String messgae, BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(messgae),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Okay'))
      ],
    ),
  );
}

void showBankDialog(String title, String bankTitle, String data,
    BuildContext context, double height) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontFamily: fontMedium),
      ),
      content: Container(
        height: height,
        child: Column(
          children: [
            Text(bankTitle),
            // Html(data: data),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Okay'))
      ],
    ),
  );
}

void showErrorDialogRoute(
    String title, String messgae, BuildContext context, String tag) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(messgae),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushNamed(context, tag);
            },
            child: Text('Okay')),
      ],
    ),
  );
}

class CustomDialog extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  final String cancelText;
  final String okText;
  VoidCallback onPressedCancel;
  VoidCallback onPressedOk;

  CustomDialog({
    @required this.image,
    @required this.title,
    @required this.subTitle,
    @required this.cancelText,
    @required this.okText,
    @required this.onPressedCancel,
    @required this.onPressedOk,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: new BoxDecoration(
          color: t3White,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0)),
          ],
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              child: Image(
                  width: MediaQuery.of(context).size.width,
                  image: AssetImage(image),
                  height: 120,
                  fit: BoxFit.cover),
            ),
            24.height,
            Text(title,
                style: boldTextStyle(color: textPrimaryColor, size: 18)),
            16.height,
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(subTitle,
                  style: secondaryTextStyle(color: textSecondaryColor)),
            ),
            16.height,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  if (cancelText.isNotEmpty)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: boxDecoration(
                            color: Colors.greenAccent,
                            radius: 8,
                            bgColor: t3White),
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                // WidgetSpan(
                                //     child: Padding(
                                //         padding: EdgeInsets.only(right: 8.0),
                                //         child: Icon(Icons.close,
                                //             color: Colors.blueAccent, size: 18))),
                                TextSpan(
                                    text: cancelText,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.greenAccent,
                                        fontFamily: fontRegular)),
                              ],
                            ),
                          ),
                        ),
                      ).onTap(onPressedCancel),
                    ),
                  16.width,
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration:
                          boxDecoration(bgColor: Colors.greenAccent, radius: 8),
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
                                  text: okText,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontFamily: fontRegular)),
                            ],
                          ),
                        ),
                      ),
                    ).onTap(onPressedOk),
                  )
                ],
              ),
            ),
            16.height,
          ],
        ),
      ),
    );
  }
}

// Error Container
Container errorContainer(String error, Function onPressed, double width) {
  return Container(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          error,
          style: TextStyle(fontFamily: fontMedium),
        ).paddingBottom(10),
        Container(
          width: width * .4,
          padding: EdgeInsets.all(8),
          decoration: boxDecoration(
              color: t3_colorPrimary, radius: 8, bgColor: t3White),
          child: Center(
            child: RichText(
              text: TextSpan(
                children: [
                  // WidgetSpan(
                  //     child: Padding(
                  //         padding: EdgeInsets.only(right: 8.0),
                  //         child: Icon(Icons.close,
                  //             color: Colors.blueAccent, size: 18))),
                  TextSpan(
                      text: 'Try again',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: t3_colorPrimary,
                          fontFamily: fontRegular)),
                ],
              ),
            ),
          ),
        ).onTap(onPressed)
      ],
    ),
  );
}

Chip customChip(String text, IconData icon, Color bgColor) {
  return Chip(
    backgroundColor: bgColor,
    label: Text(text),
    avatar: InkWell(
      onTap: () {},
      child: Icon(
        icon,
        color: t3White,
      ),
    ),
    labelStyle: TextStyle(
        fontFamily: fontRegular, fontSize: textSizeSmall, color: t3White),
  );
}

class groceryButton extends StatefulWidget {
  static String tag = '/dpButton';
  var textContent;
  VoidCallback onPressed;
  var isStroked = false;
  var height = 50.0;
  var radius = 5.0;
  var bgColors = t3_colorPrimary;
  var color = t3_colorPrimary;

  groceryButton(
      {@required this.textContent,
      @required this.onPressed,
      this.isStroked = false,
      this.height = 50.0,
      this.radius = 5.0,
      this.color,
      this.bgColors = t3_colorPrimary});

  @override
  groceryButtonState createState() => groceryButtonState();
}

class groceryButtonState extends State<groceryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
        alignment: Alignment.center,
        child: text(widget.textContent,
            textColor: widget.isStroked ? t3_colorPrimary : white,
            fontSize: textSizeLargeMedium,
            fontFamily: fontSemiBold,
            textAllCaps: true),
        decoration: widget.isStroked
            ? boxDecoration(bgColor: Colors.transparent, color: t3_colorPrimary)
            : boxDecoration(bgColor: widget.bgColors, radius: widget.radius),
      ),
    );
  }
}

Widget SliderButton(
    {Color color,
    String title = '',
    VoidCallback onPressed,
    bool disabled = false,
    double radius = 24.0}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(left: 16, right: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: Colors.transparent),
        ),
        backgroundColor: color,
      ),
      child: FittedBox(
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      onPressed: disabled ? null : onPressed);
}

Widget iconButton(
    {Color color,
    String title = '',
    VoidCallback onPressed,
    bool disabled = false,
    double radius = 24.0}) {
  return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(left: 16, right: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: Colors.transparent),
        ),
        backgroundColor: color,
      ),
      label: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      icon: Icon(
        Icons.upload_file,
        color: Colors.white,
      ),
      onPressed: disabled ? null : onPressed);
}

showSheet({BuildContext aContext, Widget child}) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: aContext,
      builder: (BuildContext context) {
        return Container(
          height: 130,
          padding: EdgeInsets.only(top: 5),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
              color: context.scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24))),
          child: Column(
            children: <Widget>[
              // Container(color: t5ViewColor, width: 50, height: 3),
              SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 16),
                  child: child,
                ),
              )
            ],
          ),
        );
      });
}

Column mediaIcons(
    {Color color,
    IconData icon,
    String text,
    double iconSIze = 30.0,
    Color iconColor = Colors.white,
    Function onPressed}) {
  return Column(
    children: [
      Container(
        decoration: ShapeDecoration(
          color: color,
          shape: CircleBorder(),
        ),
        child: IconButton(
          icon: Icon(
            icon,
            color: iconColor,
          ),
          iconSize: iconSIze,
          onPressed: onPressed,
        ),
      ),
      Text(
        text,
        style: secondaryTextStyle(),
      )
    ],
  );
}
