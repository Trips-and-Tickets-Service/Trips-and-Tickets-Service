import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripsProvider extends ChangeNotifier {
  // For manipulation with ID of user
  int _myID = -1;
  int get myID => _myID;
  set myID(int value) {
    _myID = value;
    notifyListeners();
  }

  // For manipulation with name of user
  String _myName = 'HaveNotName';
  String get myName => _myName;
  set myName(String value) {
    _myName = value;
    notifyListeners();
  }

  // For manipulation with email of user
  String _email = 'NaveNotEmail';
  String get email => _email;
  set email(String value) {
    _email = value;
    notifyListeners();
  }

  // For manipulation with password of user
  String _password = 'NaveNotPass';
  String get password => _password;
  set password(String value) {
    _password = value;
    notifyListeners();
  }

  String _languageCode = 'en';
  String get languageCode => _languageCode;

  String _accessToken = 'NoneAccessToken';
  String get accessToken => _accessToken;
  set accessToken(String value) {
    _accessToken = value;
    notifyListeners();
  }

  void toggleLanguage() {
    _languageCode = _languageCode == 'ru' ? 'en' : 'ru';
    notifyListeners();
  }

  void setLanguage(String code) {
    _languageCode = code;
    notifyListeners();
  }

  // For saving the information about the user after registration/signin
  void saveMyPersonalInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('myName', _myName);
    await prefs.setInt('myID', _myID);
    await prefs.setString('email', _email);
    await prefs.setString('password', _password);
    await prefs.setString('accessToken', _accessToken);
  }

  // For loading the information about the user
   void loadMyPersonalInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _myName = prefs.getString('myName') ?? 'HaveNotName';
    _myID = prefs.getInt('myID') ?? -1;
    _email = prefs.getString('email') ?? 'NavNotEmail';
    _password = prefs.getString('password') ?? 'NavNotPass';
    _accessToken = prefs.getString('accessToken') ?? 'NoneAccessToken';
    notifyListeners();
  }

  // For clearing the information about the user after signout
  void clearMyPersonalInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('myName');
    await prefs.remove('myID');
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('accessToken');
    _myName = 'HaveNotName';
    _myID = -1;
    _email = 'NavNotEmail';
    _password = 'NavNotPass';
    _accessToken = 'NoneAccessToken';
    notifyListeners();
  }
  
}