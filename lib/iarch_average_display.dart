import "package:flutter/material.dart";
import "package:warm_app/const.dart";

import "package:warm_app/util.dart";
import "package:warm_app/api.dart";

class IArchAverageTable extends StatefulWidget {
  final num locationId;
  final String token;
  final num plantowerSerial;

  const IArchAverageTable({
    Key? key,
    required this.locationId,
    required this.token,
    required this.plantowerSerial,
  }) : super(key: key);

  @override
  _IArchAverageTableCellState createState() => _IArchAverageTableCellState();
}

class _IArchAverageTableCellState extends State<IArchAverageTable> {
  late num locationId;
  late String token;
  late num plantowerSerial;
  List<num> iArchValues = [];

  @override
  void initState() {
    super.initState();
    locationId = widget.locationId;
    token = widget.token;
    plantowerSerial = widget.plantowerSerial;

    getMonitorData();
  }

  Future<void> getMonitorData() async {
    if (token == "") {
      return;
    }

    var data = await getHistoricMonitorDataByLocationId(token, locationId, plantowerSerial);

    if (mounted) {
      setState(() {
        iArchValues = data;
      });
    }
  }

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
            label: Flexible(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "I"),
                    WidgetSpan(
                      child: Transform.translate(
                        offset: const Offset(0.0, 4.0),
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
          return DataRow(
            cells: [
              DataCell(
                Text(
                  "${timeFrameForAverage[index]["timeframe"]!} average",
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              DataCell(
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: getIArchColor(0),
                    ),
                    child: Text(
                      getAverageIArchValue(iArchValues, int.parse(timeFrameForAverage[index]["numReadings"]!)).toStringAsFixed(0),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
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
