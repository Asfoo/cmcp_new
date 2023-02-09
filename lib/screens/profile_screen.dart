import 'dart:io';
import 'package:cmcp/model/user.dart';
import 'package:cmcp/widgets/mix_widgets.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cmcp/model/keyValue.dart';
import 'package:cmcp/providers/auth.dart';
import 'package:cmcp/theme_utils/T3widgets.dart';
import 'package:cmcp/theme_utils/strings.dart';
import 'package:cmcp/widgets/pickers/user_image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cmcp/theme_utils/T3Images.dart';
import 'package:cmcp/theme_utils/colors.dart';
import 'package:cmcp/main_theme/utils/AppWidget.dart';
import 'package:provider/provider.dart';
import '../theme_utils/fontsSize.dart';

class EditProfileScreen extends StatefulWidget {
  static String tag = '/EditProfileScreen';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var profile_image = t3_profile;
  var _isInit = true;
  var _isLoading = false;
  var _isLoading2 = false;
  var _error = '';
  User _editUser;
  KeyValueModel _selectGender = null;
  KeyValueModel _selectDistrict = null;
  List<KeyValueModel> _districtValues;

  var _userData = {
    'name': '',
    'cnic': '',
    'contact_no': '',
    'gender': '',
    'address': '',
    'district_id': '',
  };
  var maskFormatter = new MaskTextInputFormatter(
      mask: '#####-#######-#', filter: {"#": RegExp(r'[0-9]')});

  var mobileFormatter = new MaskTextInputFormatter(
      mask: '##########', initialText: '+92', filter: {"#": RegExp(r'[0-9]')});

  File _userImageFile;
  void _pickedImage(File image) {
    _userImageFile = image;
  }

  _loadDistricts() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      await Provider.of<Auth>(context, listen: false).getDistricts();
      _districtValues = Provider.of<Auth>(context, listen: false).districts;
      _selectDistrict = _districtValues.singleWhere(
          (district) => district.key == _editUser.districtId.toString());
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

  void didChangeDependencies() {
    if (_isInit) {
      _loadDistricts();
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
      profile_image = '$user_image_path/${_editUser.avatar}';
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading2 = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .updateUser(_userData, _userImageFile);
      Navigator.of(context).pop();
      toast('Profile saved successfully');
    } on SocketException {
      toastLong('No Internet connection');
    } catch (error) {
      print(error);
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occured!'),
          content: Text('Something went wrong'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Okay'),
            )
          ],
        ),
      );
    }
    setState(() {
      _isLoading2 = false;
    });
    print(_userData);
  }

  List<KeyValueModel> _genderValues = [
    KeyValueModel(key: "Male", value: "Male"),
    KeyValueModel(key: "Female", value: "Female"),
    KeyValueModel(key: "Other", value: "Other"),
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    _selectGender =
        _genderValues.singleWhere((gender) => gender.key == _editUser.gender);

    return Scaffold(
      backgroundColor: quiz_app_background,
      appBar: AppBar(
        title: text('Edit Profile',
            fontSize: textSizeNormal, fontFamily: fontMedium),
        leading: Icon(Icons.arrow_back, color: Banking_blackColor, size: 30)
            .onTap(() {
          Navigator.of(context).pop();
        }),
        centerTitle: true,
        backgroundColor: quiz_app_background,
        elevation: 0.0,
      ),
      body: Container(
        color: quiz_app_background,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _error.isEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        UserImagePicker(_pickedImage, profile_image),
                        SizedBox(height: 20),
                        Container(
                          child: Form(
                            key: this._formKey,
                            child: Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                cTextLabel('NAME', 'نام'),
                                padTextField(
                                  child: padTextField(
                                    child: comEditTextInit(
                                      textCapitalization:
                                          TextCapitalization.words,
                                      initValue: _userData['name'],
                                      hintText: 'Enter full name here',
                                      validator: (value) {
                                        if (value.isEmpty || value.length < 3) {
                                          return 'Name is too short!';
                                        }
                                        if (value.length > 15) {
                                          return 'Name is too long!';
                                        }
                                      },
                                      value: (val) {
                                        _userData['name'] = val;
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[a-zA-Z ]")),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                cTextLabel('CNIC #', 'شناختی کارڈ نمبر'),
                                padTextField(
                                  child: padTextField(
                                      child: comEditTextInit(
                                    initValue: _userData['cnic'],
                                    hintText: '00000-0000000-0',
                                    validator: (value) {
                                      if (value.isEmpty || value.length < 15) {
                                        return 'CNIC is invalid!';
                                      }
                                    },
                                    textInputType: TextInputType.number,
                                    value: (val) {
                                      _userData['cnic'] = val;
                                    },
                                    inputFormatters: [maskFormatter],
                                  )),
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                cTextLabel('Mobile #', 'موبائل نمبر'),
                                padTextField(
                                  child: padTextField(
                                      child: comEditTextInit(
                                    initValue: _userData['contact_no'],
                                    hintText: '+923333333',
                                    validator: (value) {
                                      if (value.isEmpty || value.length < 10) {
                                        return 'Number is invalid!';
                                      }
                                    },
                                    textInputType: TextInputType.number,
                                    value: (val) {
                                      _userData['contact_no'] = "+92" + val;

                                      print(
                                          "Contact Number ${_userData['contact_no']}");
                                    },
                                    inputFormatters: [mobileFormatter],
                                  )),
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                cTextLabel('GENDER', 'صنف'),
                                padTextField(
                                  child: searchDropDown(
                                    selectedItem: _selectGender,
                                    itemList: _genderValues,
                                    hint: 'Select Gender',
                                    mode: Mode.MENU,
                                    showSearch: false,
                                    value: (KeyValueModel val) {
                                      _userData['gender'] = val.key;
                                      print(val.key);
                                      _selectGender = val;
                                    },
                                    validator: (KeyValueModel item) {
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
                                cTextLabel('ADDRESS', 'پتہ'),
                                padTextField(
                                  child: comEditTextInit(
                                    initValue: _userData['address'],
                                    hintText: 'Enter address here',
                                    maxline: 4,
                                    validator: (value) {
                                      if (value.isEmpty || value.length < 5) {
                                        return 'address is too short!';
                                      }
                                    },
                                    value: (val) {
                                      _userData['address'] = val;
                                    },
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                cTextLabel('DISTRICT', 'ضلع'),
                                padTextField(
                                  child: searchDropDown(
                                    selectedItem: _selectDistrict,
                                    itemList: _districtValues,
                                    hint: 'Select District',
                                    value: (KeyValueModel val) {
                                      _userData['district_id'] = val.key;
                                      print(val.key);
                                      _selectDistrict = val;
                                    },
                                    validator: (KeyValueModel item) {
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
                        Container(
                          margin: EdgeInsets.all(24.0),
                          child: _isLoading2
                              ? CircularProgressIndicator()
                              : T3AppButton(
                                  textContent: 'UPDATE PROFILE',
                                  onPressed: _submit),
                        )
                      ],
                    ),
                  )
                : errorContainer(_error, () {
                    _loadDistricts();
                  }, size.width),
      ),
    );
  }
}
