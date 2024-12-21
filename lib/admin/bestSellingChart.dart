import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BestSellingChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Best Selling Chart'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('report').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          // Parse the data for the chart
          List<BarChartGroupData> barData = [];
          snapshot.data!.docs.forEach((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final String name = data['full_name'] ?? 'Unknown';
            final double count = double.tryParse(data['count']?.toString() ?? '0') ?? 0.0;

            barData.add(BarChartGroupData(
              x: barData.length, // Unique index for each bar
              barRods: [
                BarChartRodData(toY: count, color: Colors.blue, width: 16),
              ],
              showingTooltipIndicators: [0],
            ));
          });

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarChart(
              BarChartData(
                barGroups: barData,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (value.toInt() >= 0 && value.toInt() < barData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              snapshot.data!.docs[value.toInt()]['full_name'] ?? 'Unknown',
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString());
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
              ),
            ),
          );
        },
      ),
    );
  }
}
