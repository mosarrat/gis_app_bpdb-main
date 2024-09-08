import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../api/api.dart';
import '../../models/regions/feeder_line.dart';
import '../../models/regions/snd_info.dart';
import '../../models/regions/substation.dart';
import '../../models/regions/zone.dart';
import '../../models/regions/circle.dart';

class MapFilter extends StatefulWidget {
  const MapFilter({super.key, required this.isVisible, required this.onClose});

  final bool isVisible;
  final VoidCallback onClose;

  @override
  State<MapFilter> createState() => _MapFilterState();
}

class _MapFilterState extends State<MapFilter> {
    late Future<List<Zone>> zones;
  late Future<List<Circle>> circles;
  late Future<List<SndInfo>> snds;
  late Future<List<Substation>> substations;
  late Future<List<FeederLine>> feederLines;

  int? selectedZoneId;
  int? selectedCircleId;
  int? selectedSnDId;
  int? selectedSubstationId;
  int? selectedFeederLineId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    zones = CallApi().fetchZoneInfo();
    circles = Future.value([]);
    snds = Future.value([]);
    substations = Future.value([]);
    feederLines = Future.value([]);
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
    selectedSubstationId = null;
    selectedFeederLineId = null;
    substations = CallApi().fetchSubstationInfo(value!).whenComplete(() {
      setLoading(false);
    });
    feederLines = Future.value([]);
  }

  void onSubstationChanged(int? value) {
    setLoading(true);
    selectedSubstationId = value;
    selectedFeederLineId = null;
    feederLines = CallApi().fetchFeederLineInfo(value!).whenComplete(() {
      setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: Container(
        //width: 200,
        height: MediaQuery.of(context).size.height * 0.3, 
        color: Colors.white,
        child: Column(
          children: [
            Card(
              color: const Color.fromARGB(255, 5, 161, 182),
              margin: EdgeInsetsDirectional.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 40,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Filter Map",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Container()), 
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    iconSize: 16,
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                interactive: true,
                radius: Radius.elliptical(8.0, 2.0),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                          FutureBuilder<List<Zone>>(
                          future: zones,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.6, 
                                child: DropdownButtonFormField<int>(
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Zone',
                                    labelStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                                  ),
                                  value: null,
                                  hint: const Text('No Zones available!', style: TextStyle(fontSize: 12, color: Colors.red,),),
                                  items: [],
                                  onChanged: null,
                                ),
                              );
                            } else if (snapshot.hasData) {
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.6, 
                                height: 42,
                                child: DropdownButtonFormField<int>(
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Zone',
                                    labelStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                                  ),
                                  value: selectedZoneId,
                                  hint: const Text('Select a Zone', style: TextStyle(fontSize: 12),),
                                  items: snapshot.data!.map((zone) {
                                    return DropdownMenuItem<int>(
                                      value: zone.zoneId,
                                      child: Text('${zone.zoneId}: ${zone.zoneName}', style: TextStyle(fontSize: 12),),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedZoneId = value;
                                      onZoneChanged(value);
                                    });
                                  },
                                ),
                              );
                            } else {
                              return const Text('No Zones available!', style: TextStyle(fontSize: 12, color: Colors.red,),);
                            }
                          },
                        ),
                        const SizedBox(height: 5.0),
                        FutureBuilder<List<Circle>>(
                        future: circles,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.6, 
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Circle',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                                ),
                                value: null,
                                hint: const Text('No Circles available!', style: TextStyle(fontSize: 12, color: Colors.red,),),
                                items: [],
                                onChanged: null,
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.6, 
                              height: 42,
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Circles',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                                ),
                                value: selectedCircleId,
                                hint: const Text('Select a Circle', style: TextStyle(fontSize: 12),),
                                items: snapshot.data!.map((circle) {
                                  return DropdownMenuItem<int>(
                                    value: circle.circleId,
                                    child: Text('${circle.circleId}: ${circle.circleName}', style: TextStyle(fontSize: 12),),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCircleId = value;
                                    onCircleChanged(value);
                                  });
                                },
                              ),
                            );
                          } else {
                            return const Text('No SnDs available!', style: TextStyle(fontSize: 12, color: Colors.red,),);
                          }
                        },
                      ),
                      const SizedBox(height: 5.0),
                        FutureBuilder<List<SndInfo>>(
                        future: snds,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.8, 
                              height: 42,
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'SnD',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                value: null,
                                hint: const Text('No SnDs available!', style: TextStyle(fontSize: 12, color: Colors.red,),),
                                items: [],
                                onChanged: null,
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.6, 
                              height: 42,
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'SnD',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                                ),
                                value: selectedSnDId,
                                hint: const Text('Select a SnD', style: TextStyle(fontSize: 12),),
                                items: snapshot.data!.map((snd) {
                                  return DropdownMenuItem<int>(
                                    value: snd.sndId,
                                    child: Text('${snd.sndCode}: ${snd.sndName}', style: TextStyle(fontSize: 12),),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedSnDId = value;
                                    onSnDChanged(value);
                                  });
                                },
                              ),
                            );
                          } else {
                            return const Text('No SnDs available!', style: TextStyle(fontSize: 12, color: Colors.red,),);
                          }
                        },
                      ),
                      const SizedBox(height: 5.0),
                      FutureBuilder<List<Substation>>(
                        future: substations,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 42,
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Substation',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                                ),
                                value: null,
                                hint: const Text('No Substations available!', style: TextStyle(fontSize: 12, color: Colors.red,),),
                                items: [],
                                onChanged: null,
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 42,
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Substation',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                                ),
                                value: selectedSubstationId,
                                hint: const Text('Select a Substation', style: TextStyle(fontSize: 12),),
                                items: snapshot.data!.map((substation) {
                                  return DropdownMenuItem<int>(
                                    value: substation.substationId,
                                    child: Text('${substation.substationCode}: ${substation.substationName}', style: TextStyle(fontSize: 12),),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedSubstationId = value;
                                    onSubstationChanged(value);
                                  });
                                },
                              ),
                            );
                          } else {
                            return const Text('No SnDs available!', style: TextStyle(fontSize: 12, color: Colors.red,),);
                          }
                        },
                      ),
                      const SizedBox(height: 5.0),
                      FutureBuilder<List<FeederLine>>(
                        future: feederLines,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 42,
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Feeder Line',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                                ),
                                value: null,
                                hint: const Text('No Feeder Lines available!', style: TextStyle(fontSize: 12, color: Colors.red,),),
                                items: [],
                                onChanged: null,
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 42,
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Feeder Line',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                                ),
                                value: selectedFeederLineId,
                                hint: const Text('Select a Feeder Line', style: TextStyle(fontSize: 12),),
                                items: snapshot.data!.map((feederline) {
                                  return DropdownMenuItem<int>(
                                    value: feederline.feederLineId,
                                    child: Text('${feederline.feederLineCode}: ${feederline.feederlineName}', style: TextStyle(fontSize: 12),),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedFeederLineId = value;
                                  });
                                },
                              ),
                            );
                          } else {
                            return const Text('No SnDs available!', style: TextStyle(fontSize: 12, color: Colors.red,),);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


