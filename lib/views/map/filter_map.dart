import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../api/api.dart';
import '../../models/regions/feeder_line.dart';
import '../../models/regions/snd_info.dart';
import '../../models/regions/substation.dart';
import '../../models/regions/zone.dart';
import '../../models/regions/circle.dart';
import 'arc_gis_map.dart';
import '../../constants/constant.dart';

import 'package:fluttertoast/fluttertoast.dart';

class MapFilter extends StatefulWidget {
  const MapFilter({
    super.key,
    required this.isVisible,
    required this.onClose,
    this.mapcode,
    this.zoneId,
    this.circleId,
    this.sndId,
    this.substationId,
    this.feederlineId,
    this.centerLatitude,
    this.centerLongitude,
    this.defaultZoomLevel,
    //int? substaionId,
  });

  final bool isVisible;
  final VoidCallback onClose;
  final int? mapcode;
  final int? zoneId;
  final int? circleId;
  final int? sndId;
  final int? substationId;
  final int? feederlineId;
  final double? centerLatitude;
  final double? centerLongitude;
  final double? defaultZoomLevel;

  @override
  State<MapFilter> createState() => _MapFilterState();
}

class _MapFilterState extends State<MapFilter> {
  late Future<List<Zone>> zones;
  late Future<List<Zone>> zonedetail;
  late Future<List<Circles>> circles = Future.value([]);
  late Future<List<SndInfo>> snds = Future.value([]);
  late Future<List<Substation>> substations = Future.value([]);
  late Future<List<FeederLine>> feederLines = Future.value([]);

  int? selectedZoneId;
  int? selectedCircleId;
  int? selectedSnDId;
  int? selectedSubstationId;
  int? selectedFeederLineId;
  bool isLoading = false;
  String? mapUrl;
  int? zoneId;

  @override
  void initState() {
    super.initState();
    zones = CallApi().fetchZoneInfo();
    // Initialize other futures based on the widget properties
    if (widget.zoneId != null && widget.zoneId != 0) {
      selectedZoneId = widget.zoneId;
      circles = CallApi().fetchCircleInfo(widget.zoneId!);
    }

    if (widget.circleId != null && widget.circleId != 0) {
      selectedCircleId = widget.circleId;
      snds = CallApi().fetchSnDInfo(widget.circleId!);
    }

    if (widget.sndId != null && widget.sndId != 0) {
      selectedSnDId = widget.sndId;
      substations = CallApi().fetchSubstationInfo(widget.sndId!);
    }

    if (widget.substationId != null && widget.substationId != 0) {
      selectedSubstationId = widget.substationId;
      feederLines = CallApi().fetchFeederLineInfo(widget.substationId!);
    }

    if (widget.feederlineId != null && widget.feederlineId != 0) {
      selectedFeederLineId = widget.feederlineId;
    }
  }

  void setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  void onZoneChanged(int? value) async {
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

    try {
      // Fetch and set zone details information
      await CallApi().fetchZoneDetailsInfo(value!);

      // Ensure global variables are updated before navigating
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArcGISMapViewer(
            title: 'Map Viewer',
            mapUrl:
                "https://www.arcgisbd.com/server/rest/services/bpdb/general/MapServer/15",
            mapcode: 15,
            zoneId: value,
            centerLatitude: GlobalVariables.centerLatitude ?? 0.0,
            centerLongitude: GlobalVariables.centerLongitude ?? 0.0,
            defaultZoomLevel: GlobalVariables.defaultZoomLevel ?? 0,
          ),
        ),
      );

      // Fluttertoast.showToast(
      //   msg: (GlobalVariables.defaultZoomLevel ?? 0).toString(),
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );
    } catch (e) {
      //print('Error: $e');
      Fluttertoast.showToast(
        msg: 'Failed to load Zone info',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setLoading(false);
    }
  }

  void onCircleChanged(int? value) async {
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

    try {
      // Fetch and set zone details information
      await CallApi().fetchCircleDetailsInfo(value!);

      // Ensure global variables are updated before navigating
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArcGISMapViewer(
            title: 'Map Viewer',
            mapUrl:
                "https://www.arcgisbd.com/server/rest/services/bpdb/general/MapServer/14",
            mapcode: 14,
            zoneId: selectedZoneId,
            circleId: selectedCircleId,
            centerLatitude: GlobalVariables.centerLatitude ?? 0.0,
            centerLongitude: GlobalVariables.centerLongitude ?? 0.0,
            defaultZoomLevel: GlobalVariables.defaultZoomLevel ?? 0,
          ),
        ),
      );
    } catch (e) {
      //print('Error: $e');
      Fluttertoast.showToast(
        msg: 'Failed to load Circle info',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> onSnDChanged(int? value) async {
    setLoading(true);
    selectedSnDId = value;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    substations = CallApi().fetchSubstationInfo(value!).whenComplete(() {
      setLoading(false);
    });
    feederLines = Future.value([]);
    try {
      // Fetch and set zone details information
      await CallApi().fetchSndDetailsInfo(value!);

      // Ensure global variables are updated before navigating
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArcGISMapViewer(
            title: 'Map Viewer',
            mapUrl:
                "https://www.arcgisbd.com/server/rest/services/bpdb/general/MapServer/13",
            mapcode: 13,
            zoneId: selectedZoneId,
            circleId: selectedCircleId,
            sndId: value,
            centerLatitude: GlobalVariables.centerLatitude ?? 0.0,
            centerLongitude: GlobalVariables.centerLongitude ?? 0.0,
            defaultZoomLevel: GlobalVariables.defaultZoomLevel ?? 0,
          ),
        ),
      );
    } catch (e) {
      //print('Error: $e');
      Fluttertoast.showToast(
        msg: 'Failed to load Snd info',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> onSubstationChanged(int? value) async {
    setLoading(true);
    selectedSubstationId = value;
    selectedFeederLineId = null;
    feederLines = CallApi().fetchFeederLineInfo(value!).whenComplete(() {
      setLoading(false);
    });

    try {
      // Fetch and set zone details information
      await CallApi().fetchSubstationDetailsInfo(value!);

      // Ensure global variables are updated before navigating
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArcGISMapViewer(
            title: 'Map Viewer',
            mapUrl:
                "https://www.arcgisbd.com/server/rest/services/bpdb/general/MapServer/10",
            mapcode: 10,
            zoneId: selectedZoneId,
            circleId: selectedCircleId,
            sndId: selectedSnDId,
            substationId: value,
            centerLatitude: GlobalVariables.centerLatitude ?? 0.0,
            centerLongitude: GlobalVariables.centerLongitude ?? 0.0,
            defaultZoomLevel: GlobalVariables.defaultZoomLevel ?? 0,
          ),
        ),
      );
    } catch (e) {
      //print('Error: $e');
      Fluttertoast.showToast(
        msg: 'Failed to load Snd info',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setLoading(false);
    }
  }

  void onFeederlineChange(int? value) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArcGISMapViewer(
          title: 'Map Viewer',
          mapUrl:
              "https://www.arcgisbd.com/server/rest/services/bpdb/general/MapServer/9",
          mapcode: 9,
          zoneId: selectedZoneId,
          circleId: selectedCircleId,
          sndId: selectedSnDId,
          substationId: selectedSubstationId,
          feederlineId: value,
          centerLatitude: widget.centerLatitude,
          centerLongitude: widget.centerLongitude,
          defaultZoomLevel: widget.defaultZoomLevel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    //print(width);
    double popupHeight;
    double topbarWidth;
    double topspaceWidth;
    double dropdownWidth;

    if (height < 1300 && height > 900) {
      //print("1");
      popupHeight = height * 0.3;
    } else if (height < 900 && height > 600) {
      //print("2");
      popupHeight = height * 0.3;
    } else if (height < 600 && height > 400) {
      //print("3");
      popupHeight = height * 0.48;
    } else if (height < 400 && height > 200) {
      //print("4");
      popupHeight = height * 0.5;
    } else {
      //print("5");
      popupHeight = height * 0.3;
    }

    if (width < 1300 && width > 900) {
      //print("1");
      topbarWidth = width * 0.1;
      topspaceWidth = width * 0.03;
      dropdownWidth = width * 0.6;
    } else if (width < 900 && width > 600) {
      //print("2");
      topbarWidth = width / 8;
      topspaceWidth = width / 14;
      dropdownWidth = width * 0.6;
    } else if (width < 600 && width > 400) {
      //print("3");
      topbarWidth = width * 0.26;
      topspaceWidth = width * 0.03;
      dropdownWidth = width * 0.6;
    } else if (width < 400 && width > 200) {
      //print("4");
      topbarWidth = width * 0.26;
      topspaceWidth = width * 0.03;
      dropdownWidth = width * 0.6;
    } else {
      //print("5");
      topbarWidth = width * 0.2;
      topspaceWidth = width * 0.002;
      dropdownWidth = width * 0.6;
    }
    return Visibility(
      visible: widget.isVisible,
      child: Container(
        //width: 200,
        height: popupHeight,
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
                    width: topbarWidth,
                    height: 40,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Filter Map",
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: topspaceWidth),
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            return Container(
                              width: dropdownWidth,
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Zone',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 4),
                                ),
                                value: null,
                                hint: const Text(
                                  'No Zones available!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                                items: [],
                                onChanged: null,
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return Container(
                              width: dropdownWidth,
                              height: 42,
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Zone',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 4),
                                ),
                                value: selectedZoneId,
                                hint: const Text(
                                  'Select a Zone',
                                  style: TextStyle(fontSize: 12),
                                ),
                                items: snapshot.data!.map((zone) {
                                  return DropdownMenuItem<int>(
                                    value: zone.zoneId,
                                    child: Text(
                                      '${zone.zoneId}: ${zone.zoneName}',
                                      style: TextStyle(fontSize: 12),
                                    ),
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
                            return const Text(
                              'No Zones available!',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 5.0),
                      FutureBuilder<List<Circles>>(
                        future: circles,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            return Container(
                              width: dropdownWidth,
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Circle',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 4),
                                ),
                                value: null,
                                hint: const Text(
                                  'No Circles available!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                                items: [],
                                onChanged: null,
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return Container(
                              width: dropdownWidth,
                              height: 42,
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Circles',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 4),
                                ),
                                value: selectedCircleId,
                                hint: const Text(
                                  'Select a Circle',
                                  style: TextStyle(fontSize: 12),
                                ),
                                items: snapshot.data!.map((circle) {
                                  return DropdownMenuItem<int>(
                                    value: circle.circleId,
                                    child: Text(
                                      '${circle.circleId}: ${circle.circleName}',
                                      style: TextStyle(fontSize: 12),
                                    ),
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
                            return const Text(
                              'No SnDs available!',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 5.0),
                      FutureBuilder<List<SndInfo>>(
                        future: snds,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            return Container(
                              width: dropdownWidth,
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
                                hint: const Text(
                                  'No SnDs available!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                                items: [],
                                onChanged: null,
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return Container(
                              width: dropdownWidth,
                              height: 42,
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'SnD',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 4),
                                ),
                                value: selectedSnDId,
                                hint: const Text(
                                  'Select a SnD',
                                  style: TextStyle(fontSize: 12),
                                ),
                                items: snapshot.data!.map((snd) {
                                  return DropdownMenuItem<int>(
                                    value: snd.sndId,
                                    child: Text(
                                      '${snd.sndCode}: ${snd.sndName}',
                                      style: TextStyle(fontSize: 12),
                                    ),
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
                            return const Text(
                              'No SnDs available!',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 5.0),
                      FutureBuilder<List<Substation>>(
                        future: substations,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            return Container(
                              width: dropdownWidth,
                              height: 42,
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Substation',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 4),
                                ),
                                value: null,
                                hint: const Text(
                                  'No Substations available!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                                items: [],
                                onChanged: null,
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return Container(
                              width: dropdownWidth,
                              height: 42,
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Substation',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 4),
                                ),
                                value: selectedSubstationId,
                                hint: const Text(
                                  'Select a Substation',
                                  style: TextStyle(fontSize: 12),
                                ),
                                items: snapshot.data!.map((substation) {
                                  return DropdownMenuItem<int>(
                                    value: substation.substationId,
                                    child: Text(
                                      '${substation.substationCode}: ${substation.substationName}',
                                      style: TextStyle(fontSize: 12),
                                    ),
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
                            return const Text(
                              'No SnDs available!',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 5.0),
                      // FutureBuilder<List<FeederLine>>(
                      //   future: feederLines,
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return const SizedBox.shrink();
                      //     }

                      //     if (snapshot.hasError) {
                      //       return Container(
                      //         width: MediaQuery.of(context).size.width * 0.6,
                      //         height: 42,
                      //         child: DropdownButtonFormField<int>(
                      //           isExpanded: true,
                      //           decoration: const InputDecoration(
                      //             labelText: 'Feeder Line',
                      //             labelStyle: TextStyle(
                      //               color: Colors.blue,
                      //             ),
                      //             contentPadding:
                      //                 EdgeInsets.symmetric(vertical: 4),
                      //           ),
                      //           value: null,
                      //           hint: const Text(
                      //             'No Feeder Lines available!',
                      //             style: TextStyle(
                      //               fontSize: 12,
                      //               color: Colors.red,
                      //             ),
                      //           ),
                      //           items: [],
                      //           onChanged: null,
                      //         ),
                      //       );
                      //     } else if (snapshot.hasData) {
                      //       return Container(
                      //         width: MediaQuery.of(context).size.width * 0.6,
                      //         height: 42,
                      //         child: DropdownButtonFormField<int>(
                      //           isExpanded: true,
                      //           decoration: const InputDecoration(
                      //             labelText: 'Feeder Line',
                      //             labelStyle: TextStyle(
                      //               color: Colors.blue,
                      //             ),
                      //             contentPadding:
                      //                 EdgeInsets.symmetric(vertical: 4),
                      //           ),
                      //           value: selectedFeederLineId,
                      //           hint: const Text(
                      //             'Select a Feeder Line',
                      //             style: TextStyle(fontSize: 12),
                      //           ),
                      //           items: snapshot.data!.map((feederline) {
                      //             return DropdownMenuItem<int>(
                      //               value: feederline.feederLineId,
                      //               child: Text(
                      //                 '${feederline.feederLineCode}: ${feederline.feederlineName}',
                      //                 style: TextStyle(fontSize: 12),
                      //               ),
                      //             );
                      //           }).toList(),
                      //           onChanged: (value) {
                      //             setState(() {
                      //               selectedFeederLineId = value;
                      //               onFeederlineChange(value);
                      //             });
                      //           },
                      //         ),
                      //       );
                      //     } else {
                      //       return const Text(
                      //         'No Feederline available!',
                      //         style: TextStyle(
                      //           fontSize: 12,
                      //           color: Colors.red,
                      //         ),
                      //       );
                      //     }
                      //   },
                      // ),
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
