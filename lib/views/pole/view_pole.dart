import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../api/region_api.dart';
import '../../models/region_delails_lookup/pole_list.dart';
import 'create_poledetail.dart';
import 'pole_details.dart';

class ViewPoles extends StatefulWidget {
  final int sndId;

  const ViewPoles({
    super.key,
    required this.sndId, 
  });

  @override
  _ViewPolesState createState() => _ViewPolesState();
}

class _ViewPolesState extends State<ViewPoles> {
  final CallRegionApi api = CallRegionApi();
  late Future<List<PoleList>> _futurePoles;

  @override
  void initState() {
    super.initState();
    _futurePoles = _fetchPolesInfo();
  }

  Future<List<PoleList>> _fetchPolesInfo() async {
    return CallRegionApi().fetchPolesInfo(widget.sndId,);
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
        title: const Text('Pole Information',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      ),
      body: FutureBuilder<List<PoleList>>(
        future: _futurePoles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Pole available!'));
          } else {
            // Filter the list based on search query

            List<PoleList> poles = snapshot.data!;

            return ListView.builder(
              itemCount: poles.length,
              itemBuilder: (context, index) {
                PoleList poleInfo = poles[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text("Pole Id: ${poleInfo.poleId.toString()}" ,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Pole Type: ${poleInfo.poleTypeName}\r\nPole Condition: ${poleInfo.conditionName}\r\nPole Height: ${poleInfo.poleHeight ?? ''}',
                      style: const TextStyle(height: 1.5),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                        message: 'Add Pole Details',
                        child: Container(
                          height: 27,
                          width: 27,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            iconSize: 12,
                            icon: const Icon(
                              Icons.add_box_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddPoleDetails(
                                    zoneId: poleInfo.zoneId,
                                    circleId: poleInfo.circleId,
                                    sndId: poleInfo.sndId,
                                    esuId: poleInfo.esuId ?? 0,
                                    poleId: poleInfo.poleId,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 3),
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
                                      poleId: poleInfo.poleId,
                                    );
                                  },
                                );
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