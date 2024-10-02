import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../../api/region_api.dart';
import '../../models/regions/zone.dart';
import '../../constants/app_colors.dart';

// import 'edit_feederline.dart';

class ViewZone extends StatefulWidget {
  const ViewZone({super.key});
  @override
  _ViewZoneState createState() => _ViewZoneState();
}

class _ViewZoneState extends State<ViewZone> {
  final CallRegionApi api = CallRegionApi();
  late Future<List<Zone>> _futureZones;
  bool isLoading = false;

  String _textValue = 'Initial Value';

  @override
  void initState() {
    super.initState();
    _futureZones = _fetchZones();
  }

  Future<List<Zone>> _fetchZones() async {
    return CallRegionApi().fetchZoneInfo();
  }

  void setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }
/////////////////////////////////////////////////////////////////////////
  // void showDetailDialog(Zone zoneInfo) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: const RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.all(Radius.circular(2))),
  //         shadowColor: const Color.fromARGB(255, 3, 89, 100),
  //         contentPadding: const EdgeInsets.all(16),
  //         insetPadding: const EdgeInsets.symmetric(horizontal: 16),
  //         title: Container(
  //           color:  const Color.fromARGB(255, 5, 161, 182),
  //           height: 55,
  //           child: const Padding(
  //             padding: EdgeInsets.all(10),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Text('Zone Details',
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         titlePadding: const EdgeInsets.all(0),
  //         content: SingleChildScrollView(
  //           scrollDirection: Axis.vertical,
  //           physics: const AlwaysScrollableScrollPhysics(),
  //           child: SizedBox(
  //             width: MediaQuery.of(context)
  //                 .size
  //                 .width,
  //             child: Card(
  //               shadowColor: const Color.fromARGB(255, 3, 89, 100),
  //               child:
  //                 Padding(
  //                   padding: const EdgeInsets.all(15),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Container(
  //                         width: MediaQuery.of(context).size.width,
  //                         height: 40,
  //                         color: const Color.fromARGB(255, 223, 240, 243),
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Text('Zone Id: ${zoneInfo.zoneId.toString()}',
  //                             style: const TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                                                       ),
  //                           ),
  //                       ),
  //                       const Divider(
  //                         height:0,
  //                       ),
  //                       Container(
  //                         width: MediaQuery.of(context).size.width,
  //                         height: 40,
  //                         color: const Color.fromARGB(255, 241, 245, 245),
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Text('Zone Name: ${zoneInfo.zoneName}'),
  //                           ),
  //                       ),
  //                       const Divider(
  //                         height:0,
  //                       ),
  //                       Container(
  //                         width: MediaQuery.of(context).size.width,
  //                         height: 40,
  //                         color: const Color.fromARGB(255, 223, 240, 243),
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Text('Zone Code: ${zoneInfo.zoneCode ?? 'N/A'}'),
  //                           ),
  //                       ),
  //                       const Divider(
  //                         height:0,
  //                       ),
  //                       // Text('Zone Id: ${zoneInfo.zoneId.toString()}',
  //                       //   style: const TextStyle(
  //                       //     fontWeight: FontWeight.bold,
  //                       //   ),
  //                       // ),
  //                       // const Divider(),
  //                       // Text('Zone Name.: ${zoneInfo.zoneName}'),
  //                       // const Divider(),
  //                       // Text('Zone Code: ${zoneInfo.zoneCode ?? 'N/A'}'),
  //                       // const Divider(),
  //                     ],
  //                   ),
  //                 ),
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           Card(
  //             color: const Color.fromARGB(255, 5, 161, 182),
  //             child: TextButton(
  //               onPressed: () => Navigator.of(context).pop(),
  //               child: const Text('Cancel',
  //               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

void showDetailDialog(Zone zoneInfo) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        contentPadding: const EdgeInsets.all(0),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        backgroundColor: const Color.fromARGB(255, 5, 161, 182),
        title: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Column(
            children: [
              Text(
                "Zone Information",
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
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                shadowColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2),
                    topRight: Radius.circular(2),
                  ),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(height: 0),
                      detailContainer(
                          label: 'Zone Id', value: zoneInfo.zoneId.toString(), isAlternate: true),
                      const Divider(height: 0),
                      detailContainer(
                          label: 'Zone Name', value: zoneInfo.zoneName, isAlternate: false),
                      const Divider(height: 0),
                      detailContainer(
                          label: 'Zone Code',
                          value: zoneInfo.zoneCode ?? 'N/A',
                          isAlternate: true),
                      const Divider(height: 0),
                      const SizedBox(height: 20),
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
            ],
          ),
        ),
      );
    },
  );
}

Widget detailContainer({required String label, required String value, bool isAlternate = false}) {
  return Container(
    width: double.infinity,
    height: 40,
    color: isAlternate
        ? const Color.fromARGB(255, 223, 240, 243)
        : const Color.fromARGB(255, 241, 245, 245),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        '$label: $value',
        // style: const TextStyle(
        //   fontWeight: FontWeight.bold,
        // ),
      ),
    ),
  );
}

//////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    double deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text('Zones Information',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      ),
      body: FutureBuilder<List<Zone>>(
        future: _futureZones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Zone available!'));
          } else {
            // Filter the list based on search query

            List<Zone> Zones = snapshot.data!;

            return ListView.builder(
              itemCount: Zones.length,
              itemBuilder: (context, index) {
                Zone zoneInfo = Zones[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text("Zone Id: ${zoneInfo.zoneId.toString()}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Zone Name: ${zoneInfo.zoneName}\r\nZone Code: ${zoneInfo.zoneCode}',
                      style: const TextStyle(height: 1.5),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: 'View Details',
                          child: Container(
                            height: 27,
                            width: 27,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              iconSize: 12,
                              icon: const Icon(
                                Icons.info,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showDetailDialog(zoneInfo);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
