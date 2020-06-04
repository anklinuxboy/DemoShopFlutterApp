import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';
import '../api.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  Future<void> signup(String email, String password) async {
    const url = "$AUTH_BASE_URL$SIGNUP_PATH_URL$AUTH_API_KEY";
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final data = json.decode(response.body);
      if (data['error'] != null) {
        throw HttpException(data['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    const url = "$AUTH_BASE_URL$LOGIN_PATH_URL$AUTH_API_KEY";
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final data = json.decode(response.body);
      if (data['error'] != null) {
        throw HttpException(data['error']['message']);
      }

      _token = data['idToken'];
      _userId = data['localId'];
      _expiryDate =
          DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
