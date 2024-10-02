import 'package:flutter/material.dart';
import 'package:gis_app_bpdb/views/regions/filter_pole_detail.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../api/api.dart';
import '../../api/consumer_api.dart';
import '../../api/region_api.dart';
import '../../models/region_delails_lookup/pole.dart';
import '../../models/region_delails_lookup/pole_condition.dart';
import '../../models/region_delails_lookup/pole_type.dart';
import '../../models/regions/circle.dart';
import '../../models/regions/esu_info.dart';
import '../../models/regions/snd_info.dart';
import '../../models/regions/zone.dart';
import '../../widgets/noti/notifications.dart';
import '../../widgets/widgets/fieldset_legend.dart';
import 'polebysnd_filter.dart';

class AddPoleInfo extends StatefulWidget {
  const AddPoleInfo({super.key});

  @override
  State<AddPoleInfo> createState() => _AddPoleInfoState();
}

class _AddPoleInfoState extends State<AddPoleInfo> {
  double? _latitude;
  double? _longitude;
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  Future<void> _checkLocationPermission() async {
    // Check the current status of location permission
    var status = await Permission.location.status;

    if (status.isGranted) {
      // If permission is granted, get the current location
      await _getCurrentLocation();
    } else if (status.isDenied) {
      // Request permission if it's denied
      status = await Permission.location.request();
      if (status.isGranted) {
        await _getCurrentLocation();
      } else {
        // Handle permission denial
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
      }
    } else {
      // Handle other permission statuses (e.g., permanently denied)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Location permission is permanently denied. Please enable it from settings.')),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Get current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;

        // Update controllers with new values
        _latitudeController.text = _latitude.toString();
        _longitudeController.text = _longitude.toString();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();

  late Future<List<Zone>> zones;
  late Future<List<Circles>> circles;
  late Future<List<SndInfo>> snds;
  late Future<List<EsuInfo>> esu;

  late Future<List<PoleType>> fetchPoleType;
  late Future<List<PoleCondition>> fetchPoleCondition;

  int? selectedZoneId;
  int? selectedCircleId;
  int? selectedSnDId;
  int? selectedEsuId;

  int? selectedPoleTypeId;
  int? selectedPoleConditionId;

  var dt = DateTime.now(); // Date-Time
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    zones = CallApi().fetchZoneInfo();
    circles = Future.value([]);
    snds = Future.value([]);
    esu = Future.value([]);

    fetchPoleType = CallRegionApi().fetchPoleType();
    fetchPoleCondition = CallRegionApi().fetchPoleCondition();
  }

  void setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  void onZoneChanged(int? value) {
    setLoading(true);
    selectedZoneId = value;
    selectedCircleId = null;
    selectedSnDId = null;
    selectedEsuId = null;

    circles = CallApi().fetchCircleInfo(value!).whenComplete(() {
      setLoading(false);
    });
    snds = Future.value([]);
  }

  void onCircleChanged(int? value) {
    setLoading(true);
    selectedCircleId = value;
    selectedSnDId = null;
    selectedEsuId = null;
    snds = CallApi().fetchSnDInfo(value!).whenComplete(() {
      setLoading(false);
    });
  }

  void onSnDChanged(int? value) {
    setLoading(true);
    selectedSnDId = value;
    selectedEsuId = null;

    esu = CallConsumerApi().fetchEsuInfo(value!).whenComplete(() {
      setLoading(false);
    });
  }

  void onEsuChanged(int? value) {
    setLoading(true);
    selectedEsuId = value;
  }

  bool _streetLight = false;
  bool _transformerExist = false;
  bool _commonPole = false;
  bool _tap = false;
  void itemSwitchStreetLight(bool value) {
    setState(() {
      _streetLight = !_streetLight;
    });
  }

  void itemSwitchTransformerExist(bool value) {
    setState(() {
      _transformerExist = !_transformerExist;
    });
  }

  void itemSwitchCommonPole(bool value) {
    setState(() {
      _commonPole = !_commonPole;
    });
  }

  void itemSwitchTap(bool value) {
    setState(() {
      _tap = !_tap;
    });
  }

  final TextEditingController _poleId = TextEditingController();
  final TextEditingController _noOfWireHt = TextEditingController();
  final TextEditingController _noOfWireLt = TextEditingController();
  final TextEditingController _msjNo = TextEditingController();
  final TextEditingController _sleeveNo = TextEditingController();
  final TextEditingController _twistNo = TextEditingController();
  final TextEditingController _poleNumber = TextEditingController();
  final TextEditingController _poleHeight = TextEditingController();
  final TextEditingController _noOfLine33Kv = TextEditingController();
  final TextEditingController _noOfLine11Kv = TextEditingController();
  final TextEditingController _noOfLineP4Kv = TextEditingController();

  // final TextEditingController _latitudeController = TextEditingController();
  // final TextEditingController _longitudeController = TextEditingController();

  final TextEditingController _remarks = TextEditingController();

  final TextEditingController _surveyDateController = TextEditingController();
  final TextEditingController _surveyorNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: const Text(
            'New Pole Info',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 5, 161, 182),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Form(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Theme(
                data: ThemeData().copyWith(
                  dividerColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                child: ExpansionTile(
                  ////minTileHeight: 25,
                  collapsedBackgroundColor:
                      const Color.fromARGB(255, 223, 240, 243),
                  title: const Text('Administrative Location'),
                  childrenPadding: const EdgeInsets.all(5),
                  textColor: const Color.fromARGB(255, 5, 161, 182),
                  children: [
                    FieldsetLegend(
                      legendText: 'Administrative Location',
                      children: [
                        FutureBuilder<List<Zone>>(
                          future: zones,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              return DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  label: RichText(
                                    text: TextSpan(
                                      text: 'Zone',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: deviceFontSize + 3,
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                value: selectedZoneId,
                                hint: const Text('Select a Zone'),
                                items: snapshot.data!.map((zone) {
                                  return DropdownMenuItem<int>(
                                    value: zone.zoneId,
                                    child: Text(
                                        '${zone.zoneCode}: ${zone.zoneName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  selectedZoneId = value;
                                  onZoneChanged(value);
                                },
                              );
                            } else {
                              return const Text('No zones available');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        FutureBuilder<List<Circles>>(
                          future: circles,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              showMessage('Error: ${snapshot.error}', 'error');
                              return DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  label: RichText(
                                    text: TextSpan(
                                      text: 'Circle',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: deviceFontSize + 3,
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                value: null,
                                hint: const Text('No circles available!'),
                                items: [],
                                onChanged: null,
                              );
                            } else if (snapshot.hasData) {
                              return DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  label: RichText(
                                    text: TextSpan(
                                      text: 'Circle',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: deviceFontSize + 3,
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                value: selectedCircleId,
                                hint: const Text('Select a Circle'),
                                items: snapshot.data!.map((circle) {
                                  return DropdownMenuItem<int>(
                                    value: circle.circleId,
                                    child: Text(
                                        '${circle.circleCode}: ${circle.circleName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCircleId = value;
                                    onCircleChanged(value);
                                  });
                                },
                              );
                            } else {
                              return const Text('No circles available!');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        FutureBuilder<List<SndInfo>>(
                          future: snds,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              showMessage('Error: ${snapshot.error}', 'error');
                              return DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  label: RichText(
                                    text: TextSpan(
                                      text: 'SnD',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: deviceFontSize + 3,
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                value: null,
                                hint: const Text('No SnDs available!'),
                                items: [],
                                onChanged: null,
                              );
                            } else if (snapshot.hasData) {
                              return DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  label: RichText(
                                    text: TextSpan(
                                      text: 'SnD',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: deviceFontSize + 3,
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                value: selectedSnDId,
                                hint: const Text('Select a SnD'),
                                items: snapshot.data!.map((snd) {
                                  return DropdownMenuItem<int>(
                                    value: snd.sndId,
                                    child:
                                        Text('${snd.sndCode}: ${snd.sndName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedSnDId = value;
                                    onSnDChanged(value);
                                  });
                                },
                              );
                            } else {
                              return const Text('No SnDs available!');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        ////// ESU Info //////
                        FutureBuilder<List<EsuInfo>>(
                          future: esu,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              showMessage('Error: ${snapshot.error}', 'error');

                              return DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: 'Esu',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                ),
                                value: null,
                                hint: const Text('No Esus available!'),
                                items: [],
                                onChanged: null,
                              );
                            } else if (snapshot.hasData) {
                              return DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: 'Esu',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                ),
                                value: selectedEsuId,
                                hint: const Text('Select a Esu'),
                                items: snapshot.data!.map((esu) {
                                  return DropdownMenuItem<int>(
                                    value: esu.esuId,
                                    child:
                                        Text('${esu.esuCode}: ${esu.esuName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedEsuId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No Esus available!');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        ///// Esu Info //////

                        const SizedBox(height: 17.5),
                      ],
                    ),
                  ],
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////////

              ///////////////////////////////////////////////////////////////////////////////
              Theme(
                data: ThemeData().copyWith(
                  dividerColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                child: ExpansionTile(
                  ////minTileHeight: 25,
                  collapsedBackgroundColor:
                      const Color.fromARGB(255, 241, 245, 245),
                  title: const Text('Pole Information'),
                  childrenPadding: EdgeInsets.zero,
                  textColor: const Color.fromARGB(255, 5, 161, 182),
                  children: [
                    FieldsetLegend(
                      legendText: 'Pole Information',
                      children: [
                        _buildTextField(_poleId, 'Pole Id', true),
                        FutureBuilder<List<PoleType>>(
                          future: fetchPoleType,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              return DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                                value: selectedPoleTypeId,
                                hint: RichText(
                                  text: const TextSpan(
                                    text: 'Select a Pole Type',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 100, 97, 97),
                                      fontSize: 16.0,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                items: snapshot.data!.map((poleType) {
                                  return DropdownMenuItem<int>(
                                    value: poleType.poleTypeId,
                                    child: Text(
                                        '${poleType.poleTypeId}: ${poleType.poleTypeName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedPoleTypeId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No Pole Type available');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        FutureBuilder<List<PoleCondition>>(
                          future: fetchPoleCondition,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              return DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                                value: selectedPoleConditionId,
                                hint: RichText(
                                  text: const TextSpan(
                                    text: 'Select a Pole Condition',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 100, 97, 97),
                                      fontSize: 16.0,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                items: snapshot.data!.map((poleCondition) {
                                  return DropdownMenuItem<int>(
                                    value: poleCondition.poleConditionId,
                                    child: Text(
                                        '${poleCondition.poleConditionId}: ${poleCondition.conditionName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedPoleConditionId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No Pole Condition available');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _buildTextField(
                            _noOfWireHt, 'Number of Wire HT', false),
                        _buildTextField(
                            _noOfWireLt, 'Number of Wire LT', false),
                        _buildTextField(_msjNo, 'MSJ No.', false),
                        _buildTextField(_sleeveNo, 'Sleeve No.', false),
                        _buildTextField(_twistNo, 'Twist No.', false),
                        //Radio Button
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      text: 'Street Light',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 100, 97, 97),
                                        fontSize: 16.0,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    activeColor: Colors.blue,
                                    value: _streetLight,
                                    onChanged: itemSwitchStreetLight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      text: 'Transformer Exist',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 100, 97, 97),
                                        fontSize: 16.0,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: _transformerExist,
                                    onChanged: itemSwitchTransformerExist,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      text: 'Common Pole',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 100, 97, 97),
                                        fontSize: 16.0,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: _commonPole,
                                    onChanged: itemSwitchCommonPole,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      text: 'Tap',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 100, 97, 97),
                                        fontSize: 16.0,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: _tap,
                                    onChanged: itemSwitchTap,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //Radio Button
                        _buildTextField(_poleNumber, 'Pole Number', false),
                        _buildTextField(_poleHeight, 'Pole Height', false),
                        _buildTextField(
                            _noOfLine11Kv, 'Number of Line 11Kv', false),
                        _buildTextField(
                            _noOfLine33Kv, 'Number of Line 33Kv', false),
                        _buildTextField(
                            _noOfLineP4Kv, 'Number of Line P4Kv', false),
                      ],
                    ),
                  ],
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////

              ///////////////////////////////////////////////////////////////////////////////
              Theme(
                data: ThemeData().copyWith(
                  dividerColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                child: ExpansionTile(
                  ////minTileHeight: 25,
                  collapsedBackgroundColor:
                      const Color.fromARGB(255, 223, 240, 243),
                  title: const Text('GPS Information'),
                  childrenPadding: EdgeInsets.zero,
                  textColor: const Color.fromARGB(255, 5, 161, 182),
                  children: [
                    FieldsetLegend(
                      legendText: 'GPS Information',
                      children: [
                        _buildTextField(_latitudeController, 'Latitude', true),
                        _buildTextField(
                            _longitudeController, 'Longitude', true),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ],
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////
              ///  ///////////////////////////////////////////////////////////////////////////////
              Theme(
                data: ThemeData().copyWith(
                  dividerColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                child: ExpansionTile(
                  ////minTileHeight: 25,
                  collapsedBackgroundColor:
                      const Color.fromARGB(255, 241, 245, 245),
                  title: const Text('Survey Information'),
                  childrenPadding: EdgeInsets.zero,
                  textColor: const Color.fromARGB(255, 5, 161, 182),
                  children: [
                    FieldsetLegend(
                      legendText: 'Survey Information',
                      children: [
                        _buildTextField(
                            _surveyorNameController, 'Surveyor Name', false),
                        TextFormField(
                          controller: _surveyDateController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.calendar_today),
                            label: RichText(
                              text: const TextSpan(
                                text: "Survey Date",
                                style: TextStyle(
                                  color: Color.fromARGB(
                                      255, 105, 103, 103), // Label text color
                                  fontSize: 16.0, // Label font size
                                ),
                                children: [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                      color: Colors
                                          .red, // Red color for the asterisk
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectSurvryDate(context);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Survey Date';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _startDateController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.calendar_today),
                            label: RichText(
                              text: const TextSpan(
                                text: "Starting Date",
                                style: TextStyle(
                                  color: Color.fromARGB(
                                      255, 105, 103, 103), // Label text color
                                  fontSize: 16.0, // Label font size
                                ),
                                children: [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                      color: Colors
                                          .red, // Red color for the asterisk
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectStartingDate(context);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Start Date';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////
              ///////////////////////////////////////////////////////////////////////////////
              Theme(
                data: ThemeData().copyWith(
                  dividerColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                child: ExpansionTile(
                  ////minTileHeight: 25,
                  collapsedBackgroundColor:
                      const Color.fromARGB(255, 223, 240, 243),
                  title: const Text('Remarks'),
                  childrenPadding: EdgeInsets.zero,
                  textColor: const Color.fromARGB(255, 5, 161, 182),
                  children: [
                    FieldsetLegend(
                      legendText: 'Remarks',
                      children: [
                        _buildTextField(_remarks, 'Remarks', false),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              int parseOrZero(String? text) {
                                try {
                                  return int.tryParse(text?.trim() ?? '') ?? 0;
                                } catch (e) {
                                  throw 'Invalid integer for field $text';
                                }
                              }

                              double parseOrZeroDouble(String? text) {
                                try {
                                  return double.tryParse(text?.trim() ?? '') ??
                                      0.0;
                                } catch (e) {
                                  throw 'Invalid double for field $text';
                                }
                              }

                              String formatDate(String? text) {
                                if (text != '') {
                                  try {
                                    return DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                                        .format(DateTime.parse(
                                            text ?? dt.toString()));
                                  } catch (e) {
                                    throw 'Invalid Date format';
                                  }
                                } else {
                                  return "";
                                }
                              }

                              T checkNotNull<T>(T? value, String fieldName) {
                                if (value == null || value == 0.00) {
                                  throw 'Invalid value for $fieldName. PLease Check Again ';
                                }
                                return value;
                              }

                              Poles pole = Poles(
                                zoneId: selectedZoneId ?? 0,
                                circleId: selectedCircleId ?? 0,
                                sndId: selectedSnDId ?? 0,
                                esuId: selectedEsuId,
                                poleId: parseOrZero(_poleId.text),
                                poleTypeId: selectedPoleTypeId ?? 0,
                                poleConditionId: selectedPoleConditionId ?? 0,
                                noOfWireHt: parseOrZero(_noOfWireHt.text),
                                noOfWireLt: parseOrZero(_noOfWireLt.text),
                                msjNo: _msjNo.text,
                                sleeveNo: _sleeveNo.text,
                                twistNo: _twistNo.text,
                                streetLight: _streetLight,
                                transformerExist: _transformerExist,
                                commonPole: _commonPole,
                                tap: _tap,
                                poleNumber: _poleNumber.text,
                                poleHeight: parseOrZeroDouble(_poleHeight.text),
                                noOfLine11Kv: parseOrZero(_noOfLine11Kv.text),
                                noOfLine33Kv: parseOrZero(_noOfLine33Kv.text),
                                noOfLineP4Kv: parseOrZero(_noOfLineP4Kv.text),
                                latitude: checkNotNull(
                                    parseOrZeroDouble(_latitudeController.text),
                                    'Latitude'),
                                longitude: checkNotNull(
                                    parseOrZeroDouble(
                                        _longitudeController.text),
                                    'Longitude'),
                                surveyorName: _surveyorNameController.text,
                                surveyDate:
                                    formatDate(_surveyDateController.text),
                                startingDate:
                                    formatDate(_startDateController.text),
                                remarks: _remarks.text,
                                activationStatusId: 2,
                                verificationStateId: 2,
                              );

                              await CallRegionApi().createPole(pole);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FilterPoleBySnd()),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Pole Created Successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (error) {
                              //print(error);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Failed to Create data: $error'),
                                    backgroundColor: Colors.red),
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          child: const Text('Save',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildTextField(TextEditingController controller, String label) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 16.0),
  //     child: TextFormField(
  //       controller: controller,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //       ),
  //       validator: (value) {
  //         if (value == null || value.isEmpty) {
  //           return 'Please enter $label';
  //         }
  //         return null;
  //       },
  //     ),
  //   );
  // }
  Widget _buildTextField(
      TextEditingController controller, String label, bool mandatory) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          label: RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                color: Color.fromARGB(255, 100, 97, 97),
                fontSize: 16.0,
              ),
              children: [
                if (mandatory)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  void _errorPrint(String label, BuildContext context) {
    final snackBar = SnackBar(content: Text('Please enter $label'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _selectSurvryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _surveyDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectStartingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
