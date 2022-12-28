import 'dart:convert';
import 'dart:io';
import 'package:cmcp/model/category.dart';
import 'package:cmcp/model/complain.dart';
import 'package:cmcp/model/keyValue.dart';
import 'package:cmcp/model/tehsil.dart';
import 'package:cmcp/model/track.dart';
import 'package:cmcp/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:cmcp/services/base_api.dart';

class Complains extends BaseApi with ChangeNotifier {
  final Auth _auth;
  Complains(this._auth);

  List<Complain> _complains = [];
  List<Track> _tracks = [];
  List<Category> _categories = [];
  List<Tehsil> _tehsils = [];
  List<KeyValueModel> _cat2s = [];
  List<KeyValueModel> _cat3s = [];
  List<KeyValueModel> _districts = [];
  List<KeyValueModel> _tehsilValues = [];

  KeyValueModel selectCat3;

  List<Category> get categories => [..._categories];
  List<Complain> get complains => [..._complains];
  List<Track> get tracks => [..._tracks];
  List<Tehsil> get tehsils => [..._tehsils];
  List<KeyValueModel> get cat2s => [..._cat2s];
  List<KeyValueModel> get cat3s => [..._cat3s];
  List<KeyValueModel> get districts => [..._districts];
  List<KeyValueModel> get tehsilValues => [..._tehsilValues];

  // Create Complain Section

  Future<void> fetchcat1() async {
    try {
      var response = await api.httpGet('loadCat1');
      if (response.statusCode != 200) {
        throw Exception();
      }
      final loadedData = json.decode(response.body);
      final List<Category> loadedCats = [];
      loadedData['categories'].forEach((catData) {
        loadedCats.add(Category.fromJson(catData));
      });
      _categories = loadedCats;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> fetchCatDist(String id) async {
    try {
      var response = await api.httpGet('createComplain/$id');
      if (response.statusCode != 200) {
        throw Exception();
      }
      final loadedData = json.decode(response.body);
      final List<KeyValueModel> loadedDistricts = [];
      final List<KeyValueModel> loadedCat2s = [];
      final List<Tehsil> loadedtehsils = [];

      loadedData['cat2'].forEach((cat2Data) {
        loadedCat2s.add(
          KeyValueModel(
              key: cat2Data['id'].toString(), value: cat2Data['title']),
        );
      });
      loadedData['districts'].forEach((schData) {
        loadedDistricts.add(
          KeyValueModel(key: schData['id'].toString(), value: schData['title']),
        );
      });

      loadedData['tehsils'].forEach((schData) {
        loadedtehsils.add(
          Tehsil.fromJson(schData),
        );
      });

      _cat2s = loadedCat2s;
      _districts = loadedDistricts;
      _tehsils = loadedtehsils;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> fetchCat3(String id) async {
    try {
      selectCat3 = null;
      _cat3s.clear();
      var response = await api.httpGet('loadCat3/$id');
      if (response.statusCode != 200) {
        throw Exception();
      }
      final loadedData = json.decode(response.body);
      final List<KeyValueModel> loadedCat3s = [];
      loadedData['cat3'].forEach((catData) {
        loadedCat3s.add(
          KeyValueModel(key: catData['id'].toString(), value: catData['title']),
        );
      });
      _cat3s = loadedCat3s;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> fetchTehsil(String id) async {
    try {
      List<Tehsil> filterTeh = tehsils
          .where((element) => element.districtId == int.parse(id))
          .toList();
      final List<KeyValueModel> loadedTehsils = [];
      filterTeh.forEach((catData) {
        loadedTehsils.add(
          KeyValueModel(key: catData.id.toString(), value: catData.title),
        );
      });
      _tehsilValues = loadedTehsils;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> registerComplain(var comData, List<File> file) async {
    try {
      var response = await api.httpPostWithMultiFile('storeComplain', comData,
          allFile: file);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['response'] == 0) {
        throw HttpException(responseData['message'].join(','));
      }
      if (responseData['response'] == 1) {
        this._auth.updateDashboard();
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // show Complains

  Future<void> fetchComplains(String query) async {
    try {
      var response = await api.httpGet('complains?status=$query');
      if (response.statusCode != 200) {
        throw Exception();
      }
      final loadedData = json.decode(response.body);
      final List<Complain> loadedComp = [];
      loadedData['data'].forEach((comData) {
        loadedComp.add(Complain.fromJson(comData));
      });
      _complains = loadedComp;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Complain findById(int id) {
    return _complains.firstWhere((ath) => ath.id == id);
  }

  Future<void> fetchTrack(int id) async {
    try {
      var response = await api.httpGet('complainTrack/$id');
      if (response.statusCode != 200) {
        throw Exception();
      }
      final loadedData = json.decode(response.body);
      print(loadedData);
      final List<Track> loadedTrack = [];
      loadedData['data'].forEach((comData) {
        loadedTrack.add(Track.fromJson(comData));
      });
      _tracks = loadedTrack;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // feedback section

  Future<void> getFeedback(int id) async {
    try {
      var response = await api.httpGet('feedbacks/$id');
      if (response.statusCode != 200) {
        throw Exception();
      }
      final loadedData = json.decode(response.body);
      print(loadedData);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> giveFeedback(int id, var data) async {
    try {
      var response = await api.httpPost('feedback/$id', data);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final loadedData = json.decode(response.body);
      print(loadedData);
      if (loadedData['response'] == 0) {
        throw HttpException(loadedData['message'].join(','));
      }

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
