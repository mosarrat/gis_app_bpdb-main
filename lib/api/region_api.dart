import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../constants/constant.dart';
import '../models/app_config.dart';
import '../models/pole_lookup/add_poledetails.dart';
import '../models/region_delails_lookup/circle.dart';
import '../models/region_delails_lookup/dt_details.dart';
import '../models/region_delails_lookup/dt_info.dart';
import '../models/region_delails_lookup/esu.dart';
import '../models/pole_lookup/line_type.dart';
import '../models/pole_lookup/pole.dart';
import '../models/region_delails_lookup/poleDetailsId.dart';
import '../models/region_delails_lookup/poleId.dart';
import '../models/pole_lookup/pole_condition.dart';
import '../models/region_delails_lookup/pole_image.dart';
import '../models/pole_lookup/pole_list.dart';
import '../models/pole_lookup/pole_type.dart';
import '../models/pole_lookup/sag_condition.dart';
import '../models/region_delails_lookup/snd.dart';
import '../models/region_delails_lookup/substation.dart';
import '../models/pole_lookup/wire_condition.dart';
import '../models/pole_lookup/wire_type.dart';
import '../models/regions/pole.dart';
import '../models/regions/zone.dart';
import 'package:gis_app_bpdb/models/region_delails_lookup/dt_info.dart';

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

  Future<List<Pole>> fetchPoleInfo(int feederId) async {
    final response = await http.get(
        Uri.parse('$myAPILink/api/PoleDetails/search?feederLineId=$feederId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<Pole>((json) => Pole.fromJson(json)).toList();
      // List<dynamic> body = jsonDecode(response.body);
      // List<Pole> allDatas =
      //     body.map((dynamic item) => Pole.fromJson(item)).toList();
      // List<Pole> filteredDatas =
      //     allDatas.where((data) => data.poleId > 2000000).toList();
      // return filteredDatas;
    } else {
      throw Exception('Failed to load Pole info');
    }
  }

  Future<List<PoleDetails>> fetchPolesByDetailsId(int poleDetailsId) async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/PoleDetails/$poleDetailsId'));
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
    final response = await http.get(Uri.parse('$myAPILink/api/Poles/$poleId'));
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

  Future<List<TransformerDetails>> fetchDT({
    int? substation,
    int? feederLineId,
  }) async {
    final String apiUrl = '$myAPILink/api/DistributionTransformers';

    final Uri uri = Uri.parse(
      feederLineId != 0
          ? '$apiUrl/search${feederLineId != null ? '?substationId=$substation&feederLineId=$feederLineId' : ''}'
          //? '$apiUrl/search${feederLineId != null ? '?feederLineId=$feederLineId' : ''}'
          : '$apiUrl/search${substation != null ? '?substationId=$substation' : ''}',
    );

    //debugPrint('$uri');

    try {
      final response = await http.get(uri);
      //print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        //print('Response data: $data');

        List<TransformerDetails> dts =
            data.map((json) => TransformerDetails.fromJson(json)).toList();
        //print('Parsed Consumers: $consumers');

        return dts;
      } else {
        throw Exception(
            'Failed to load DT Info! Status code: ${response.statusCode}');
      }
    } catch (e) {
      //print('Error caught: $e');
      throw Exception('Failed to load DT Info: $e');
    }
  }

  Future<List<Transformer>> fetchDTByDetailsId(int id) async {
    final response = await http
        .get(Uri.parse('$myAPILink/api/DistributionTransformers/$id'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<Transformer>((json) => Transformer.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Dt info');
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
    final requestData = {
      'zoneId': pole.zoneId != 0 ? pole.zoneId : null,
      'circleId': pole.circleId != 0 ? pole.circleId : null,
      'sndId': pole.sndId != 0 ? pole.sndId : null,
      'esuId': pole.esuId != 0 ? pole.esuId : null,
      'poleId': pole.poleId,
      'poleTypeId': pole.poleTypeId,
      'poleConditionId': pole.poleConditionId,
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
    // return Future.error('Stopped execution for debugging.');
    try {
      final response = await http.post(
        Uri.parse('$myAPILink/api/Poles'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return Poles.fromJson(jsonResponse);
      } else {
        final responseBody = jsonDecode(response.body);
        final errors = responseBody['errors'];
        final fieldName = errors.keys.first;
        //print('Field causing error: $fieldName');
        throw "$fieldName";
      }
    } catch (e) {
      //print(e);
      throw 'Failed to create pole. Please Check $e';
    }
  }
  //--Pole Create--//

  // --View Pole -- //
  //   Future<List<PoleList>> fetchPolesInfo(int sndid) async {
  //   final response = await http.get(Uri.parse('$myAPILink/api/Poles/search?sndId=$sndid'));

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body);
  //     return data.map<PoleList>((json) => PoleList.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load Poles info');
  //   }
  // }
  Future<List<PoleList>> fetchPolesInfo(int sndid) async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/Poles/search?sndId=$sndid'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<PoleList> allDatas =
          body.map((dynamic item) => PoleList.fromJson(item)).toList();
      List<PoleList> filteredDatas =
          allDatas.where((data) => data.poleId > 2000000).toList();
      return filteredDatas;
    } else {
      throw Exception('Failed to load Pole');
    }
  }
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
    try {
      final response = await http.get(
        Uri.parse('$myAPILink/api/PoleDetails/maxId'),
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
    try {
      final response = await http.get(
        Uri.parse('$myAPILink/api/Poles/maxId'),
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
      'previousPoleNo': poleDetailInfo.previousPoleNo != '' ? poleDetailInfo.previousPoleNo : null,
      'lineTypeId': poleDetailInfo.lineTypeId,
      'backSpan': poleDetailInfo.backSpan!= '' ? poleDetailInfo.backSpan : null,
      'typeOfWireId': poleDetailInfo.typeOfWireId,
      'wireLength': poleDetailInfo.wireLength != 0.0 ? poleDetailInfo.wireLength : null,
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
        },
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return Poles.fromJson(jsonResponse);
      } else {
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
