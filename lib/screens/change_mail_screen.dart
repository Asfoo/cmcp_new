import 'package:cmcp/widgets/mix_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cmcp/model/http_exception.dart';
import 'package:cmcp/providers/auth.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cmcp/theme_utils/colors.dart';
import 'package:cmcp/main_theme/utils/AppWidget.dart';
import 'package:provider/provider.dart';
import '../theme_utils/fontsSize.dart';
import 'package:cmcp/theme_utils/T3widgets.dart';

class ChangeEmailScreen extends StatefulWidget {
  static String tag = '/ChangeEmailScreen';

  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  var _isLoading = false;
  var oldObscureText = true;
  var newObscureText = true;
  var confirmObscureText = true;
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _oldPassword;
  String _newPassword;

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .changePassword(_oldPassword, _newPassword);
      Navigator.of(context).pop();
      toastLong('Password Successfully Changed', length: Toast.LENGTH_LONG);
    } on CustomHttpException catch (error) {
      print('good');
      showErrorDialog("Notification", error.toString(), context);
    } catch (error) {
      print(error.toString());
      const errorMessage =
          'Could not Change your Password. Please try again later.';
      toastLong(errorMessage, length: Toast.LENGTH_LONG, textColor: redColor);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('Change Password',
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
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: quiz_app_background,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  text(
                    'Enter your new password below\n the old password',
                    textColor: quiz_textColorSecondary,
                    isLongText: true,
                  ).center(),
                  Container(
                    // margin: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        cTextLabel('OLD PASSWORD', 'پرانا پاسورڈ'),
                        padTextField(
                          child: comEditTextPass(
                            isPassword: oldObscureText,
                            hintText: 'Enter old password here',
                            confirmPass: true,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Old password is required';
                              }
                              return null;
                            },
                            value: (value) {
                              _oldPassword = value;
                            },
                            suffix: text(oldObscureText ? "Show" : "Hide",
                                    textColor: quiz_textColorSecondary,
                                    fontSize: textSizeSmall,
                                    fontFamily: fontMedium)
                                .onTap(() {
                              setState(() {
                                oldObscureText = !oldObscureText;
                              });
                            }),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        cTextLabel('NEW PASSWORD', 'نیا پاس ورڈ'),
                        padTextField(
                          child: comEditTextPass(
                            isPassword: newObscureText,
                            hintText: 'Enter new password here',
                            controller: _passwordController,
                            confirmPass: true,
                            validator: (value) {
                              if (value.isEmpty || value.length < 6) {
                                return 'Password is too short!';
                              }
                              return null;
                            },
                            value: (value) {
                              _newPassword = value;
                            },
                            suffix: text(newObscureText ? "Show" : "Hide",
                                    textColor: quiz_textColorSecondary,
                                    fontSize: textSizeSmall,
                                    fontFamily: fontMedium)
                                .onTap(() {
                              setState(() {
                                newObscureText = !newObscureText;
                              });
                            }),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        cTextLabel('CONFIRM PASSWORD', 'پاس ورڈ کی تصدیق'),
                        padTextField(
                          child: comEditTextPass(
                            isPassword: confirmObscureText,
                            confirmPass: true,
                            hintText: 'Enter confirm password here',
                            validator: (value) {
                              if (value != _passwordController.text) {
                                print(value);
                                return 'Passwords do not match!';
                              }
                              return null;
                            },
                            value: (value) {
                              _newPassword = value;
                            },
                            suffix: text(confirmObscureText ? "Show" : "Hide",
                                    textColor: quiz_textColorSecondary,
                                    fontSize: textSizeSmall,
                                    fontFamily: fontMedium)
                                .onTap(() {
                              setState(() {
                                confirmObscureText = !confirmObscureText;
                              });
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.all(24.0),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : T3AppButton(
                            textContent: 'Change Password', onPressed: _submit),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
