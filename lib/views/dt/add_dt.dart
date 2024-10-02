import 'package:flutter/material.dart';

import '../../api/api.dart';
import '../../api/consumer_api.dart';
import '../../models/regions/circle.dart';
import '../../models/regions/esu_info.dart';
import '../../models/regions/feeder_line.dart';
import '../../models/regions/snd_info.dart';
import '../../models/regions/substation.dart';
import '../../models/regions/zone.dart';
import '../../widgets/noti/notifications.dart';
import '../../widgets/widgets/fieldset_legend.dart';

class AddDTInfo extends StatefulWidget {
  const AddDTInfo({super.key});

  @override
  State<AddDTInfo> createState() => _AddDTInfoState();
}

class _AddDTInfoState extends State<AddDTInfo> {
  final _formKey = GlobalKey<FormState>();

  late Future<List<Zone>> zones;
  late Future<List<Circles>> circles;
  late Future<List<SndInfo>> snds;
  late Future<List<EsuInfo>> esu;
  late Future<List<Substation>> substations;
  late Future<List<FeederLine>> feederLines;

  int? selectedZoneId;
  int? selectedCircleId;
  int? selectedSnDId;
  int? selectedEsuId;
  int? selectedSubstationId;
  int? selectedFeederLineId;

  var dt = DateTime.now(); // Date-Time
  bool isLoading = false;

  String? gpsLat = "0.00";
  String? gpsLong = "0.00";
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    zones = CallApi().fetchZoneInfo();
    circles = Future.value([]);
    snds = Future.value([]);
    esu = Future.value([]);
    substations = Future.value([]);
    feederLines = Future.value([]);
  }

  void _getCurrentLocation() async {
    try {
      //Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latitudeController.text = "0.00"; // position.latitude.toString();
        _longitudeController.text = "0.00"; // position.longitude.toString();

        gpsLat = "0.00"; // position.latitude.toString();
        gpsLong = "0.00"; // position.longitude.toString();
      });
    } catch (e) {
      //print(e);
      _latitudeController.text = "0.00";
      _longitudeController.text = "0.00";

      gpsLat = "0.00";
      gpsLong = "0.00";
    }
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
    selectedSubstationId = null;
    selectedFeederLineId = null;
    circles = CallApi().fetchCircleInfo(value!).whenComplete(() {
      setLoading(false);
    });
    snds = Future.value([]);
    substations = Future.value([]);
    feederLines = Future.value([]);
  }

  void onCircleChanged(int? value) {
    setLoading(true);
    selectedCircleId = value;
    selectedSnDId = null;
    selectedEsuId = null;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    snds = CallApi().fetchSnDInfo(value!).whenComplete(() {
      setLoading(false);
    });
    substations = Future.value([]);
    feederLines = Future.value([]);
  }

  void onSnDChanged(int? value) {
    setLoading(true);
    selectedSnDId = value;
    selectedEsuId = null;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    substations = CallApi().fetchSubstationInfo(value!).whenComplete(() {
      setLoading(false);
    });
    esu = CallConsumerApi().fetchEsuInfo(value!).whenComplete(() {
      setLoading(false);
    });
    feederLines = Future.value([]);
  }

  void onEsuChanged(int? value) {
    setLoading(true);
    selectedEsuId = value;
    selectedSubstationId = null;
    selectedFeederLineId = null;
  }

  void onSubstationChanged(int? value) {
    setLoading(true);
    selectedSubstationId = value;
    selectedFeederLineId = null;
    feederLines = CallApi().fetchFeederLineInfo(value!).whenComplete(() {
      setLoading(false);
    });
  }

  void onFeederLineChanged(int? value) {
    setLoading(true);
    selectedFeederLineId = value;
  }

  final TextEditingController _dtId = TextEditingController();
  final TextEditingController _dtCode = TextEditingController();
  final TextEditingController _dtLocationName = TextEditingController();
  final TextEditingController _dtNumber = TextEditingController();
  final TextEditingController _dtConditionId = TextEditingController();

  final TextEditingController _poleLeftId = TextEditingController();
  final TextEditingController _poleDetailLeftId = TextEditingController();
  final TextEditingController _poleDetailRightId = TextEditingController();

  final TextEditingController _nameOf33Bs11KvSubstation =
      TextEditingController();
  final TextEditingController _nameof11KvFeeder = TextEditingController();
  final TextEditingController _sndIdentificationNo = TextEditingController();
  final TextEditingController _nearestHoldingHouseNoShop =
      TextEditingController();
  final TextEditingController _existingPoleNumberIfAny =
      TextEditingController();
  final TextEditingController _installedConditionPadPoleMounted =
      TextEditingController();
  final TextEditingController _installedPlaceIndoorOutdoor =
      TextEditingController();
  final TextEditingController _transformerOwnerId = TextEditingController();
  final TextEditingController _transformerKvaRating = TextEditingController();
  final TextEditingController _contactNo = TextEditingController();
  final TextEditingController _yearOfManufacturing = TextEditingController();
  final TextEditingController _nameofManufacturer = TextEditingController();
  final TextEditingController _transformerSerialNo = TextEditingController();
  final TextEditingController _bodyColorConditionId = TextEditingController();
  final TextEditingController _nameOfBodyColor = TextEditingController();
  final TextEditingController _oilLeakageYesOrNo = TextEditingController();
  final TextEditingController _placeOfOilLeakageMark = TextEditingController();
  final TextEditingController _platformMaterialId = TextEditingController();
  final TextEditingController _typeofTransformerSupportPoleLeft =
      TextEditingController();
  final TextEditingController _conditionofTransformerSupportPoleLeft =
      TextEditingController();
  final TextEditingController _typeofTransformerSupportPoleRight =
      TextEditingController();
  final TextEditingController _conditionofTransformerSupportPoleRight =
      TextEditingController();

  final TextEditingController _ratedVoltage = TextEditingController();
  final TextEditingController _ratedHtVoltage = TextEditingController();
  final TextEditingController _ratedLTVoltage = TextEditingController();
  final TextEditingController _ratedHTCurrent = TextEditingController();
  final TextEditingController _ratedLTCurrent = TextEditingController();
  final TextEditingController _controlVoltage = TextEditingController();
  final TextEditingController _motorVoltageforspringcharge =
      TextEditingController();

  final TextEditingController _htBushingRPhaseOil = TextEditingController();
  final TextEditingController _htBushingRPhaseGood = TextEditingController();
  final TextEditingController _htBushingRPhaseColor = TextEditingController();
  final TextEditingController _htBushingYPhaseOil = TextEditingController();
  final TextEditingController _htBushingYPhaseGood = TextEditingController();
  final TextEditingController _htBushingYPhaseColor = TextEditingController();
  final TextEditingController _htBushingBPhaseOil = TextEditingController();
  final TextEditingController _htBushingBPhaseGood = TextEditingController();
  final TextEditingController _htBushingBPhaseColor = TextEditingController();
  final TextEditingController _htBushingNPhaseOil = TextEditingController();
  final TextEditingController _htBushingNPhaseGood = TextEditingController();
  final TextEditingController _htBushingNPhaseColor = TextEditingController();

  final TextEditingController _ltBushingRPhaseOil = TextEditingController();
  final TextEditingController _ltBushingRPhaseGood = TextEditingController();
  final TextEditingController _ltBushingRPhaseColor = TextEditingController();
  final TextEditingController _ltBushingYPhaseOil = TextEditingController();
  final TextEditingController _ltBushingYPhaseGood = TextEditingController();
  final TextEditingController _ltBushingYPhaseColor = TextEditingController();

  final TextEditingController _ltBushingBPhaseOil = TextEditingController();
  final TextEditingController _ltBushingBPhaseGood = TextEditingController();
  final TextEditingController _ltBushingBPhaseColor = TextEditingController();
  final TextEditingController _ltBushingNPhaseOil = TextEditingController();
  final TextEditingController _ltBushingNPhaseGood = TextEditingController();
  final TextEditingController _ltBushingNPhaseColor = TextEditingController();

  final TextEditingController _voltage1 = TextEditingController();
  final TextEditingController _ryVoltageVolt1 = TextEditingController();
  final TextEditingController _ybVoltageVolt1 = TextEditingController();
  final TextEditingController _rbVoltageVolt1 = TextEditingController();
  final TextEditingController _rnVoltageVolt1 = TextEditingController();
  final TextEditingController _ynVoltageVolt1 = TextEditingController();
  final TextEditingController _bnVoltageVolt1 = TextEditingController();
  final TextEditingController _leakageVoltageBodyEarthVolt1 =
      TextEditingController();

  final TextEditingController _voltage2 = TextEditingController();
  final TextEditingController _ryVoltageVolt2 = TextEditingController();
  final TextEditingController _ybVoltageVolt2 = TextEditingController();
  final TextEditingController _rbVoltageVolt2 = TextEditingController();

  final TextEditingController _wireSizeofHTDrop = TextEditingController();
  final TextEditingController _conditionofHTDropGoodbsBad =
      TextEditingController();
  final TextEditingController _wirebsCableSizeofLTDropCKT1 =
      TextEditingController();
  final TextEditingController _conditionofLTDropGoodbsBadCKT1 =
      TextEditingController();
  final TextEditingController _wirebsCableSizeofLTDropCKT2 =
      TextEditingController();
  final TextEditingController _conditionofLTDropGoodbsBadCKT2 =
      TextEditingController();
  final TextEditingController _earthingLead1 = TextEditingController();
  final TextEditingController _earthingLead1Size = TextEditingController();
  final TextEditingController _earthingLead1Material = TextEditingController();
  final TextEditingController _earthingLead1ConditionStandard =
      TextEditingController();
  final TextEditingController _earthingLead2 = TextEditingController();
  final TextEditingController _earthingLead2Size = TextEditingController();
  final TextEditingController _earthingLead2Material = TextEditingController();
  final TextEditingController _earthingLead2ConditionStandard =
      TextEditingController();
  final TextEditingController _dayPeak = TextEditingController();
  final TextEditingController _dateAndtime1 = TextEditingController();

  final TextEditingController _rPhaseCurrentAmps1Ckt1 = TextEditingController();
  final TextEditingController _rPhaseCurrentAmps1Ckt2 = TextEditingController();
  final TextEditingController _rPhaseCurrentAmps1Ckt3 = TextEditingController();
  final TextEditingController _yPhaseCurrentAmps1Ckt1 = TextEditingController();
  final TextEditingController _yPhaseCurrentAmps1Ckt2 = TextEditingController();
  final TextEditingController _yPhaseCurrentAmps1Ckt3 = TextEditingController();
  final TextEditingController _bPhaseCurrentAmps1Ckt1 = TextEditingController();
  final TextEditingController _bPhaseCurrentAmps1Ckt2 = TextEditingController();
  final TextEditingController _bPhaseCurrentAmps1Ckt3 = TextEditingController();
  final TextEditingController _neutralCurrentAmps1Ckt1 =
      TextEditingController();
  final TextEditingController _neutralCurrentAmps1Ckt2 =
      TextEditingController();
  final TextEditingController _neutralCurrentAmps1Ckt3 =
      TextEditingController();
  final TextEditingController _calculatedDayPeakkVA = TextEditingController();
  final TextEditingController _eveningPeak = TextEditingController();
  final TextEditingController _dateAndTime2 = TextEditingController();

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
            'New DT Info',
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
          child: ListView(padding: EdgeInsets.zero, children: [
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
                                labelText: 'Zone',
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: deviceFontSize + 3,
                                  //fontWeight: FontWeight.bold,
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
                                labelText: 'Circle',
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: deviceFontSize + 3,
                                  //fontWeight: FontWeight.bold,
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
                                labelText: 'Circle',
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: deviceFontSize + 3,
                                  //fontWeight: FontWeight.bold,
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
                                labelText: 'SnD',
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: deviceFontSize + 3,
                                  //fontWeight: FontWeight.bold,
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
                                labelText: 'SnD',
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: deviceFontSize + 3,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: selectedSnDId,
                              hint: const Text('Select a SnD'),
                              items: snapshot.data!.map((snd) {
                                return DropdownMenuItem<int>(
                                  value: snd.sndId,
                                  child: Text('${snd.sndCode}: ${snd.sndName}'),
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
                                  child: Text('${esu.esuCode}: ${esu.esuName}'),
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
                      FutureBuilder<List<Substation>>(
                        future: substations,
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
                                labelText: 'Substation',
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: deviceFontSize + 3,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: null,
                              hint: const Text('No substations available!'),
                              items: [],
                              onChanged: null,
                            );
                          } else if (snapshot.hasData) {
                            return DropdownButtonFormField<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'Substation',
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: deviceFontSize + 3,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: selectedSubstationId,
                              hint: const Text('Select a Substation'),
                              items: snapshot.data!.map((substation) {
                                return DropdownMenuItem<int>(
                                  value: substation.substationId,
                                  child: Text(
                                      '${substation.substationCode}: ${substation.substationName}'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSubstationId = value;
                                  onSubstationChanged(value);
                                });
                              },
                            );
                          } else {
                            return const Text('No substations available!');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<FeederLine>>(
                        future: feederLines,
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
                                labelText: 'Feeder Line',
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: deviceFontSize + 3,
                                ),
                              ),
                              value: null,
                              hint: const Text('No feeder line available!'),
                              items: [],
                              onChanged: null,
                            );
                          } else if (snapshot.hasData) {
                            return DropdownButtonFormField<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'Feeder Line',
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: deviceFontSize + 3,
                                ),
                              ),
                              value: selectedFeederLineId,
                              hint: const Text('Select a Feeder Line'),
                              items: snapshot.data!.map((feeder) {
                                return DropdownMenuItem<int>(
                                  value: feeder.feederLineId,
                                  child: Text(
                                      '${feeder.feederLineCode}: ${feeder.feederlineName}'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedFeederLineId = value;
                                  onFeederLineChanged(value);
                                });
                              },
                            );
                          } else {
                            return const Text('No feeder line available!');
                          }
                        },
                      ),
                      const SizedBox(height: 17.5),
                      _buildTextField(_poleLeftId, 'Pole Id'),
                      _buildTextField(_poleDetailLeftId, 'Pole Detail Left Id'),
                      _buildTextField(
                          _poleDetailRightId, 'Pole Detail Right Id'),
                    ],
                  ),
                ],
              ),
            ),
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
                title: const Text('Distribution Transformer Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Distribution Transformer Information',
                    children: [
                      _buildTextField(_dtId, 'Distribution Transformer Id'),
                      _buildTextField(_dtCode, 'Distribution Transformer Code'),
                      _buildTextField(_dtLocationName,
                          'Distribution Transformer Location Name'),
                      _buildTextField(
                          _dtNumber, 'Distribution Transformer Number'),
                      _buildTextField(_dtConditionId,
                          'Distribution Transformer Condition Id'),
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
                title: const Text('Distribution Transformer Other Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Distribution Transformer Other Information',
                    children: [
                      _buildTextField(_nameOf33Bs11KvSubstation,
                          'Name Of 33 Bs 11 Kv Substation'),
                      _buildTextField(
                          _nameof11KvFeeder, 'Name Of 11 Kv Feeder'),
                      _buildTextField(
                          _sndIdentificationNo, 'SnD Identification No'),
                      _buildTextField(_nearestHoldingHouseNoShop,
                          'Nearest Holding House No Shop'),
                      _buildTextField(_existingPoleNumberIfAny,
                          'Existing Pole Number If Any'),
                      _buildTextField(_installedConditionPadPoleMounted,
                          'Installed Condition Pad Pole Mounted'),
                      _buildTextField(_installedPlaceIndoorOutdoor,
                          'Installed Place Indoor Outdoor'),
                      _buildTextField(
                          _transformerOwnerId, 'Transformer Owner Id'),
                      _buildTextField(
                          _transformerKvaRating, 'Transformer Kva Rating'),
                      _buildTextField(_contactNo, 'Contact No'),
                      _buildTextField(
                          _yearOfManufacturing, 'Year Of Manufacturing'),
                      _buildTextField(
                          _nameofManufacturer, 'Name of Manufacturer'),
                      _buildTextField(
                          _transformerSerialNo, 'Transformer Serial No'),
                      _buildTextField(
                          _bodyColorConditionId, 'Body Color Condition Id'),
                      _buildTextField(_nameOfBodyColor, 'nameOfBodyColor'),
                      _buildTextField(
                          _oilLeakageYesOrNo, 'Oil Leakage Yes Or No'),
                      _buildTextField(
                          _placeOfOilLeakageMark, 'Place Of Oil Leakage Mark'),
                      _buildTextField(
                          _platformMaterialId, 'Platform Material Id'),
                      _buildTextField(_typeofTransformerSupportPoleLeft,
                          'Type Of Transformer Support Pole Left'),
                      _buildTextField(_conditionofTransformerSupportPoleLeft,
                          'Condition Of Transformer Support Pole Left'),
                      _buildTextField(_typeofTransformerSupportPoleRight,
                          'Type Of Transformer Support Pole Right'),
                      _buildTextField(_conditionofTransformerSupportPoleRight,
                          'Condition Of Transformer Support Pole Right'),
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
                    const Color.fromARGB(255, 241, 245, 245),
                title: const Text('Voltage Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Rated Voltage/Current',
                    children: [
                      _buildTextField(_ratedVoltage, 'Rated Voltage'),
                      _buildTextField(_ratedHtVoltage, 'Rated Ht Voltage'),
                      _buildTextField(_ratedLTVoltage, 'Rated Lt Voltage'),
                      _buildTextField(_ratedHTCurrent, 'Rated Ht Current'),
                      _buildTextField(_ratedLTCurrent, 'Rated Lt Current'),
                      _buildTextField(_controlVoltage, 'Control Voltage'),
                      _buildTextField(_motorVoltageforspringcharge,
                          'Motor Voltage for Spring Charge'),
                    ],
                  ),
                  FieldsetLegend(
                    legendText: 'Voltage 1',
                    children: [
                      _buildTextField(_voltage1, 'Voltage 1'),
                      _buildTextField(_ryVoltageVolt1, 'RY Voltage Volt 1'),
                      _buildTextField(_ybVoltageVolt1, 'YB Voltage Volt 1'),
                      _buildTextField(_rbVoltageVolt1, 'RB Voltage Volt 1'),
                      _buildTextField(_rnVoltageVolt1, 'RN Voltage Volt 1'),
                      _buildTextField(_ynVoltageVolt1, 'YN Voltage Volt 1'),
                      _buildTextField(_bnVoltageVolt1, 'BN Voltage Volt 1'),
                      _buildTextField(_leakageVoltageBodyEarthVolt1,
                          'Leakage Voltage Body Earth Volt 1'),
                    ],
                  ),
                  FieldsetLegend(
                    legendText: 'Voltage 2',
                    children: [
                      _buildTextField(_voltage2, 'Voltage 2'),
                      _buildTextField(_ryVoltageVolt2, 'RY Voltage Volt 2'),
                      _buildTextField(_ybVoltageVolt2, 'YB Voltage Volt 2'),
                      _buildTextField(_rbVoltageVolt2, 'RB Voltage Volt 2'),
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
                title: const Text('Bushing Phase Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Bushing Phase',
                    children: [
                      _buildTextField(
                          _htBushingRPhaseOil, 'Ht Bushing R Phase Oil'),
                      _buildTextField(
                          _htBushingRPhaseGood, 'Ht Bushing R Phase Good'),
                      _buildTextField(
                          _htBushingRPhaseColor, 'Ht Bushing R Phase Color'),
                      _buildTextField(
                          _htBushingYPhaseOil, 'Ht Bushing Y Phase Oil'),
                      _buildTextField(
                          _htBushingYPhaseGood, 'Ht Bushing Y Phase Good'),
                      _buildTextField(
                          _htBushingYPhaseColor, '"Ht Bushing Y Phase Color'),
                      _buildTextField(
                          _htBushingBPhaseOil, 'Ht Bushing B Phase Oil'),
                      _buildTextField(
                          _htBushingBPhaseGood, 'Ht Bushing B Phase Good'),
                      _buildTextField(
                          _htBushingBPhaseColor, 'Ht Bushing B Phase Color'),
                      _buildTextField(
                          _htBushingNPhaseOil, 'Ht Bushing N Phase Oil'),
                      _buildTextField(
                          _htBushingNPhaseGood, 'Ht Bushing N Phase Good'),
                      _buildTextField(
                          _htBushingNPhaseColor, 'Ht Bushing N Phase Color'),
                      _buildTextField(
                          _ltBushingRPhaseOil, 'Lt Bushing R Phase Oil'),
                      _buildTextField(
                          _ltBushingRPhaseGood, 'Lt Bushing R Phase Good'),
                      _buildTextField(
                          _ltBushingRPhaseColor, 'Lt Bushing R Phase Color'),
                      _buildTextField(
                          _ltBushingYPhaseOil, 'Lt Bushing Y Phase Oil'),
                      _buildTextField(
                          _ltBushingYPhaseGood, 'Lt Bushing Y Phase Good'),
                      _buildTextField(
                          _ltBushingYPhaseColor, 'Lt Bushing Y Phase Color'),
                      _buildTextField(
                          _ltBushingBPhaseOil, 'Lt Bushing B Phase Oil'),
                      _buildTextField(
                          _ltBushingBPhaseGood, 'Lt Bushing B Phase Good'),
                      _buildTextField(
                          _ltBushingBPhaseColor, 'Lt Bushing B Phase Color'),
                      _buildTextField(
                          _ltBushingNPhaseOil, 'Lt Bushing N Phase Oil'),
                      _buildTextField(
                          _ltBushingNPhaseGood, 'Lt Bushing N Phase Good'),
                      _buildTextField(
                          _ltBushingNPhaseColor, 'Lt Bushing N Phase Color'),
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
                    const Color.fromARGB(255, 241, 245, 245),
                title: const Text('Wire/Earthing Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Wire/Earthing Information',
                    children: [
                      _buildTextField(
                          _wireSizeofHTDrop, 'Wire Size Of HT Drop'),
                      _buildTextField(_conditionofHTDropGoodbsBad,
                          'Condition Of HT Drop Good Bs Bad'),
                      _buildTextField(_wirebsCableSizeofLTDropCKT1,
                          'Wire BS Cable Size Of LT Drop CKT1'),
                      _buildTextField(_conditionofLTDropGoodbsBadCKT1,
                          'Condition Of LT Drop Good BS Bad CKT1'),
                      _buildTextField(_wirebsCableSizeofLTDropCKT2,
                          'Wire BS Cable Size Of LT Drop CKT2'),
                      _buildTextField(_conditionofLTDropGoodbsBadCKT2,
                          'Condition Of LT Drop Good BS Bad CKT2'),
                      _buildTextField(_earthingLead1, 'Earthing Lead 1'),
                      _buildTextField(
                          _earthingLead1Size, 'Earthing Lead 1 Size'),
                      _buildTextField(
                          _earthingLead1Material, 'Earthing Lead 1 Material'),
                      _buildTextField(_earthingLead1ConditionStandard,
                          'Earthing Lead 1 Condition Standard'),
                      _buildTextField(_earthingLead2, 'Earthing Lead 2'),
                      _buildTextField(
                          _earthingLead2Size, 'Earthing Lead 2 Size'),
                      _buildTextField(
                          _earthingLead2Material, 'Earthing Lead 2 Material'),
                      _buildTextField(_earthingLead2ConditionStandard,
                          'Earthing Lead 2 Condition Standard'),
                      _buildTextField(_dayPeak, 'Day Peak'),
                      _buildTextField(_dateAndtime1, 'Date And time 1'),
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
                title: const Text('Phase Current Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Phase Current',
                    children: [
                      _buildTextField(_rPhaseCurrentAmps1Ckt1,
                          'R Phase Current Amps 1 Ckt1'),
                      _buildTextField(_rPhaseCurrentAmps1Ckt2,
                          'R Phase Current Amps 1 Ckt2'),
                      _buildTextField(_rPhaseCurrentAmps1Ckt3,
                          'R Phase Current Amps 1 Ckt3'),
                      _buildTextField(_yPhaseCurrentAmps1Ckt1,
                          'Y Phase Current Amps 1 Ckt1'),
                      _buildTextField(_yPhaseCurrentAmps1Ckt2,
                          'Y Phase Current Amps 1 Ckt2'),
                      _buildTextField(_yPhaseCurrentAmps1Ckt3,
                          'Y Phase Current Amps 1 Ckt3'),
                      _buildTextField(_bPhaseCurrentAmps1Ckt1,
                          'B Phase Current Amps 1 Ckt1'),
                      _buildTextField(_bPhaseCurrentAmps1Ckt2,
                          'B Phase Current Amps 1 Ckt2'),
                      _buildTextField(_bPhaseCurrentAmps1Ckt3,
                          'B Phase Current Amps 1 Ckt3'),
                      _buildTextField(_neutralCurrentAmps1Ckt1,
                          'Neutral Current Amps 1 Ckt1'),
                      _buildTextField(_neutralCurrentAmps1Ckt2,
                          'Neutral Current Amps 1 Ckt2'),
                      _buildTextField(_neutralCurrentAmps1Ckt3,
                          'Neutral Current Amps 1 Ckt3'),
                      _buildTextField(
                          _calculatedDayPeakkVA, 'Calculated Day Peak kVA'),
                      _buildTextField(_eveningPeak, 'Evening Peak'),
                      _buildTextField(_dateAndTime2, 'Date And Time 2'),
                    ],
                  ),
                ],
              ),
            ),
            ///////////////////////////////////////////////////////////////////////////
          ]),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        //_installDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
