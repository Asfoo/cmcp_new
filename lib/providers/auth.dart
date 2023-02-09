import 'dart:io';

import 'package:cmcp/model/dasboard.dart';
import 'package:cmcp/model/keyValue.dart';
import 'package:cmcp/model/user.dart';
import 'package:flutter/widgets.dart';
import 'package:cmcp/services/api.dart';
import 'package:cmcp/services/base_api.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/http_exception.dart';

class Auth extends BaseApi with ChangeNotifier {
  Api _api = Api();
  String _token;
  DateTime _expiryDate;
  Timer _authTimer;
  User _user;
  Dashboard _dashboard;
  bool _check = false;
  bool _checkEmail = false;
  String _website;
  List<KeyValueModel> _districts = [];

  bool get isAuth {
    return token != null;
  }

  User get user => _user;
  Dashboard get dashboard => _dashboard;
  List<KeyValueModel> get districts => [..._districts];

  String get userName {
    return _user.name;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  bool get check => _check;
  bool get checkEmail => _checkEmail;
  String get website => _website ?? 'https://cmdu.gob.pk';

  set() {
    _checkEmail = false;
    notifyListeners();
  }

  notifyAuth() {
    notifyListeners();
  }

  // setCheck() {
  //   _check = true;
  //   notifyListeners();
  // }

  Future<dynamic> _authenticate(
    String email,
    String password,
    String fcmToken,
  ) async {
    try {
      print(email);
      print(password);
      var response = await api.httpPost(
        'login',
        {'email': email, 'password': password, 'fcm_token': fcmToken},
      );
      if (response.statusCode != 200) {
        throw Exception();
      }
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['response'] == 0) {
        throw new CustomHttpException(responseData['message']);
      }

      if (responseData['response'] == '2') {
        return responseData;
      }
      _checkEmail = true;
      _user = User.fromJson(responseData['user']);
      _dashboard = Dashboard.fromJson(responseData['dashboard']);
      _token = responseData['token'];
      // _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      _api.token = _token;
      final userData = json.encode({
        'token': _token,
        'user': json.encode(_user.toJson()),
      });
      prefs.setString('userData', userData);
      return responseData;
    } catch (error) {
      throw error;
    }
  }

  // Future<void> signup(String email, String password) async {
  //   return _authenticate(email, password, 'signUp');
  // }

  Future<dynamic> login(
    String email,
    String password,
    String fcmToken,
  ) async {
    return _authenticate(email, password, fcmToken);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 4));
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    _token = extractedUserData['token'];
    _user = User.fromJson(json.decode(extractedUserData['user']));
    _api.token = _token;
    _check = true;
    notifyListeners();

    return true;
    // _autoLogout();
    // return true;
  }

  Future<void> logout() async {
    _token = null;
    _user = User();
    _api.token = _token;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<dynamic> register(var data) async {
    try {
      var response = await api.httpPost('register', data);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['response'] == 0) {
        throw CustomHttpException(responseData['message'].join(','));
      }

      _setUserData(responseData);
      return responseData;
    } catch (error) {
      print('error $error');
      throw error;
    }
  }

  // Profile Place

  Future<void> getDashboard() async {
    try {
      final response = await api.httpGet('dashboard');
      if (response.statusCode != 200) {
        throw Exception();
      }
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['message'] == 'Unauthenticated.') {
        logout();
      }
      if (responseData['user'] == null) {
        throw Exception;
      }
      _user = User.fromJson(responseData['user']);
      _dashboard = Dashboard.fromJson(responseData['dashboard']);
      _check = false;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  updateDashboard() {
    Dashboard updateDash = Dashboard(
      total: _dashboard.total + 1,
      inprogress: _dashboard.inprogress + 1,
      dropp: _dashboard.dropp,
      resolved: _dashboard.resolved,
    );
    _dashboard = updateDash;
    notifyListeners();
  }

  // Future<void> updateUser(Map<String, String> user, File image) async {
  //   try {
  //     var response =
  //         await api.httpPostWithFile('user/update', user, file: image);
  //     final loadedData = json.decode(response.body);
  //     final updateUser = User(
  //         first_name: user['first_name'],
  //         last_name: user['last_name'],
  //         dial_code: user['dial_code'],
  //         phone: user['phone'],
  //         email: user['email'],
  //         nationality: user['nationality'],
  //         address: user['address'],
  //         avatar: loadedData['user']['avatar'],
  //         relation: user['relation'],
  //         status: loadedData['user']['status']);
  //     _user = updateUser;
  //     notifyListeners();
  //   } catch (error) {
  //     print('error : ' + error);
  //     throw error;
  //   }
  // }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      var response = await api.httpPost(
        'user/password',
        {
          'old_password': oldPassword.trim(),
          'new_password': newPassword.trim(),
        },
      );
      if (response.statusCode != 200) {
        throw Exception();
      }
      final responseData = json.decode(response.body);
      if (responseData['response'] == 0) {
        print(responseData['message']);
        throw new CustomHttpException(responseData['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> getDistricts() async {
    try {
      final response = await api.httpGet('loadDistrict');
      if (response.statusCode != 200) {
        throw Exception();
      }
      final responseData = json.decode(response.body);
      print(responseData);
      final List<KeyValueModel> loadedDistricts = [];
      responseData['districts'].forEach((schData) {
        loadedDistricts.add(
          KeyValueModel(key: schData['id'].toString(), value: schData['title']),
        );
      });
      _districts = loadedDistricts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  _setUserData(var responseData) async {
    _user = User.fromJson(responseData['user']);
    _dashboard = Dashboard.fromJson(responseData['dashboard']);
    _token = responseData['token'];
    // _autoLogout();
    _checkEmail = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    _api.token = _token;
    final userData = json.encode({
      'token': _token,
      'user': json.encode(_user.toJson()),
    });
    prefs.setString('userData', userData);
  }

  Future<void> updateUser(Map<String, String> user, File image) async {
    try {
      var response =
          await api.httpPostWithFile('user/update', user, file: image);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final loadedData = json.decode(response.body);
      print(loadedData);
      final updateUser = User.fromJson(loadedData['user']);
      _user = updateUser;
      notifyListeners();
    } catch (error) {
      print('error : ' + error);
      throw error;
    }
  }

  Future<dynamic> sendResetPassRequest(var data) async {
    try {
      var response = await api.httpPost('requestReset', data);
      print(json.decode(response.body));
      if (response.statusCode != 200) {
        throw Exception();
      }
      final responseData = json.decode(response.body);
      print(responseData);
      return responseData;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<dynamic> resetPass(var data) async {
    try {
      var response = await api.httpPost('verifyPassOtp', data);
      if (response.statusCode != 200) {
        print(json.decode(response.body));
        throw Exception();
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // email verification
  Future<dynamic> requestEmailVerify() async {
    try {
      var response = await api.httpGet('requestEmailVerify');
      print(json.decode(response.body));
      if (response.statusCode != 200) {
        throw Exception();
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<dynamic> verifyEmail(var data) async {
    try {
      var response = await api.httpPost('verifyEmail', data);
      if (response.statusCode != 200) {
        print(json.decode(response.body));
        throw Exception();
      }
      final responseData = json.decode(response.body);
      if (responseData['response'] == 1) {
        final updateUser = User.fromJson(responseData['user']);
        _user = updateUser;
        notifyListeners();
      }

      return responseData;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // mobile verification
  Future<dynamic> requestNumberVerify() async {
    try {
      var response = await api.httpGet('requestNumberVerify');
      print("heloo");
      print(response.statusCode);
      print(json.decode(response.body));
      if (response.statusCode != 200) {
        throw Exception();
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<dynamic> verifyNumber(var data) async {
    try {
      var response = await api.httpPost('verifyNumber', data);
      if (response.statusCode != 200) {
        print(json.decode(response.body));
        throw Exception();
      }
      final responseData = json.decode(response.body);
      if (responseData['response'] == 1) {
        final updateUser = User.fromJson(responseData['user']);
        _user = updateUser;
        notifyListeners();
      }

      return responseData;
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
