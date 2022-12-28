import 'package:cmcp/providers/auth.dart';
import 'package:cmcp/theme_utils/fontsSize.dart';
import 'package:cmcp/widgets/mix_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cmcp/theme_utils/T3widgets.dart';
import 'package:cmcp/widgets/app_bar.dart';
import 'package:cmcp/widgets/app_bar_gradient.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../main_theme/utils/AppWidget.dart';
// import '../theme_utils/T3widgets.dart';
import '../theme_utils/colors.dart';

class ForgotPassScreen extends StatefulWidget {
  static const String tag = "/ForgotPassword";

  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final GlobalKey<FormState> _formKey1 = GlobalKey();
  final _passwordController = TextEditingController();
  var _isInit = true;
  var _isloading = false;
  var _isLoading2 = false;
  var _allow = false;
  var _error = '';

  String _email = '';
  String _otp = '';
  String _password = '';

  Future<bool> _onWillPop() async {
    // Provider.of<Athletes>(context, listen: false).clearAll();
    return true;
  }

  void _sendMail() async {
    if (!_formKey1.currentState.validate()) {
      return;
    }
    _formKey1.currentState.save();
    showLoading();
    try {
      var response = await Provider.of<Auth>(context, listen: false)
          .sendResetPassRequest({'email': _email});
      Get.back();
      if (response['response'] == 0) {
        showErrorDialog('Notifictaion!', response['message'], context);
      } else if (response['response'] == 1) {
        setState(() {
          _allow = true;
        });
        toast(response['message'],
            length: Toast.LENGTH_LONG, textColor: webSuccess);
      }
    } catch (error) {
      Get.back();
      print(error);
      toast('Something went wrong',
          length: Toast.LENGTH_LONG, textColor: redColor);
    }
  }

  void _resetPassOtp() async {
    if (!_formKey1.currentState.validate()) {
      return;
    }
    _formKey1.currentState.save();
    showLoading();
    try {
      var response = await Provider.of<Auth>(context, listen: false)
          .resetPass({'email': _email, 'otp': _otp, 'password': _password});
      print(response);
      Get.back();
      if (response['response'] == 0) {
        showErrorDialog('Notifictaion!', response['message'], context);
      } else if (response['response'] == 1) {
        toast(response['message'],
            length: Toast.LENGTH_LONG, textColor: webSuccess);
        Navigator.of(context).pop();
      }
    } catch (error) {
      Get.back();
      print(error);
      toast('Something went wrong',
          length: Toast.LENGTH_LONG, textColor: redColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // final auth = Provider.of<Auth>(context, listen: false);
    changeStatusColor(Colors.transparent);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                              ? Form(
                                  key: _formKey1,
                                  child: SingleChildScrollView(
                                    child: Container(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        cTextLabel('EMAIL', 'ای میل'),
                                        padTextField(
                                          child: padTextField(
                                            child: comEditTextStyle(
                                              // controller:
                                              //     _emailController,
                                              enabled: !_allow,
                                              textInputAction:
                                                  TextInputAction.done,
                                              textInputType:
                                                  TextInputType.emailAddress,
                                              hintText: 'Enter email here',
                                              validator: (email) {
                                                bool emailValid = RegExp(
                                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                    .hasMatch(email);
                                                if (!emailValid) {
                                                  return 'Email is not valid';
                                                }
                                              },
                                              value: (val) {
                                                _email = val;
                                              },
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        if (_allow)
                                          Column(
                                            children: [
                                              Text(
                                                'A verification code has been sent to your email.',
                                                style: TextStyle(
                                                    color: redColor,
                                                    fontFamily: fontSemiBold,
                                                    fontSize: textSizeSmall),
                                              ),
                                              Text(
                                                'آپ کے ای میل پر ایک تصدیقی کوڈ بھیجا گیا ہے۔',
                                                style: TextStyle(
                                                    color: redColor,
                                                    fontFamily: fontSemiBold,
                                                    fontSize: textSizeSmall),
                                              ),
                                              cTextLabel('VERIFICATION CODE',
                                                  'تصدیقی کوڈ'),
                                              padTextField(
                                                child: padTextField(
                                                  child: comEditTextStyle(
                                                    // controller:
                                                    //     _emailController,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    hintText:
                                                        'Enter Verification code',
                                                    validator: (value) {
                                                      if (value.isEmpty ||
                                                          value.length < 6) {
                                                        return 'Invalid Verification Code!';
                                                      }
                                                    },
                                                    value: (val) {
                                                      _otp = val;
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                thickness: 1,
                                              ),
                                              Divider(
                                                thickness: 1,
                                              ),
                                              cTextLabel('NEW PASSWORD',
                                                  'نیا پاس ورڈ'),
                                              padTextField(
                                                child: padTextField(
                                                    child: comEditTextPass(
                                                  isPassword: true,
                                                  hintText:
                                                      'Enter new password here',
                                                  controller:
                                                      _passwordController,
                                                  confirmPass: true,
                                                  validator: (value) {
                                                    if (value.isEmpty ||
                                                        value.length < 5) {
                                                      return 'Password is too short!';
                                                    }
                                                    return null;
                                                  },
                                                  value: (value) {
                                                    _password = value;
                                                  },
                                                )),
                                              ),
                                              Divider(
                                                thickness: 1,
                                              ),
                                              cTextLabel('CONFIRM PASSWORD',
                                                  'پاس ورڈ کی تصدیق'),
                                              padTextField(
                                                child: padTextField(
                                                    child: comEditTextStyle(
                                                  isPassword: true,
                                                  hintText:
                                                      'Enter confirm password here',
                                                  validator: (value) {
                                                    if (value !=
                                                        _passwordController
                                                            .text) {
                                                      print(value);
                                                      return 'Passwords do not match!';
                                                    }
                                                    return null;
                                                  },
                                                )),
                                              ),
                                              Divider(
                                                thickness: 1,
                                              ),
                                            ],
                                          )
                                      ],
                                    )),
                                  ),
                                )
                              : errorContainer(_error, () {
                                  // _loadData();
                                }, size.width),
                        ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                      child: _isLoading2
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : _allow
                              ? Container(
                                  height: 55,
                                  child: T3AppButton(
                                    textContent: 'RESET PASSWORD',
                                    onPressed: _resetPassOtp,
                                  ),
                                )
                              : Container(
                                  height: 55,
                                  child: T3AppButton(
                                    textContent: 'SUBMIT',
                                    onPressed: _sendMail,
                                  ),
                                ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  MyAppBar(
                    titleName: 'Forgot Password',

                    // actions: TextButton.icon(
                    //   onPressed: () {},
                    //   icon: Icon(Icons.add),
                    //   label: Text('Add', style: TextStyle(color: t3White),),
                    // ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
