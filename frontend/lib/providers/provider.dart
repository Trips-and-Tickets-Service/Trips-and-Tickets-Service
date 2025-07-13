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
  String _myName = 'HavNotName';
  String get myName => _myName;
  set myName(String value) {
    _myName = value;
    notifyListeners();
  }

  // For manipulation with email of user
  String _email = 'NavNotEmail';
  String get email => _email;
  set email(String value) {
    _email = value;
    notifyListeners();
  }

  // For manipulation with password of user
  String _password = 'NavNotPass';
  String get password => _password;
  set password(String value) {
    _password = value;
    notifyListeners();
  }

  // For saving the information about the user after registration/signin
  void saveMyPersonalInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('myName', _myName);
    await prefs.setInt('myID', _myID);
    await prefs.setString('email', _email);
    await prefs.setString('password', _password);
  }

  // For loading the information about the user
   void loadMyPersonalInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _myName = prefs.getString('myName') ?? 'HaveNotName';
    _myID = prefs.getInt('myID') ?? -1;
    _email = prefs.getString('email') ?? 'NavNotEmail';
    notifyListeners();
  }

  // For clearing the information about the user after signout
  void clearMyPersonalInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('myName');
    await prefs.remove('myID');
    await prefs.remove('email');
    await prefs.remove('password');
    _myName = 'HaveNotName';
    _myID = -1;
    _email = 'NavNotEmail';
    _password = 'NavNotPass';
    notifyListeners();
  }
}