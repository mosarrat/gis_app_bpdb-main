import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gis_app_bpdb/widgets/login/signin.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../constants/constant.dart';
import '../models/Login/login.dart';

class CallLoginApi {
  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  void showMessage(String message, String type) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: type.contains('error') ? Colors.red : Colors.grey[800],
      textColor: type.contains('error') ? Colors.yellow : Colors.white,
      fontSize: 20.0,
    );
  }

  Future<LoginResponse?> loginApi(Login login) async {
    final requestData = {
      'Username': login.Username,
      'Password': login.Password,
    };
    final url = Uri.parse('$myAPILink/api/Auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw 'Failed to log in! Please check your credentials and try again.';
    }
  }
}
