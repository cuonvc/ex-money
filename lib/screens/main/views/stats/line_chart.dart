import 'dart:math';
import 'dart:developer' as log;

import 'package:ex_money/utils/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LineChartDemo extends StatefulWidget {
  const LineChartDemo({super.key});

  @override
  State<LineChartDemo> createState() => _LineChartStateDemo();
}

class _LineChartStateDemo extends State<LineChartDemo> {
  List<Color> gradientColors = [
    cPrimary,
    cPrimary,
  ];

  bool showAvg = false;

  static Map<double, double> dayMapAmount = {
    2: 50,
    3: 0,
    4: 50,
    5: 0,
    6: 80 + 20 + 116,
    7: 50 + 47,
    8: 0
  };

  static double totalAmount = dayMapAmount.values.reduce((a, b) => a + b);
  static double maxDay = dayMapAmount.values.reduce((day1, day2) => max(day1, day2)); //số tiền đã tiêu từ đầu tuần tới giờ
  static double avgDay = totalAmount / dayMapAmount.length;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: LineChart(
            showAvg ? avgData() : mainData(),
          ),
        ),
        Positioned(
          top: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Row(
              children: [
                Text(
                  !showAvg ? 'Trung bình' : 'Quay lại',
                  style: const TextStyle(
                    fontSize: 12,
                    color: cTextDisable
                  ),
                ),
                const SizedBox(width: 4,),
                !showAvg
                    ? const Icon(Icons.show_chart, size: 14, color: cTextDisable,)
                    : const Icon(Icons.close_fullscreen, size: 14, color: cTextDisable,),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: cTextDisable,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('Th2', style: style);
        break;
      case 3:
        text = const Text('Th3', style: style);
        break;
      case 4:
        text = const Text('Th4', style: style);
        break;
      case 5:
        text = const Text('Th5', style: style);
        break;
      case 6:
        text = const Text('Th6', style: style);
        break;
      case 7:
        text = const Text('Th7', style: style);
        break;
      case 8:
        text = const Text('CN      ', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: cTextDisable
    );
    String text;
    switch (value.toInt()) {
      case 10:
        text = '10K';
        break;
      case 50:
        text = '50K';
        break;
      case 200:
        text = '200K';
        break;
      case 500:
        text = '500K';
        break;
      case 1000:
        text = '1Tr';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: const FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 2,
      maxX: 8,
      minY: 0,
      maxY: maxDay,
      lineBarsData: [
        LineChartBarData(
          spots: dayMapAmount.entries.map((entry) => mapData(entry)).toList(),
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: const FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 2,
      maxX: 8,
      minY: 0,
      maxY: maxDay,
      lineBarsData: [
        LineChartBarData(
          spots: dayMapAmount.entries.map((entry) => mapData(MapEntry(entry.key, avgDay))).toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
      ],
    );
  }

  FlSpot mapData(MapEntry<double, double> map) {
    return FlSpot(map.key, map.value);
  }
}