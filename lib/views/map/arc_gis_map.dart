import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:latlong2/latlong.dart';

import 'filter_map.dart';
import 'map_legends.dart';

class ArcGISMapViewer extends StatefulWidget {
  const ArcGISMapViewer({
    super.key,
    required this.title,
  });

  final String title;

  @override
  _ArcGISMapViewer createState() => _ArcGISMapViewer();
}

class _ArcGISMapViewer extends State<ArcGISMapViewer> {
  // bool _showMapFilter = false;
  // bool _showMapLegends = false;

  // void _toggleMapFilter() {
  //   setState(() {
  //     _showMapFilter = !_showMapFilter;
  //   });
  // }

  // void _toggleMapLegends() {
  //   setState(() {
  //     _showMapLegends = !_showMapLegends;
  //   });
  // }
  bool _showMapFilter = false;
  bool _showMapLegends = false;

  void _toggleMapFilter() {
    setState(() {
      _showMapFilter = !_showMapFilter;
    });
  }

  void _toggleMapLegends() {
    setState(() {
      _showMapLegends = !_showMapLegends;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white, // change your color here
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Map Viewer',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // backgroundColor: const Color.fromARGB(255, 5, 161, 182),
            backgroundColor: Color.fromARGB(255, 3, 89, 100),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Flexible(
                child: FlutterMap(
                  options: const MapOptions(
                    center: LatLng(23.7817257, 90.3455213),
                    zoom: 7.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                      subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                    ),
                    FeatureLayer(
                      FeatureLayerOptions(
                        "https://www.arcgisbd.com/server/rest/services/bpdb/general/MapServer/10",
                        "polygon",
                        onTap: (dynamic attributes, LatLng location) {
                          print(attributes);
                        },
                        render: (dynamic attributes) {
                          return const PolygonOptions(
                              borderColor: Colors.red,
                              color: Colors.black45,
                              borderStrokeWidth: 2,
                              isFilled: false);
                        },
                      ),
                    ),
                    FeatureLayer(FeatureLayerOptions(
                      "https://www.arcgisbd.com/server/rest/services/bpdb/consumers/MapServer/2",
                      "polyline",
                      render: (dynamic attributes) {
                        return const PolygonLineOptions(
                            borderColor: Colors.red,
                            color: Colors.red,
                            borderStrokeWidth: 2);
                      },
                      onTap: (attributes, LatLng location) {
                        print(attributes);
                      },
                    )),
                    FeatureLayer(FeatureLayerOptions(
                      "https://www.arcgisbd.com/server/rest/services/bpdb/consumers/MapServer/3",
                      "point",
                      render: (dynamic attributes) {
                        return const PointOptions(
                          width: 30.0,
                          height: 30.0,
                          builder: Icon(Icons.pin_drop),
                        );
                      },
                      onTap: (attributes, LatLng location) {
                        print(attributes);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Consumer Location'),
                              content: Text(
                                  'Name: ${attributes['consumer_name']}\nConsumer No: ${attributes['consumer_no']}'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    )),
                  ],
                ),
              ),
              
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  color: Colors.white,
                  constraints: const BoxConstraints(
                    minWidth: 25,
                    minHeight: 25,
                    maxWidth: 25,
                    maxHeight: 25,
                  ),
                  margin: const EdgeInsets.all(8),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                    icon: const Icon(
                      Icons.table_rows_rounded,
                      color: Colors.blue,
                    ),
                    onPressed: _toggleMapFilter,
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  color: Colors.white,
                  constraints: const BoxConstraints(
                    minWidth: 25,
                    minHeight: 25,
                    maxWidth: 25,
                    maxHeight: 25,
                  ),
                  margin: const EdgeInsets.all(8),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 25,
                    icon: const Icon(
                      Icons.legend_toggle_rounded,
                      color: Colors.blue,
                    ),
                    onPressed: _toggleMapLegends,
                  ),
                ),
              ),
              Visibility(
                visible: _showMapFilter,
                child: Positioned(
                  top: 5, 
                  right: 5,
                  left: 200,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    color: Colors.white,
                    child: MapFilter(
                      isVisible: _showMapFilter,
                      onClose: _toggleMapFilter,
                    ), 
                  ),
                ),
              ),

              Visibility(
                visible: _showMapLegends,
                child: Positioned(
                  bottom: 5, 
                  right: 5,
                  left: 200,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    color: Colors.white,
                    child: MapLegends(
                      isVisible: _showMapLegends,
                      onClose: _toggleMapLegends,
                    ), 
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
