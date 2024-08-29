import 'package:flutter/material.dart';
import '../../api/region_api.dart';
import '../../models/region_delails_lookup/esu.dart';
import '../../widgets/widgets/fieldset_legend.dart';

// import 'edit_feederline.dart';

class ViewEsu extends StatefulWidget {
  const ViewEsu({super.key});
  @override
  _ViewEsuState createState() => _ViewEsuState();
}

class _ViewEsuState extends State<ViewEsu> {

  late Future<List<Esu>> _futureEsus;
  bool isLoading = false;

  String _textValue = 'Initial Value';

  @override
  void initState() {
    super.initState();
    _futureEsus = _fetchEsus();
  }

  Future<List<Esu>> _fetchEsus() async {
    return CallApi().fetchEsuInfo();
  }

  void setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }
/////////////////////////////////////////////////////////////////////////
  void showDetailDialog(Esu esuInfo)  {
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
                  "Esu Information",
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
                              child: Text('Esu Id: ${esuInfo.esuId.toString()}',
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
                              child: Text('Esu Name.: ${esuInfo.esuName}'),
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
                              child: Text('Esu Code: ${esuInfo.esuCode ?? 'N/A'}'),
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
                              child: Text('Zone Info: ${esuInfo.zoneId}: ${esuInfo.zoneInfo ?? ""}'),
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
                              child: Text('Circle Info: ${esuInfo.circleId}: ${esuInfo.circleInfo ?? ""}'),
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
                              child: Text('SnD Type Info: ${esuInfo.sndId}: ${esuInfo.sndInfo ?? ""}'),
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
                              child: Text('Center Latitude: ${esuInfo.centerLatitude ?? 'N/A'}'),
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
                              child: Text('Center Longitude: ${esuInfo.centerLongitude ?? 'N/A'}'),
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
                              child: Text('Default Zoom Level: ${esuInfo.defaultZoomLevel ?? 'N/A'}'),
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
                              child: Text('Office Info: ${esuInfo.officeInfo ?? 'N/A'}'),
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
        title: const Text('Esu Information',
         style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      ),
      body: FutureBuilder<List<Esu>>(
        future: _futureEsus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Esu available!'));
          } else {
            // Filter the list based on search query

            List<Esu> Esus = snapshot.data!;

            return ListView.builder(
              itemCount: Esus.length,
              itemBuilder: (context, index) {
                Esu esuInfo = Esus[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      esuInfo.esuId.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Esu Name #${esuInfo.esuName}\r\nCode #${esuInfo.esuCode}',
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
                                showDetailDialog(esuInfo);
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
