// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../../models/regions/circle.dart';
import '../../models/regions/feeder_line.dart';
import '../../models/regions/substation.dart';
import '../../models/regions/zone.dart';
import '../../models/regions/snd_info.dart';
import '../../widgets/noti/notifications.dart';
import 'view_consumers.dart';

class FilterConsumers extends StatefulWidget {
  const FilterConsumers({super.key});

  @override
  _FilterConsumersState createState() => _FilterConsumersState();
}

class _FilterConsumersState extends State<FilterConsumers> {
  late Future<List<Zone>> zones;
  late Future<List<Circles>> circles;
  late Future<List<SndInfo>> snds;
  late Future<List<Substation>> substations;
  late Future<List<FeederLine>> feederLines;
  late TextEditingController _ConsumerNo = TextEditingController();

  int? selectedZoneId;
  int? selectedCircleId;
  int? selectedSnDId;
  int? selectedSubstationId;
  int? selectedFeederLineId;
  //int? consumerNo;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    zones = CallApi().fetchZoneInfo();
    circles = Future.value([]);
    snds = Future.value([]);
    substations = Future.value([]);
    feederLines = Future.value([]);
  }

  void setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  void onZoneChanged(int? value) {
    setLoading(true);
    selectedZoneId = value;
    selectedCircleId = null;
    selectedSnDId = null;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    circles = CallApi().fetchCircleInfo(value!).whenComplete(() {
      setLoading(false);
    });
    snds = Future.value([]);
    substations = Future.value([]);
    feederLines = Future.value([]);
  }

  void onCircleChanged(int? value) {
    setLoading(true);
    selectedCircleId = value;
    selectedSnDId = null;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    snds = CallApi().fetchSnDInfo(value!).whenComplete(() {
      setLoading(false);
    });
    substations = Future.value([]);
    feederLines = Future.value([]);
  }

  void onSnDChanged(int? value) {
    setLoading(true);
    selectedSnDId = value;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    substations = CallApi().fetchSubstationInfo(value!).whenComplete(() {
      setLoading(false);
    });
    feederLines = Future.value([]);
  }

  void onSubstationChanged(int? value) {
    setLoading(true);
    selectedSubstationId = value;
    selectedFeederLineId = null;
    feederLines = CallApi().fetchFeederLineInfo(value!).whenComplete(() {
      setLoading(false);
    });
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
        title: const Text('Filter Consumers',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top:8),
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FutureBuilder<List<Zone>>(
                      future: zones,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          return DropdownButtonFormField<int>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Zone',
                              labelStyle: TextStyle(
                                color: const Color.fromARGB(255, 5, 161, 182),
                                fontSize: deviceFontSize + 6,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: selectedZoneId,
                            hint: const Text('Select a Zone'),
                            items: snapshot.data!.map((zone) {
                              return DropdownMenuItem<int>(
                                value: zone.zoneId,
                                child:
                                    Text('${zone.zoneCode}: ${zone.zoneName}'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              selectedZoneId = value;
                              onZoneChanged(value);
                            },
                          );
                        } else {
                          return const Text('No zones available');
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    FutureBuilder<List<Circles>>(
                      future: circles,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        }

                        if (snapshot.hasError) {
                          showMessage('Error: ${snapshot.error}', 'error');

                          return DropdownButtonFormField<int>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Circle',
                              labelStyle: TextStyle(
                                color: const Color.fromARGB(255, 5, 161, 182),
                                fontSize: deviceFontSize + 6,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: null,
                            hint: const Text('No circles available!'),
                            items: [],
                            onChanged: null,
                          );
                        } else if (snapshot.hasData) {
                          return DropdownButtonFormField<int>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Circle',
                              labelStyle: TextStyle(
                                color: const Color.fromARGB(255, 5, 161, 182),
                                fontSize: deviceFontSize + 6,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: selectedCircleId,
                            hint: const Text('Select a Circle'),
                            items: snapshot.data!.map((circle) {
                              return DropdownMenuItem<int>(
                                value: circle.circleId,
                                child: Text(
                                    '${circle.circleCode}: ${circle.circleName}'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCircleId = value;
                                onCircleChanged(value);
                              });
                            },
                          );
                        } else {
                          return const Text('No circles available!');
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    FutureBuilder<List<SndInfo>>(
                      future: snds,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        }

                        if (snapshot.hasError) {
                          showMessage('Error: ${snapshot.error}', 'error');

                          return DropdownButtonFormField<int>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'SnD',
                              labelStyle: TextStyle(
                                color: const Color.fromARGB(255, 5, 161, 182),
                                fontSize: deviceFontSize + 6,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: null,
                            hint: const Text('No SnDs available!'),
                            items: [],
                            onChanged: null,
                          );
                        } else if (snapshot.hasData) {
                          return DropdownButtonFormField<int>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'SnD',
                              labelStyle: TextStyle(
                                color: const Color.fromARGB(255, 5, 161, 182),
                                fontSize: deviceFontSize + 6,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: selectedSnDId,
                            hint: const Text('Select a SnD'),
                            items: snapshot.data!.map((snd) {
                              return DropdownMenuItem<int>(
                                value: snd.sndId,
                                child: Text('${snd.sndCode}: ${snd.sndName}'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedSnDId = value;
                                onSnDChanged(value);
                              });
                            },
                          );
                        } else {
                          return const Text('No SnDs available!');
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    FutureBuilder<List<Substation>>(
                      future: substations,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        }

                        if (snapshot.hasError) {
                          showMessage('Error: ${snapshot.error}', 'error');
                          return DropdownButtonFormField<int>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Substation',
                              labelStyle: TextStyle(
                                color: const Color.fromARGB(255, 5, 161, 182),
                                fontSize: deviceFontSize + 6,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: null,
                            hint: const Text('No substations available!'),
                            items: [],
                            onChanged: null,
                          );
                        } else if (snapshot.hasData) {
                          return DropdownButtonFormField<int>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Substation',
                              labelStyle: TextStyle(
                                color: const Color.fromARGB(255, 5, 161, 182),
                                fontSize: deviceFontSize + 6,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: selectedSubstationId,
                            hint: const Text('Select a Substation'),
                            items: snapshot.data!.map((substation) {
                              return DropdownMenuItem<int>(
                                value: substation.substationId,
                                child: Text(
                                    '${substation.substationCode}: ${substation.substationName}'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedSubstationId = value;
                                onSubstationChanged(value);
                              });
                            },
                          );
                        } else {
                          return const Text('No substations available!');
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    FutureBuilder<List<FeederLine>>(
                      future: feederLines,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        }

                        if (snapshot.hasError) {
                          showMessage('Error: ${snapshot.error}', 'error');
                          //return Center(child: Text('Error: ${snapshot.error}'));

                          // Show an empty dropdown when there's an error
                          return DropdownButtonFormField<int>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Feeder Line',
                              labelStyle: TextStyle(
                                color: const Color.fromARGB(255, 5, 161, 182),
                                fontSize: deviceFontSize + 6,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: null,
                            hint: const Text('No feeder line available!'),
                            items: [],
                            onChanged: null,
                          );
                        } else if (snapshot.hasData) {
                          return DropdownButtonFormField<int>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Feeder Line',
                              labelStyle: TextStyle(
                                color: const Color.fromARGB(255, 5, 161, 182),
                                fontSize: deviceFontSize + 6,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: selectedFeederLineId,
                            hint: const Text('Select a Feeder Line'),
                            items: snapshot.data!.map((feeder) {
                              return DropdownMenuItem<int>(
                                value: feeder.feederLineId,
                                child: Text(
                                    '${feeder.feederLineCode}: ${feeder.feederlineName}'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedFeederLineId = value;
                              });
                            },
                          );
                        } else {
                          return const Text('No feeder line available!');
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    const Center(
                      child: Text('OR',
                      style: TextStyle(
                        color: Color.fromARGB(255, 5, 161, 182),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                    //const SizedBox(height: 0.5),
                    TextField(
                      controller: _ConsumerNo,
                      decoration: const InputDecoration(
                        labelText: 'Consumer No',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 5, 161, 182),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: SizedBox(
                        width: width * 0.4,
                        height: height * 0.07,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_ConsumerNo.text.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConsumerListView(
                                    consumerNo: _ConsumerNo.text,
                                    feederLineId: selectedFeederLineId ?? 0,
                                  ),
                                ),
                              );
                            } else if (selectedFeederLineId != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConsumerListView(
                                    feederLineId: selectedFeederLineId!,
                                    consumerNo: '',
                                  ),
                                ),
                              );
                            } else {
                              showMessage('Please enter a Consumer No or select a Feeder Line', 'error');
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              // Adjust the color based on the button state
                              if (states.contains(MaterialState.pressed)) {
                                return const Color.fromARGB(255, 5, 161, 182).withOpacity(0.5);
                              }
                              return const Color.fromARGB(255, 5, 161, 182);
                            }),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Color.fromARGB(255, 5, 161, 182)),
                            )),
                            elevation: MaterialStateProperty.all(4),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ))),
    );
  }
}
