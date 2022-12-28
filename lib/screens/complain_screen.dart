import 'dart:io';
import 'package:cmcp/main_theme/utils/AppConstant.dart';
import 'package:cmcp/model/keyValue.dart';
import 'package:cmcp/providers/complains.dart';
import 'package:cmcp/widgets/mix_widgets.dart';
import 'package:cmcp/widgets/pickers/complain_picker.dart';
import 'package:cmcp/widgets/pickers/location_picker.dart';
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

class ComplainScreen extends StatefulWidget {
  static const String tag = "/Complain";

  @override
  _ComplainScreenState createState() => _ComplainScreenState();
}

class _ComplainScreenState extends State<ComplainScreen> {
  final GlobalKey<FormState> _formKey1 = GlobalKey();
  var _isInit = true;
  var _isloading = false;
  var _isLoading2 = false;
  var _error = '';
  var _args_data;
  bool _hideMe = false;
  // KeyValueModel _selectedCat2;
  KeyValueModel _selectedCat3;
  KeyValueModel _selectedTehsil;
  // Future _cat3Future;

  var _comData = {
    'subject': '',
    'detail': '',
    'category3_id': '',
    'address': '',
    'district_id': '',
    'tehsil_id': '',
    'gps_location': '',
    'lat_long': '',
    'hide_identity': '0',
  };

  _loadData() async {
    setState(() {
      _isloading = true;
      _error = '';
    });
    try {
      await Provider.of<Complains>(context, listen: false)
          .fetchCatDist(_args_data['id']);
    } on SocketException {
      _error = 'No Internet connection';
    } catch (e) {
      print(e.toString());
      _error = 'Something went wrong!';
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _args_data =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      _loadData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<bool> _onWillPop() async {
    // Provider.of<Athletes>(context, listen: false).clearAll();
    return true;
  }

  _obtainCat3Future(String cat_id) async {
    showLoading();
    try {
      await Provider.of<Complains>(context, listen: false).fetchCat3(cat_id);
      setState(() {
        _selectedCat3 = null;
      });
    } catch (error) {
      toast('Something went wrong', textColor: redColor);
      print(error);
    }
    Get.back();
  }

  _obtainTehsil(String dis_id) async {
    await Provider.of<Complains>(context, listen: false).fetchTehsil(dis_id);
  }

  void _pickedLocation(String latLong, String address) {
    _comData['lat_long'] = latLong;
    _comData['gps_location'] = address;
    print('nami');
    print(_comData['gps_location']);
  }

  List<File> _compFile;
  void _pickedImage(List<File> file) {
    _compFile = file;
    print('files $_compFile');
  }

  void _register() async {
    if (!_formKey1.currentState.validate()) {
      return;
    }
    _formKey1.currentState.save();
    showLoading();
    try {
      await Provider.of<Complains>(context, listen: false)
          .registerComplain(_comData, _compFile);
      Get.back();
      Navigator.of(context).popUntil((route) => route.isFirst);
      toast('Complain Successfully Register');
    } on HttpException catch (error) {
      Get.back();
      showErrorDialog('An error occured!', error.toString(), context);
    } on SocketException {
      Get.back();
      toast('No Internet connection');
    } catch (error) {
      Get.back();
      showErrorDialog('An error occured!', 'Something went wrong', context);
    }

    print(_comData);
    // Navigator.of(context).pop();
    // toast('Successfully Register');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final _cat2s = Provider.of<Complains>(context, listen: false).cat2s;
    final _district = Provider.of<Complains>(context, listen: false).districts;
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
                                        cTextLabel('SUBJECT', 'عنوان'),
                                        padTextField(
                                            child: comEditTextStyle(
                                          maxLength: 100,
                                          showCounter: true,
                                          hintText: 'Enter Subject here',
                                          validator: (value) {
                                            if (value.isEmpty ||
                                                value.length < 3) {
                                              return 'Subject must be at least 5 characters!';
                                            }
                                          },
                                          value: (val) {
                                            _comData['subject'] = val;
                                          },
                                        )),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        cTextLabel('CATEGORY', 'زمرہ'),
                                        padTextField(
                                          child: searchDropDown(
                                            itemList: _cat2s,
                                            hint: 'Select Category',
                                            value: (KeyValueModel val) {
                                              _obtainCat3Future(val.key);
                                              setState(() {
                                                _selectedCat3 = null;
                                              });
                                            },
                                            validator: (KeyValueModel item) {
                                              if (item == null)
                                                return "Category required";
                                              else
                                                return null;
                                            },
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        cTextLabel('CATEGORY TWO', 'زمرہ دوم'),
                                        padTextField(
                                          child: Consumer<Complains>(
                                            builder: (ctx, compData, _) =>
                                                searchDropDown(
                                              key: UniqueKey(),
                                              selectedItem: _selectedCat3,
                                              itemList: compData.cat3s,
                                              hint: 'Select Category Two',
                                              value: (KeyValueModel val) {
                                                _comData['category3_id'] =
                                                    val.key;
                                                _selectedCat3 = val;
                                              },
                                              validator: (KeyValueModel item) {
                                                if (item == null)
                                                  return "Category Two required";
                                                else
                                                  return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        cTextLabel('COMPLAINT DETAILS',
                                            'شکایت کی تفصیل'),
                                        padTextField(
                                            child: comEditTextStyle(
                                          maxLength: 1000,
                                          showCounter: true,
                                          hintText: 'Enter Details here',
                                          maxline: 4,
                                          validator: (value) {
                                            if (value.isEmpty ||
                                                value.length < 25) {
                                              return 'Detail must be at least 30 characters!';
                                            }
                                          },
                                          value: (val) {
                                            _comData['detail'] = val;
                                          },
                                        )),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        cTextLabel('COMPLAINT ADDRESS',
                                            'شکایت کا پتہ'),
                                        padTextField(
                                            child: comEditTextStyle(
                                          hintText: 'Enter address here',
                                          maxline: 4,
                                          validator: (value) {
                                            if (value.isEmpty ||
                                                value.length < 5) {
                                              return 'Address is too short!';
                                            }
                                          },
                                          value: (val) {
                                            _comData['address'] = val;
                                          },
                                        )),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        cTextLabel('DISTRICT', 'ضلع'),
                                        padTextField(
                                          child: searchDropDown(
                                            itemList: _district,
                                            hint: 'Select District',
                                            value: (KeyValueModel val) {
                                              _obtainTehsil(val.key);
                                              _selectedTehsil = null;
                                              _comData['district_id'] = val.key;
                                            },
                                            validator: (KeyValueModel item) {
                                              if (item == null)
                                                return "District is required";
                                              else
                                                return null;
                                            },
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        cTextLabel('TEHSIL', 'تحصیل',
                                            required: false),
                                        padTextField(
                                          child: Consumer<Complains>(
                                            builder: (ctx, compData, _) =>
                                                searchDropDown(
                                              key: UniqueKey(),
                                              selectedItem: _selectedTehsil,
                                              itemList: compData.tehsilValues,
                                              hint: 'Select Tehsil',
                                              value: (KeyValueModel val) {
                                                _comData['tehsil_id'] = val.key;
                                                _selectedTehsil = val;
                                              },
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        cTextLabel('GPS LOCATION', '',
                                            required: false),
                                        LocationPicler(_pickedLocation),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        cTextLabel('ATTACHMENTS', '',
                                            required: false),
                                        ComplainPicker(_pickedImage),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Card(
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                unselectedWidgetColor:
                                                    gray_text_color,
                                              ),
                                              child: CheckboxListTile(
                                                tileColor:
                                                    complain_app_Background,
                                                checkColor: white,
                                                value: _hideMe,
                                                onChanged: (checked) {
                                                  print(checked);
                                                  setState(() {
                                                    _hideMe = checked;
                                                    _comData['hide_identity'] =
                                                        checked ? '1' : '0';
                                                  });
                                                },
                                                title: Text(
                                                  'HIDE MY IDENTITY ?',
                                                  style: TextStyle(
                                                      color: t3_colorPrimary,
                                                      fontFamily: fontBold,
                                                      fontSize: textSizeSmall),
                                                ),
                                                subtitle: Text(
                                                  'میری شناخت چھپائیں',
                                                  style: secondaryTextStyle(
                                                      color: gray_text_color),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              30, 0, 30, 10),
                                          child: _isLoading2
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : T3AppButton(
                                                  textContent: 'SUBMIT',
                                                  onPressed: _register,
                                                ),
                                        ),
                                      ],
                                    )),
                                  ),
                                )
                              : errorContainer(_error, () {
                                  _loadData();
                                }, size.width),
                        ),
                ],
              ),
              Column(
                children: [
                  MyAppBar(
                    titleName: 'New Complain',

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

Padding padTextField({Widget child}) {
  return Padding(
      padding: EdgeInsets.only(left: 12, right: 12, bottom: 3, top: 0),
      child: child);
}

Column mediaIcons({Color color, IconData icon, String text}) {
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
            color: Colors.white,
          ),
          iconSize: 30,
          onPressed: () {
            // toasty(context, "upload");
          },
        ),
      ),
      Text(
        text,
        style: secondaryTextStyle(),
      )
    ],
  );
}
