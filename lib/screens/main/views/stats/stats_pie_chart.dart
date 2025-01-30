import 'dart:math';

import 'package:ex_money/screens/main/views/stats/widgets/indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:repository/repository.dart';

class StatsPieChart extends StatefulWidget {
  final List<ExpenseResponse> expenses;
  const StatsPieChart({super.key, required this.expenses});

  @override
  State<StatsPieChart> createState() => _StatsPieChartState();
}

class _StatsPieChartState extends State<StatsPieChart> {

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {

    final List<ExpenseResponse> expenses = widget.expenses;
    double totalAmount = expenses.fold(0, (total, exp) => total + exp.amount);
    Map<String, double> categoryMapPercent = {};
    Map<String, Color> categoryMapColor = {};

    for (ExpenseResponse exp in expenses) {
      double plusPercent = exp.amount / totalAmount * 100;
      if (categoryMapPercent.containsKey(exp.parentCategoryName)) {
        double? currentPercent = categoryMapPercent[exp.parentCategoryName]; //không null đâu
        if (currentPercent != null && plusPercent != null) {
          categoryMapPercent[exp.parentCategoryName!] = currentPercent + plusPercent;
        }
      } else {
        categoryMapPercent[exp.parentCategoryName!] = plusPercent;
        Color randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
        if (categoryMapColor.containsValue(randomColor)) { //nếu trùng màu thì random lại
          randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
        }
        categoryMapColor[exp.parentCategoryName!] = randomColor;
      }
    }

    List<MapEntry<String, double>> entries = categoryMapPercent.entries.toList();

    return Column(
      children: <Widget>[
        pieCircle(entries, categoryMapColor),
        const SizedBox(height: 20,),
        remarks(entries, categoryMapColor),
        const SizedBox(height: 20,),
      ],
    );
  }

  Widget pieCircle(List<MapEntry<String, double>> entries, Map<String, Color> categoryMapColor) {
    return Flexible(
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = pieTouchResponse
                    .touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 2,
          centerSpaceRadius: 45,
          sections: showingSections(entries, categoryMapColor),
        ),
      ),
    );
  }

  Widget remarks(List<MapEntry<String, double>> entries, Map<String, Color> categoryMapColor) {
    return SizedBox(
      // width: MediaQuery.sizeOf(context).width - ConstantSize.hozPadScreen * 2,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 10,
        runSpacing: 10,
        children: List.generate(entries.length, (index) {
          return Indicator(
            color: categoryMapColor[entries[index].key]!,
            text: entries[index].key!,
            isSquare: true,
          );
        }),
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<MapEntry<String, double>> entries, Map<String, Color> categoryMapColor) {
    return List.generate(entries.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 15.0 : 10.0;
      final radius = isTouched ? 35.0 : 30.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      double value = double.parse(entries[index].value.toStringAsFixed(1));
      return PieChartSectionData(
        color: categoryMapColor[entries[index].key],
        value: value,
        title: '$value%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }
}
