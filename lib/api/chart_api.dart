import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../constants/constant.dart';
import '../models/charts_lookups/pie_chart.dart';
import '../models/charts_lookups/bar_chart.dart';

Future<List<ZoneData>> PieData(String? selectedData) async {
  String url;
  if (selectedData == "1") {
    url = '$myAPILink/api/Consumers/consumerPiechart';
  } else {
        url = '$myAPILink/api/Consumers/polePiechart';
  }
  final response = await http.get(Uri.parse(url));
  
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map<ZoneData>((json) => ZoneData.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Data');
  }
}


Future<List<ZoneReport>> BarData(String? selectedBarData) async {
  String url;
  if (selectedBarData == "1") {
    url = '$myAPILink/api/Consumers/consumerGraph';
  } else {
    url = '$myAPILink/api/Consumers/poleGraph';
  }
  final response = await http.get(Uri.parse(url));
  
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map<ZoneReport>((json) => ZoneReport.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Data');
  }
}

