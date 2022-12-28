import 'package:cmcp/screens/forgot_password_screen.dart';
import 'package:cmcp/screens/registration_mobile_screen.dart';
import 'package:cmcp/screens/registration_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cmcp/model/http_exception.dart';
import 'package:cmcp/providers/auth.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../main_theme/utils/AppWidget.dart';
import '../theme_utils/T3Images.dart';
import '../theme_utils/T3widgets.dart';
import '../theme_utils/colors.dart';
import '../theme_utils/strings.dart';

class SignIn extends StatefulWidget {
  static var tag = "/SignIn";

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String _fcmToken;
  bool passwordVisible = false;
  bool isRemember = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _email = '';
  String _password = '';
  var _isLoading = false;
  var maskFormatter = new MaskTextInputFormatter(
      mask: '#####-#######-#', filter: {"#": RegExp(r'[0-9]')});

  final cnicCont = TextEditingController();
  @override
  void initState() {
    _firebaseMessaging.getToken().then((token) {
      _fcmToken = token;
    });
    super.initState();
    passwordVisible = false;
  }

  void _showErrorDialog(String messgae) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured'),
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

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      var authProvider = Provider.of<Auth>(context, listen: false);
      await authProvider.login(_email, _password, _fcmToken);
    } on CustomHttpException catch (error) {
      var errorMessage = 'Authentication failed';
      // _showErrorDialog(error.toString());
      toast(error.toString(), textColor: Colors.red);
    } catch (error) {
      print(error);
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      toast(errorMessage, textColor: Colors.red);
      // _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
    // print(_email + ' - ' + _password);
    // Provider.of<Auth>(context, listen: false).setToken();
    // Navigator.of(context).pushReplacementNamed(DashboardScreen.tag);
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.transparent);
    return Scaffold(
      body: Observer(
        builder: (_) => SingleChildScrollView(
          child: Container(
            color: appStore.scaffoldBackground,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Container(
                  height: (MediaQuery.of(context).size.height) / 3.5,
                  child: Stack(
                    children: <Widget>[
                      Image.asset(t3_ic_background,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width),
                      Container(
                        margin: EdgeInsets.only(left: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('E-COMPLAINT',
                                style:
                                    boldTextStyle(size: 40, color: t3_white)),
                            SizedBox(height: 4),
                            Text('CELL',
                                style: boldTextStyle(size: 34, color: t3_white))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(right: 45),
                  transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                  child: Image.asset(cmdu_icon, height: 70, width: 70),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          child: Image.asset(s_bg_icon),
                        ),
                      ),
                      Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              t3EditTextField(
                                inputFormatters: [maskFormatter],
                                controller: cnicCont,
                                hintText: t3_hint_Email,
                                validator: (value) {
                                  if (value.isEmpty ||
                                      !RegExp(r'^[0-9]{5}-[0-9]{7}-[0-9]$')
                                          .hasMatch(value)) {
                                    return 'Invalid CNIC!';
                                  }
                                  return null;
                                },
                                value: (val) => _email = val,
                                isPassword: false,
                                textInputType: TextInputType.phone,
                              ),
                              SizedBox(height: 16),
                              t3EditTextField(
                                hintText: t3_hint_password,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Password is too short!';
                                  }
                                },
                                value: (val) => _password = val,
                                isPassword: true,
                                textInputAction: TextInputAction.done,
                              ),
                              SizedBox(height: 14),
                              SizedBox(height: 14),
                              if (_isLoading)
                                CircularProgressIndicator()
                              else
                                Padding(
                                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: T3AppButton(
                                      textContent: t3_lbl_sign_in,
                                      onPressed: _submit),
                                ),
                              SizedBox(height: 16),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(ForgotPassScreen.tag);
                                },
                                child: Text(t3_lbl_forgot_password,
                                    style: secondaryTextStyle(size: 16)),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(t3_lbl_don_t_have_account,
                                      style: primaryTextStyle()),
                                  Container(
                                    margin: EdgeInsets.only(left: 4),
                                    child: GestureDetector(
                                        child: Text(t3_lbl_sign_up,
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                decoration:
                                                    TextDecoration.underline,
                                                color: t3_colorPrimary)),
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, RegistrationScreen.tag);
                                        }),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
