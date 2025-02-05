import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../constants/constant.dart';
import '../models/region_delails_lookup/circle.dart';
import '../models/region_delails_lookup/esu.dart';
import '../models/region_delails_lookup/snd.dart';
import '../models/region_delails_lookup/substation.dart';
import '../models/regions/zone.dart';

class CallRegionApi {
  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
    //return true;
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

  Future<List<Zone>> fetchZoneInfo() async {
    final response = await http.get(Uri.parse('$myAPILink/api/ZoneInfoes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<Zone>((json) => Zone.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load zone info');
    }
  }

  Future<List<Circle>> fetchCircleInfo() async {
    final response = await http.get(Uri.parse('$myAPILink/api/CircleInfoes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<Circle>((json) => Circle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load circle info');
    }
  }

  Future<List<Snd>> fetchSndInfo() async {
    final response = await http.get(Uri.parse('$myAPILink/api/SndInfoes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<Snd>((json) => Snd.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Snd info');
    }
  }

  Future<List<Esu>> fetchEsuInfo() async {
    final response = await http.get(Uri.parse('$myAPILink/api/EsuInfoes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<Esu>((json) => Esu.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Esu info');
    }
  }

  Future<List<Substations>> fetchSubstationInfo() async {
    final response = await http.get(Uri.parse('$myAPILink/api/Substations'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<Substations>((json) => Substations.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Substation info');
    }
  }
}
