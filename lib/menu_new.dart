import 'package:flutter/material.dart';

import 'views/consumers/filter_consumers.dart';
import 'views/consumers/new_consumer_exp.dart';
import 'views/dt/add_dt.dart';
import 'views/dt/filter_dt.dart';
import 'views/feederline/view_feederline.dart';
import 'views/pole/create_pole.dart';
import 'views/regions/circle_view.dart';
import 'views/regions/esu_view.dart';
import 'views/regions/filter_pole_detail.dart';
import 'views/regions/snd_view.dart';
import 'views/regions/substation_view.dart';
import 'views/regions/zone_view.dart';

class ToggleRowVisibility extends StatefulWidget {
  const ToggleRowVisibility({Key? key}) : super(key: key);

  @override
  State<ToggleRowVisibility> createState() => _ToggleRowVisibilityState();
}

class _ToggleRowVisibilityState extends State<ToggleRowVisibility> {
  bool _isRegionClicked = false; // Track if Region is clicked
  bool _isViewMoreClicked = false; // Track if View More is clicked
  double _containerHeight = 225; // Default container height

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Determine number of columns based on screen width
    int columns = width > 600 ? 4 : 3; // 4 columns for tablets, 3 for phones

    return SingleChildScrollView(
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: _containerHeight,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Row-1 (Region, Substation, Feeder Line)
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: width / 20, // Space between items
                    runSpacing: height / 40, // Space between rows
                    children: [
                      buildClickableIconWithText(
                        'assets/icons/worldwide.png',
                        'Region',
                        () {
                          setState(() {
                            _isRegionClicked = !_isRegionClicked;
                            _isViewMoreClicked = false;
                            _containerHeight = _isRegionClicked ? 310 : 238;
                          });
                        },
                      ),
                      buildClickableIconWithText(
                        'assets/images/new_icons/new_substation.png',
                        'Substation',
                        () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ViewSubstation(),
                            ),
                          );
                        },
                      ),
                      buildClickableIconWithText(
                        'assets/icons/feederline_2.png',
                        'Feeder Line',
                        () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ViewFeederlines(),
                            ),
                          );
                        },
                      ),
                      if (width > 600)
                        buildClickableIconWithText(
                          'assets/icons/power-line.png',
                          'Pole',
                          () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FilterPoleDetails(),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                  SizedBox(height: height / 37.5),

                  // Row-2 (Pole, DT, Consumer)
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: width / 20,
                    runSpacing: height / 40,
                    children: [
                      if (width <= 600)
                        buildClickableIconWithText(
                          'assets/icons/power-line.png',
                          'Pole',
                          () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FilterPoleDetails(),
                              ),
                            );
                          },
                        ),
                      buildClickableIconWithText(
                        'assets/icons/transformer.png',
                        'DT',
                        () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FilterDTDetails(),
                            ),
                          );
                        },
                      ),
                      buildClickableIconWithText(
                        'assets/images/new_icons/new_consumer.png',
                        'Consumer',
                        () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FilterConsumers(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: height / 37.5),

                  // Region Options (Zone, Circle, SND, ESU)
                  if (_isRegionClicked)
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      firstChild: Container(),
                      secondChild: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: width / 20,
                        runSpacing: height / 40,
                        children: [
                          buildClickableIconWithText(
                            'assets/map_legend/zone.png',
                            'Zones',
                            () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ViewZone(),
                                ),
                              );
                            },
                          ),
                          buildClickableIconWithText(
                            'assets/map_legend/circle.png',
                            'Circles',
                            () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ViewCircles(),
                                ),
                              );
                            },
                          ),
                          buildClickableIconWithText(
                            'assets/map_legend/snd.png',
                            'SnD',
                            () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ViewSnd(),
                                ),
                              );
                            },
                          ),
                          buildClickableIconWithText(
                            'assets/map_legend/esu.png',
                            'Esu',
                            () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ViewEsu(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      crossFadeState: _isRegionClicked
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                    ),

                  // View More Options (Add Pole, Add DT, Add Consumer)
                  if (!_isRegionClicked)
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      firstChild: Container(),
                      secondChild: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: width / 20,
                        runSpacing: height / 40,
                        children: [
                          buildClickableIconWithTextUsingIcon(
                            Icons.add,
                            'Add Pole',
                            () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddPoleInfo(),
                                ),
                              );
                            },
                          ),
                          buildClickableIconWithTextUsingIcon(
                            Icons.add,
                            'Add DT',
                            () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddDTInfo(),
                                ),
                              );
                            },
                          ),
                          buildClickableIconWithTextUsingIcon(
                            Icons.add_home,
                            'Add Consumer',
                            () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NewConsumerExp(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      crossFadeState: _isViewMoreClicked
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -10,
            left: 115,
            right: 115,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isViewMoreClicked = !_isViewMoreClicked;
                  _containerHeight = _isViewMoreClicked ? 310 : 225;
                  _isRegionClicked = false;
                });
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                side: BorderSide.none,
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isViewMoreClicked ? "View Less" : "View More",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 3, 89, 100),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    _isViewMoreClicked
                        ? Icons.arrow_drop_up_sharp
                        : Icons.arrow_drop_down_sharp,
                    color: const Color.fromARGB(255, 3, 89, 100),
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build an icon with label
  Widget buildClickableIconWithText(
      String assetPath, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            width: 45,
            height: 45,
            child: Image.asset(
              assetPath,
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(height: 5),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // Function to build an icon using IconData
  Widget buildClickableIconWithTextUsingIcon(
      IconData iconData, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(iconData, size: 45),
          const SizedBox(height: 5),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
