import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../constants/constant.dart';
import '../models/pole_lookup/add_poledetails.dart';
import '../models/pole_lookup/line_type.dart';
import '../models/pole_lookup/pole.dart';
import '../models/pole_lookup/pole_condition.dart';
import '../models/pole_lookup/pole_list.dart';
import '../models/pole_lookup/pole_type.dart';
import '../models/pole_lookup/sag_condition.dart';
import '../models/pole_lookup/wire_condition.dart';
import '../models/pole_lookup/wire_type.dart';
import '../models/region_delails_lookup/poleDetailsId.dart';
import '../models/region_delails_lookup/poleId.dart';
import '../models/region_delails_lookup/pole_image.dart';
import '../models/regions/pole.dart';

class CallPoleApi {
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

  Future<List<Pole>> fetchPoleInfo(int feederId) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final response = await http.get(
        Uri.parse('$myAPILink/api/PoleDetails/search?feederLineId=$feederId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<Pole>((json) => Pole.fromJson(json)).toList();
      // List<dynamic> body = jsonDecode(response.body);
      // List<Pole> allDatas =
      //     body.map((dynamic item) => Pole.fromJson(item)).toList();
      // List<Pole> filteredDatas =
      //     allDatas.where((data) => data.poleId > 871182).toList();
      // return filteredDatas;
    } else {
      throw Exception('Failed to load Pole info');
    }
  }

  Future<List<PoleDetails>> fetchPolesByDetailsId(int poleDetailsId) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final response = await http
        .get(Uri.parse('$myAPILink/api/PoleDetails/$poleDetailsId'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<PoleDetails>((json) => PoleDetails.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Pole info');
    }
  }

  Future<List<PoleDetailByID>> fetchPolesById(int poleId) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final response =
        await http.get(Uri.parse('$myAPILink/api/Poles/$poleId'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<PoleDetailByID>((json) => PoleDetailByID.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Pole info');
    }
  }
  //

  Future<List<PoleImage>> fetchPoleImage(int poleId) async {
    final response = await http
        .get(Uri.parse('$myAPILink/api/PolePictures/search?poleId=$poleId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<PoleImage>((json) => PoleImage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Pole info');
    }
  }

  //--Pole Type--//
  Future<List<PoleType>> fetchPoleType() async {
    final response = await http.get(Uri.parse('$myAPILink/api/PoleTypes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<PoleType>((json) => PoleType.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Pole Type');
    }
  }
  //--Pole Type--//

  //--Pole Condition--//
  Future<List<PoleCondition>> fetchPoleCondition() async {
    final response = await http.get(Uri.parse('$myAPILink/api/PoleConditions'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<PoleCondition>((json) => PoleCondition.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Consumer Type');
    }
  }
  //--Pole Condition--//

  //--Pole Create--//
  Future<Poles> createPole(Poles pole) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final requestData = {
      'zoneId': pole.zoneId != 0 ? pole.zoneId : null,
      'circleId': pole.circleId != 0 ? pole.circleId : null,
      'sndId': pole.sndId != 0 ? pole.sndId : null,
      'esuId': pole.esuId != 0 ? pole.esuId : null,
      'poleId': pole.poleId,
      'poleTypeId': pole.poleTypeId,
      'poleConditionId': pole.poleConditionId != 0 ? pole.poleConditionId : null,
      'noOfWireHt': pole.noOfWireHt,
      'noOfWireLt': pole.noOfWireLt,
      'msjNo': pole.msjNo,
      'sleeveNo': pole.sleeveNo,
      'twistNo': pole.twistNo,
      'streetLight': pole.streetLight,
      'transformerExist': pole.transformerExist,
      'commonPole': pole.commonPole,
      'tap': pole.tap,
      'poleNumber': pole.poleNumber != '' ? pole.poleNumber : null,
      'poleHeight': pole.poleHeight != 0.0 ? pole.poleHeight : null,
      'noOfLine11Kv': pole.noOfLine11Kv != 0 ? pole.noOfLine11Kv : null,
      'noOfLine33Kv': pole.noOfLine33Kv != 0 ? pole.noOfLine33Kv : null,
      'noOfLineP4Kv': pole.noOfLineP4Kv != 0 ? pole.noOfLineP4Kv : null,
      'latitude': pole.latitude,
      'longitude': pole.longitude,
      'surveyorName': pole.surveyorName,
      'surveyDate': pole.surveyDate,
      'startingDate': pole.startingDate,
      'remarks': pole.remarks,
      'activationStatusId': pole.activationStatusId,
      'verificationStateId': pole.verificationStateId,
    };
    // debugPrint('Request Data: $requestData');
    // print('Request data: ${jsonEncode(requestData)}');
    // return Future.error('Stopped execution for debugging.');
    
    try {
      final response = await http.post(
        Uri.parse('$myAPILink/api/Poles'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return Poles.fromJson(jsonResponse);
      } else {
        // print('Error response body: ${response.body}');
        final responseBody = jsonDecode(response.body);
        final errors = responseBody['errors'];
        final fieldName = errors.keys.first;
        //print('Field causing error: $fieldName');
        throw "$fieldName";
      }
    } catch (e) {
      // print(e);
      throw 'Failed to create pole. Please Check $e';
    }
    
  }
  //--Pole Create--//

  // --View Pole -- //
  Future<List<PoleList>> fetchPolesInfo(int sndid) async {
    final String? token = globalToken;
    final response = await http.get(
      Uri.parse('$myAPILink/api/Poles/search?sndId=$sndid'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<PoleList>((json) => PoleList.fromJson(json)).toList();

      // List<dynamic> body = jsonDecode(response.body);
      // List<PoleList> allDatas =
      //     body.map((dynamic item) => PoleList.fromJson(item)).toList();
      // List<PoleList> filteredDatas =
      //     allDatas.where((data) => data.poleId > 871182).toList();
      // return filteredDatas;
    } else {
      throw Exception('Failed to load Poles info');
    }
  }
  // Future<List<PoleList>> fetchPolesInfo(int sndid) async {
  //   final response =
  //       await http.get(Uri.parse('$myAPILink/api/Poles/search?sndId=$sndid'));

  //   if (response.statusCode == 200) {
  //     List<dynamic> body = jsonDecode(response.body);
  //     List<PoleList> allDatas =
  //         body.map((dynamic item) => PoleList.fromJson(item)).toList();
  //     List<PoleList> filteredDatas =
  //         allDatas.where((data) => data.poleId > 2000000).toList();
  //     return filteredDatas;
  //   } else {
  //     throw Exception('Failed to load Pole');
  //   }
  // }
  // --View Pole -- //

  // -- Line Type -- //
  Future<List<LineType>> fetchLineType() async {
    final response = await http.get(Uri.parse('$myAPILink/api/LineTypes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<LineType>((json) => LineType.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Line Type');
    }
  }
  // -- Line Type -- //

  // -- Wire Type -- //
  Future<List<WireType>> fetchWireType() async {
    final response = await http.get(Uri.parse('$myAPILink/api/TypeOfWires'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<WireType>((json) => WireType.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Wire Type');
    }
  }
  // -- Wire Type -- //

  // -- Condition Wire -- //
  Future<List<WireCondition>> fetchWireCondition() async {
    final response = await http.get(Uri.parse('$myAPILink/api/WireConditions'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<WireCondition>((json) => WireCondition.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Wire Condition');
    }
  }
  // -- Condition Wire -- //

  // -- Condition Sag -- //
  Future<List<SagCondition>> fetchSagCondition() async {
    final response = await http.get(Uri.parse('$myAPILink/api/SagConditions'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<SagCondition>((json) => SagCondition.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Sag Condition');
    }
  }
  // -- Condition Sag -- //

  //--Pole Create--//
  Future<int> fetchMaxPoleDetailId() async {
    final String? token = globalToken;
    try {
      final response = await http.get(
        Uri.parse('$myAPILink/api/PoleDetails/maxId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        throw 'Failed to fetch maxId';
      }
    } catch (e) {
      throw 'Error fetching maxId: $e';
    }
  }

  Future<int> fetchMaxPoleId() async {
    final String? token = globalToken;
    try {
      final response = await http.get(
        Uri.parse('$myAPILink/api/Poles/maxId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        throw 'Failed to fetch maxId';
      }
    } catch (e) {
      throw 'Error fetching maxId: $e';
    }
  }

  Future<Poles> createPoleDetailInfo(PoleDetailInfo poleDetailInfo) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final requestData = {
      'poleDetailsId': poleDetailInfo.poleDetailsId,
      'poleId': poleDetailInfo.poleId,
      'poleCode': poleDetailInfo.poleCode,
      'feederLineId': poleDetailInfo.feederLineId,
      'poleUid': poleDetailInfo.poleUid,
      'feederLineUid': poleDetailInfo.feederLineUid,
      'zoneId': poleDetailInfo.zoneId,
      'circleId': poleDetailInfo.circleId,
      'sndId': poleDetailInfo.sndId,
      'esuId': poleDetailInfo.esuId != 0 ? poleDetailInfo.esuId : null,
      'substationId': poleDetailInfo.substationId,
      'feederWiseSerialNo': poleDetailInfo.feederWiseSerialNo,
      'poleNo': poleDetailInfo.poleNo,
      'previousPoleNo': poleDetailInfo.previousPoleNo != ''
          ? poleDetailInfo.previousPoleNo
          : null,
      'lineTypeId': poleDetailInfo.lineTypeId,
      'backSpan':
          poleDetailInfo.backSpan != '' ? poleDetailInfo.backSpan : null,
      'typeOfWireId': poleDetailInfo.typeOfWireId,
      'wireLength':
          poleDetailInfo.wireLength != 0.0 ? poleDetailInfo.wireLength : null,
      'wireConditionId': poleDetailInfo.wireConditionId,
      'phaseAId': poleDetailInfo.phaseAId,
      'phaseBId': poleDetailInfo.phaseBId,
      'phaseCId': poleDetailInfo.phaseCId,
      'neutral': poleDetailInfo.neutral,
      'poleUniqueCode': poleDetailInfo.poleUniqueCode,
      'isRightPole': poleDetailInfo.isRightPole,
    };
    // debugPrint('Request Data: $requestData');
    // return Future.error('Stopped execution for debugging.');
    try {
      final response = await http.post(
        Uri.parse('$myAPILink/api/PoleDetails'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return Poles.fromJson(jsonResponse);
      } else {
        // print('Error response body: ${response.body}');
        final responseBody = jsonDecode(response.body);
        final errors = responseBody['errors'];
        final fieldName = errors.keys.first;
        //print('Field causing error: $fieldName');
        throw "$fieldName";
      }
    } catch (e) {
      //print(e);
      throw 'Failed to create pole details. Please Check $e';
    }
  }
  //--Pole Create--//
}
