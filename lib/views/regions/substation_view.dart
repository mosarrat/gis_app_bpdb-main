import 'package:flutter/material.dart';
import '../../api/region_api.dart';
import '../../models/region_delails_lookup/substation.dart';
import '../../models/region_delails_lookup/substation.dart';
import '../../widgets/widgets/fieldset_legend.dart';

// import 'edit_feederline.dart';

class ViewSubstation extends StatefulWidget {
  const ViewSubstation({super.key});
  @override
  _ViewSubstationState createState() => _ViewSubstationState();
}

class _ViewSubstationState extends State<ViewSubstation> {
  final CallApi api = CallApi();
  late Future<List<Substation>> _futureSubstations;
  bool isLoading = false;

  String _textValue = 'Initial Value';

  @override
  void initState() {
    super.initState();
    _futureSubstations = _fetchSubstations();
  }

  Future<List<Substation>> _fetchSubstations() async {
    return CallApi().fetchSubstationInfo();
  }

  void setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }
/////////////////////////////////////////////////////////////////////////
  void showDetailDialog(Substation substationInfo)  {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3))),
          contentPadding: const EdgeInsets.all(0),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: const Color.fromARGB(255, 5, 161, 182),
          title: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Substation Information",
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
                  // width: MediaQuery.of(context).size.width,
                  shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2),)),
                  //color: const Color.fromARGB(255, 206, 242, 248),
                  color: Colors.white,
                  margin: const EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 223, 240, 243),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Substation Id: ${substationInfo.substationId.toString()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 241, 245, 245),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Substation Name.: ${substationInfo.substationName}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 223, 240, 243),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Substation Code: ${substationInfo.substationCode ?? 'N/A'}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 241, 245, 245),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Substation Type Info: ${substationInfo.substationTypeId}: ${substationInfo.substationType ?? ""}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 223, 240, 243),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Zone Info: ${substationInfo.zoneId}: ${substationInfo.zoneInfo ?? ""}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 241, 245, 245),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Circle Info: ${substationInfo.circleId}: ${substationInfo.circleInfo ?? ""}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 223, 240, 243),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('SnD Type Info: ${substationInfo.sndId}: ${substationInfo.sndInfo ?? ""}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 241, 245, 245),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('SnD Type Info: ${substationInfo.sndDetailTypeId}: ${substationInfo.sndDetailType ?? ""}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 223, 240, 243),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Esu Type Info: ${substationInfo.esuId}: ${substationInfo.esuInfo ?? ""}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 241, 245, 245),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Nominal Voltage: ${substationInfo.nominalVoltage ?? 'N/A'}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 223, 240, 243),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Installed Capacity: ${substationInfo.installedCapacity ?? 'N/A'}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 241, 245, 245),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Max Demand: ${substationInfo.maximumDemand ?? 'N/A'}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 223, 240, 243),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Peak Load: ${substationInfo.peakLoad ?? 'N/A'}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 241, 245, 245),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Location: ${substationInfo.location ?? 'N/A'}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 223, 240, 243),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Area of Substation: ${substationInfo.areaOfSubstation ?? 'N/A'}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 241, 245, 245),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Latitude: ${substationInfo.latitude ?? 'N/A'}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 223, 240, 243),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Longitude: ${substationInfo.longitude ?? 'N/A'}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 241, 245, 245),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Default Zoom Level: ${substationInfo.defaultZoomLevel ?? 'N/A'}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 223, 240, 243),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Year of Comissioning: ${substationInfo.yearOfComissioning ?? 'N/A'}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 241, 245, 245),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Total Capacity: ${substationInfo.totalCapacity ?? 'N/A'}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: const Color.fromARGB(255, 223, 240, 243),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Remarks: ${substationInfo.remarks ?? 'N/A'}'),
                            ),
                        ),
                        const Divider(
                          height:0,
                        ),
                        const SizedBox( height: 20,),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Card(
                            color: const Color.fromARGB(255, 5, 161, 182),
                            child: 
                              TextButton(
                                child: const Text('Cancel', 
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        title: const Text('Substation Information',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      ),
      body: FutureBuilder<List<Substation>>(
        future: _futureSubstations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Substation available!'));
          } else {
            // Filter the list based on search query

            List<Substation> substations = snapshot.data!;

            return ListView.builder(
              itemCount: substations.length,
              itemBuilder: (context, index) {
                Substation substationInfo = substations[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      substationInfo.substationId.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Substation Name #${substationInfo.substationName}\r\nCode #${substationInfo.substationCode}',
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
                                showDetailDialog(substationInfo);
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
