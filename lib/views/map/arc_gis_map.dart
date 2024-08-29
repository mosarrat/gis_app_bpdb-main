import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:latlong2/latlong.dart';

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
            color: Colors.white, //change your color here
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
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
          backgroundColor: const Color.fromARGB(255, 5, 161, 182),
        ),
      ),
        //AppBar(title: Text('Map Viewer')),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Flexible(
                child: FlutterMap(
                  options: MapOptions(
                    // center: LatLng(39.7644863,-105.0199111), // line
                    center: LatLng(23.7817257, 90.3455213),
                    zoom: 7.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                      subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                    ),
                    FeatureLayer(
                      FeatureLayerOptions(
                        "https://www.arcgisbd.com/server/rest/services/bpdb/general/MapServer/10",
                        "polygon",
                        onTap: (dynamic attributes, LatLng location) {
                          print(attributes);
                        },
                        render: (dynamic attributes) {
                          return PolygonOptions(
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
                        // You can render by attribute
                        return PolygonLineOptions(
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
                        // You can render by attribute
                        return PointOptions(
                          width: 30.0,
                          height: 30.0,
                          builder: const Icon(Icons.pin_drop),
                        );
                      },
                      onTap: (attributes, LatLng location) {
                        print(attributes);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Consumer Location'),
                              content: Text(
                                  'Name: ${attributes['consumer_name']}\nConsumer No: ${attributes['consumer_no']}'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
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
            ],
          ),
        ),
      ),
    );
  }
}
