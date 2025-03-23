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
            label: Text(
              "Timeframe",
              style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          DataColumn(
            label: Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "I"),
                    WidgetSpan(
                      child: Transform.translate(
                        offset: const Offset(0.0, 5.0),
                        child: const Text(
                          "arch",
                          style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextSpan(text: " Number"),
                  ],
                  style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)
                ),
                softWrap: true,
                textAlign: TextAlign.center,
              )
            ),
            columnWidth: FixedColumnWidth(101),
          ),
        ],
        rows: List.generate(timeFrameForAverage.length, (index) {
          num averageIArchValue = getAverageIArchValue(iArchValues, int.parse(timeFrameForAverage[index]["numReadings"]!));
          
          return DataRow(
            cells: [
              DataCell(
                Text(
                  "${timeFrameForAverage[index]["timeframe"]!} average",
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              DataCell(
                Center(
                  child: iArchValues.isEmpty ? CircularProgressIndicator(
                    color: Color.fromARGB(255, 28, 117, 188),
                    constraints: BoxConstraints(minWidth: 20, maxWidth: 25, minHeight: 20, maxHeight: 20),
                  ) : Container(
                    padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: getIArchColor(averageIArchValue),
                    ),
                    child: Text(
                      averageIArchValue < 0 ? "---" : averageIArchValue.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  )
                )
              ),
            ],
          );
        }),
        columnSpacing: 15,
        dataRowMinHeight: 50,
        dataRowMaxHeight: double.infinity,
        headingRowHeight: 65,
        border: TableBorder(
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
}
