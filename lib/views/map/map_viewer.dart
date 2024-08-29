import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart';

class MapViewer extends StatefulWidget {
  
  const MapViewer({
    super.key,
    required this.title,
    this.lat,
    this.long,
    this.properties,
  });

  final String title;
  final double? lat;
  final double? long;
  final String? properties;

  @override
  State<MapViewer> createState() => _MapViewerState();
}

class _MapViewerState extends State<MapViewer> {
  late String testGeoJson;
  bool loadingData = false;

  // Instantiate parser, use the defaults
  GeoJsonParser geoJsonParser = GeoJsonParser(
    defaultMarkerColor: Colors.orange[900],
    defaultMarkerIcon: Icons.location_on,
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DefaultTabController(
          length: 2,
          child: AlertDialog(
            title: const Text('Consumer'),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
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
                                _buildDetailItem(
                                    'Consumer No.',
                                    mapData['Consumer']
                                        .toString()
                                        .split('#')[0]),
                                _buildDetailItem(
                                    'Consumer',
                                    mapData['Consumer']
                                        .toString()
                                        .split('#')[1]),
                                _buildDetailItem(
                                    'Meter No.',
                                    mapData['Consumer']
                                        .toString()
                                        .split('#')[2]),
                                _buildDetailItem(
                                    'Zone',
                                    mapData['Consumer']
                                        .toString()
                                        .split('#')[3]),
                                _buildDetailItem(
                                    'Circle',
                                    mapData['Consumer']
                                        .toString()
                                        .split('#')[4]),
                                _buildDetailItem(
                                    'SnD',
                                    mapData['Consumer']
                                        .toString()
                                        .split('#')[5]),
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
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
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
      print(testGeoJson);

      Future.delayed(const Duration(seconds: 3), () {
        processData().then((_) {
          print("GeoJSON parsed: ${geoJsonParser.markers.length} markers");

          setState(() {
            loadingData = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('GeoJson Processing time: ${stopwatch2.elapsed}'),
              duration: const Duration(milliseconds: 5000),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
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
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FlutterMap(
        mapController: MapController(),
        options: const MapOptions(
          initialCenter: LatLng(23.506657, 90.3443647),
          initialZoom: 7,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
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
}
