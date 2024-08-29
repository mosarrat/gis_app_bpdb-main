import 'package:flutter/material.dart';
import 'package:gis_app_bpdb/views/map/map_viewer.dart';
import "package:carousel_slider/carousel_slider.dart";
import 'package:intl/intl.dart';
import '../../api/region_api.dart';
import '../../models/region_delails_lookup/poleDetailsId.dart';
import '../../models/region_delails_lookup/poleId.dart';
import '../../models/region_delails_lookup/pole_image.dart';
import '../../constants/constant.dart';

class ShowDetailDialog extends StatefulWidget {
  final int poleId;
  final int poleDetailsId;

  const ShowDetailDialog({
    super.key,
    required this.poleId,
    required this.poleDetailsId,
  });

  @override
  State<ShowDetailDialog> createState() => _ShowDetailDialogState();
}

class _ShowDetailDialogState extends State<ShowDetailDialog> {
  late Future<List<PoleDetails>> _futurePolesByDetailsId;
  late Future<List<PoleDetailByID>> _futurePolesById;
  late Future<List<PoleImage>> _futurePoleImg;

  @override
  void initState() {
    super.initState();
    _futurePolesByDetailsId = _fetchPolesByDetailsId();
    _futurePolesById = _fetchPolesById();
    _futurePoleImg = _fetchPoleImage();
  }

  Future<List<PoleDetails>> _fetchPolesByDetailsId() async {
    return CallApi().fetchPolesByDetailsId(widget.poleDetailsId);
  }

  Future<List<PoleDetailByID>> _fetchPolesById() async {
    return CallApi().fetchPolesById(widget.poleId);
  }

  Future<List<PoleImage>> _fetchPoleImage() async {
    return CallApi().fetchPoleImage(widget.poleId);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: const Text('Pole Details'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<PoleDetails>>(
              future: _futurePolesByDetailsId,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data != null) {
                  final poleDetails = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: poleDetails.map((poleDetail) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pole Detail Id: ${poleDetail.poleDetailsId.toString()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Text('Name: ${poleDetail.name}'),
                          const Divider(),
                          Text('Pole Code: ${poleDetail.poleCode}'),
                          const Divider(),
                          Text(
                              'Pole Unique Code: ${poleDetail.poleUniqueCode ?? 'N/A'}'),
                          const Divider(),
                          Text(
                              'Zone Info: ${poleDetail.zoneId} (${poleDetail.zoneName ?? ""})'),
                          const Divider(),
                          Text(
                              'Circle Info: ${poleDetail.circleId} (${poleDetail.circleName ?? ""})'),
                          const Divider(),
                          Text(
                              'SnD Info: ${poleDetail.sndId} (${poleDetail.snDName ?? ""})'),
                          const Divider(),
                          Text(
                              'Esu Info: ${poleDetail.esuId ?? ""} (${poleDetail.esuName ?? ""})'),
                          const Divider(),
                          Text(
                              'Substation Info: ${poleDetail.substationId} (${poleDetail.substationName ?? ""})'),
                          const Divider(),
                          Text(
                              'Feeder Line Info: ${poleDetail.feederLineId} (${poleDetail.feederlineName ?? ""})'),
                          const Divider(),
                          Text(
                              'Feeder Wise Serial No. : ${poleDetail.feederWiseSerialNo}'),
                          const Divider(),
                          Text('Pole No. : ${poleDetail.poleNo}'),
                          const Divider(),
                          Text(
                              'Previous Pole No. : ${poleDetail.previousPoleNo ?? 'N/A'}'),
                          const Divider(),
                          Text(
                              'Line Type Info: ${poleDetail.lineTypeId} (${poleDetail.lineTypeName ?? ""})'),
                          const Divider(),
                          Text('Type of Wire Id: ${poleDetail.typeOfWireId}'),
                          const Divider(),
                          Text('Wire Length: ${poleDetail.wireLength}'),
                          const Divider(),
                          Text(
                              'Wire Condition Id: ${poleDetail.wireConditionId}'),
                          const Divider(),
                          Text('Back Span: ${poleDetail.backSpan}'),
                          const Divider(),
                          Text('Phase A Id: ${poleDetail.phaseAId}'),
                          const Divider(),
                          Text('Phase B Id: ${poleDetail.phaseBId}'),
                          const Divider(),
                          Text('Phase C Id: ${poleDetail.phaseCId}'),
                          const Divider(),
                          Text('Neutral: ${poleDetail.neutral}'),
                          const Divider(),
                          Text('Is Right Pole: ${poleDetail.isRightPole}'),
                          const Divider(),
                        ],
                      );
                    }).toList(),
                  );
                } else {
                  return const Text('No data found');
                }
              },
            ),
            FutureBuilder<List<PoleDetailByID>>(
              future: _futurePolesById,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data != null) {
                  final poles = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: poles.map((pole) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pole Id: ${pole.poleId.toString()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Text(
                              'Pole Type: ${pole.poleTypeId} (${pole.poleTypeName ?? ""})'),
                          const Divider(),
                          Text(
                              'Pole condition: ${pole.poleConditionId} (${pole.conditionName ?? ""})'),
                          const Divider(),
                          Text('Surveyor Name: ${pole.surveyorName}'),
                          const Divider(),
                          Text('Survey Date: ${pole.surveyDate}'),
                          const Divider(),
                          Text('Latitude: ${pole.latitude}'),
                          const Divider(),
                          Text('Longitude: ${pole.longitude}'),
                          const Divider(),
                          Text('No of Whire Ht: ${pole.noOfWireHt}'),
                          const Divider(),
                          Text('No of Wire Lt: ${pole.noOfWireLt}'),
                          const Divider(),
                          Text('Msj No. : ${pole.msjNo}'),
                          const Divider(),
                          Text('Sleeve No. : ${pole.sleeveNo}'),
                          const Divider(),
                          Text('Twist No. : ${pole.twistNo}'),
                          const Divider(),
                          Text('Street Light: ${pole.streetLight}'),
                          const Divider(),
                          Text('Transformer Exist: ${pole.transformerExist}'),
                          const Divider(),
                          Text('Common Pole: ${pole.commonPole}'),
                          const Divider(),
                          Text('Tap: ${pole.tap}'),
                          const Divider(),
                          Text(
                              'pole Number: ${pole.poleNumber ?? "Not Given"}'),
                          const Divider(),
                          Text(
                              'Pole Height: ${pole.poleHeight ?? "Not Given"}'),
                          const Divider(),
                          Text(
                              'No of Line 11Kv: ${pole.noOfLine11Kv ?? "Not Given"}'),
                          const Divider(),
                          Text(
                              'No of Line P4Kv: ${pole.noOfLineP4Kv ?? "Not Given"}'),
                          const Divider(),
                          Text(
                              'No of Line 33Kv: ${pole.noOfLine33Kv ?? "Not Given"}'),
                          const Divider(),
                          const Text(
                            'Images: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      );
                    }).toList(),
                  );
                } else {
                  return const Text('No data found');
                }
              },
            ),

            //////////////////////////// Image Handeling /////////////////////////////
            FutureBuilder<List<PoleImage>>(
              future: _futurePoleImg,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data != null) {
                  final poles = snapshot.data!;

                  if (poles.isEmpty) {
                    return const Text('No images available');
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height / 2,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        scrollDirection: Axis.horizontal,
                      ),
                      items: poles.map((poleImg) {
                        // print('Image URL: $poleImgPath/${poleImg.pictureName}');
                        final imageUrl = '$poleImgPath/${poleImg.pictureName}';
                        return Builder(
                          builder: (BuildContext context) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return const Text('No data found');
                }
              },
            )
            ////////////////////////////Image Handeling/////////////////////////////
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
