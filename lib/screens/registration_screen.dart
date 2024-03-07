import 'dart:io';
import 'package:cmcp/model/keyValue.dart';
import 'package:cmcp/widgets/mix_widgets.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cmcp/providers/auth.dart';
import 'package:cmcp/theme_utils/T3widgets.dart';
import 'package:cmcp/widgets/app_bar.dart';
import 'package:cmcp/widgets/app_bar_gradient.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../main_theme/utils/AppWidget.dart';
import 'package:cmcp/model/http_exception.dart';
// import '../theme_utils/T3widgets.dart';
import '../theme_utils/colors.dart';

class RegistrationScreen extends StatefulWidget {
  static const String tag = "/Registration";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GlobalKey<FormState> _formKey1 = GlobalKey();
  final GlobalKey<FormState> _formKey2 = GlobalKey(debugLabel: 'form2');
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _cnicController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _confController = TextEditingController();
  PageController? pageController;
  var _isInit = true;
  var _isLoading = false;
  var _isLoading2 = false;
  var _error = '';
  int pageChanged = 0;
  bool _disable = false;
  KeyValueModel? _selectGender ;
  KeyValueModel ? _selectDistrict;

  var _regData = {
    'name': '',
    'contact_no': '',
    'email': '',
    'cnic': '',
    'gender': '',
    'address': '',
    'district_id': '',
    'password': '',
    'fcm_token': '',
  };

  List<KeyValueModel> _genderValues = [
    KeyValueModel(key: "Male", value: "Male"),
    KeyValueModel(key: "Female", value: "Female"),
    KeyValueModel(key: "Other", value: "Other"),
  ];

  List<KeyValueModel> ?_districtValues;

  var maskFormatter = new MaskTextInputFormatter(
      mask: '#####-#######-#', filter: {"#": RegExp(r'[0-9]')});

  var mobileFormatter = new MaskTextInputFormatter(
      mask: '3133333333', initialText: '+92', filter: {"#": RegExp(r'[0-9]')});

  _loadDistricts() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      await Provider.of<Auth>(context, listen: false).getDistricts();
    } on SocketException {
      _error = 'No Internet connection';
    } catch (e) {
      print(e.toString());
      _error = 'Something went wrong!';
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _submit1() async {
    if (!this._formKey1.currentState!.validate()) {
      return;
    }
    _formKey1.currentState!.save();
    pageController!.nextPage(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInCirc,
    );
    print(_regData);
  }

  void _register() async {
    if (!_formKey2.currentState!.validate()) {
      return;
    }
    _formKey2.currentState!.save();
    showLoading();
    try {
      await Provider.of<Auth>(context, listen: false).register(_regData);
      Get.back();
      Navigator.of(context).pop();
      toast('Successfully Register');
    } on CustomHttpException catch (error) {
      Get.back();
      showErrorDialog('Account cannot be created!', error.toString(), context);
    } on SocketException {
      Get.back();
      toast('No Internet connection');
    } catch (error) {
      Get.back();
      showErrorDialog('An error occured!', 'Something went wrong', context);
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _loadDistricts();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _firebaseMessaging.getToken().then((token) {
      _regData['fcm_token'] = token!;
    });
    super.initState();
  }

  Future<bool> _onWillPop() async {
    // Provider.of<Athletes>(context, listen: false).clearAll();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    pageController = PageController(initialPage: 0);
    var size = MediaQuery.of(context).size;
    _districtValues = Provider.of<Auth>(context, listen: false).districts;
    final auth = Provider.of<Auth>(context, listen: false);
    changeStatusColor(Colors.transparent);

    List<Widget> buildDotIndicator() {
      List<Widget> list = [];
      for (int i = 0; i <= 1; i++) {
        list.add(i == pageChanged
            ? oPDotIndicator(isActive: true)
            : oPDotIndicator(isActive: false));
      }

      return list;
    }

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
                  _isLoading
                      ? Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Expanded(
                          child: _error.isEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: double.infinity,
                                        width: double.infinity,
                                        child: PageView(
                                            onPageChanged: (index) {
                                              setState(() {
                                                pageChanged = index;
                                              });
                                            },
                                            physics:
                                                new NeverScrollableScrollPhysics(),
                                            controller: pageController,
                                            children: <Widget>[
                                              Container(
                                                child: Form(
                                                  key: this._formKey1,
                                                  child: SingleChildScrollView(
                                                    child: Container(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        cTextLabel(
                                                            'NAME', 'نام'),
                                                        padTextField(
                                                          child: padTextField(
                                                            child:
                                                                comEditTextStyle(
                                                              controller:
                                                                  _nameController,
                                                              hintText:
                                                                  'Enter full name here',
                                                              textCapitalization:
                                                                  TextCapitalization
                                                                      .words,
                                                              validator:
                                                                  (value) {
                                                                if (value
                                                                        .isEmpty ||
                                                                    value.length <
                                                                        3) {
                                                                  return 'Name is too short!';
                                                                }
                                                                if (value
                                                                        .length >
                                                                    50) {
                                                                  return 'Name is too long!';
                                                                }
                                                              },
                                                              value: (val) {
                                                                _regData[
                                                                        'name'] =
                                                                    val;
                                                              },
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter.allow(
                                                                    RegExp(
                                                                        "[a-zA-Z ]")),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Divider(
                                                          thickness: 1,
                                                        ),
                                                        cTextLabel('Mobile #',
                                                            'موبائل نمبر'),
                                                        padTextField(
                                                          child:
                                                              comEditTextPrefix(
                                                            controller:
                                                                _contactController,
                                                            hintText:
                                                                '3133333333',
                                                            maxLength: 10,
                                                            textInputType:
                                                                TextInputType
                                                                    .number,
                                                            prefixWidget:
                                                                SizedBox(
                                                              child: Center(
                                                                widthFactor:
                                                                    0.2,
                                                                child: Text(
                                                                  '+92',
                                                                  style:
                                                                      boldTextStyle(
                                                                          size:
                                                                              18),
                                                                ).paddingLeft(
                                                                    2),
                                                              ),
                                                            ),
                                                            validator: (value) {
                                                              if (value
                                                                      .isEmpty ||
                                                                  value.length <
                                                                      10) {
                                                                return 'Number is invalid!';
                                                              }
                                                            },
                                                            value: (val) {
                                                              _regData[
                                                                      'contact_no'] =
                                                                  '+92' + val;
                                                            },
                                                          ),
                                                        ),
                                                        Divider(
                                                          thickness: 1,
                                                        ),
                                                        cTextLabel('CNIC #',
                                                            'شناختی کارڈ نمبر'),
                                                        padTextField(
                                                          child: padTextField(
                                                              child:
                                                                  comEditTextStyle(
                                                            controller:
                                                                _cnicController,
                                                            hintText:
                                                                '00000-0000000-0',
                                                            validator: (value) {
                                                              if (value
                                                                      .isEmpty ||
                                                                  value.length <
                                                                      15 ||
                                                                  value ==
                                                                      '00000-0000000-0') {
                                                                return 'CNIC is invalid!';
                                                              }
                                                            },
                                                            textInputType:
                                                                TextInputType
                                                                    .number,
                                                            value: (val) {
                                                              _regData['cnic'] =
                                                                  val;
                                                            },
                                                            inputFormatters: [
                                                              maskFormatter
                                                            ],
                                                          )),
                                                        ),
                                                        Divider(
                                                          thickness: 1,
                                                        ),
                                                        cTextLabel(
                                                            'GENDER', 'صنف'),
                                                        padTextField(
                                                          child: searchDropDown(
                                                            selectedItem:
                                                                _selectGender!,
                                                            itemList:
                                                                _genderValues,
                                                            hint:
                                                                'Select Gender',
                                                            mode: Mode.MENU,
                                                            showSearch: false,
                                                            value:
                                                                (KeyValueModel
                                                                    val) {
                                                              _regData[
                                                                      'gender'] =
                                                                  val.key;
                                                              print(val.key);
                                                              _selectGender =
                                                                  val;
                                                            },
                                                            validator:
                                                                (KeyValueModel
                                                                    item) {
                                                              if (item == null)
                                                                return "Gender required";
                                                              else
                                                                return null;
                                                            },
                                                          ),
                                                        ),
                                                        Divider(
                                                          thickness: 1,
                                                        ),
                                                        cTextLabel(
                                                            'ADDRESS', 'پتہ'),
                                                        padTextField(
                                                          child:
                                                              comEditTextStyle(
                                                            controller:
                                                                _addressController,
                                                            hintText:
                                                                'Enter address here',
                                                            maxline: 4,
                                                            validator: (value) {
                                                              if (value
                                                                      .isEmpty ||
                                                                  value.length <
                                                                      5) {
                                                                return 'address is too short!';
                                                              }
                                                            },
                                                            value: (val) {
                                                              _regData[
                                                                      'address'] =
                                                                  val;
                                                            },
                                                          ),
                                                        ),
                                                        Divider(
                                                          thickness: 1,
                                                        ),
                                                        cTextLabel(
                                                            'DISTRICT', 'ضلع'),
                                                        padTextField(
                                                          child: searchDropDown(
                                                            selectedItem:
                                                                _selectDistrict!,
                                                            itemList:
                                                                _districtValues!,
                                                            hint:
                                                                'Select District',
                                                            value:
                                                                (KeyValueModel
                                                                    val) {
                                                              _regData[
                                                                      'district_id'] =
                                                                  val.key;
                                                              print(val.key);
                                                              _selectDistrict =
                                                                  val;
                                                            },
                                                            validator:
                                                                (KeyValueModel
                                                                    item) {
                                                              if (item == null)
                                                                return "District required";
                                                              else
                                                                return null;
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: SingleChildScrollView(
                                                  child: Form(
                                                    key: _formKey2,
                                                    child: Container(
                                                      child: Column(
                                                        children: [
                                                          cTextLabel('EMAIL',
                                                              'ای میل'),
                                                          padTextField(
                                                            child: padTextField(
                                                              child:
                                                                  comEditTextStyle(
                                                                controller:
                                                                    _emailController,
                                                                hintText:
                                                                    'Enter email here',
                                                                validator:
                                                                    (email) {
                                                                  bool emailValid = RegExp(
                                                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                                      .hasMatch(
                                                                          email);
                                                                  if (!emailValid) {
                                                                    return 'Email is not valid';
                                                                  }
                                                                },
                                                                value: (val) {
                                                                  _regData[
                                                                          'email'] =
                                                                      val;
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          Divider(
                                                            thickness: 1,
                                                          ),
                                                          cTextLabel('PASSWORD',
                                                              'پاس ورڈ'),
                                                          padTextField(
                                                            child: padTextField(
                                                                child:
                                                                    comEditTextPass(
                                                              isPassword: true,
                                                              hintText:
                                                                  'Enter password here',
                                                              controller:
                                                                  _passwordController,
                                                              confirmPass: true,
                                                              validator:
                                                                  (value) {
                                                                if (value
                                                                        .isEmpty ||
                                                                    value.length <
                                                                        5) {
                                                                  return 'Password is too short!';
                                                                }
                                                                return null;
                                                              },
                                                              value: (value) {
                                                                _regData[
                                                                        'password'] =
                                                                    value;
                                                              },
                                                            )),
                                                          ),
                                                          Divider(
                                                            thickness: 1,
                                                          ),
                                                          cTextLabel(
                                                              'CONFIRM PASSWORD',
                                                              'پاس ورڈ کی تصدیق'),
                                                          padTextField(
                                                            child: padTextField(
                                                                child:
                                                                    comEditTextStyle(
                                                              controller:
                                                                  _confController,
                                                              isPassword: true,
                                                              hintText:
                                                                  'Enter confirm password here',
                                                              validator:
                                                                  (value) {
                                                                if (value !=
                                                                    _passwordController
                                                                        .text) {
                                                                  print(value);
                                                                  print(
                                                                      _passwordController
                                                                          .text);
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
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]),
                                      ),
                                    ),
                                    _isLoading2
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(bottom: 20),
                                            width: size.width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                pageChanged == 0
                                                    ? Expanded(
                                                        child: SizedBox(),
                                                        flex: 1,
                                                      )
                                                    : Expanded(
                                                        flex: 1,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 20,
                                                          ),
                                                          child: SliderButton(
                                                            color: Color(
                                                                0xFFFF6E18),
                                                            title: 'Back',
                                                            onPressed: () {
                                                              pageController!.previousPage(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  curve: Curves
                                                                      .easeInCirc);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children:
                                                        buildDotIndicator(),
                                                  ),
                                                ),
                                                pageChanged != 1
                                                    ? Expanded(
                                                        flex: 1,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            right: 20,
                                                          ),
                                                          child: SliderButton(
                                                            color:
                                                                t3_colorPrimary,
                                                            title: 'Next',
                                                            // disabled: _disable,
                                                            onPressed: () {
                                                              _submit1();
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    : Expanded(
                                                        flex: 1,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            right: 20,
                                                          ),
                                                          child: SliderButton(
                                                            color:
                                                                t3_colorPrimary,
                                                            title: 'Register',
                                                            onPressed: () {
                                                              print(_regData);
                                                              // _addBooking();
                                                              _register();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          )
                                  ],
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
                    titleName: 'Registration',

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

Widget oPDotIndicator({bool? isActive}) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 150),
    margin: EdgeInsets.symmetric(horizontal: 4.0),
    height: isActive! ? 10.0 : 8.0,
    width: isActive ? 10.0 : 8.0,
    decoration: BoxDecoration(
      color: isActive ? t3_colorPrimary : Colors.grey.withOpacity(0.5),
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  );
}
