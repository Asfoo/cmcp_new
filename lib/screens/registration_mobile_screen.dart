import 'package:cmcp/providers/auth.dart';
import 'package:cmcp/theme_utils/fontsSize.dart';
import 'package:cmcp/widgets/mix_widgets.dart';
import 'package:cmcp/widgets/otp_field.dart';
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

class RegPhoneScreen extends StatefulWidget {
  static const String tag = "/RegPhoneword";

  @override
  _RegPhoneScreenState createState() => _RegPhoneScreenState();
}

class _RegPhoneScreenState extends State<RegPhoneScreen> {
  final GlobalKey<FormState> _formKey1 = GlobalKey();
  final _passwordController = TextEditingController();
  var _isInit = true;
  var _isloading = false;
  var _isLoading2 = false;
  var _allow = false;
  var _error = '';

  String _contact = '';
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
          .sendResetPassRequest({'contact': _contact});
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
          .resetPass({'email': _contact, 'otp': _otp, 'password': _password});
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
                                        cTextLabel('Mobile #', 'موبائل نمبر'),
                                        padTextField(
                                          child: comEditTextPrefix(
                                            // controller:
                                            //     _contactController,
                                            hintText: '3133333333',
                                            maxLength: 10,
                                            textInputType: TextInputType.number,
                                            enabled: !_allow,
                                            prefixWidget: SizedBox(
                                              child: Center(
                                                widthFactor: 0.2,
                                                child: Text(
                                                  '+92',
                                                  style:
                                                      boldTextStyle(size: 18),
                                                ).paddingLeft(2),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty ||
                                                  value.length < 10) {
                                                return 'Number is invalid!';
                                              }
                                            },
                                            value: (val) {
                                              _contact = '+92' + val;
                                            },
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        if (_allow)
                                          Column(
                                            children: [
                                              Text(
                                                'A verification code has been sent to your mobile number.',
                                                style: TextStyle(
                                                    color: redColor,
                                                    fontFamily: fontSemiBold,
                                                    fontSize: textSizeSmall),
                                              ),
                                              Text(
                                                'آپ کے موبائل نمبر پر ایک تصدیقی کوڈ بھیجا گیا ہے۔',
                                                style: TextStyle(
                                                    color: redColor,
                                                    fontFamily: fontSemiBold,
                                                    fontSize: textSizeSmall),
                                              ),
                                              cTextLabel('VERIFICATION CODE',
                                                  'تصدیقی کوڈ'),
                                              Column(
                                                children: [
                                                  PinEntryTextField(
                                                    fields: 6,
                                                    fontSize: textSizeNormal,
                                                    onSubmit: (val) {
                                                      _otp = val;
                                                      print(_otp);
                                                    },
                                                    fieldWidth: 40.0,
                                                    showFieldAsBox: true,
                                                  ),
                                                  Divider(
                                                    thickness: 1,
                                                  )
                                                ],
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
                                    textContent: 'NEXT',
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
                    titleName: 'Mobile Number Verification',

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
