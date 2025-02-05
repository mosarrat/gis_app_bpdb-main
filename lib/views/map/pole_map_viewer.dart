import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart';

import '../../dashboard.dart';

class PoleMapViewer extends StatefulWidget {
  const PoleMapViewer({
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
  State<PoleMapViewer> createState() => _PoleMapViewerState();
}

class _PoleMapViewerState extends State<PoleMapViewer> {
  late String testGeoJson;
  bool loadingData = false;
  late double height;
  late double width;
  late double boxheight;
  // Instantiate parser, use the defaults
  GeoJsonParser geoJsonParser = GeoJsonParser(
    defaultMarkerColor: Colors.orange[900],
    //defaultMarkerIcon: Icons.add,
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
    //print(mapData);
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
                    "Pole",
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
            // backgroundColor: const Color.fromARGB(255, 5, 161, 182),
            backgroundColor: const Color.fromARGB(255, 3, 89, 100),
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
                        indicatorColor: const Color.fromARGB(255, 3, 89, 100),
                        labelColor:  const Color.fromARGB(255, 3, 89, 100),
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
                                    horizontal: 1.0, vertical: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    const Divider(
                                      height: 0,
                                    ),
                                    _buildDetailItem(
                                            'Pole Detail Id.',
                                            mapData['Pole']
                                                .toString()
                                                .split('#')[0], isAlternate: true),
                                    const Divider(
                                      height: 0,
                                    ),
                                    _buildDetailItem('Pole Code',
                                            mapData['Pole'].split('#')[1], isAlternate: false),
                                    const Divider(
                                      height: 0,
                                    ),
                                    _buildDetailItem('Zone Name.',
                                            mapData['Pole'].split('#')[2], isAlternate: true),
                                    const Divider(
                                      height: 0,
                                    ),
                                    _buildDetailItem('Circle Name',
                                            mapData['Pole'].split('#')[3], isAlternate: false),
                                    const Divider(
                                      height: 0,
                                    ),
                                    _buildDetailItem('SnD Name',
                                            mapData['Pole'].split('#')[4], isAlternate: true),
                                    const Divider(
                                      height: 0,
                                    ),
                                    _buildDetailItem(
                                            'Substation Name',
                                            mapData['Pole'].split('#')[5], isAlternate: false),
                                    const Divider(
                                      height: 0,
                                    ),
                                    _buildDetailItem(
                                            'Feeder Line Name',
                                            mapData['Pole'].split('#')[6], isAlternate: true),
                                    const Divider(
                                      height: 0,
                                    ),
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
                        //child: Card(
                          //color: const Color.fromARGB(255, 5, 161, 182),
                          child: TextButton(
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                  // color: Colors.white,
                                  color: const Color.fromARGB(255, 3, 89, 100),
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        //),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                    "Pole": "${widget.properties}"
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

    _generateGeoJson().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        processData().then((_) {
          setState(() {
            loadingData = false;
          });
        });
      });
    });
    geoJsonParser.markerCreationCallback = (LatLng latLng, Map<String, dynamic> properties) {
      return Marker(
        width: 40, 
        height: 40, 
        point: latLng,
        child: GestureDetector(
          onTap: () {
            _handleMarkerTap(properties);
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: const Color.fromARGB(255, 3, 89, 100),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center, 
            child: ClipOval( 
              child: Image.asset(
                'assets/icons/power-line.png',
                width: 28, 
                height: 28, 
                fit: BoxFit.cover, 
                color: Colors.white,
              ),
            ),
          ),
          // child: Image.asset(
          //   'assets/icons/power-line.png',
          //   width: 28, 
          //   height: 28, 
          //   fit: BoxFit.cover, 
          //   color: const Color.fromARGB(255, 3, 89, 100),
          // ),
        ),
      );
    };
    geoJsonParser.filterFunction = myFilterFunction;
  }

  void _handleMarkerTap(Map<String, dynamic> properties) {
    //print("Marker tapped: ${properties['DT']}");
    onTapMarkerFunction(context, properties);
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

  Widget _buildDetailItem(String label, String value, {bool isAlternate = false}) {
    return Container(
      width: double.infinity,
      height: 40,
      color: isAlternate
          ? const Color.fromARGB(255, 223, 240, 243)
          : const Color.fromARGB(255, 241, 245, 245),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 145,
              child: Text(
                '$label :',
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
