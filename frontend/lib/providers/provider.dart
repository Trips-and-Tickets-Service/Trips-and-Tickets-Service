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

  String _lightMode = 'light';
  String get lightMode => _lightMode;

  String _accessToken = 'NoneAccessTokenInInitialProvider';
  String get accessToken => _accessToken;
  set accessToken(String value) {
    _accessToken = value;
    notifyListeners();
  }

  void toggleLanguage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _languageCode = _languageCode == 'ru' ? 'en' : 'ru';
    await prefs.setString('languageCode', _languageCode);
    notifyListeners();
  }

  void toggleLightMode() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _lightMode = _lightMode == 'light' ? 'dark' : 'light';
    await prefs.setString('lightMode', _lightMode);
    notifyListeners();
  }

    void loadLanguageAndLightMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _languageCode = prefs.getString('languageCode') ?? 'en';
    _lightMode = prefs.getString('lightMode') ?? 'light';
    notifyListeners();
  }

  void setLanguage(String code) {
    _languageCode = code;
    notifyListeners();
  }

  // For saving the information about the user after registration/signin
  Future<void> saveMyPersonalInfo() async {
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
    // _accessToken = prefs.getString('accessToken') ?? 'NoneAccessTokenInPersInfo';
    notifyListeners();
  }

  Future<void> loadAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('accessToken') ?? 'NoneAccessTokenInLoad';
    notifyListeners();
  }

  // For clearing the information about the user after signout
  Future<void> clearMyPersonalInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('myName');
    // await prefs.remove('myID');
    // await prefs.remove('email');
    // await prefs.remove('password');
    // await prefs.remove('accessToken');
    await prefs.clear();
    _myName = 'HaveNotName';
    _myID = -1;
    _email = 'NavNotEmail';
    _password = 'NavNotPass';
    _accessToken = 'NoneAccessTokenInLogOut';
    notifyListeners();
  }
}