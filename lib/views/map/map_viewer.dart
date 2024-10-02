import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart';

import '../../dashboard.dart';

class MapViewer extends StatefulWidget {
  const MapViewer({
    super.key,
    required this.title,
    this.lat,
    this.long,
    this.properties,
    this.defaultZoomLevel,
  });

  final String title;
  final double? lat;
  final double? long;
  final String? properties;
  final double? defaultZoomLevel;

  @override
  State<MapViewer> createState() => _MapViewerState();
}

class _MapViewerState extends State<MapViewer> {
  late String testGeoJson;
  bool loadingData = false;
  late double height;
  late double width;
  late double boxheight;

  // Instantiate parser, use the defaults
  GeoJsonParser geoJsonParser = GeoJsonParser(
    defaultMarkerColor: Colors.orange[900],
    defaultMarkerIcon: Icons.home,
    defaultPolygonBorderColor: Colors.red,
    defaultPolygonFillColor: Colors.red.withOpacity(0.1),
    defaultCircleMarkerColor: Colors.red.withOpacity(0.25),
  );

  bool myFilterFunction(Map<String, dynamic> properties) {
    if (properties['section'].toString().contains('Point M-4')) {
      return false;
    } else {
      return true;
    }
  }

  void onTapMarkerFunction(BuildContext context, Map<String, dynamic> mapData) {
    if (width < 400 && width > 200) {
      boxheight = 60;
    } else {
      boxheight = 50;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DefaultTabController(
          length: 2,
          child: AlertDialog(
            title: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Consumer",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(3))),
            contentPadding: const EdgeInsets.all(0),
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            backgroundColor: const Color.fromARGB(255, 5, 161, 182),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Card(
                shadowColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                )),
                color: Colors.white,
                margin: const EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(text: 'Details'),
                          Tab(text: 'Attachments'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    const Divider(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: boxheight,
                                      color: const Color.fromARGB(
                                          255, 223, 240, 243),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: _buildDetailItem(
                                            'Consumer No.',
                                            mapData['Consumer']
                                                .toString()
                                                .split('#')[0]),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: boxheight,
                                      color: const Color.fromARGB(
                                          255, 241, 245, 245),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: _buildDetailItem(
                                            'Consumer',
                                            mapData['Consumer']
                                                .toString()
                                                .split('#')[1]),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: boxheight,
                                      color: const Color.fromARGB(
                                          255, 223, 240, 243),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: _buildDetailItem(
                                            'Meter No.',
                                            mapData['Consumer']
                                                .toString()
                                                .split('#')[2]),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: boxheight,
                                      color: const Color.fromARGB(
                                          255, 241, 245, 245),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: _buildDetailItem(
                                            'Zone',
                                            mapData['Consumer']
                                                .toString()
                                                .split('#')[3]),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: boxheight,
                                      color: const Color.fromARGB(
                                          255, 223, 240, 243),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: _buildDetailItem(
                                            'Circle',
                                            mapData['Consumer']
                                                .toString()
                                                .split('#')[4]),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: boxheight,
                                      color: const Color.fromARGB(
                                          255, 241, 245, 245),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: _buildDetailItem(
                                            'SnD',
                                            mapData['Consumer']
                                                .toString()
                                                .split('#')[5]),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                    // _buildDetailItem(
                                    //     'Consumer No.',
                                    //     mapData['Consumer']
                                    //         .toString()
                                    //         .split('#')[0]),
                                    // _buildDetailItem(
                                    //     'Consumer',
                                    //     mapData['Consumer']
                                    //         .toString()
                                    //         .split('#')[1]),
                                    // _buildDetailItem(
                                    //     'Meter No.',
                                    //     mapData['Consumer']
                                    //         .toString()
                                    //         .split('#')[2]),
                                    // _buildDetailItem(
                                    //     'Zone',
                                    //     mapData['Consumer']
                                    //         .toString()
                                    //         .split('#')[3]),
                                    // _buildDetailItem(
                                    //     'Circle',
                                    //     mapData['Consumer']
                                    //         .toString()
                                    //         .split('#')[4]),
                                    // _buildDetailItem(
                                    //     'SnD',
                                    //     mapData['Consumer']
                                    //         .toString()
                                    //         .split('#')[5]),
                                  ],
                                ),
                              ),
                            ),
                            const SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Card(
                          color: const Color.fromARGB(255, 5, 161, 182),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // actions: <Widget>[
            //   TextButton(
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //     child: const Text('Close'),
            //   ),
            // ],
          ),
        );
      },
    );
  }

  Future<void> _generateGeoJson() async {
    testGeoJson = '''
    {
        "type": "FeatureCollection",
        "features": [
            {
                "type": "Feature",
                "geometry": {
                    "type": "Point",
                    "coordinates": [
                        ${widget.long},
                        ${widget.lat}
                    ]
                },
                "properties": {
                    "Consumer": "${widget.properties}"
                }
            }
        ]
    }
    ''';
  }

  Future<void> processData() async {
    geoJsonParser.parseGeoJsonAsString(testGeoJson);
  }

  @override
  void initState() {
    super.initState();

    loadingData = true;
    Stopwatch stopwatch2 = Stopwatch()..start();

    _generateGeoJson().then((_) {
      // print(testGeoJson);

      Future.delayed(const Duration(seconds: 3), () {
        processData().then((_) {
          //print("GeoJSON parsed: ${geoJsonParser.markers.length} markers");

          setState(() {
            loadingData = false;
          });

          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('GeoJson Processing time: ${stopwatch2.elapsed}'),
          //     duration: const Duration(milliseconds: 5000),
          //     behavior: SnackBarBehavior.floating,
          //     backgroundColor: Colors.green,
          //   ),
          // );
        });
      });
    });

    geoJsonParser
        .setDefaultMarkerTapCallback((Map<String, dynamic> properties) {
      onTapMarkerFunction(context, properties);
    });

    geoJsonParser.filterFunction = myFilterFunction;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    //print(width);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          // backgroundColor: const Color.fromARGB(255, 5, 161, 182),
          backgroundColor: const Color.fromARGB(255, 3, 89, 100),
        ),
      ),
      body: FlutterMap(
        mapController: MapController(),
        options: MapOptions(
          initialCenter: LatLng(widget.lat!, widget.long!),
          initialZoom: widget.defaultZoomLevel!,
        ),
        children: [
          TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c']),
          //userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          loadingData
              ? const Center(child: CircularProgressIndicator())
              : MarkerLayer(markers: geoJsonParser.markers),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {

    if (width < 400 && width > 200) {
      return Padding(
        padding: EdgeInsets.all(2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label :',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200,
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                ': $value',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      );
    }
    // return Padding(
    //   padding: const EdgeInsets.only(bottom: 12.0),
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       SizedBox(
    //         width: 150,
    //         child: Text(
    //           label,
    //           style: const TextStyle(
    //             fontWeight: FontWeight.bold,
    //             color: Colors.black87,
    //           ),
    //         ),
    //       ),
    //       const SizedBox(width: 10),
    //       Expanded(
    //         child: Text(
    //           ': $value',
    //           style: const TextStyle(
    //             fontSize: 16,
    //             color: Colors.black87,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
