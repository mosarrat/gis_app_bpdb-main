// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, deprecated_member_use

import 'dart:io';

import "package:carousel_slider/carousel_slider.dart";
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gis_app_bpdb/views/map/map_viewer.dart';
import 'package:gis_app_bpdb/views/map/arc_gis_map.dart';
import 'package:gis_app_bpdb/views/map/arc_gis_map_filter.dart';

import 'package:gis_app_bpdb/widgets/chart/bar_chart_view.dart';

import 'api/api.dart';
import 'main.dart';
import 'views/consumers/filter_consumers.dart';
// import 'views/consumers/new_consumer.dart';
//import 'widgets/chart/bar_chart_view.dart';
import 'views/consumers/new_consumer_exp.dart';
import 'views/consumers/view_tariff_sub_category.dart';
import 'views/dt/filter_dt.dart';
import 'views/feederline/new_feeder_ex.dart';
// import 'views/feederline/new_feederline.dart';
import 'views/feederline/view_feederline.dart';
import 'views/feederline/view_table.dart';
import 'views/profile/profile_page.dart';
// import 'views/profile/view_profile.dart';
import 'views/regions/circle_view.dart';
import 'views/regions/esu_view.dart';
import 'views/regions/filter_pole_detail.dart';
import 'views/regions/snd_view.dart';
import 'views/regions/substation_view.dart';
import 'views/regions/zone_view.dart';
import 'widgets/chart/pie_chart_view.dart';
import 'widgets/login/signin.dart';
// import 'widgets/login/signin_control.dart';
import 'widgets/menu/bottom_menu_bar.dart';
import 'models/Login/login.dart';
import 'constants/constant.dart';
import 'package:intl/intl.dart';

import 'widgets/widgets/fieldset_legend.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //bool _isExpanded = false;
  //User? user = globalUser;
  UniqueKey region = UniqueKey();
  UniqueKey feederline = UniqueKey();
  UniqueKey pole = UniqueKey();
  UniqueKey consumer = UniqueKey();
  UniqueKey profile = UniqueKey();
  UniqueKey dt = UniqueKey();

  final List<Map<String, String>> _carouselItems = [
    {
      'imagePath': 'assets/images/carousel/barabkunda_ss.png',
      'title': 'Barabkunda Substation'
    },
    {
      'imagePath': 'assets/images/carousel/bpdb_dt.jpg',
      'title': 'BPDB Distribution Transformer'
    },
    {'imagePath': 'assets/images/carousel/bpdb_pole.jpg', 'title': 'BPDB Pole'},
    {
      'imagePath': 'assets/images/carousel/bpdb_pole_2.jpg',
      'title': 'BPDB Pole 2'
    },
    {
      'imagePath': 'assets/images/carousel/bpdb_substation.jpg',
      'title': 'BPDB Substation'
    },
    {
      'imagePath': 'assets/images/carousel/bpdb_substation_2.jpg',
      'title': 'BPDB Substation 2'
    },
  ];

  // final List<Map<String, String>> _textCarouselItems = [
  //   {'title': 'Feeders', 'value': '1,740'},
  //   {'title': 'D/T', 'value': '23,883'},
  //   {'title': 'Poles', 'value': '5,76,400'},
  //   {'title': 'Consumers', 'value': '9,38,855'},
  //   {'title': 'Service Points', 'value': '1,47,897'},
  //   {'title': 'Substations', 'value': '151'},
  // ];

  final List<Map<String, String>> _textCarouselItems = [
    {'title': 'Feeders', 'value': '0'},
    {'title': 'D/T', 'value': '0'},
    {'title': 'Detail Poles', 'value': '0'},
    {'title': 'Unique Poles', 'value': '0'},
    {'title': 'Consumers', 'value': '0'},
    {'title': 'Service Points', 'value': '0'},
    {'title': 'Substations', 'value': '0'},
  ];

  int _currentSlide = 0;
  late List<bool> _buttonStates;

  @override
  void initState() {
    super.initState();
    getDashboardCounting();
    _buttonStates = List.generate(5, (index) => false);
    _pieController.text = pieDropdown.first['value'].toString();
    selectedData = pieDropdown[0]["value"];
    selectedBarData = barDropdown[0]["value"];
  }

  void getDashboardCounting() async {
    try {
      Map<String, dynamic> consumerCount =
          await CallApi().fetchDashboardCounting();

      setState(() {
        _textCarouselItems[0]['value'] = consumerCount['feederline'].toString();
        _textCarouselItems[1]['value'] = consumerCount['dt'].toString();
        _textCarouselItems[2]['value'] = consumerCount['detailPole'].toString();
        _textCarouselItems[3]['value'] = consumerCount['uniquePole'].toString();

        _textCarouselItems[4]['value'] = consumerCount['consumer'].toString();
        _textCarouselItems[5]['value'] =
            consumerCount['servicePoint'].toString();
        _textCarouselItems[6]['value'] = consumerCount['substation'].toString();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }

      _textCarouselItems[0]['value'] = "0";
      _textCarouselItems[1]['value'] = "0";
      _textCarouselItems[2]['value'] = "0";
      _textCarouselItems[3]['value'] = "0";
      _textCarouselItems[4]['value'] = "0";
      _textCarouselItems[5]['value'] = "0";
      _textCarouselItems[6]['value'] = "0";
    }
  }

//////////////////// -----Chart ----- /////////////////////
  String? selectedData;
  String? selectedBarData;
  String heading = "Zone Wise Consumer Count";
  String BarChartHeading = "Zone Wise Consumer Info Report";
  final _pieController = TextEditingController();
  final List<Map<String, dynamic>> pieDropdown = [
    {"value": "1", "text": "Consumer"},
    {"value": "2", "text": "Pole"},
  ];
  final List<Map<String, dynamic>> barDropdown = [
    {"value": "1", "text": "Consumer"},
    {"value": "2", "text": "Pole"},
  ];
  void _onDropdownChanged(String? newValue) {
    setState(() {
      selectedData = newValue;
      selectedBarData = newValue;
      heading = selectedData == "1"
          ? "Zone Wise Consumer Count"
          : "Zone Wise Pole Count";
      BarChartHeading = selectedBarData == "1"
          ? "Zone Wise Consumer Info Report"
          : "Zone Wise Pole Info Report";
    });
  }

  void _onBarDropdownChanged(String? newValue) {
    setState(() {
      selectedBarData = newValue;
      BarChartHeading = selectedBarData == "1"
          ? "Zone Wise Consumer Info Report"
          : "Zone Wise Pole Info Report";
    });
  }

//////////////////// -----Chart ----- /////////////////////
  @override
  Widget build(BuildContext context) {
    double deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    User? user = globalUser;
    //print(selectedData);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        flexibleSpace: Stack(
          children: [
            Container(
              color: Color.fromARGB(255, 3, 89, 100),
            ),
          ],
        ),
        leading: GestureDetector(
          onTap: () {
            if (kDebugMode) {
              print('ok');
            }
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text(
          "BPDB GIS APP",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: deviceFontSize + 6,
          ),
        ),
      ),
      //////////////////////////////////////////////////////////////////////////////////////
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 145,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 3, 89, 100),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage('assets/images/bpdb_logo.png'),
                      radius: 35,
                    ),
                    SizedBox(width: 15), // Adds some spacing between the avatar and text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          //"BPDB GIS App",
                          "User Name: ${user?.UserName}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Login Date and Time:\n$LoginTime',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              //minTileHeight: 40,
              leading: Icon(
                Icons.home,
                // color: const Color.fromARGB(255, 40, 138, 196),
                color: Color.fromARGB(255, 3, 89, 100),
              ),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Dashboard(), // Intangible(id: 0, isLocal: true),
                  ),
                );
              },
            ),
            //Divider(),

            ///////////////-----Regions Menu-----////////////////
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                //minTileHeight: 40,
                key: region,
                onExpansionChanged: (expanded) {
                  if (expanded = true) {
                    setState(() {
                      feederline = UniqueKey();
                      pole = UniqueKey();
                      consumer = UniqueKey();
                      profile = UniqueKey();
                      dt = UniqueKey();
                    });
                  }
                },
                leading: Image.asset(
                  'assets/icons/worldwide.png',
                  width: 24,
                  height: 24,
                ),
                title: const Text('Regions'),
                children: [
                  Container(
                    height: height*0.27,
                    //child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewZone(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset('assets/map_legend/zone.png',
                                  width: 24,
                                  height: 24,
                                  colorBlendMode: BlendMode.multiply,
                                ),
                                SizedBox(width: 8), 
                                Container(
                                  width: width * 0.5,
                                  child: Text('Zones', style: TextStyle(fontSize: 16),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 14),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewCircles(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset('assets/map_legend/circle.png',
                                  width: 24,
                                  height: 24,
                                  colorBlendMode: BlendMode.multiply,
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: width * 0.5,
                                  child: Text('Circles', style: TextStyle(fontSize: 16),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 14),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewSnd(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset('assets/map_legend/snd.png',
                                  width: 24,
                                  height: 24,
                                  colorBlendMode: BlendMode.multiply,
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: width * 0.5,
                                  child: Text('SnD', style: TextStyle(fontSize: 16),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 14),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewEsu(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset('assets/map_legend/esu.png',
                                  width: 24,
                                  height: 24,
                                  colorBlendMode: BlendMode.multiply,
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: width * 0.5,
                                  child: Text('Esu', style: TextStyle(fontSize: 16),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 14),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewSubstation(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset('assets/map_legend/substation_map.png',
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: width * 0.5,
                                  child: Text('Substation', style: TextStyle(fontSize: 16),),
                                ),
                                // Text('Substation', style: TextStyle(fontSize: 16),),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ///////////////-----Regions Menu-----////////////////
            ///////////////-----Feeder Line Menu-----////////////////
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                //minTileHeight: 40,
                key: feederline,
                onExpansionChanged: (expanded) {
                  if (expanded = true) {
                    setState(() {
                      region = UniqueKey();
                      pole = UniqueKey();
                      consumer = UniqueKey();
                      profile = UniqueKey();
                      dt = UniqueKey();
                    });
                  }
                },
                leading: Image.asset(
                  'assets/icons/feederline_2.png',
                  width: 24,
                  height: 24,
                  // color: Color.fromARGB(255, 3, 89, 100),
                ),
                title: const Text('Feeder Line'),
                children: [
                  Container(
                    //height: 120,
                    height: height * 0.12,
                    //child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 8),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewFedderLineExp(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Color.fromARGB(255, 7, 105, 185),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: width * 0.5,
                                  child: Text('New Feeder Line', style: TextStyle(fontSize: 16),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 18),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewFeederlines(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.view_agenda,
                                  color: Color.fromARGB(255, 124, 173, 7),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: width * 0.5,
                                  child: Text('View Feeder Line', style: TextStyle(fontSize: 16),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 16.0),
                        //   child: ListTile(
                        //     //minTileHeight: 40,
                        //     leading: const Icon(
                        //       Icons.table_chart,
                        //       color: Color.fromARGB(255, 241, 59, 59),
                        //     ),
                        //     title: const Text('View Feeder Line'),
                        //     onTap: () async {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => ViewFeederlinesTable(),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                    //),
                  ),
                ],
              ),
            ),
            ///////////////-----Feeder Line Menu-----////////////////
            ///////////////-----Pole Menu-----////////////////
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                //minTileHeight: 40,
                key: pole,
                onExpansionChanged: (expanded) {
                  if (expanded = true) {
                    setState(() {
                      region = UniqueKey();
                      feederline = UniqueKey();
                      consumer = UniqueKey();
                      profile = UniqueKey();
                      dt = UniqueKey();
                    });
                  }
                },
                leading: Image.asset(
                  // 'assets/icons/pole.png',
                  'assets/icons/power-line.png',
                  width: 24,
                  height: 24,
                  // color: Color.fromARGB(255, 3, 89, 100),
                ),
                title: const Text('Pole'),
                children: [
                  Container(
                    //height: 90,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: ListTile(
                              //minTileHeight: 40,
                              leading: const Icon(
                                Icons.view_stream,
                                color: Color.fromARGB(255, 35, 159, 216),
                              ),
                              title: const Text('View Pole Details'),
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilterPoleDetails(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ///////////////-----Pole Menu-----////////////////
            ///////////////-----DT Menu-----////////////////
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                //minTileHeight: 40,
                key: dt,
                onExpansionChanged: (expanded) {
                  if (expanded = true) {
                    setState(() {
                      pole = UniqueKey();
                      region = UniqueKey();
                      feederline = UniqueKey();
                      consumer = UniqueKey();
                      profile = UniqueKey();
                    });
                  }
                },
                leading: Image.asset(
                  'assets/icons/transformer.png',
                  width: 24,
                  height: 24,
                  // color: Color.fromARGB(255, 3, 89, 100),
                ),
                title: const Text('DT'),
                children: [
                  Container(
                    //height: 90,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: ListTile(
                              //minTileHeight: 40,
                              leading: const Icon(
                                Icons.view_stream,
                                color: Color.fromARGB(255, 35, 159, 216),
                              ),
                              title: const Text('View DT Details'),
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilterDTDetails(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ///////////////-----DT Menu-----////////////////

            ///////////////-----Consumer Menu-----///////////////
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                //minTileHeight: 40,
                key: consumer,
                onExpansionChanged: (expanded) {
                  if (expanded = true) {
                    setState(() {
                      region = UniqueKey();
                      feederline = UniqueKey();
                      pole = UniqueKey();
                      profile = UniqueKey();
                      dt = UniqueKey();
                    });
                  }
                },
                leading: const Icon(
                  Icons.group,
                  color: Color.fromARGB(255, 233, 13, 134),
                ),
                title: const Text('Consumer'),
                children: [
                  Container(
                    //height: 144,
                    height: height * 0.13,
                    //child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 8),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewConsumerExp(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.group_add,
                                  color: Color.fromARGB(255, 7, 105, 185),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: width * 0.5,
                                  child: Text('New Consumer', style: TextStyle(fontSize: 16),),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 18),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FilterConsumers(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.groups_2_outlined,
                                  color: Color.fromARGB(255, 124, 173, 7),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: width * 0.5,
                                  child: Text('View Consumers', style: TextStyle(fontSize: 16),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 16.0),
                        //   child: ListTile(
                        //     //minTileHeight: 40,
                        //     leading: const Icon(
                        //       Icons.groups_2_outlined,
                        //       color: Color.fromARGB(255, 124, 173, 7),
                        //     ),
                        //     title: const Text('View Tariff Sub-Categories'),
                        //     onTap: () async {
                        //       //List<String> roadLinkNumbers = await dbHelper.getRoadLinkNumbers();

                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => ViewTariffSubCategory(),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                    //),
                  ),
                ],
              ),
            ),

            // ListTile(
            //   //minTileHeight: 40,
            //   leading: Icon(
            //     Icons.map_rounded,
            //     color: const Color.fromARGB(255, 127, 83, 134),
            //   ),
            //   title: const Text('Map Viewer'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => MapViewer(title: 'Map Viewer'),
            //       ),
            //     );
            //   },
            // ),
            ListTile(
              //minTileHeight: 40,
              leading: Icon(
                Icons.map_rounded,
                color: const Color.fromARGB(255, 127, 83, 134),
              ),
              title: const Text('Map Viewer'),
              onTap: () {
                Navigator.push(
                  context,
                    MaterialPageRoute(
                      builder: (context) => ArcGISMapViewer(
                        title: 'Map Viewer',
                        mapUrl: "https://www.arcgisbd.com/server/rest/services/bpdb/general/MapServer", 
                        zoneId: 0,
                        circleId: 0,
                        sndId: 0,
                        substationId: 0,
                        feederlineId: 0,
                        centerLatitude: 23.7817257,
                        centerLongitude: 90.3455213,
                        defaultZoomLevel: 7, 

                    ),
                  ),
                );
              },
            ),

            Divider(),
            ///////////////-----Profile Menu-----////////////////
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                //minTileHeight: 40,
                key: profile,
                onExpansionChanged: (expanded) {
                  if (expanded = true) {
                    setState(() {
                      region = UniqueKey();
                      feederline = UniqueKey();
                      pole = UniqueKey();
                      consumer = UniqueKey();
                      dt = UniqueKey();
                    });
                  }
                },
                leading: Image.asset(
                  'assets/icons/profile_main.png',
                  width: 24,
                  height: 24,
                  color: Color.fromARGB(255, 3, 89, 100),
                ),
                title: const Text('Profile'),
                children: [
                  Container(
                    //height: height * 0.13,
                    //child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 0),
                          child: ListTile(
                            //minTileHeight: 40,
                            leading: Image.asset(
                              'assets/icons/profile_summary.png',
                              width: 24,
                              height: 24,
                            ),
                            title: const Text('View Profile'),
                            onTap: () async {
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return const ViewProfile();

                              //   },
                              // );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(),
                                ),
                              );
                            },
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 16.0),
                        //   child: ListTile(
                        //     //minTileHeight: 40,
                        //     leading: Image.asset(
                        //       'assets/icons/profile_settings.png',
                        //       width: 24,
                        //       height: 24,
                        //     ),
                        //     title: const Text('Manage Profile'),
                        //     onTap: () async {
                        //       // Navigator.push(
                        //       //   context,
                        //       //   MaterialPageRoute(
                        //       //     builder: (context) => ManageProfile(),
                        //       //   ),
                        //       // );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                    //),
                  ),
                ],
              ),
            ),
            ///////////////-----Profile Menu-----////////////////
            ListTile(
              //minTileHeight: 40,
              leading: Icon(
                Icons.logout,
                color: Colors.amber[600],
              ),
              title: const Text('Sign out'),
              onTap: () async {
                Username.clear();
                Password.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Signin(),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Signed out successfully!'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
                await Future.delayed(Duration(seconds: 2));
              },
            ),
          ],
        ),
      ),
      /////////////////////////////////////////////////////////////////////////////////////
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  Container(
                    width: width,
                    height: height / 2.8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CarouselSlider.builder(
                              itemCount: _carouselItems.length,
                              options: CarouselOptions(
                                height: height / 3,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                aspectRatio: 16 / 9,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                viewportFraction: 0.85,
                                onPageChanged: (index, _) {
                                  setState(() {
                                    _currentSlide = index;
                                  });
                                },
                              ),
                              itemBuilder: (context, index, realIndex) {
                                final item = _carouselItems[index];

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: width,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.asset(
                                          item['imagePath']!,
                                          fit: BoxFit.cover,
                                          height: height / 3.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item['title']!,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 10,
                    child: CarouselSlider.builder(
                      itemCount: _textCarouselItems.length,
                      options: CarouselOptions(
                        height: height / 7,
                        enlargeCenterPage: false,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        viewportFraction: 0.45,
                        onPageChanged: (index, _) {
                          setState(() {
                            _currentSlide = index;
                          });
                        },
                      ),
                      itemBuilder: (context, index, realIndex) {
                        final item = _textCarouselItems[index];

                        return Container(
                          margin: const EdgeInsets.only(right: 20.0),
                          width: MediaQuery.of(context).size.width * 0.9 - 20,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        item['title']!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        item['value']!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  /////////// Pie Chart Container //////////
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding:
                        EdgeInsets.only(top: 8, bottom: 0, left: 8, right: 8),
                    width: MediaQuery.of(context).size.width,
                    //height: 273,
                    height: height * 0.45,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromARGB(255, 220, 240, 243)),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            heading,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        DropdownButtonFormField<String>(
                          menuMaxHeight: 140,
                          padding: EdgeInsets.zero,
                          value: selectedData,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          items: pieDropdown.map((option) {
                            return DropdownMenuItem<String>(
                              value: option['value'].toString(),
                              child: Text(option['text'].toString()),
                            );
                          }).toList(),
                          onChanged: _onDropdownChanged,
                        ),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        if (selectedData != null)
                          PieChartView(
                            selectedData: selectedData,
                          ),
                        /////////// Pie Chart Container //////////
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 8)),
                  /////////// Bar Chart Container //////////
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding:
                        EdgeInsets.only(top: 8, bottom: 2, left: 8, right: 8),
                    width: MediaQuery.of(context).size.width,
                    //height: 273,
                    height: height * 0.5,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromARGB(255, 220, 240, 243)),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            BarChartHeading,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          menuMaxHeight: 140,
                          padding: EdgeInsets.zero,
                          value: selectedBarData,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          items: barDropdown.map((option) {
                            return DropdownMenuItem<String>(
                              value: option['value'].toString(),
                              child: Text(option['text'].toString()),
                            );
                          }).toList(),
                          onChanged: _onBarDropdownChanged,
                        ),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        if (selectedBarData != null)
                          //BarChartView(),
                          BarChartView(
                            selectedBarData: selectedBarData,
                          ),
                        /////////// Bar Chart Container //////////
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 50)),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < 3; i++)
                    BottomMenuBar(
                      icon: _getButtonIcon(i),
                      label: _getButtonLabel(i),
                      isSelected: _buttonStates[i],
                      onPressed: (isSelected) {
                        _updateButtonStates(i);
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getButtonIcon(int index) {
    switch (index) {
      case 0:
        return Icons.map_rounded;
      case 1:
        return Icons.home;
      case 2:
        return Icons.help;
      default:
        return Icons.error;
    }
  }

  String _getButtonLabel(int index) {
    switch (index) {
      case 0:
        return 'Map';
      case 1:
        return 'Home';
      case 2:
        return 'Help';
      default:
        return 'Unknown';
    }
  }

  void _updateButtonStates(int selectedIndex) {
    setState(() {
      for (int i = 0; i < _buttonStates.length; i++) {
        _buttonStates[i] = (i == selectedIndex);
      }
    });
  }
}
