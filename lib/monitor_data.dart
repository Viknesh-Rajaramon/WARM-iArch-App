import "package:flutter/material.dart";

import "package:warm_app/util.dart";

class MonitorData extends StatelessWidget {
  final Map<String, num> monitorData;

  const MonitorData({
    required this.monitorData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DataTable(
        columns: [
          DataColumn(label: Text("")),
          DataColumn(label: Text("")),
        ],
        rows: getDisplayData(monitorData).map((value) {
          return DataRow(
            cells: [
              DataCell(
                SensorDataCell(displayName: value.displayName, unit: value.unit, infoMessage: value.info),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 6.0),
                  decoration: BoxDecoration(
                    color: value.color,
                  ),
                  child: Text(
                    value.reading.toStringAsFixed(value.decimalPoint),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              ),
            ]
          );
        }).toList(),
        columnSpacing: 30,
        dataRowMinHeight: 15,
        dataRowMaxHeight: 40,
        headingRowHeight: 0,
        dividerThickness: 0.01,
        border: TableBorder(
          top: BorderSide(style: BorderStyle.solid, width: 2.5, color: Color.fromARGB(255, 28, 117, 188)),
          right: BorderSide(style: BorderStyle.solid, width: 2.5, color: Color.fromARGB(255, 28, 117, 188)),
          bottom: BorderSide(style: BorderStyle.solid, width: 2.5, color: Color.fromARGB(255, 28, 117, 188)),
          left: BorderSide(style: BorderStyle.solid, width: 2.5, color: Color.fromARGB(255, 28, 117, 188)),
        ),
      )
    );
  }
}

class SensorDataCell extends StatefulWidget {
  final String displayName;
  final String unit;
  final String infoMessage;

  const SensorDataCell({
    Key? key,
    required this.displayName,
    required this.unit,
    required this.infoMessage,
  }) : super(key: key);

  @override
  _SensorDataCellState createState() => _SensorDataCellState();
}

class _SensorDataCellState extends State<SensorDataCell> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "${widget.displayName} (${widget.unit})",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            showPopupMessage(context);
          },
          child: Icon(
            Icons.info_outline,
            size: 16,
            color: Colors.black,
          ),
        )
      ],
    );
  }

  void showPopupMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(widget.infoMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Close",
                style: TextStyle(color: Color.fromARGB(255, 28, 117, 188)),
              ),
            ),
          ],
        );
      },
    );
  }
}
