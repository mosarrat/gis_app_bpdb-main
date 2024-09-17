import 'package:flutter/material.dart';
import 'package:gis_app_bpdb/views/map/map_viewer.dart';
import "package:carousel_slider/carousel_slider.dart";
import 'package:intl/intl.dart';
import '../../api/region_api.dart';
import '../../models/region_delails_lookup/dt_details.dart';
import '../../models/region_delails_lookup/poleDetailsId.dart';
import '../../models/region_delails_lookup/poleId.dart';
import '../../models/region_delails_lookup/pole_image.dart';
import '../../constants/constant.dart';
import '../map/dt_map_viewer.dart';

class ShowDetailDialog extends StatefulWidget {
  final int id;

  const ShowDetailDialog({
    super.key,
    required this.id,
  });

  @override
  State<ShowDetailDialog> createState() => _ShowDetailDialogState();
}

class _ShowDetailDialogState extends State<ShowDetailDialog> {
  late Future<List<Transformer>> _futureDTByDetailsId;
  late double latitude;
  late double longitude;
  late int DTId;
  late String dtCode;
  late String dtLocation;
  late String zone;
  late String circle;
  late String snd;
  late String substation;
  late String feederline;

  @override
  void initState() {
    super.initState();
    _futureDTByDetailsId = _fetchDTByDetailsId();
  }

  Future<List<Transformer>> _fetchDTByDetailsId() async {
    return CallApi().fetchDTByDetailsId(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3))),
      contentPadding: const EdgeInsets.all(0),
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      // title: const Text('FeederLine Details'),
      backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      title: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: const Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Distribution Transformer Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            //SizedBox(height: 10),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: Column(
                children: [
                  FutureBuilder<List<Transformer>>(
                    future: _futureDTByDetailsId,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData && snapshot.data != null) {
                        final dtDetails = snapshot.data!;
                        if (dtDetails.isNotEmpty) {
                          latitude = dtDetails.first.latitude;
                          longitude = dtDetails.first.longitude;
                          DTId = dtDetails.first.id;
                          dtCode = dtDetails.first.distributionTransformerCode!;
                          dtLocation = dtDetails.first.dtLocationName!;
                          zone = dtDetails.first.zoneName;
                          circle = dtDetails.first.circleName;
                          snd = dtDetails.first.snDName;
                          substation = dtDetails.first.substationName;
                          feederline = dtDetails.first.feederlineName;
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: dtDetails.map((transformer) {
                            return Card(
                              child: Padding(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Divider(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      color: const Color.fromARGB(
                                          255, 223, 240, 243),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Distribution Transformer Id: ${transformer.id.toString()}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      color: const Color.fromARGB(
                                          255, 241, 245, 245),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            'DT Code: ${transformer.distributionTransformerCode ?? ''}'),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      color: const Color.fromARGB(
                                          255, 223, 240, 243),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            'DT Location Name: ${transformer.dtLocationName ?? ''}'),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      color: const Color.fromARGB(255, 241, 245, 245),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Zone Name: ${transformer.zoneName}',
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      color: const Color.fromARGB(255, 223, 240, 243),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            'Circle Name: ${transformer.circleName}'),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      color: const Color.fromARGB(255, 241, 245, 245),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            'SnD Name : ${transformer.snDName ?? ''}'),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      color: const Color.fromARGB(
                                          255, 223, 240, 243),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Esu Name: ${transformer.esuName ?? ''}',
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      color: const Color.fromARGB(255, 241, 245, 245),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            'Substation Name: ${transformer.substationName}'),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      color: const Color.fromARGB(
                                          255, 223, 240, 243),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            'Feeder Line Name : ${transformer.feederlineName ?? ''}'),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      color: const Color.fromARGB(255, 241, 245, 245),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Pole Left Code: ${transformer.poleLeftCode}',
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      color: const Color.fromARGB(255, 223, 240, 243),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            'Pole Right Code: ${transformer.poleRightCode}'),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      color: const Color.fromARGB(255, 241, 245, 245),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            'Transformer Kva Rating : ${transformer.transformerKvaRating ?? 'N/A'}'),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      color: const Color.fromARGB(
                                          255, 223, 240, 243),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Contract No: ${transformer.contractNo ?? ''}',
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      color: const Color.fromARGB(255, 241, 245, 245),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            'Rated Ht Voltage: ${transformer.ratedHtVoltage ?? ''}'),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      color: const Color.fromARGB(
                                          255, 223, 240, 243),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            'Rated LT Voltage : ${transformer.ratedLtVoltage ?? ''}'),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      color: const Color.fromARGB(255, 241, 245, 245),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            'Rated LT Current: ${transformer.ratedLtCurrent ?? ''}'),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      color: const Color.fromARGB(
                                          255, 223, 240, 243),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            'Rated HT Current : ${transformer.ratedHtCurrent ?? ''}'),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Card(
                                            color: const Color.fromARGB(255, 5, 161, 182),
                                            margin: const EdgeInsets.only(right: 10, bottom: 10,),
                                            child: TextButton(
                                              child: const Text(
                                                'Open Map View',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => DTMapViewer(
                                                      title: 'Map View',
                                                      lat: latitude,
                                                      long: longitude,
                                                      defaultZoomLevel: 20,
                                                      properties:
                                                        '$DTId#$dtCode#$dtLocation#$zone#$circle#$snd#$substation#$feederline',
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Card(
                                            color: const Color.fromARGB(255, 5, 161, 182),
                                            margin: const EdgeInsets.only(right: 10, bottom: 10,),
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
                            );
                          }).toList(),
                        );
                      } else {
                        return const Text('No data found');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // actions: <Widget>[
      //   TextButton(
      //     child: const Text('Close'),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      // ],
    );
  }
}
