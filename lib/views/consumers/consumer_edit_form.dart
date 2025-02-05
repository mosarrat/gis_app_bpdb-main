import 'package:flutter/material.dart';
import 'package:gis_app_bpdb/models/consumer_lookup/consumers.dart';
import 'package:intl/intl.dart';

import '../../api/api.dart';
import '../../api/consumer_api.dart';
import '../../api/region_api.dart';
import '../../models/consumer_form_lookup/bussiness_type.dart';
import '../../models/consumer_form_lookup/connection_status.dart';
import '../../models/consumer_form_lookup/connection_type.dart';
import '../../models/consumer_form_lookup/consumer_type.dart';
import '../../models/consumer_form_lookup/location.dart';
import '../../models/consumer_form_lookup/meter_type.dart';
import '../../models/consumer_form_lookup/opreating_voltage.dart';
import '../../models/consumer_form_lookup/phasing_code.dart';
import '../../models/consumer_form_lookup/service_cabletype.dart';
import '../../models/consumer_form_lookup/structure_type.dart';
import '../../models/consumer_form_lookup/tarif_subcatagory.dart';
import '../../models/consumer_form_lookup/tariff_category.dart';
import '../../models/regions/distribution_transformer.dart';
import '../../models/regions/circle.dart';
import '../../models/regions/esu_info.dart';
import '../../models/regions/feeder_line.dart';
import '../../models/regions/pole.dart';
import '../../models/regions/service_point.dart';
import '../../models/regions/snd_info.dart';
import '../../models/regions/substation.dart';
import '../../models/regions/zone.dart';
import '../../widgets/noti/notifications.dart';
import '../../widgets/widgets/fieldset_legend.dart';
import 'view_consumers.dart';

class ShowConsumerEdit extends StatefulWidget {
  final int consumerId;
  const ShowConsumerEdit({
    super.key,
    required this.consumerId,
  });

  @override
  State<ShowConsumerEdit> createState() => _ShowConsumerEditState();
}

class _ShowConsumerEditState extends State<ShowConsumerEdit> {
  late Future<Consumers> _futureConsumerData;

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
  late Future<List<DistributionTransformer>> dts;
  late TextEditingController _installDateController;

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

  late TextEditingController _consumerId = TextEditingController();
  late TextEditingController _consumerNoController = TextEditingController();
  late TextEditingController _consumerNameController = TextEditingController();
  late TextEditingController _consumerNameBanglaController =
      TextEditingController();
  late TextEditingController _fatherNameController = TextEditingController();
  late TextEditingController _nidController = TextEditingController();
  late TextEditingController _mobileNoController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _meterModelController = TextEditingController();
  late TextEditingController _meterManufacturerController =
      TextEditingController();
  late TextEditingController _sanctionedLoadController =
      TextEditingController();
  late TextEditingController _connectedLoadController = TextEditingController();
  late TextEditingController _otherBusinessController = TextEditingController();
  late TextEditingController _accountNumberController = TextEditingController();
  late TextEditingController _specialCodeController = TextEditingController();
  late TextEditingController _specialTypeController = TextEditingController();
  late TextEditingController _billGroupController = TextEditingController();
  late TextEditingController _bookNumberController = TextEditingController();
  late TextEditingController _omfKwhController = TextEditingController();
  late TextEditingController _meterReadingController = TextEditingController();
  late TextEditingController _serviceCableSizeController =
      TextEditingController();
  late TextEditingController _consumerAddressController =
      TextEditingController();
  late TextEditingController _plotNoController = TextEditingController();
  late TextEditingController _buildingAptNoController = TextEditingController();
  late TextEditingController _premiseNameController = TextEditingController();

  late TextEditingController _structureController = TextEditingController();
  late TextEditingController _structureMapNoController =
      TextEditingController();
  late TextEditingController _numberOfFloorController = TextEditingController();
  late TextEditingController _remarks = TextEditingController();
  late TextEditingController _latitudeController = TextEditingController();
  late TextEditingController _longitudeController = TextEditingController();
  late TextEditingController _feederUId = TextEditingController();
  late TextEditingController _unionGeoCode = TextEditingController();
  late TextEditingController _meterNumberController = TextEditingController();

  Future<Consumers> _fetchConsumerData() async {
    return CallConsumerApi().fetchConsumerById(widget.consumerId);
  }

  @override
  void initState() {
    super.initState();

    // Fetch the consumer data
    _futureConsumerData = _fetchConsumerData();
    zones = CallApi().fetchZoneInfo();
    dts = Future.value([]);
    circles = Future.value([]);
    snds = Future.value([]);
    esu = Future.value([]);
    substations = Future.value([]);
    feederLines = Future.value([]);
    poles = Future.value([]);
    servicePoints = Future.value([]);
    fetchConsumerType = Future.value([]);
    fetchTariffCategory = Future.value([]);
    fetchTariffSubcategory = Future.value([]);
    fetchMeterType = Future.value([]);
    fetchPhasingCode = Future.value([]);
    fetchConnectionStatus = Future.value([]);
    fetchConnectiontype = Future.value([]);
    fetchLocations = Future.value([]);
    fetchServiceCableType = Future.value([]);
    fetchBusinessType = Future.value([]);
    fetchStructureType = Future.value([]);
    fetchOperatingVoltage = Future.value([]);
    _installDateController = TextEditingController();
    // Initialize dependent data
    _futureConsumerData.then((consumer) {
      setState(() {
        circles = CallApi().fetchCircleInfo(consumer.zoneId);
        snds = CallApi().fetchSnDInfo(consumer.circleId);
        esu = CallConsumerApi().fetchEsuInfo(consumer.sndId);
        substations = CallApi().fetchSubstationInfo(consumer.sndId);
        feederLines = CallApi().fetchFeederLineInfo(consumer.substationId);
        poles = CallApi().fetchPoleInfo(consumer.feederLineId);
        servicePoints = CallApi().fetchServicePoints(consumer.poleDetailsId);
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
        // Initialize selected values
        selectedZoneId = consumer.zoneId;
        selectedCircleId = consumer.circleId;
        selectedSnDId = consumer.sndId;
        selectedEsuId = consumer.esuId;
        selectedSubstationId = consumer.substationId;
        selectedFeederLineId = consumer.feederLineId;
        selectedPoleId = consumer.poleDetailsId;
        selectedServicePointId = consumer.servicesPointId;
        //selectedConsumerTypeId = consumer.consumerTypeId;
        if (consumer.consumerTypeId != null &&
            consumer.consumerTypeId != 0) {
          selectedConsumerTypeId = consumer.consumerTypeId;
        }

        if (consumer.tariffCategoryId != null &&
            consumer.tariffCategoryId != 0) {
          selectedTariffCategoryId = consumer.tariffCategoryId;
        }

        if (consumer.tariffSubCategoryId != null &&
            consumer.tariffSubCategoryId != 0) {
          selectedTariffSubCategoryId = consumer.tariffSubCategoryId;
        }

        selectedMeterTypeId = (consumer.meterTypeId != null &&
              consumer.meterTypeId != 0)
            ? consumer.meterTypeId
            : selectedMeterTypeId;

        selectedPhasingCodeId = (consumer.phasingCodeTypeId != null &&
              consumer.phasingCodeTypeId != 0)
            ? consumer.phasingCodeTypeId
            : selectedPhasingCodeId;

        selectedConnectionStatusId = (consumer.connectionStatusId != null &&
              consumer.connectionStatusId != 0)
            ? consumer.connectionStatusId
            : selectedConnectionStatusId;

        selectedConnectiontypeId = (consumer.connectionTypeId != null &&
              consumer.connectionTypeId != 0)
            ? consumer.connectionTypeId
            : selectedConnectiontypeId;

        selectedLocationId =
            (consumer.locationId != null && consumer.locationId != 0)
                ? consumer.locationId
                : selectedLocationId;

        selectedServiceCableId = (consumer.serviceCableTypeId != null &&
                consumer.serviceCableTypeId != 0)
            ? consumer.serviceCableTypeId
            : selectedServiceCableId;

        selectedDTId = (consumer.dtId != null && consumer.dtId != 0)
            ? consumer.dtId
            : selectedDTId;

        selectedOperatingVoltage = (consumer.operatingVoltageId != null &&
              consumer.operatingVoltageId != 0)
            ? consumer.operatingVoltageId
            : selectedOperatingVoltage;

        selectedBusinessType = (consumer.businessTypeId != null &&
              consumer.businessTypeId != 0)
            ? consumer.businessTypeId
            : selectedBusinessType;

        selectedStructureType = (consumer.structureTypeId != null &&
              consumer.structureTypeId != 0)
            ? consumer.structureTypeId
            : selectedStructureType;

        if (consumer.installDate != "") {
          var installedDate = DateFormat("yyyy-MM-dd")
              .format(DateTime.parse(consumer.installDate));
          _installDateController = TextEditingController(
            text: installedDate,
          );
        } else {
          _installDateController =
              TextEditingController(text: consumer.installDate);
        }

        _consumerId.text = consumer.consumerId.toString();
        _consumerNoController.text = consumer.consumerNo;
        _consumerNameController.text = consumer.customerName;
        _consumerNameBanglaController.text = consumer.customerNameBng ?? '';
        _fatherNameController.text = consumer.fatherName ?? '';
        _nidController.text = consumer.customerNid ?? '';
        _mobileNoController.text = consumer.mobileNo ?? '';
        _emailController.text = consumer.email ?? '';
        _meterModelController.text = consumer.meterModel ?? '';
        _meterManufacturerController.text = consumer.meterManufacturer ?? '';
        _sanctionedLoadController.text =
            consumer.sanctionedLoad?.toString() ?? '';
        _connectedLoadController.text =
            consumer.connectedLoad?.toString() ?? '';
        _otherBusinessController.text = consumer.othersBusiness ?? '';
        _accountNumberController.text = consumer.accountNumber ?? '';
        _specialCodeController.text = consumer.specialCode ?? '';
        _specialTypeController.text = consumer.specialType ?? '';
        _billGroupController.text = consumer.billGroup ?? '';
        _bookNumberController.text = consumer.bookNumber ?? '';
        _omfKwhController.text = consumer.omfKwh?.toString() ?? '';
        _meterReadingController.text = consumer.meterReading?.toString() ?? '';
        _serviceCableSizeController.text = consumer.serviceCableSize.toString();
        _consumerAddressController.text = consumer.customerAddress ?? '';
        _plotNoController.text = consumer.plotNo ?? '';
        _buildingAptNoController.text = consumer.buildingAptNo ?? '';
        _premiseNameController.text = consumer.premiseName ?? '';
        _structureController.text = consumer.structureId ?? '';
        _structureMapNoController.text = consumer.structureMapNo ?? '';
        _numberOfFloorController.text =
            consumer.numberOfFloor?.toString() ?? '';
        _remarks.text = consumer.remarks ?? '';
        _latitudeController.text = consumer.latitude?.toString() ?? '';
        _longitudeController.text = consumer.longitude?.toString() ?? '';
        _feederUId.text = consumer.feederUId.toString();
        _unionGeoCode.text = consumer.unionGeoCode ?? '';
        _meterNumberController.text = consumer.meterNumber ?? '';
      });
    });
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
    var dt = DateTime.now(); // Date-Time
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3))),
      contentPadding: const EdgeInsets.all(0),
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      // title: const Text('FeederLine Details'),
      backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      title: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Consumer Update Information",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                shadowColor: Colors.transparent,
                // width: MediaQuery.of(context).size.width,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                )),
                //color: const Color.fromARGB(255, 206, 242, 248),
                color: Colors.white,
                margin: const EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ////////////////////////////////////////Theme_1//////////////////////////////////
                      Theme(
                        data: ThemeData().copyWith(
                          dividerColor: Colors.transparent,
                          iconTheme: const IconThemeData(color: Colors.white),
                        ),
                        child: ExpansionTile(
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
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Zone',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
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
                                      showMessage(
                                          'Error: ${snapshot.error}', 'error');
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Circle',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        value: null,
                                        hint:
                                            const Text('No circles available!'),
                                        items: [],
                                        onChanged: null,
                                      );
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        decoration: const InputDecoration(
                                          labelText: 'Circle',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
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
                                      return const Text(
                                          'No circles available!');
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
                                      showMessage(
                                          'Error: ${snapshot.error}', 'error');
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'SnD',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
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
                                        decoration: const InputDecoration(
                                          labelText: 'SnD',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        value: selectedSnDId,
                                        hint: const Text('Select a SnD'),
                                        items: snapshot.data!.map((snd) {
                                          return DropdownMenuItem<int>(
                                            value: snd.sndId,
                                            child: Text(
                                                '${snd.sndCode}: ${snd.sndName}'),
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
                                      showMessage(
                                          'Error: ${snapshot.error}', 'error');

                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Esu',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
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
                                        decoration: const InputDecoration(
                                          labelText: 'Esu',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        value: selectedEsuId,
                                        hint: const Text('Select a Esu'),
                                        items: snapshot.data!.map((esu) {
                                          return DropdownMenuItem<int>(
                                            value: esu.esuId,
                                            child: Text(
                                                '${esu.esuCode}: ${esu.esuName}'),
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
                                      showMessage(
                                          'Error: ${snapshot.error}', 'error');
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Substation',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        value: null,
                                        hint: const Text(
                                            'No substations available!'),
                                        items: [],
                                        onChanged: null,
                                      );
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Substation',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
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
                                      return const Text(
                                          'No substations available!');
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
                                      showMessage(
                                          'Error: ${snapshot.error}', 'error');
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Feeder Line',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        value: null,
                                        hint: const Text(
                                            'No feeder line available!'),
                                        items: [],
                                        onChanged: null,
                                      );
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Feeder Line',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        value: selectedFeederLineId,
                                        hint:
                                            const Text('Select a Feeder Line'),
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
                                      return const Text(
                                          'No feeder line available!');
                                    }
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                FutureBuilder<List<Pole>>(
                                  future: poles,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      showMessage(
                                          'Error: ${snapshot.error}', 'error');

                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Pole Details',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        value: null,
                                        hint: const Text('No pole available!'),
                                        items: [],
                                        onChanged: null,
                                      );
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Pole Details',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
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
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      showMessage(
                                          'Error: ${snapshot.error}', 'error');
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Service Point',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        value: null,
                                        hint: const Text(
                                            'No service point available!'),
                                        items: [],
                                        onChanged: null,
                                      );
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Service Point',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        value: selectedServicePointId,
                                        hint: const Text(
                                            'Select a Service Point'),
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
                                      return const Text(
                                          'No service point available!');
                                    }
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                FutureBuilder<List<DistributionTransformer>>(
                                  future: dts,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      showMessage(
                                          'Error: ${snapshot.error}', 'error');
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Distribution Transformer',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
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
                                        decoration: const InputDecoration(
                                          labelText: 'Distribution Transformer',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        value: selectedDTId,
                                        hint: const Text(
                                            'Select a Distribution Transformer'),
                                        items: snapshot.data!.map((dt) {
                                          return DropdownMenuItem<int>(
                                            value: dt.id,
                                            child: Text(
                                                dt.distributionTransformerCode),
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
                                _buildTextField(
                                    context, _feederUId, 'Feeder Line UId'),
                                // _buildTextField(
                                //     context, _unionGeoCode, 'Union Geo Code'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ////////////////////////////////////////Theme_1//////////////////////////////////
                      ///////////////////////////////////////////Theme_2//////////////////////////////////
                      Theme(
                        data: ThemeData().copyWith(
                          dividerColor: Colors.transparent,
                          iconTheme: const IconThemeData(color: Colors.white),
                        ),
                        child: ExpansionTile(
                          collapsedBackgroundColor:
                              const Color.fromARGB(255, 241, 245, 245),
                          title: const Text('Consumer Information'),
                          childrenPadding: const EdgeInsets.all(5),
                          textColor: const Color.fromARGB(255, 5, 161, 182),
                          children: [
                            FieldsetLegend(
                              legendText: 'Consumer Information',
                              children: [
                                _buildTextField(
                                    context, _consumerId, 'Consumer Id'),
                                _buildTextField(context, _consumerNoController,
                                    'Consumer No'),
                                _buildTextField(
                                    context, _consumerNameController, 'Name'),
                                // _buildTextField(
                                //     context, _consumerNameBanglaController, 'Name (বাংলায়)'),
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
                                _buildTextField(context, _fatherNameController,
                                    'Father Name'),
                                _buildTextField(context, _nidController, 'NID'),
                                _buildTextField(
                                    context, _mobileNoController, 'Mobile No'),
                                _buildTextField(
                                    context, _emailController, 'Email Address'),
                                _buildTextField(context,
                                    _accountNumberController, 'Account Number'),
                                FutureBuilder<List<ConsumerType>>(
                                  future: fetchConsumerType,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        value: selectedConsumerTypeId,
                                        hint: const Text(
                                            'Select a Consumer Type'),
                                        items:
                                            snapshot.data!.map((consumerType) {
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
                                      return const Text(
                                          'No Consumer Type available');
                                    }
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                _buildTextField(context,
                                    _consumerAddressController, 'Address'),
                                _buildTextField(
                                    context, _plotNoController, 'Plot No'),
                                _buildTextField(
                                    context,
                                    _buildingAptNoController,
                                    'Building Apt. No'),
                                _buildTextField(context, _premiseNameController,
                                    'Premise Name'),
                                _buildTextField(
                                    context,
                                    _numberOfFloorController,
                                    'Number of Floor'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ////////////////////////////////////////Theme_2//////////////////////////////////
                      ////////////////////////////////////////Theme_3//////////////////////////////////
                      Theme(
                        data: ThemeData().copyWith(
                          dividerColor: Colors.transparent,
                          iconTheme: const IconThemeData(color: Colors.white),
                        ),
                        child: ExpansionTile(
                          collapsedBackgroundColor:
                              const Color.fromARGB(255, 223, 240, 243),
                          title: const Text('Tariff Information'),
                          childrenPadding: const EdgeInsets.all(5),
                          textColor: const Color.fromARGB(255, 5, 161, 182),
                          children: [
                            FieldsetLegend(
                              legendText: 'Tariff',
                              children: [
                                const SizedBox(height: 8.0),
                                FutureBuilder<List<TariffCategory>>(
                                  future: fetchTariffCategory,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        value: selectedTariffCategoryId,
                                        hint: const Text(
                                            'Select a Tariff Category'),
                                        items: snapshot.data!
                                            .map((tariffCategory) {
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
                                      return const Text(
                                          'No Tariff Category available');
                                    }
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                FutureBuilder<List<SubCategory>>(
                                  future: fetchTariffSubcategory,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        value: selectedTariffSubCategoryId,
                                        hint: const Text(
                                            'Select a Tariff Subcategory'),
                                        items: snapshot.data!
                                            .map((tariffSubcategory) {
                                          return DropdownMenuItem<int>(
                                            value:
                                                tariffSubcategory.subCategoryId,
                                            child: Text(tariffSubcategory
                                                .subCategoryName),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedTariffSubCategoryId = value;
                                          });
                                        },
                                      );
                                    } else {
                                      return const Text(
                                          'No Tariff Sub Category available');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ////////////////////////////////////////Theme_3//////////////////////////////////
                      ///////////////////////////////////////////Theme_4//////////////////////////////////
                      Theme(
                        data: ThemeData().copyWith(
                          dividerColor: Colors.transparent,
                          iconTheme: const IconThemeData(color: Colors.white),
                        ),
                        child: ExpansionTile(
                          collapsedBackgroundColor:
                              const Color.fromARGB(255, 241, 245, 245),
                          title: const Text('Meter Information'),
                          childrenPadding: const EdgeInsets.all(5),
                          textColor: const Color.fromARGB(255, 5, 161, 182),
                          children: [
                            FieldsetLegend(
                              legendText: 'Meter Information',
                              children: [
                                const SizedBox(height: 16.0),
                                FutureBuilder<List<MeterType>>(
                                  future: fetchMeterType,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          // labelText: 'Feeder Line Type',
                                          labelStyle: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
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
                                      return const Text(
                                          'No Meter Type available');
                                    }
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                _buildTextField(context, _meterModelController,
                                    'Meter Model'),
                                _buildTextField(context, _meterNumberController,
                                    'Meter Number'),
                                _buildTextField(
                                    context,
                                    _meterManufacturerController,
                                    'Meter Manufacturer'),
                                _buildTextField(context,
                                    _meterReadingController, 'Meter Reading'),
                                FutureBuilder<List<PhasingCode>>(
                                  future: fetchPhasingCode,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          // labelText: 'Feeder Line Type',
                                          labelStyle: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        value: selectedPhasingCodeId,
                                        hint:
                                            const Text('Select a Phasing Code'),
                                        items:
                                            snapshot.data!.map((phasingcode) {
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
                                      return const Text(
                                          'No Phasing Code available');
                                    }
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                FutureBuilder<List<OperatingVoltage>>(
                                  future: fetchOperatingVoltage,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          // labelText: 'Feeder Line Type',
                                          labelStyle: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        value: selectedOperatingVoltage,
                                        hint: const Text(
                                            'Select a Operating Voltage'),
                                        items: snapshot.data!
                                            .map((operatingVoltage) {
                                          return DropdownMenuItem<int>(
                                            value: operatingVoltage
                                                .operatingVoltageId,
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
                                      return const Text(
                                          'No Operating Voltage available');
                                    }
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                TextFormField(
                                  controller: _installDateController,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.calendar_today),
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
                      ////////////////////////////////////////Theme_4//////////////////////////////////
                      ////////////////////////////////////////Theme_5//////////////////////////////////
                      Theme(
                        data: ThemeData().copyWith(
                          dividerColor: Colors.transparent,
                          iconTheme: const IconThemeData(color: Colors.white),
                        ),
                        child: ExpansionTile(
                          collapsedBackgroundColor:
                              const Color.fromARGB(255, 223, 240, 243),
                          title: const Text(
                              'Connection,  Business, Bill, Services Information'),
                          childrenPadding: const EdgeInsets.all(5),
                          textColor: const Color.fromARGB(255, 5, 161, 182),
                          children: [
                            FieldsetLegend(
                              legendText:
                                  'Connection,  Business, Bill, Services',
                              children: [
                                const SizedBox(height: 8.0),
                                FutureBuilder<List<ConnectionStatus>>(
                                  future: fetchConnectionStatus,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          // labelText: 'Feeder Line Type',
                                          labelStyle: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        value: selectedConnectionStatusId,
                                        hint: const Text(
                                            'Select a Connection Status'),
                                        items: snapshot.data!
                                            .map((connectionstatus) {
                                          return DropdownMenuItem<int>(
                                            value: connectionstatus
                                                .connectionStatusId,
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
                                      return const Text(
                                          'No Connection Status available');
                                    }
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                FutureBuilder<List<ConnectionType>>(
                                  future: fetchConnectiontype,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          // labelText: 'Feeder Line Type',
                                          labelStyle: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        value: selectedConnectiontypeId,
                                        hint: const Text(
                                            'Select a Connection Type'),
                                        items: snapshot.data!
                                            .map((connectiontype) {
                                          return DropdownMenuItem<int>(
                                            value:
                                                connectiontype.connectionTypeId,
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
                                      return const Text(
                                          'No Connection Type available');
                                    }
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                _buildTextField(
                                    context,
                                    _sanctionedLoadController,
                                    'Sanctioned Load'),
                                _buildTextField(context,
                                    _connectedLoadController, 'Connected Load'),
                                FutureBuilder<List<BusinessType>>(
                                  future: fetchBusinessType,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          // labelText: 'Feeder Line Type',
                                          labelStyle: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        value: selectedBusinessType,
                                        hint: const Text(
                                            'Select a Business Type'),
                                        items:
                                            snapshot.data!.map((businessType) {
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
                                      return const Text(
                                          'No Business Type available');
                                    }
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                _buildTextField(context,
                                    _otherBusinessController, 'Other Business'),
                                _buildTextField(context, _specialCodeController,
                                    'Special Code'),
                                _buildTextField(context, _specialTypeController,
                                    'Special Type'),
                                FutureBuilder<List<Locations>>(
                                  future: fetchLocations,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          // labelText: 'Feeder Line Type',
                                          labelStyle: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
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
                                      return const Text(
                                          'No Location available');
                                    }
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                _buildTextField(context, _billGroupController,
                                    'Bill Group'),
                                _buildTextField(context, _bookNumberController,
                                    'Book Number'),
                                _buildTextField(context, _omfKwhController,
                                    'OMF kWh (kWh)'),
                                _buildTextField(
                                    context,
                                    _serviceCableSizeController,
                                    'Service Cable Size (RM)'),
                                FutureBuilder<List<SurviceCableType>>(
                                  future: fetchServiceCableType,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          // labelText: 'Feeder Line Type',
                                          labelStyle: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        value: selectedServiceCableId,
                                        hint: const Text(
                                            'Select a Service Cable Type'),
                                        items:
                                            snapshot.data!.map((servicecable) {
                                          return DropdownMenuItem<int>(
                                            value:
                                                servicecable.serviceCableTypeId,
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
                                      return const Text(
                                          'No Service Cable Type available');
                                    }
                                  },
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ////////////////////////////////////////Theme_5//////////////////////////////////
                      ///////////////////////////////////////////Theme_6//////////////////////////////////
                      Theme(
                        data: ThemeData().copyWith(
                          dividerColor: Colors.transparent,
                          iconTheme: const IconThemeData(color: Colors.white),
                        ),
                        child: ExpansionTile(
                          collapsedBackgroundColor:
                              const Color.fromARGB(255, 241, 245, 245),
                          title: const Text('GPS Information'),
                          childrenPadding: const EdgeInsets.all(5),
                          textColor: const Color.fromARGB(255, 5, 161, 182),
                          children: [
                            FieldsetLegend(
                              legendText: 'GPS Information',
                              children: [
                                _buildTextField(
                                    context, _latitudeController, 'Latitude'),
                                _buildTextField(
                                    context, _longitudeController, 'Longitude'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ////////////////////////////////////////Theme_6//////////////////////////////////
                      ////////////////////////////////////////Theme_7//////////////////////////////////
                      Theme(
                        data: ThemeData().copyWith(
                          dividerColor: Colors.transparent,
                          iconTheme: const IconThemeData(color: Colors.white),
                        ),
                        child: ExpansionTile(
                          collapsedBackgroundColor:
                              const Color.fromARGB(255, 223, 240, 243),
                          title: const Text('Structure Information'),
                          childrenPadding: const EdgeInsets.all(5),
                          textColor: const Color.fromARGB(255, 5, 161, 182),
                          children: [
                            FieldsetLegend(
                              legendText: 'Structure Information',
                              children: [
                                _buildTextField(
                                    context, _structureController, 'Structure'),
                                _buildTextField(
                                    context,
                                    _structureMapNoController,
                                    'Structure Map No'),
                                FutureBuilder<List<StructureType>>(
                                  future: fetchStructureType,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          // labelText: 'Feeder Line Type',
                                          labelStyle: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        value: selectedStructureType,
                                        hint: const Text(
                                            'Select a Structure Type'),
                                        items:
                                            snapshot.data!.map((structureType) {
                                          return DropdownMenuItem<int>(
                                            value:
                                                structureType.structureTypeId,
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
                                      return const Text(
                                          'No Structure Type available');
                                    }
                                  },
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ////////////////////////////////////////Theme_7//////////////////////////////////
                      ///////////////////////////////////////////Theme_8//////////////////////////////////
                      Theme(
                        data: ThemeData().copyWith(
                          dividerColor: Colors.transparent,
                          iconTheme: const IconThemeData(color: Colors.white),
                        ),
                        child: ExpansionTile(
                          collapsedBackgroundColor:
                              const Color.fromARGB(255, 241, 245, 245),
                          title: const Text('Remarks'),
                          childrenPadding: const EdgeInsets.all(5),
                          textColor: const Color.fromARGB(255, 5, 161, 182),
                          children: [
                            FieldsetLegend(
                              legendText: 'Remarks',
                              children: [
                                _buildTextField(context, _remarks, 'Remarks'),
                              ],
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      // Parsing reusable variables
                                      int parseOrZero(String? text) =>
                                          int.tryParse(text?.trim() ?? '') ?? 0;
                                      double parseOrZeroDouble(String? text) =>
                                          double.tryParse(text?.trim() ?? '') ??
                                          0.0;
                                      String formatDate(String? text) =>
                                          DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                                              .format(DateTime.parse(
                                                  text ?? dt.toString()));

                                      Consumers consumer = Consumers(
                                        zoneId: selectedZoneId ?? 0,
                                        circleId: selectedCircleId ?? 0,
                                        sndId: selectedSnDId ?? 0,
                                        esuId: selectedEsuId,
                                        substationId: selectedSubstationId ?? 0,
                                        feederLineId: selectedFeederLineId ?? 0,
                                        poleDetailsId: selectedPoleId ?? 0,
                                        servicesPointId:
                                            selectedServicePointId ?? 0,
                                        dtId: selectedDTId ?? 0,
                                        feederUId: parseOrZero(_feederUId.text),
                                        unionGeoCode: null,
                                        consumerId:
                                            parseOrZero(_consumerId.text),
                                        customerName:
                                            _consumerNameController.text,
                                        customerNameBng:
                                            _consumerNameBanglaController.text,
                                        fatherName: _fatherNameController.text,
                                        customerNid: _nidController.text,
                                        mobileNo: _mobileNoController.text,
                                        email: _emailController.text,
                                        consumerNo: _consumerNoController.text,
                                        accountNumber:
                                            _accountNumberController.text,
                                        consumerTypeId:
                                            selectedConsumerTypeId ?? 0,
                                        customerAddress:
                                            _consumerAddressController.text,
                                        plotNo: _plotNoController.text,
                                        buildingAptNo:
                                            _buildingAptNoController.text,
                                        premiseName:
                                            _premiseNameController.text,
                                        numberOfFloor: parseOrZero(
                                            _numberOfFloorController.text),
                                        tariffCategoryId:
                                            selectedTariffCategoryId ?? 0,
                                        tariffSubCategoryId:
                                            selectedTariffSubCategoryId ?? 0,
                                        meterTypeId: selectedMeterTypeId ?? 0,
                                        meterModel: _meterModelController.text,
                                        meterNumber:
                                            _meterNumberController.text,
                                        meterManufacturer:
                                            _meterManufacturerController.text,
                                        meterReading: parseOrZeroDouble(
                                            _meterReadingController.text),
                                        phasingCodeTypeId:
                                            selectedPhasingCodeId ?? 0,
                                        operatingVoltageId:
                                            selectedOperatingVoltage ?? 0,
                                        installDate: formatDate(
                                            _installDateController.text),
                                        connectionStatusId:
                                            selectedConnectionStatusId ?? 0,
                                        connectionTypeId:
                                            selectedConnectiontypeId ?? 0,
                                        sanctionedLoad: parseOrZeroDouble(
                                            _sanctionedLoadController.text),
                                        connectedLoad: parseOrZeroDouble(
                                            _connectedLoadController.text),
                                        businessTypeId:
                                            selectedBusinessType ?? 0,
                                        othersBusiness:
                                            _otherBusinessController.text,
                                        specialCode:
                                            _specialCodeController.text,
                                        specialType:
                                            _specialTypeController.text,
                                        locationId: selectedLocationId ?? 0,
                                        billGroup: _billGroupController.text,
                                        bookNumber: _bookNumberController.text,
                                        omfKwh: parseOrZeroDouble(
                                            _omfKwhController.text),
                                        serviceCableSize: parseOrZero(
                                            _serviceCableSizeController.text),
                                        serviceCableTypeId:
                                            selectedServiceCableId ?? 0,
                                        surveyDate: formatDate(dt.toString()),
                                        latitude: parseOrZeroDouble(
                                            _latitudeController.text),
                                        longitude: parseOrZeroDouble(
                                            _longitudeController.text),
                                        structureId: _structureController.text,
                                        structureMapNo:
                                            _structureMapNoController.text,
                                        structureTypeId:
                                            selectedStructureType ?? 0,
                                        startingDate: formatDate(dt.toString()),
                                        remarks: _remarks.text,
                                        activationStatusId: 2,
                                        verificationStateId: 2,
                                        distance_from_sp: 0,
                                      );

                                      await CallConsumerApi()
                                          .updateConsumer(consumer);

                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ConsumerListView(
                                            consumerNo:
                                                _consumerNoController.text,
                                            feederLineId: 0,
                                          ),
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Consumer Updated Successfully'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } catch (error) {
                                      // Handle Error
                                      //print(error);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Failed to update data: $error'),
                                          backgroundColor: Colors.red,
                                          duration: const Duration(seconds: 20),
                                        ),
                                      );
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue),
                                  ),
                                  child: const Text('Save Update',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ////////////////////////////////////////Theme_8//////////////////////////////////
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Card(
                              color: const Color.fromARGB(255, 5, 161, 182),
                              margin: const EdgeInsets.only(
                                right: 10,
                                bottom: 10,
                              ),
                              child: TextButton(
                                child: const Text(
                                  'Close',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

Widget _buildTextField(
    BuildContext context, TextEditingController controller, String label) {
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
