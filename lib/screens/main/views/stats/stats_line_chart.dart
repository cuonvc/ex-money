import 'dart:math';

import 'package:ex_money/utils/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:repository/repository.dart';

class StatsLineChart extends StatefulWidget {
  final List<WeekMapAmount> weekList;
  const StatsLineChart({super.key, required this.weekList});

  @override
  State<StatsLineChart> createState() => _StatsLineChartState();
}

class _StatsLineChartState extends State<StatsLineChart> {
  List<Color> gradientColors = [
    cPrimary,
    cPrimary,
  ];

  bool showAvg = false;

  List<WeekMapAmount> weeks = [];
  double totalAmount = 0;
  double maxWeek = 0; //Giai đoạn (tuần) tiêu nhiều tiền nhất trong tháng
  double amtWeek1 = 0;
  double amtWeek2 = 0;
  double amtWeek3 = 0;
  double amtWeek4 = 0;
  double amtWeek5 = 0;
  double avg = 0;

  @override
  void initState() {
    super.initState();
    weeks = widget.weekList;
    totalAmount = weeks.map((w) => w.amount.toDouble()).reduce((amt1, amt2) => amt1 + amt2);
    maxWeek = weeks.map((w) => w.amount.toDouble()).reduce(max);
    amtWeek1 = weeks[0].amount.toDouble();
    amtWeek2 = weeks[1].amount.toDouble();
    amtWeek3 = weeks[2].amount.toDouble();
    amtWeek4 = weeks[3].amount.toDouble();
    amtWeek5 = weeks[4].amount.toDouble();
    avg = totalAmount / weeks.length;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 30, right: 20),
          child: LineChart(
            !showAvg ? mainData() : avgData(),
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
      fontSize: 10,
    );
    Widget text;
    text = Text(value.toString(), style: style,);
    switch (value.toInt()) {
      case 01:
        text = const Text('Tuần 1', style: style);
        break;
      case 02:
        text = const Text('Tuần 2', style: style);
        break;
      case 03:
        text = const Text('Tuần 3', style: style);
        break;
      case 04:
        text = const Text('Tuần 4', style: style);
        break;
      case 05:
        text = const Text('Tuần 5', style: style);
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
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: cTextDisable
    );
    String text = '';
    double dispAmount = 0;

    if (value == amtWeek1) {
      dispAmount = amtWeek1;
    } else if (value == amtWeek2) {
      dispAmount = amtWeek2;
    } else if (value == amtWeek3) {
      dispAmount = amtWeek3;
    } else if (value == amtWeek4) {
      dispAmount = amtWeek4;
    } else if (value == amtWeek5) {
      dispAmount = amtWeek5;
    } else if (value == maxWeek) {
      dispAmount = maxWeek;
    } else {
      return const SizedBox();
    }

    if (dispAmount == 0) {
      text = '';
      //nếu là VND thì bỏ luôn phần thập phân của nghìn
    } else if (dispAmount < 1000) {
      text = "${dispAmount.toInt()}K";
    } else if (dispAmount >= 1000) {
      text = "${(dispAmount/1000).toStringAsFixed(1)}Tr";
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
      minX: 1,
      maxX: 5, //tối đa 1 tháng có 5 tuần
      minY: 0,
      maxY: maxWeek.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: weeks.map((w) => mapData(w.week, w.amount)).toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            color: cBlurPrimary
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      gridData: const FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 6),
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
      minX: 1,
      maxX: 5, //tối đa 1 tháng có 5 tuần
      minY: 0,
      maxY: maxWeek.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: weeks.map((w) => mapData(w.week, avg)).toList(),
          isCurved: true,
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

  FlSpot mapData(num week, num amount) {
    return FlSpot(week.toDouble(), amount.toDouble()); //1 đơn vị amount = 1 case (switch)
  }
}