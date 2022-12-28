import 'dart:io';

import 'package:cmcp/widgets/mix_widgets.dart';
import 'package:cmcp/widgets/otp_field.dart';
import 'package:flutter/material.dart';
import 'package:cmcp/model/http_exception.dart';
import 'package:cmcp/providers/auth.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cmcp/theme_utils/colors.dart';
import 'package:cmcp/main_theme/utils/AppWidget.dart';
import 'package:provider/provider.dart';
import '../theme_utils/fontsSize.dart';
import 'package:cmcp/theme_utils/T3widgets.dart';

class VerificationScreen extends StatefulWidget {
  static String tag = '/VerificationScreen';

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  var _isLoading = false;
  var _allow = false;
  String _otp = '';
  Future<void> _sendVCode() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response =
          await Provider.of<Auth>(context, listen: false).requestEmailVerify();
      if (response['response'] == 0) {
        showErrorDialog('Notifictaion!', response['message'], context);
      } else if (response['response'] == 1) {
        setState(() {
          _allow = true;
        });
        toastLong(response['message'],
            length: Toast.LENGTH_LONG, textColor: webSuccess);
      }
    } on SocketException {
      toastLong('No Internet connection');
    } catch (error) {
      print(error.toString());
      const errorMessage = 'Something went wrong. Please try again later.';
      toastLong(errorMessage, length: Toast.LENGTH_LONG, textColor: redColor);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _verifyCode() async {
    if (_otp.length < 6) {
      toast('Enter a valid verification code', textColor: redColor);
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await Provider.of<Auth>(context, listen: false)
          .verifyEmail({'otp': _otp});
      if (response['response'] == 0) {
        showErrorDialog('Notifictaion!', response['message'], context);
      } else if (response['response'] == 1) {
        toastLong(response['message'],
            length: Toast.LENGTH_LONG, textColor: webSuccess);
        Navigator.of(context).pop();
      }
    } on SocketException {
      toastLong('No Internet connection');
    } catch (error) {
      print(error.toString());
      const errorMessage = 'Something went wrong. Please try again later.';
      toastLong(errorMessage, length: Toast.LENGTH_LONG, textColor: redColor);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _auth = Provider.of<Auth>(context, listen: false).user;
    return Scaffold(
      appBar: AppBar(
        title: text('Verification',
            fontSize: textSizeNormal, fontFamily: fontMedium),
        leading: Icon(
          Icons.arrow_back,
          color: Banking_blackColor,
          size: 30,
        ).onTap(() {
          Navigator.of(context).pop();
        }),
        centerTitle: true,
        backgroundColor: quiz_app_background,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: quiz_app_background,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Please verify your email. So that you can be contacted when needed.',
                  style: TextStyle(
                      color: redColor,
                      fontFamily: fontMedium,
                      fontSize: textSizeSmall),
                ),
                Text(
                  'براہ کرم اپنے ای میل کی تصدیق کریں۔ تاکہ ضرورت پڑنے پر آپ سے رابطہ کیا جا سکے۔',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: redColor,
                      fontFamily: fontMedium,
                      fontSize: textSizeSmall),
                ),
                Divider(
                  thickness: 1,
                ),
                Container(
                  // margin: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      padTextField(
                        child: padTextField(
                            child: Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            _auth.email,
                            style: TextStyle(
                                fontFamily: fontBold,
                                fontSize: textSizeMedium,
                                color: t3_colorPrimary),
                          ),
                        )),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      if (_allow)
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
                        )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.all(24.0),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : _allow
                          ? T3AppButton(
                              textContent: 'Verify', onPressed: _verifyCode)
                          : T3AppButton(
                              textContent: 'Send Verification Code',
                              onPressed: _sendVCode),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
