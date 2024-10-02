import 'package:flutter/material.dart';
import 'package:gis_app_bpdb/views/map/map_viewer.dart';
import 'package:intl/intl.dart';
import '../../api/region_api.dart';
import '../../constants/constant.dart';
import '../../models/region_delails_lookup/dt_info.dart';
import 'dt_details_info.dart';

class DTListView extends StatefulWidget {
  final int substation;
  final int feederLineId;

  const DTListView({
    super.key,
    required this.substation,
    required this.feederLineId,
  });

  @override
  State<DTListView> createState() => _DTListViewState();
}

class _DTListViewState extends State<DTListView> {
  final CallRegionApi apiCall = CallRegionApi();
  late Future<List<TransformerDetails>> _futureDT;

  @override
  void initState() {
    super.initState();
    _futureDT = _fetchDT();
  }

  void _loadData() {
    setState(() {
      _futureDT = apiCall.fetchDT(
        substation: widget.substation,
        feederLineId: widget.feederLineId,
      );
    });
  }

  Future<List<TransformerDetails>> _fetchDT() async {
    return CallRegionApi().fetchDT(
      substation: widget.substation,
      feederLineId: widget.feederLineId,
    );
  }

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
        title: const Text(
          'Distribution Transformer Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      ),
      body: FutureBuilder<List<TransformerDetails>>(
        future: _futureDT,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Distribution Transformer available!'));
          } else {
            List<TransformerDetails> dts = snapshot.data!;

            return ListView.builder(
              itemCount: dts.length,
              itemBuilder: (context, index) {
                TransformerDetails dtInfo = dts[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text("Distribution Transformer Id: ${dtInfo.id.toString()}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Distribution Transformer Code: ${dtInfo.distributionTransformerCode ?? 'N/A'}\n'
                      'Pole Detail Left Id: ${dtInfo.poleDetailsLeftId?.toString() ?? 'N/A'}\n'
                      'Pole Detail Right Id: ${dtInfo.poleDetailsRightId?.toString() ?? 'N/A'}',
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
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ShowDetailDialog(
                                      id: dtInfo.id,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                    },
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
