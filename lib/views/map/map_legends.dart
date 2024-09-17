import 'package:flutter/material.dart';

class MapLegends extends StatefulWidget {
  const MapLegends({super.key, required this.isVisible, required this.onClose});

  final bool isVisible;
  final VoidCallback onClose;

  @override
  State<MapLegends> createState() => _MapLegendsState();
}

class _MapLegendsState extends State<MapLegends> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double popupHeight;
    double topbarWidth;
    double topspaceWidth;

    if (height < 1300 && height > 900) {
      popupHeight = height * 0.3;
    } else if (height < 900 && height > 600) {
      popupHeight = height * 0.28;
    } else if (height < 600 && height > 400) {
      popupHeight = height * 0.48;
    } else if (height < 400 && height > 200) {
      popupHeight = height * 0.5;
    } else {
      popupHeight = height * 0.28;
    }

    if (width < 1300 && width > 900) {
      topbarWidth = width * 0.2;
      topspaceWidth = width * 0.03;
    } else if (width < 900 && width > 600) {
      topbarWidth = width / 7.5;
      topspaceWidth = width / 14;
    } else if (width < 600 && width > 400) {
      topbarWidth = width * 0.26;
      topspaceWidth = width * 0.03;
    } else if (width < 400 && width > 200) {
      topbarWidth = width * 0.26;
      topspaceWidth = width *0.03;
    } else {
      topbarWidth = width * 0.2;
      topspaceWidth = width * 0.002;
    }
    return Visibility(
      visible: widget.isVisible,
      child: Container( 
        height: popupHeight, 
        color: Colors.grey[300],
        child: Column(
          children: [
            Card(
              color: const Color.fromARGB(255, 5, 161, 182),
              margin: EdgeInsetsDirectional.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: topbarWidth,
                    height: 40,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Map Legend",
                          style: TextStyle(
                            fontSize: 15.2,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: topspaceWidth),
                  Expanded(child: Container()), 
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    iconSize: 16,
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                interactive: true,
                radius: Radius.elliptical(8.0, 2.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildLegendCard('zone.png', 'Zone'),
                      _buildLegendCard('circle.png', 'Circle'),
                      _buildLegendCard('snd.png', 'SnD'),
                      _buildLegendCard('esu.png', 'Esu'),
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
          ],
        ),
      ),
    );
  }

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
                  child: Text(title,
                    style: const TextStyle(
                      fontSize: 12,  
                    ),
                  ),
                  // TextField(
                  //   readOnly: true,
                  //   decoration: InputDecoration(
                      
                  //     labelText: title,
                  //     labelStyle: const TextStyle(fontSize: 10.5),
                  //     border: InputBorder.none,
                  //     contentPadding: const EdgeInsets.symmetric(vertical: 1),
                  //     isDense: true, 
                  //   ),
                  // ),
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

