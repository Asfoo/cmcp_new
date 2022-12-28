import 'dart:io';
import 'package:cmcp/main_theme/utils/AppConstant.dart';
import 'package:cmcp/main_theme/utils/flutter_rating_bar.dart';
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

class NewFeedbackScreen extends StatefulWidget {
  static const String tag = "/NewFeedback";

  @override
  _NewFeedbackScreenState createState() => _NewFeedbackScreenState();
}

class _NewFeedbackScreenState extends State<NewFeedbackScreen> {
  final GlobalKey<FormState> _formKey1 = GlobalKey();
  var _isInit = true;
  var _isloading = false;
  var _isLoading2 = false;
  var _error = '';
  var _comId;
  int _rStatusInd = 6;
  int _sStatusInd = 6;

  List _rStatus = ['r', 'pr', 'nr'];
  List _sStatus = ['s', 'ns'];

  String _ratingError = '';
  String _rStatusError = '';
  String _sStatusError = '';

  var _fdData = {
    'rating': '',
    'comments': '',
    'r_status': '',
    's_status': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _comId = ModalRoute.of(context).settings.arguments as int;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<bool> _onWillPop() async {
    // Provider.of<Athletes>(context, listen: false).clearAll();
    return true;
  }

  void _submit() async {
    setState(() {
      _ratingError = '';
      _rStatusError = '';
      _sStatusError = '';
    });
    if (_fdData['rating'] == '' ||
        _fdData['r_status'] == '' ||
        _fdData['s_status'] == '') {
      setState(() {
        if (_fdData['rating'] == '') {
          _ratingError = 'Rating is required!';
        }
        if (_fdData['r_status'] == '') {
          _rStatusError = 'Resolution status is required!';
        }
        if (_fdData['s_status'] == '') {
          _sStatusError = 'Satisfied status is required!';
        }
      });
      return;
    }

    if (!_formKey1.currentState.validate()) {
      return;
    }
    _formKey1.currentState.save();

    showLoading();
    try {
      await Provider.of<Complains>(context, listen: false)
          .giveFeedback(_comId, _fdData);
      Get.back();
      Navigator.of(context).popUntil((route) => route.isFirst);
      toast('Feedback Successfully Submitted');
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

    print(_fdData);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                                        cTextLabel('RATING', 'درجہ بندی'),
                                        padTextField(
                                          child: RatingBar(
                                            initialRating: 0,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                              _fdData['rating'] =
                                                  rating.toInt().toString();
                                            },
                                          ),
                                        ),
                                        if (_ratingError.isNotEmpty)
                                          validationError(_ratingError),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        cTextLabel('FEEDBACK', 'فیڈ بیک'),
                                        padTextField(
                                            child: comEditTextStyle(
                                          maxLength: 1000,
                                          showCounter: false,
                                          hintText: 'Write feeback here...',
                                          maxline: 4,
                                          validator: (value) {
                                            if (value.isEmpty ||
                                                value.length < 5) {
                                              return 'Feedback must be at least 5 characters!';
                                            }
                                          },
                                          value: (val) {
                                            _fdData['comments'] = val;
                                          },
                                        )),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        cTextLabel('RESOLUTION STATUS', ''),
                                        padTextField(
                                            child: ButtonGroup(
                                          titles: [
                                            "Resolved",
                                            "Partial Resolved",
                                            "Not Resolved"
                                          ],
                                          current: _rStatusInd,
                                          color: t3_colorPrimary,
                                          secondaryColor: Colors.white,
                                          onTab: (selected) {
                                            setState(() {
                                              _rStatusInd = selected;
                                              print(_rStatus[_rStatusInd]);
                                              _fdData['r_status'] =
                                                  _rStatus[_rStatusInd];
                                            });
                                          },
                                        )),
                                        if (_rStatusError.isNotEmpty)
                                          validationError(_rStatusError),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        cTextLabel(
                                            'ARE YOU SATISFIED WITH THE COMPLAINT RESOLUTION?',
                                            ''),
                                        padTextField(
                                            child: ButtonGroup(
                                          titles: [
                                            "YES",
                                            "NO",
                                          ],
                                          current: _sStatusInd,
                                          color: t3_colorPrimary,
                                          secondaryColor: Colors.white,
                                          onTab: (selected) {
                                            setState(() {
                                              _sStatusInd = selected;
                                              print(_sStatus[_sStatusInd]);
                                              _fdData['s_status'] =
                                                  _sStatus[_sStatusInd];
                                            });
                                          },
                                        )),
                                        if (_sStatusError.isNotEmpty)
                                          validationError(_sStatusError),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              30, 40, 30, 10),
                                          child: _isLoading2
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : T3AppButton(
                                                  textContent: 'SUBMIT',
                                                  onPressed: _submit,
                                                ),
                                        ),
                                      ],
                                    )),
                                  ),
                                )
                              : errorContainer(_error, () {}, size.width),
                        ),
                ],
              ),
              Column(
                children: [
                  MyAppBar(
                    titleName: 'Feedback',

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
