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
import 'views/consumers/new_consumer.dart';
//import 'widgets/chart/bar_chart_view.dart';
import 'views/consumers/view_tariff_sub_category.dart';
import 'views/feederline/new_feeder_ex.dart';
import 'views/feederline/new_feederline.dart';
import 'views/feederline/view_feederline.dart';
import 'views/feederline/view_table.dart';
import 'views/profile/view_profile.dart';
import 'views/regions/circle_view.dart';
import 'views/regions/esu_view.dart';
import 'views/regions/filter_pole_detail.dart';
import 'views/regions/snd_view.dart';
import 'views/regions/substation_view.dart';
import 'views/regions/zone_view.dart';
import 'widgets/login/signin.dart';
import 'widgets/login/signin_control.dart';
import 'widgets/menu/bottom_menu_bar.dart';
import 'models/Login/login.dart';
import 'constants/constant.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isExpanded = false;
  //User? user = globalUser;

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

  @override
  Widget build(BuildContext context) {
    double deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    User? user = globalUser;
    // var now = DateTime.now();
    // var formatterDate = DateFormat('dd-MM-yyyy');
    // String formattedDate = formatterDate.format(now);
    // var formatterTime = DateFormat('hh:mm');
    // String formattedTime = formatterTime.format(now);
    // print(formattedDate);
    // print(user?.UserName);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, // Set the default color for icons here
        ),
        flexibleSpace: Stack(
          children: [
            // Positioned.fill(
            //   child: Image.asset(
            //     'assets/images/android-drawer-bg.jpg',
            //     fit: BoxFit.cover,
            //   ),
            // ),
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
          // child: Icon(
          //   Icons.menu,
          //   color: Colors.white,
          // ),
        ),
        title: Text(
          "BPDB GIS App",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: deviceFontSize + 6,
          ),
        ),
      ),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 150,
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
                    SizedBox(
                        width:
                            15), // Adds some spacing between the avatar and text
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
                        Text('Login Date and Time:\n$LoginTime',
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
                leading: Image.asset(
                  'assets/icons/worldwide.png',
                  width: 24,
                  height: 24,
                  // color: Color.fromARGB(255, 3, 89, 100),
                ),
                title: const Text('Regions'),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.location_pin,
                        color: Color.fromARGB(255, 7, 105, 185),
                      ),
                      title: const Text('Zones'),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewZone(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.circle,
                        color: Color.fromARGB(255, 124, 173, 7),
                      ),
                      title: const Text('Circles'),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewCircles(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.circle_outlined,
                        color: Color.fromARGB(255, 241, 59, 59),
                      ),
                      title: const Text('Snd'),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewSnd(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.circle_outlined,
                        color: Color.fromARGB(255, 241, 183, 59),
                      ),
                      title: const Text('Esu'),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewEsu(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/icons/substation.png',
                        width: 24,
                        height: 24,
                      ),
                      title: const Text('Substation'),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewSubstation(),
                          ),
                        );
                      },
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
                leading: Image.asset(
                  'assets/icons/feederline.png',
                  width: 24,
                  height: 24,
                  // color: Color.fromARGB(255, 3, 89, 100),
                ),
                title: const Text('Feeder Line'),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.add,
                        color: Color.fromARGB(255, 7, 105, 185),
                      ),
                      title: const Text('New Feeder Line'),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // builder: (context) => NewFedderLine(),
                            builder: (context) => NewFedderLineExp(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.view_agenda,
                        color: Color.fromARGB(255, 124, 173, 7),
                      ),
                      title: const Text('View Feeder Line'),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewFeederlines(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.table_chart,
                        color: Color.fromARGB(255, 241, 59, 59),
                      ),
                      title: const Text('View Feeder Line'),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewFeederlinesTable(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            ///////////////-----Feeder Line Menu-----////////////////
            ///////////////-----Pole Menu-----////////////////
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: Image.asset(
                  'assets/icons/pole.png',
                  width: 24,
                  height: 24,
                  // color: Color.fromARGB(255, 3, 89, 100),
                ),
                
                title: const Text('Pole'),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ListTile(
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
            ///////////////-----Pole Menu-----////////////////
            ///////////////-----Consumer Menu-----///////////////
            Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.group,
                    color: Color.fromARGB(255, 233, 13, 134),
                  ),
                  title: const Text('Consumer'),
                  trailing: _isExpanded
                      ? Icon(Icons.expand_less)
                      : Icon(Icons.expand_more),
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
                if (_isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.group_add,
                        color: Color.fromARGB(255, 7, 105, 185),
                      ),
                      title: const Text('New Consumer'),
                      onTap: () async {
                        //List<String> roadLinkNumbers = await dbHelper.getRoadLinkNumbers();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewConsumer(),
                          ),
                        );
                      },
                    ),
                  ),
                if (_isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.groups_2_outlined,
                        color: Color.fromARGB(255, 124, 173, 7),
                      ),
                      title: const Text('View Consumers'),
                      onTap: () async {
                        //List<String> roadLinkNumbers = await dbHelper.getRoadLinkNumbers();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FilterConsumers(),
                          ),
                        );
                      },
                    ),
                  ),
                if (_isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.groups_2_outlined,
                        color: Color.fromARGB(255, 124, 173, 7),
                      ),
                      title: const Text('View Tariff Sub-Categories'),
                      onTap: () async {
                        //List<String> roadLinkNumbers = await dbHelper.getRoadLinkNumbers();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewTariffSubCategory(),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
            ///////////////-----Consumer Menu-----///////////////

            ListTile(
              leading: Icon(
                Icons.map_rounded,
                color: const Color.fromARGB(255, 127, 83, 134),
              ),
              title: const Text('Map Viewer'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapViewer(title: 'Map Viewer'),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.map_rounded,
                color: const Color.fromARGB(255, 127, 83, 134),
              ),
              title: const Text('ArcGIS Map'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArcGISMapViewer(title: 'ArcGIS Map'),
                  ),
                );
              },
            ),

            Divider(),
            //if (userName != 'User')
            // ListTile(
            //   // leading: Icon(
            //   //   Icons.local_library,
            //   //   color: Colors.teal,
            //   // ),
            //   leading: Image.asset(
            //       'assets/icons/profile_main.png',
            //       width: 24,
            //       height: 24,
            //       color: Color.fromARGB(255, 3, 89, 100),
            //   ),
            //   title: const Text('View Profile'),
            //   onTap: () async {
            //     // String userIdToDelete = userID.toString();
            //     // await dbHelper.deleteUser(userIdToDelete);
            //   },
            // ),
            // ListTile(
            //   leading: Icon(
            //     Icons.logout,
            //     color: Colors.amber[600],
            //   ),
            //   title: const Text('Sign out'),
            //   onTap: () async {
            //     // Navigator.pushReplacement(
            //     //   context,
            //     //   MaterialPageRoute(
            //     //     builder: (context) => const Signin(),
            //     //   ),
            //     // );
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => Signin(),
            //       ),
            //     );

            //     // Close the app
            //     exit(0);

            //     // String userIdToDelete = userID.toString();
            //     // await dbHelper.deleteUser(userIdToDelete);

            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(
            //     //     builder: (context) => HomePage(
            //     //       userID: 0,
            //     //       userName: 'User',
            //     //       name: 'User',
            //     //       userGroupID: '-1',
            //     //       userGroup: '',
            //     //       email: '',
            //     //       phoneNumber: '',
            //     //       profilePicture: '',
            //     //     ),
            //     //   ),
            //     // );
            //   },
            // ),
            ///////////////-----Profile Menu-----////////////////
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: Image.asset(
                  'assets/icons/profile_main.png',
                  width: 24,
                  height: 24,
                  color: Color.fromARGB(255, 3, 89, 100),
              ),
                title: const Text('Profile'),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/icons/profile_summary.png',
                        width: 24,
                        height: 24,
                      ),
                      title: const Text('View Profile'),
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const ViewProfile();
                          },
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ListTile(
                      leading: Image.asset(
                          'assets/icons/profile_settings.png',
                          width: 24,
                          height: 24,
                      ),
                      title: const Text('Manage Profile'),
                      onTap: () async {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ManageProfile(),
                        //   ),
                        // );
                      },
                    ),
                  ),
                ],
              ),
            ),
            ///////////////-----Profile Menu-----////////////////
            ListTile(
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: width,
              height: height,
              child: Stack(
                children: [
                  Container(
                    width: width,
                    height: height,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: width,
                        height: height / 2.8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
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
                              margin: EdgeInsets.only(right: 20.0),
                              width:
                                  MediaQuery.of(context).size.width * 0.9 - 20,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            item['title']!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            item['value']!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 18,
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
                      //BarChartView(),
                    ],
                  ),
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
