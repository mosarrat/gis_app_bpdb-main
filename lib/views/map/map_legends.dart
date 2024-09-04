import 'package:flutter/material.dart';

class MapLegends extends StatefulWidget {
  const MapLegends({super.key});

  @override
  State<MapLegends> createState() => _MapLegendsState();
}

class _MapLegendsState extends State<MapLegends> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      contentPadding: const EdgeInsets.all(0),
      insetPadding: const EdgeInsets.only(left: 215, top: 420, right: 9),
      backgroundColor: const Color.fromARGB(255, 5, 161, 182), 
      titlePadding: const EdgeInsets.all(0),
      title: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              iconSize: 16,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            height: 40,
            child: const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Map Legend",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.02,
        child: Scrollbar(
          thumbVisibility: true,
          interactive: true,
          radius: Radius.elliptical(8.0, 2.0),
          child: SingleChildScrollView(
            child: Card(
              shadowColor: Colors.transparent, 
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
              ),
              color: const Color.fromARGB(237, 255, 255, 255),
              margin: const EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    _buildLegendCard('zone.png', 'Zone'),
                    _buildLegendCard('circle.png', 'Circle'),
                    _buildLegendCard('snd.png', 'SnD'),
                    _buildLegendCard('substation_map.png', 'Substation'),
                    _buildLegendCard('feederline_0.4k.png', '0.4 KV feeder Line'),
                    _buildLegendCard('feederline_11k.png', '11 KV Feeder Line'),
                    _buildLegendCard('feederline_33k.png', '33 KV Feeder Line'),
                    _buildLegendCard('pole.png', 'Pole'),
                    _buildLegendCard('common_pole.png', 'Common Pole'),
                    _buildLegendCard('lt_pole.png', 'LT Pole'),
                    _buildLegendCard('dt.png', 'DT'),
                    _buildLegendCard('service_point.png', 'Service Point'),
                    _buildLegendCard('consumers.png', 'Consumers'),
                    _buildLegendCard('consumer_serviceline.png', 'Consumer - Service Line'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build a legend card
  // Widget _buildLegendCard(String assetName, String title) {
  //   return Column(
  //     children: [
  //       Card(
  //         color: Colors.white,
  //         shadowColor: Colors.transparent,
  //         shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(2),
  //             topRight: Radius.circular(2),
  //           ),
  //         ),
  //         child: ListTile(
  //           leading: Image.asset(
  //             'assets/map_legend/$assetName',
  //             width: 24,
  //             height: 24,
  //           ),
  //           title: Text(title),
  //         ),
  //       ),
  //       const SizedBox(height: 1.5),
  //     ],
  //   );
  // }
  Widget _buildLegendCard(String assetName, String title) {
  return Column(
    children: [
      Card(
        color: Colors.white,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              Image.asset(
                'assets/map_legend/$assetName',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: title,
                    labelStyle: TextStyle(fontSize: 10.5),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 1),
                    isDense: true, 
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      //const SizedBox(height: 1),
    ],
  );
}

}

