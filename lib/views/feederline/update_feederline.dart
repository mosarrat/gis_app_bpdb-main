import 'package:flutter/material.dart';
import 'package:gis_app_bpdb/widgets/widgets/fieldset_legend.dart';
import 'package:intl/intl.dart';
import '../../api/api.dart';
import '../../api/feederline_api.dart';
import '../../models/feederlines_lookup/feederline.dart';
import '../../models/regions/feederline_conductor.dart';
import '../../models/regions/feederlinetype.dart';
import '../../models/regions/zone.dart';
import '../../models/regions/circle.dart';
import '../../models/regions/snd_info.dart';
import '../../models/regions/esu_info.dart';
import '../../models/regions/substation.dart';
import '../../models/regions/service_point.dart';

Future<void> showEditDialog(BuildContext context, CallApiService apiService,
    FeederLines item, VoidCallback onSuccess) async {
  showDialog(
    context: context,
    builder: (context) => EditDialog(
      apiService: apiService,
      item: item,
      onSuccess: onSuccess,
    ),
  );
}

class EditDialog extends StatefulWidget {
  final CallApiService apiService;
  final FeederLines item;
  final VoidCallback onSuccess;

  const EditDialog({
    Key? key,
    required this.apiService,
    required this.item,
    required this.onSuccess,
  }) : super(key: key);

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late Future<List<Zone>> zones;
  late Future<List<Circle>> circles;
  late Future<List<SndInfo>> snds;
  late Future<List<EsuInfo>> esu;
  late Future<List<Substation>> substations;
  late Future<List<ServicePoint>> servicePoints;
  late Future<List<FeederLineType>> feederlinetype;
  late Future<List<FeederConductorType>> feederlineConductor;
  late bool isGridSelected;
  late bool isBluckConsumerSelected;

  int? selectedZoneId;
  int? selectedCircleId;
  int? selectedSnDId;
  int? selectedEsuId;
  int? selectedSubstationId;
  int? selectedFeederLineId;
  int? selectedFeederlineTypeId;
  int? selectedFeederLineConductorId;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    zones = CallApi().fetchZoneInfo();
    circles = CallApi().fetchCircleInfo(widget.item.zoneId);
    snds = CallApi().fetchSnDInfo(widget.item.circleId);
    esu = CallApiService().fetchEsuInfo(widget.item.sndId);
    substations = CallApi().fetchSubstationInfo(widget.item.sndId);
    feederlinetype = CallApiService().fetchFeederLineTypeInfo();
    feederlineConductor = CallApiService().fetchFeederlineConductor();

    // Initialize selected values
    selectedZoneId = widget.item.zoneId;
    selectedCircleId = widget.item.circleId;
    selectedSnDId = widget.item.sndId;
    selectedEsuId = widget.item.esuId;
    selectedSubstationId = widget.item.sourceSubstationId;
    selectedFeederLineId = widget.item.feederLineId;
    selectedFeederlineTypeId = widget.item.feederLineTypeId;
    selectedFeederLineConductorId = widget.item.feederConductorTypeId;
    isGridSelected = widget.item.isGrid;
    isBluckConsumerSelected = widget.item.isBulkCustomer;
  }

  void setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  void onFeederlineType(int? value) {
    setLoading(true);
    selectedFeederlineTypeId = value;
  }

  void onFeederlineConductor(int? value) {
    setLoading(true);
    selectedFeederLineConductorId = value;
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
    esu = CallApiService().fetchEsuInfo(value!).whenComplete(() {
      setLoading(false);
    });
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
  }


  void itemSwitchGrid(bool value) {
    setState(() {
      isGridSelected = value;
    });
  }

  void itemSwitchBlukConsumer(bool value) {
    setState(() {
      isBluckConsumerSelected = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _feederlineId =
        TextEditingController(text: widget.item.feederLineId.toString());
    TextEditingController _feederLineCode =
        TextEditingController(text: widget.item.feederLineCode);
    TextEditingController _feederlineName =
        TextEditingController(text: widget.item.feederlineName);
    TextEditingController _feederLineToGrid =
        TextEditingController(text: widget.item.feederLineToGrid);
    TextEditingController _feederLineUId =
        TextEditingController(text: widget.item.feederLineUId);
    TextEditingController _feederLocation =
        TextEditingController(text: widget.item.feederLocation);
    TextEditingController _feederLength =
        TextEditingController(text: widget.item.feederLength.toString());
    // var isGridSelected = widget.item.isGrid;
    // var isBluckConsumerSelected = widget.item.isBulkCustomer;
    TextEditingController _feederMeterNumber =
        TextEditingController(text: widget.item.feederMeterNumber);
    TextEditingController _maximumDemand =
        TextEditingController(text: widget.item.maximumDemand);
    TextEditingController _peakDemand =
        TextEditingController(text: widget.item.peakDemand);
    TextEditingController _sanctionedLoad =
        TextEditingController(text: widget.item.sanctionedLoad);
    TextEditingController _connectionTypeController = TextEditingController();
    TextEditingController _nominalVoltage =
        TextEditingController(text: widget.item.nominalVoltage.toString());
    TextEditingController _meterCurrentRating =
        TextEditingController(text: widget.item.meterCurrentRating);
    TextEditingController _bulkCustomerName =
        TextEditingController(text: widget.item.bulkCustomerName);
    TextEditingController _meterVoltageRating =
        TextEditingController(text: widget.item.meterVoltageRating);
    TextEditingController _remarks =
        TextEditingController(text: widget.item.remarks);
    var dt = DateTime.now(); // Date-Time
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: const Text('FeederLine Update Information', 
        style: TextStyle(fontSize: 23),
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
              FieldsetLegend(
                legendText: 'Administrative Location',
                children: [
                  FutureBuilder<List<Zone>>(
                    future: zones,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        return DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Zone',
                            labelStyle: TextStyle(color: Colors.blue),
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
                  /////-----Circle
                  FutureBuilder<List<Circle>>(
                    future: circles,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        return DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Circle',
                            labelStyle: TextStyle(color: Colors.blue),
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
                            selectedCircleId = value;
                            onCircleChanged(value);
                          },
                        );
                      } else {
                        return const Text('No circles available');
                      }
                    },
                  ),
                  /////-----Snd
                  FutureBuilder<List<SndInfo>>(
                    future: snds,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        return DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Snd',
                            labelStyle: TextStyle(color: Colors.blue),
                          ),
                          value: selectedSnDId,
                          hint: const Text('Select a Snd'),
                          items: snapshot.data!.map((snd) {
                            return DropdownMenuItem<int>(
                              value: snd.sndId,
                              child: Text('${snd.sndCode}: ${snd.sndName}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedSnDId = value;
                            onSnDChanged(value);
                          },
                        );
                      } else {
                        return const Text('No SnD value available');
                      }
                    },
                  ),
                  /////-----Esu
                  FutureBuilder<List<EsuInfo>>(
                    future: esu,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        return DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Esu',
                            labelStyle: TextStyle(color: Colors.blue),
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
                            selectedEsuId = value;
                          },
                        );
                      } else {
                        return const Text('No Esu value available');
                      }
                    },
                  ),
                  /////-----substation
                  FutureBuilder<List<Substation>>(
                    future: substations,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        return DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Substations',
                            labelStyle: TextStyle(color: Colors.blue),
                          ),
                          value: selectedSubstationId,
                          hint: const Text('Select a substations'),
                          items: snapshot.data!.map((substation) {
                            return DropdownMenuItem<int>(
                              value: substation.substationId,
                              child: Text(
                                  '${substation.substationCode}: ${substation.substationName}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedSubstationId = value;
                          },
                        );
                      } else {
                        return const Text('No Substation value available');
                      }
                    },
                  ),
                ],
              ),
              FieldsetLegend(
                legendText: 'Feeder Line Information',
                children: [
                  _buildTextField(_feederlineId, 'Feeder Line Id'),
                  _buildTextField(_feederLineCode, 'Feeder Line Code'),
                  _buildTextField(_feederlineName, 'Feeder Line Name'),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'IsGrid',
                              style: TextStyle(fontSize: 16),
                            ),
                            Switch(
                              value: isGridSelected,
                              onChanged: itemSwitchGrid,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  _buildTextField(_feederLineToGrid, 'Feeder Line To Grid'),
                  _buildTextField(_feederLineUId, 'Feeder Line UId'),
                  FutureBuilder<List<FeederLineType>>(
                    future: feederlinetype,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        return DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            // labelText: 'Feeder Line Type',
                            labelStyle: const TextStyle(
                              color: Colors.blue,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          value: selectedFeederlineTypeId,
                          hint: const Text('Select a Feeder Line Type'),
                          items: snapshot.data!.map((feederlinetype) {
                            return DropdownMenuItem<int>(
                              value: feederlinetype.feederLineTypeId,
                              child: Text(
                                  '${feederlinetype.feederLineTypeId}: ${feederlinetype.feederLineTypeName}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedFeederlineTypeId = value;
                            });
                          },
                        );
                      } else {
                        return const Text('No Feeder Line Type available');
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  FutureBuilder<List<FeederConductorType>>(
                    future: feederlineConductor,
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
                            // labelText: 'Feeder Line Type',
                            labelStyle: const TextStyle(
                              color: Colors.blue,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          value: selectedFeederLineConductorId,
                          hint:
                              const Text('Select a FeederLine Conductor Type'),
                          items: snapshot.data!.map((feederlineConductor) {
                            return DropdownMenuItem<int>(
                              value: feederlineConductor.feederConductorTypeId,
                              child: Text(
                                '${feederlineConductor.feederConductorTypeId}: ${feederlineConductor.feederConductorTypeName}',
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedFeederLineConductorId = value;
                            });
                          },
                        );
                      } else {
                        return const Text('No Feeder Line Type available');
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(_feederLocation, 'Feeder Line Location'),
                  _buildTextField(_feederLength, 'Feeder Line Length'),
                ],
              ),
              FieldsetLegend(
                legendText: 'Meter Information',
                children: [
                  _buildTextField(_feederMeterNumber, 'Feeder Meter No'),
                  _buildTextField(_nominalVoltage, 'Nominal Voltage'),
                  _buildTextField(_meterCurrentRating, 'Meter Current Rating'),
                  _buildTextField(_meterVoltageRating, 'Meter Voltage Rating'),
                  _buildTextField(_maximumDemand, 'Maximum Demand'),
                  _buildTextField(_peakDemand, 'Peak Demand'),
                  _buildTextField(_sanctionedLoad, 'Sanctioned Load'),
                  _buildTextField(
                      _connectionTypeController, 'Connection Type Controller'),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Is BulkCustomer',
                              style: TextStyle(fontSize: 16),
                            ),
                            Switch(
                              value: isBluckConsumerSelected,
                              onChanged: itemSwitchBlukConsumer,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  _buildTextField(_bulkCustomerName, 'Bulk Customer Name'),
                ],
              ),
              FieldsetLegend(
                legendText: 'Remarks',
                children: [
                  _buildTextField(_remarks, 'remarks'),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () async {
                    // Add your save functionality here
                      try{
                        await CallApiService().updateFeederLine(FeederLines(
                        feederLineId: int.parse(_feederlineId.text),
                        feederlineName: _feederlineName.text,
                        zoneId: selectedZoneId ?? 0,
                        circleId: selectedCircleId ?? 0,
                        sndId: selectedSnDId ?? 0,
                        esuId: selectedEsuId,
                        sourceSubstationId: selectedSubstationId ?? 0,
                        destinationSubstationId: 2,
                        feederLineCode: _feederLineCode.text,
                        isGrid: isGridSelected,
                        gridSubstationInputId: 0,
                        feederLineUId: _feederLineUId.text,
                        feederLineTypeId: selectedFeederlineTypeId ?? 0,
                        feederConductorTypeId: selectedFeederLineConductorId ?? 0,
                        nominalVoltage:
                            double.tryParse(_nominalVoltage.text) ?? 0,
                        feederLocation: _feederLocation.text,
                        feederMeterNumber: _feederMeterNumber.text,
                        meterCurrentRating:
                            int.tryParse(_meterCurrentRating.text),
                        meterVoltageRating:
                            double.tryParse(_meterVoltageRating.text),
                        maximumDemand: double.tryParse(_maximumDemand.text),
                        peakDemand: double.tryParse(_peakDemand.text),
                        maximumLoad: double.tryParse(_maximumDemand.text),
                        sanctionedLoad: double.tryParse(_sanctionedLoad.text),
                        isBulkCustomer: isBluckConsumerSelected,
                        bulkCustomerName: _bulkCustomerName.text,
                        isPgcbGrid: false,
                        startingDate:
                            DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dt),
                        activationStatusId: 2,
                        verificationStateId: 2,
                        isPermittedToVerify: false,
                        isPermittedToApprove: false,
                        isEditAvailable: false,
                        feederLength: int.tryParse(_feederLength.text) ?? 0,
                        remarks: _remarks.text,
                      ));
                      Navigator.of(context).pop();
                      widget.onSuccess();
                    }catch (error){
                        print("Error updating Data: $error");
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.blue),
                  ),
                  child:
                      const Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
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
