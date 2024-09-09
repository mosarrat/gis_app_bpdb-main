// ignore_for_file: library_private_types_in_public_api, deprecated_member_use
import 'package:intl/intl.dart';
//import 'package:gis_app_bpdb/models/consumer_lookup/tariff_sub_category,dart';
import 'package:gis_app_bpdb/models/consumer_form_lookup/tariff_category.dart';
import '../../api/api.dart';
import '../../api/consumer_api.dart';
import '../../models/consumer_form_lookup/bussiness_type.dart';
import '../../models/consumer_form_lookup/connection_status.dart';
import '../../models/consumer_form_lookup/connection_type.dart';
import '../../models/consumer_form_lookup/meter_type.dart';
import '../../models/consumer_form_lookup/opreating_voltage.dart';
import '../../models/consumer_form_lookup/phasing_code.dart';
import '../../models/consumer_form_lookup/service_cabletype.dart';
import '../../models/consumer_form_lookup/structure_type.dart';
import '../../models/consumer_form_lookup/tarif_subcatagory.dart';
import '../../models/regions/circle.dart';
import '../../models/consumer_form_lookup/consumer_type.dart';
import '../../models/regions/distribution_transformer.dart';
import '../../models/regions/feeder_line.dart';
import '../../models/regions/pole.dart';
import '../../models/regions/service_point.dart';
import '../../models/regions/snd_info.dart';
import '../../models/regions/substation.dart';
import '../../models/regions/zone.dart';
import '../../widgets/noti/notifications.dart';
import '../../widgets/widgets/fieldset_legend.dart';
import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import '../../models/regions/esu_info.dart';
import '../../models/consumer_form_lookup/location.dart';
import 'filter_consumers.dart';
import '../../models/consumer_lookup/consumers.dart';

class NewConsumerExp extends StatefulWidget {
  const NewConsumerExp({super.key});

  @override
  _NewConsumerExpState createState() => _NewConsumerExpState();
}

class _NewConsumerExpState extends State<NewConsumerExp> {
final _formKey = GlobalKey<FormState>();

  late Future<List<Zone>> zones;
  late Future<List<Circles>> circles;
  late Future<List<SndInfo>> snds;
  late Future<List<EsuInfo>> esu;
  late Future<List<Substation>> substations;
  late Future<List<FeederLine>> feederLines;
  late Future<List<Pole>> poles;
  late Future<List<ServicePoint>> servicePoints;
  late Future<List<ConsumerType>> fetchConsumerType;
  late Future<List<TariffCategory>> fetchTariffCategory;
  late Future<List<SubCategory>> fetchTariffSubcategory;
  ////
  late Future<List<MeterType>> fetchMeterType;
  late Future<List<PhasingCode>> fetchPhasingCode;
  late Future<List<OperatingVoltage>> fetchOperatingVoltage;
  late Future<List<ConnectionStatus>> fetchConnectionStatus;
  late Future<List<ConnectionType>> fetchConnectiontype;
  late Future<List<BusinessType>> fetchBusinessType;
  late Future<List<Locations>> fetchLocations;
  late Future<List<SurviceCableType>> fetchServiceCableType;
  late Future<List<StructureType>> fetchStructureType;

  ///

  late Future<List<DistributionTransformer>> dts;

  int? selectedZoneId;
  int? selectedCircleId;
  int? selectedSnDId;
  int? selectedEsuId;
  int? selectedSubstationId;
  int? selectedFeederLineId;
  int? selectedPoleId;
  int? selectedServicePointId;
  int? selectedConsumerTypeId;
  int? selectedTariffCategoryId;
  int? selectedTariffSubCategoryId;
  int? selectedMeterTypeId;
  int? selectedPhasingCodeId;
  int? selectedConnectionStatusId;
  int? selectedConnectiontypeId;
  int? selectedLocationId;
  int? selectedServiceCableId;
  int? selectedDTId;
  int? selectedOperatingVoltage;
  int? selectedBusinessType;
  int? selectedStructureType;
  var dt = DateTime.now(); // Date-Time
  bool isLoading = false;

  // #region controls
  final TextEditingController _consumerId = TextEditingController();
  final TextEditingController _consumerNoController = TextEditingController();
  final TextEditingController _consumerNameController = TextEditingController();
  final TextEditingController _consumerNameBanglaController =
      TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _nidController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _installDateController = TextEditingController();
  final TextEditingController _meterModelController = TextEditingController();
  final TextEditingController _meterManufacturerController =
      TextEditingController();
  final TextEditingController _sanctionedLoadController =
      TextEditingController();
  final TextEditingController _connectedLoadController =
      TextEditingController();
  final TextEditingController _otherBusinessController =
      TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _specialCodeController = TextEditingController();
  final TextEditingController _specialTypeController = TextEditingController();
  final TextEditingController _billGroupController = TextEditingController();
  final TextEditingController _bookNumberController = TextEditingController();
  final TextEditingController _omfKwhController = TextEditingController();
  final TextEditingController _meterReadingController = TextEditingController();
  final TextEditingController _serviceCableSizeController =
      TextEditingController();
  final TextEditingController _consumerAddressController =
      TextEditingController();
  final TextEditingController _plotNoController = TextEditingController();
  final TextEditingController _buildingAptNoController =
      TextEditingController();
  final TextEditingController _premiseNameController = TextEditingController();
  // final TextEditingController _surveyDateController = TextEditingController();

  String? gpsLat = "0.00";
  String? gpsLong = "0.00";
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  final TextEditingController _structureController = TextEditingController();
  final TextEditingController _structureMapNoController =
      TextEditingController();
  final TextEditingController _numberOfFloorController =
      TextEditingController();
  final TextEditingController _remarks = TextEditingController();
  // #endregion

  //New Line
  final TextEditingController _feederUId = TextEditingController();
  final TextEditingController _unionGeoCode = TextEditingController();
  final TextEditingController _meterNumberController = TextEditingController();

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

    poles = Future.value([]);
    servicePoints = Future.value([]);
    dts = Future.value([]);
    fetchConsumerType = CallConsumerApi().fetchConsumerType();
    fetchTariffCategory = CallConsumerApi().fetchTariffCategory();
    fetchTariffSubcategory = CallConsumerApi().fetchTariffSubcategory();
    fetchMeterType = CallConsumerApi().fetchMeterType();
    fetchPhasingCode = CallConsumerApi().fetchPhasingCode();
    fetchConnectionStatus = CallConsumerApi().fetchConnectionStatus();
    fetchConnectiontype = CallConsumerApi().fetchConnectiontype();
    fetchLocations = CallConsumerApi().fetchLocations();
    fetchServiceCableType = CallConsumerApi().fetchServiceCableType();
    fetchBusinessType = CallConsumerApi().fetchBusinessType();
    fetchStructureType = CallConsumerApi().fetchStructureType();
    fetchOperatingVoltage = CallConsumerApi().fetchOperatingVoltage();
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
    selectedPoleId = null;
    selectedServicePointId = null;
    selectedDTId = null;
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
    selectedPoleId = null;
    selectedServicePointId = null;
    selectedDTId = null;
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
    selectedPoleId = null;
    selectedServicePointId = null;
    selectedDTId = null;
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
    selectedPoleId = null;
    selectedServicePointId = null;
    selectedDTId = null;
  }

  void onSubstationChanged(int? value) {
    setLoading(true);
    selectedSubstationId = value;
    selectedFeederLineId = null;
    selectedPoleId = null;
    selectedServicePointId = null;
    selectedDTId = null;
    feederLines = CallApi().fetchFeederLineInfo(value!).whenComplete(() {
      setLoading(false);
    });
  }

  void onFeederLineChanged(int? value) {
    setLoading(true);
    selectedFeederLineId = value;
    selectedPoleId = null;
    selectedServicePointId = null;
    selectedDTId = null;

    poles = CallApi().fetchPoleInfo(value!).whenComplete(() {
      setLoading(false);
    });
  }

  void onPoleChanged(int? value) {
    setLoading(true);
    selectedPoleId = value;
    selectedServicePointId = null;
    selectedDTId = null;

    servicePoints = CallApi().fetchServicePoints(value!).whenComplete(() {
      setLoading(false);
    });

    dts = CallApi().fetchDistributionTransformers(value).whenComplete(() {
      setLoading(false);
    });
  }
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
            'New Consumer',
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
          key: _formKey,
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
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
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
                                    child: Text('${zone.zoneCode}: ${zone.zoneName}'),
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
                            if (snapshot.connectionState == ConnectionState.waiting) {
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
                            if (snapshot.connectionState == ConnectionState.waiting) {
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
                            if (snapshot.connectionState == ConnectionState.waiting) {
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
                            if (snapshot.connectionState == ConnectionState.waiting) {
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
                            if (snapshot.connectionState == ConnectionState.waiting) {
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
                        const SizedBox(height: 16.0),
                        FutureBuilder<List<Pole>>(
                          future: poles,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              showMessage('Error: ${snapshot.error}', 'error');
                              return DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: 'Pole Details',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                ),
                                value: null,
                                hint: const Text('No pole available!'),
                                items: [],
                                onChanged: null,
                              );
                            } else if (snapshot.hasData) {
                              return DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: 'Pole Details',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                ),
                                value: selectedPoleId,
                                hint: const Text('Select a Pole'),
                                items: snapshot.data!.map((pole) {
                                  return DropdownMenuItem<int>(
                                    value: pole.poleId,
                                    child: Text(pole.poleCode),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedPoleId = value;
                                    onPoleChanged(value);
                                  });
                                },
                              );
                            } else {
                              return const Text('No pole available!');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        FutureBuilder<List<ServicePoint>>(
                          future: servicePoints,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              showMessage('Error: ${snapshot.error}', 'error');
                              return DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: 'Service Point',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                ),
                                value: null,
                                hint: const Text('No service point available!'),
                                items: [],
                                onChanged: null,
                              );
                            } else if (snapshot.hasData) {
                              return DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: 'Service Point',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                ),
                                value: selectedServicePointId,
                                hint: const Text('Select a Service Point'),
                                items: snapshot.data!.map((sp) {
                                  return DropdownMenuItem<int>(
                                    value: sp.servicesPointId,
                                    child: Text(sp.servicePointCode),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedServicePointId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No service point available!');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        FutureBuilder<List<DistributionTransformer>>(
                          future: dts,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              showMessage('Error: ${snapshot.error}', 'error');
                              return DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: 'Distribution Transformer',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                ),
                                value: null,
                                hint: const Text(
                                    'No distribution transformer available!'),
                                items: [],
                                onChanged: null,
                              );
                            } else if (snapshot.hasData) {
                              return DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: 'Distribution Transformer',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                ),
                                value: selectedDTId,
                                hint: const Text('Select a Distribution Transformer'),
                                items: snapshot.data!.map((dt) {
                                  return DropdownMenuItem<int>(
                                    value: dt.id,
                                    child: Text(dt.distributionTransformerCode),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedDTId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text(
                                  'No distribution transformer available!');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _buildTextField(_feederUId, 'Feeder Line UId'),
                        _buildTextField(_unionGeoCode, 'Union Geo Code'),
                      ],
                    ),
                  ],
                ),
              ),
              ////////////////////////////////////////////////////////////////////////////
              Theme(
                data: ThemeData().copyWith(
                  dividerColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                child: ExpansionTile(
                  ////minTileHeight: 25,
                  collapsedBackgroundColor:
                      const Color.fromARGB(255, 241, 245, 245),
                  title: const Text('Consumer Information'),
                  childrenPadding: EdgeInsets.zero,
                  textColor: const Color.fromARGB(255, 5, 161, 182),
                  children: [
                    FieldsetLegend(
                      legendText: 'Consumer Information',
                      children: [
                        _buildTextField(_consumerId, 'Consumer Id'),
                        _buildTextField(_consumerNoController, 'Consumer No'),
                        _buildTextField(_consumerNameController, 'Name'),
                        // _buildTextField(
                        //     _consumerNameBanglaController, 'Name (বাংলায়)'),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _consumerNameBanglaController,
                              decoration: InputDecoration(
                                labelText: 'Name (বাংলায়)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              style: const TextStyle(
                                fontFamily: 'NotoSansBengali', 
                                fontSize: 18,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Name (বাংলায়)'; 
                                }
                                return null;
                              },
                            ),
                          ),
                        _buildTextField(_fatherNameController, 'Father Name'),
                        _buildTextField(_nidController, 'NID'),
                        _buildTextField(_mobileNoController, 'Mobile No'),
                        _buildTextField(_emailController, 'Email Address'),
                        _buildTextField(_accountNumberController, 'Account Number'),
                        FutureBuilder<List<ConsumerType>>(
                          future: fetchConsumerType,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
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
                                value: selectedConsumerTypeId,
                                hint: const Text('Select a Consumer Type'),
                                items: snapshot.data!.map((consumerType) {
                                  return DropdownMenuItem<int>(
                                    value: consumerType.consumerTypeId,
                                    child: Text(
                                        '${consumerType.consumerTypeId}: ${consumerType.consumerTypeName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedConsumerTypeId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No Consumer Type available');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _buildTextField(_consumerAddressController, 'Address'),
                        _buildTextField(_plotNoController, 'Plot No'),
                        _buildTextField(_buildingAptNoController, 'Building Apt. No'),
                        _buildTextField(_premiseNameController, 'Premise Name'),
                        _buildTextField(_numberOfFloorController, 'Number of Floor'),
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
                  title: const Text('Tariff Information'),
                  childrenPadding: EdgeInsets.zero,
                  textColor: const Color.fromARGB(255, 5, 161, 182),
                  children: [
                   FieldsetLegend(
                      legendText: 'Tariff',
                      children: [
                        const SizedBox(height: 8.0),
                        FutureBuilder<List<TariffCategory>>(
                          future: fetchTariffCategory,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
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
                                value: selectedTariffCategoryId,
                                hint: const Text('Select a Tariff Category'),
                                items: snapshot.data!.map((tariffCategory) {
                                  return DropdownMenuItem<int>(
                                    value: tariffCategory.categoryId,
                                    child: Text(
                                        '${tariffCategory.categoryId}: ${tariffCategory.categoryName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedTariffCategoryId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No Tariff Category available');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        FutureBuilder<List<SubCategory>>(
                          future: fetchTariffSubcategory,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
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
                                value: selectedTariffSubCategoryId,
                                hint: const Text('Select a Tariff Subcategory'),
                                items: snapshot.data!.map((tariffSubcategory) {
                                  return DropdownMenuItem<int>(
                                    value: tariffSubcategory.subCategoryId,
                                    child: Text(tariffSubcategory.subCategoryName),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedTariffSubCategoryId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No Tariff Sub Category available');
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////
              //////////////////////////////////////////////////////////////////////////////////
              Theme(
                data: ThemeData().copyWith(
                  dividerColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                child: ExpansionTile(
                  ////minTileHeight: 25,
                  collapsedBackgroundColor:
                      const Color.fromARGB(255, 241, 245, 245),
                  title: const Text('Meter Information'),
                  childrenPadding: EdgeInsets.zero,
                  textColor: const Color.fromARGB(255, 5, 161, 182),
                  children: [
                    FieldsetLegend(
                      legendText: 'Meter Information',
                      children: [
                        const SizedBox(height: 16.0),
                        FutureBuilder<List<MeterType>>(
                          future: fetchMeterType,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
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
                                value: selectedMeterTypeId,
                                hint: const Text('Select a Meter Type'),
                                items: snapshot.data!.map((metertype) {
                                  return DropdownMenuItem<int>(
                                    value: metertype.meterTypeId,
                                    child: Text(
                                        '${metertype.meterTypeId}: ${metertype.meterTypeName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedMeterTypeId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No Meter Type available');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _buildTextField(_meterModelController, 'Meter Model'),
                        _buildTextField(_meterNumberController, 'Meter Number'),
                        _buildTextField(
                            _meterManufacturerController, 'Meter Manufacturer'),
                        _buildTextField(_meterReadingController, 'Meter Reading'),
                        FutureBuilder<List<PhasingCode>>(
                          future: fetchPhasingCode,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
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
                                value: selectedPhasingCodeId,
                                hint: const Text('Select a Phasing Code'),
                                items: snapshot.data!.map((phasingcode) {
                                  return DropdownMenuItem<int>(
                                    value: phasingcode.phasingCodeId,
                                    child: Text(
                                        '${phasingcode.phasingCodeId}: ${phasingcode.phasingCodeName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedPhasingCodeId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No Phasing Code available');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        FutureBuilder<List<OperatingVoltage>>(
                          future: fetchOperatingVoltage,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
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
                                value: selectedOperatingVoltage,
                                hint: const Text('Select a Operating Voltage'),
                                items: snapshot.data!.map((operatingVoltage) {
                                  return DropdownMenuItem<int>(
                                    value: operatingVoltage.operatingVoltageId,
                                    child: Text(
                                        '${operatingVoltage.operatingVoltageId}: ${operatingVoltage.operatingVoltageName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedOperatingVoltage = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No Operating Voltage available');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _installDateController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.calendar_today),
                            labelText: 'Install Date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectDate(context);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Installed Date';
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
              ///////////////////////////////////////////////////////////////////////////
              Theme(
                data: ThemeData().copyWith(
                  dividerColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                child: ExpansionTile(
                  ////minTileHeight: 25,
                  collapsedBackgroundColor:
                      const Color.fromARGB(255, 223, 240, 243),
                  title: const Text('Connection, Business, Bill, Service Information'),
                  childrenPadding: EdgeInsets.zero,
                  textColor: const Color.fromARGB(255, 5, 161, 182),
                  children: [
                    FieldsetLegend(
                      legendText: 'Connection,  Business, Bill, Services',
                      children: [
                        const SizedBox(height: 8.0),
                        FutureBuilder<List<ConnectionStatus>>(
                          future: fetchConnectionStatus,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
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
                                value: selectedConnectionStatusId,
                                hint: const Text('Select a Connection Status'),
                                items: snapshot.data!.map((connectionstatus) {
                                  return DropdownMenuItem<int>(
                                    value: connectionstatus.connectionStatusId,
                                    child: Text(
                                        '${connectionstatus.connectionStatusId}: ${connectionstatus.connectionStatusName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedConnectionStatusId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No Connection Status available');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        FutureBuilder<List<ConnectionType>>(
                          future: fetchConnectiontype,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
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
                                value: selectedConnectiontypeId,
                                hint: const Text('Select a Connection Type'),
                                items: snapshot.data!.map((connectiontype) {
                                  return DropdownMenuItem<int>(
                                    value: connectiontype.connectionTypeId,
                                    child: Text(
                                        '${connectiontype.connectionTypeId}: ${connectiontype.connectionTypeName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedConnectiontypeId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No Connection Type available');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _buildTextField(_sanctionedLoadController, 'Sanctioned Load'),
                        _buildTextField(_connectedLoadController, 'Connected Load'),
                        FutureBuilder<List<BusinessType>>(
                          future: fetchBusinessType,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
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
                                value: selectedBusinessType,
                                hint: const Text('Select a Business Type'),
                                items: snapshot.data!.map((businessType) {
                                  return DropdownMenuItem<int>(
                                    value: businessType.businessTypeId,
                                    child: Text(
                                        '${businessType.businessTypeId}: ${businessType.businessTypeName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedBusinessType = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No Business Type available');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _buildTextField(_otherBusinessController, 'Other Business'),
                        _buildTextField(_specialCodeController, 'Special Code'),
                        _buildTextField(_specialTypeController, 'Special Type'),
                        FutureBuilder<List<Locations>>(
                          future: fetchLocations,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
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
                                value: selectedLocationId,
                                hint: const Text('Select a Location'),
                                items: snapshot.data!.map((location) {
                                  return DropdownMenuItem<int>(
                                    value: location.locationId,
                                    child: Text(
                                        '${location.locationId}: ${location.locationName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedLocationId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No Location available');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _buildTextField(_billGroupController, 'Bill Group'),
                        _buildTextField(_bookNumberController, 'Book Number'),
                        _buildTextField(_omfKwhController, 'OMF kWh (kWh)'),
                        _buildTextField(
                            _serviceCableSizeController, 'Service Cable Size (RM)'),
                        FutureBuilder<List<SurviceCableType>>(
                          future: fetchServiceCableType,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
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
                                value: selectedServiceCableId,
                                hint: const Text('Select a Service Cable Type'),
                                items: snapshot.data!.map((servicecable) {
                                  return DropdownMenuItem<int>(
                                    value: servicecable.serviceCableTypeId,
                                    child: Text(
                                        '${servicecable.serviceCableTypeId}: ${servicecable.serviceCableTypeName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedServiceCableId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No Service Cable Type available');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ],
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////
              ///////////////////////////////////////////////////////////////////////////
              Theme(
                data: ThemeData().copyWith(
                  dividerColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                child: ExpansionTile(
                  ////minTileHeight: 25,
                  collapsedBackgroundColor:
                      const Color.fromARGB(255, 241, 245, 245),
                  title: const Text('GPS Information'),
                  childrenPadding: EdgeInsets.zero,
                  textColor: const Color.fromARGB(255, 5, 161, 182),
                  children: [
                    FieldsetLegend(
                      legendText: 'GPS Information',
                      children: [
                        _buildTextField(_latitudeController, 'Latitude'),
                        _buildTextField(_longitudeController, 'Longitude'),
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
                  title: const Text('Structure Information'),
                  childrenPadding: EdgeInsets.zero,
                  textColor: const Color.fromARGB(255, 5, 161, 182),
                  children: [
                    FieldsetLegend(
                      legendText: 'Structure Information',
                      children: [
                        _buildTextField(_structureController, 'Structure'),
                        _buildTextField(
                            _structureMapNoController, 'Structure Map No'),
                        FutureBuilder<List<StructureType>>(
                          future: fetchStructureType,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
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
                                value: selectedStructureType,
                                hint: const Text('Select a Structure Type'),
                                items: snapshot.data!.map((structureType) {
                                  return DropdownMenuItem<int>(
                                    value: structureType.structureTypeId,
                                    child: Text(
                                        '${structureType.structureTypeId}: ${structureType.structureTypeName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedStructureType = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No Structure Type available');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
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
                  title: const Text('Remarks'),
                  childrenPadding: EdgeInsets.zero,
                  textColor: const Color.fromARGB(255, 5, 161, 182),
                  children: [
                    FieldsetLegend(
                      legendText: 'Remarks',
                      children: [
                        _buildTextField(_remarks, 'Remarks'),
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
                                  return double.tryParse(text?.trim() ?? '') ?? 0.0;
                                } catch (e) {
                                  throw 'Invalid double for field $text';
                                }
                              }

                              String formatDate(String? text) {
                                try {
                                  return DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                                      .format(DateTime.parse(text ?? dt.toString()));
                                } catch (e) {
                                  throw 'Invalid date format for field Install Date';
                                }
                              }
                              T checkNotNull<T>(T? value, String fieldName) {
                                if (value == null || value == 0.00) {
                                  throw 'Invalid value for $fieldName. PLease Check Again ';
                                }
                                return value;
                              }
                              Consumers consumer = Consumers(
                                zoneId: selectedZoneId ?? 0,
                                circleId: selectedCircleId ?? 0,
                                sndId: selectedSnDId ?? 0,
                                esuId: selectedEsuId,
                                substationId: selectedSubstationId ?? 0,
                                feederLineId: selectedFeederLineId ?? 0,
                                poleDetailsId: selectedPoleId ?? 0,
                                servicesPointId: selectedServicePointId ?? 0,
                                dtId: selectedDTId ?? 0,
                                feederUId: parseOrZero(_feederUId.text),
                                unionGeoCode: _unionGeoCode.text,
                                consumerId: parseOrZero(_consumerId.text),
                                customerName: _consumerNameController.text,
                                customerNameBng: _consumerNameBanglaController.text,
                                fatherName: _fatherNameController.text,
                                customerNid: checkNotNull(_nidController.text, 'Union Geocode' ),
                                mobileNo: checkNotNull(_mobileNoController.text, 'Mobile Number'),
                                email: checkNotNull(_emailController.text, 'Email'),
                                consumerNo: _consumerNoController.text,
                                accountNumber: _accountNumberController.text,
                                consumerTypeId: selectedConsumerTypeId ?? 0,
                                customerAddress: _consumerAddressController.text,
                                plotNo: _plotNoController.text,
                                buildingAptNo: _buildingAptNoController.text,
                                premiseName: _premiseNameController.text,
                                numberOfFloor:
                                    parseOrZero(_numberOfFloorController.text),
                                tariffCategoryId: selectedTariffCategoryId ?? 0,
                                tariffSubCategoryId: selectedTariffSubCategoryId ?? 0,
                                meterTypeId: selectedMeterTypeId ?? 0,
                                meterModel: _meterModelController.text,
                                meterNumber: _meterNumberController.text,
                                meterManufacturer: _meterManufacturerController.text,
                                meterReading:
                                    parseOrZeroDouble(_meterReadingController.text),
                                phasingCodeTypeId: selectedPhasingCodeId ?? 0,
                                operatingVoltageId: selectedOperatingVoltage ?? 0,
                                installDate: formatDate(_installDateController.text),
                                connectionStatusId: selectedConnectionStatusId ?? 0,
                                connectionTypeId: selectedConnectiontypeId ?? 0,
                                sanctionedLoad:
                                    parseOrZeroDouble(_sanctionedLoadController.text),
                                connectedLoad:
                                    parseOrZeroDouble(_connectedLoadController.text),
                                businessTypeId: selectedBusinessType ?? 0,
                                othersBusiness: _otherBusinessController.text,
                                specialCode: _specialCodeController.text,
                                specialType: _specialTypeController.text,
                                locationId: selectedLocationId ?? 0,
                                billGroup: _billGroupController.text,
                                bookNumber: _bookNumberController.text,
                                omfKwh: parseOrZeroDouble(_omfKwhController.text),
                                serviceCableSize:
                                    parseOrZero(_serviceCableSizeController.text),
                                serviceCableTypeId: selectedServiceCableId ?? 0,
                                surveyDate: formatDate(dt.toString()),
                                latitude: checkNotNull(parseOrZeroDouble(_latitudeController.text), 'Latitude'),
                                longitude:
                                    checkNotNull(parseOrZeroDouble(_longitudeController.text), 'Longitude'),
                                structureId: _structureController.text,
                                structureMapNo: _structureMapNoController.text,
                                structureTypeId: selectedStructureType ?? 0,
                                startingDate: formatDate(dt.toString()),
                                remarks: _remarks.text,
                                activationStatusId: 2,
                                verificationStateId: 2,
                                distance_from_sp: 0,
                              );
                              
                              await CallConsumerApi().createConsumer(consumer);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FilterConsumers()),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Consumer Created Successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (error) {
                              //print(error);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Failed to Create data: $error'),
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
        _installDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
