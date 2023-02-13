import 'dart:io';

import 'package:cmcp/widgets/mix_widgets.dart';
import 'package:cmcp/widgets/otp_field.dart';
import 'package:flutter/material.dart';
import 'package:cmcp/model/http_exception.dart';
import 'package:cmcp/providers/auth.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cmcp/theme_utils/colors.dart';
import 'package:cmcp/main_theme/utils/AppWidget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/user.dart';
import '../theme_utils/fontsSize.dart';
import 'package:cmcp/theme_utils/T3widgets.dart';

class PhoneVerificationScreen extends StatefulWidget {
  static String tag = '/PhoneVerificationScreen';

  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  var _isLoading = false;
  var _allow = false;
  String _otp = '';

  User _editUser;
  void didChangeDependencies() {
    if (_isInit) {
      _editUser = Provider.of<Auth>(context, listen: false).user;

      print("User Contact Number ${_editUser.contactNo}");
      _userData = {
        'name': _editUser.name,
        'cnic': _editUser.cnic,
        'contact_no': _editUser.contactNo,
        'gender': _editUser.gender,
        'address': _editUser.address,
        'district_id': _editUser.districtId.toString(),
      };
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  var _isInit = true;
  var _userData = {
    'name': '',
    'cnic': '',
    'contact_no': '',
    'gender': '',
    'address': '',
    'district_id': '',
  };

  Future<void> _sendVCode() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response =
          await Provider.of<Auth>(context, listen: false).requestNumberVerify();
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
          .verifyNumber({'otp': _otp});
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
                padTextField(
                  child: Text(
                    'Please verify your mobile number. So that you can be contacted when needed.',
                    style: TextStyle(
                        color: redColor,
                        fontFamily: fontMedium,
                        fontSize: textSizeSmall),
                  ),
                ),
                padTextField(
                  child: Text(
                    'براہ کرم اپنے موبائل نمبر کی تصدیق کریں۔ تاکہ ضرورت پڑنے پر آپ سے رابطہ کیا جا سکے۔',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: redColor,
                        fontFamily: fontMedium,
                        fontSize: textSizeSmall),
                  ),
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
                            _auth.contactNo,
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
                ),
                Divider(
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Note : ',
                          style: boldTextStyle(color: redColor, size: 18)),
                      16.height,
                      Expanded(
                        child: Text(
                            'In case of incorrect phone number, kindly change it from profile update.',
                            style: secondaryTextStyle(color: errorColor)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                _allow
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Note : ',
                                    style: boldTextStyle(
                                        color: redColor, size: 18)),
                                16.height,
                                Expanded(
                                  child: Text(
                                      'In case OTP is not recieved, kindly call on 03188170841 for OTP.',
                                      style: secondaryTextStyle(
                                          color: errorColor)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: padTextField(
                                    child: Text(
                                      "آپکا کوڈ موصول نہ ہونے کی صورت میں 03188170841 پر رابطہ کریں",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: redColor,
                                          fontFamily: fontMedium,
                                          fontSize: textSizeSmall),
                                    ),
                                  ),
                                ),
                                Text(' : نوٹ ',
                                    style: boldTextStyle(
                                        color: redColor, size: 18)),
                                16.height,
                              ],
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _allow
          ? FloatingActionButton(
              child: Icon(Icons.whatsapp),
              backgroundColor: Colors.green,
              onPressed: () {
                var whatsappUrl = "whatsapp://send?phone=+923188170841" +
                    "&text=${Uri.encodeComponent("I need OTP for my CMC Portal \n My details are :- \n Name : ${_userData['name']} \n CNIC: ${_userData['cnic']} \n Contact No : ${_userData['contact_no']}   ")}";
                try {
                  launch(whatsappUrl);
                } catch (e) {
                  //To handle error and display error message
                  Get.snackbar("Whatsapp", "Unable to open Whatsapp");
                }
              },
            )
          : SizedBox(),
    );
  }
}
