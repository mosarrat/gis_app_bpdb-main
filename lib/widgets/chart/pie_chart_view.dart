import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../api/chart_api.dart';
import '../../models/charts_lookups/pie_chart.dart';

class PieChartView extends StatefulWidget {
  final String? selectedData;

  PieChartView({super.key, required this.selectedData});

  @override
  _PieChartViewState createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView> {
  Future<List<ZoneData>>? _futureZones;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(PieChartView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedData != widget.selectedData) {
      _loadData();
    }
  }

  void _loadData() {
    setState(() {
      _futureZones = PieData(widget.selectedData);
    });
  }

  List<PieChartSectionData> getPieChartData(List<ZoneData> zones) {
    List<Color> colors = [
      Colors.green,
      Colors.blue,
      Colors.red,
      Colors.yellow,
      Colors.deepPurple,
      Colors.brown,
      Colors.orange,
      Colors.indigo,
      Colors.lime,
      Colors.blueGrey,
    ];

    return zones.asMap().entries.map((entry) {
      int index = entry.key;
      ZoneData zoneInfo = entry.value;
      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 18 : 14;
      final double radius = isTouched ? 93 : 85;
      var formatter = NumberFormat('#,##,000');
      final val = formatter.format(zoneInfo.count);
      final String titelVal = isTouched ? '$val' : '${zoneInfo.percentage}%';
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: zoneInfo.count.toDouble(),
        title: titelVal,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<LegendItem> getLegends(List<ZoneData> zones) {
    List<Color> colors = [
      Colors.green,
      Colors.blue,
      Colors.red,
      Colors.yellow,
      Colors.deepPurple,
      Colors.brown,
      Colors.orange,
      Colors.indigo,
      Colors.lime,
      Colors.blueGrey,
    ];

    return zones.asMap().entries.map((entry) {
      int index = entry.key;
      ZoneData zoneInfo = entry.value;
      return LegendItem(
        zoneName: zoneInfo.zone,
        color: colors[index % colors.length],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.width;
    var width = MediaQuery.of(context).size.width;
    return FutureBuilder<List<ZoneData>>(
      future: _futureZones,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available!'));
        } else {
          List<ZoneData> zones = snapshot.data!;
          List<PieChartSectionData> pieSections = getPieChartData(zones);
          List<LegendItem> legends = getLegends(zones);
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: width * 0.1),
                  SizedBox(
                    height: height * 0.4,
                    width: width / 3,
                    child: PieChart(
                      PieChartData(
                        sections: pieSections,
                        centerSpaceRadius: 0,
                        sectionsSpace: 2,
                        borderData: FlBorderData(show: false),
                        pieTouchData: PieTouchData(
                          longPressDuration: const Duration(seconds: 2),
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (pieTouchResponse != null &&
                                  pieTouchResponse.touchedSection != null) {
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                                Future.delayed(const Duration(seconds: 5), () {
                                  setState(() {
                                    touchedIndex = -1;
                                  });
                                });
                              } else {
                                touchedIndex = -1;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width *0.12),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: legends.length,
                      itemBuilder: (context, index) {
                        final legend = legends[index];
                        return Container(
                          //margin: EdgeInsets.only(top:8),
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                color: legend.color,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                legend.zoneName,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class LegendItem {
  final String zoneName;
  final Color color;

  LegendItem({
    required this.zoneName,
    required this.color,
  });
}
