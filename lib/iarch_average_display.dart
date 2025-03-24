import "package:flutter/material.dart";
import "package:warm_app/const.dart";

import "package:warm_app/util.dart";

class IArchAverageTable extends StatelessWidget {
  final List<num> iArchValues;

  const IArchAverageTable({
    required this.iArchValues,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DataTable(
        columns: [
          DataColumn(
            label: const Text(
              "Timeframe",
              style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          DataColumn(
            label: Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(text: "I"),
                    _buildSubscriptText("arch"),
                    const TextSpan(text: " Number"),
                  ],
                  style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)
                ),
                textAlign: TextAlign.center,
              )
            ),
          ),
        ],
        rows: timeFrameForAverage.map((timeFrame) {
          num averageIArchValue = iArchValues.isNotEmpty ? getAverageIArchValue(iArchValues, int.parse(timeFrame["numReadings"]!)) : -1;
          
          return DataRow(
            cells: [
              DataCell(
                Text(
                  "${timeFrame["timeframe"]} average",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              DataCell(
                Center(
                  child: _buildIArchValueCell(averageIArchValue)
                ),
                
              ),
            ],
          );
        }).toList(),
        columnSpacing: 15,
        dataRowMinHeight: 50,
        dataRowMaxHeight: double.infinity,
        headingRowHeight: 65,
        border: const TableBorder(
          top: BorderSide(style: BorderStyle.solid, width: 3.0, color: Color.fromARGB(255, 28, 117, 188)),
          right: BorderSide(style: BorderStyle.solid, width: 3.0, color: Color.fromARGB(255, 28, 117, 188)),
          bottom: BorderSide(style: BorderStyle.solid, width: 3.0, color: Color.fromARGB(255, 28, 117, 188)),
          left: BorderSide(style: BorderStyle.solid, width: 3.0, color: Color.fromARGB(255, 28, 117, 188)),
          verticalInside: BorderSide(style: BorderStyle.solid, width: 1.5, color: Color.fromARGB(255, 28, 117, 188)),
          horizontalInside: BorderSide(style: BorderStyle.solid, width: 1.5, color: Color.fromARGB(255, 28, 117, 188)),
        ),
      ),
    );
  }

  WidgetSpan _buildSubscriptText(String text) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold)
      ),
    );
  }

  Widget _buildIArchValueCell(num value) {
    if (iArchValues.isEmpty) {
      return const CircularProgressIndicator(
        color: Color.fromARGB(255, 28, 117, 188),
        strokeWidth: 2,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
      decoration: BoxDecoration(color: getIArchColor(value)),
      child: Text(
        value < 0 ? "---" : value.toStringAsFixed(0),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
