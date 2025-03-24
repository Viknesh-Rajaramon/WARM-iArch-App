import "package:flutter/material.dart";
import "package:warm_app/class.dart";

import "package:warm_app/util.dart";

class MonitorData extends StatelessWidget {
  final Map<String, num> monitorData;

  const MonitorData({
    required this.monitorData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final sensorValues = getDisplayData(monitorData);

    return Center(
      child: DataTable(
        columns: const [
          DataColumn(label: SizedBox.shrink()),
          DataColumn(label: SizedBox.shrink()),
        ],
        rows: sensorValues.map(_buildDataRow).toList(),
        columnSpacing: 30,
        dataRowMinHeight: 15,
        dataRowMaxHeight: 40,
        headingRowHeight: 0,
        dividerThickness: 0.01,
        border: const TableBorder(
          top: BorderSide(style: BorderStyle.solid, width: 2.5, color: Color.fromARGB(255, 28, 117, 188)),
          right: BorderSide(style: BorderStyle.solid, width: 2.5, color: Color.fromARGB(255, 28, 117, 188)),
          bottom: BorderSide(style: BorderStyle.solid, width: 2.5, color: Color.fromARGB(255, 28, 117, 188)),
          left: BorderSide(style: BorderStyle.solid, width: 2.5, color: Color.fromARGB(255, 28, 117, 188)),
        ),
      )
    );
  }

  DataRow _buildDataRow(SensorDisplayUnit value) {
    return DataRow(
      cells: [
        DataCell(
          SensorDataCell(displayName: value.displayName, unit: value.unit, infoMessage: value.info),
        ),
        DataCell(_buildReadingCell(value)),
      ],
    );
  }

  Widget _buildReadingCell(SensorDisplayUnit value) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 6.0),
        decoration: BoxDecoration(color: value.color),
        child: Text(
          value.reading.toStringAsFixed(value.decimalPoint),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class SensorDataCell extends StatelessWidget {
  final String displayName;
  final String unit;
  final String infoMessage;

  const SensorDataCell({
    required this.displayName,
    required this.unit,
    required this.infoMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            "$displayName ($unit)",
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => _showPopupMessage(context),
          child: const Icon(Icons.info_outline, size: 16, color: Colors.black),
        )
      ],
    );
  }

  void _showPopupMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(infoMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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
