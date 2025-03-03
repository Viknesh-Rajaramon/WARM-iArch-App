import "dart:async";
import "package:flutter/material.dart";

import "package:warm_app/calculation.dart";
import "package:warm_app/util.dart";
import "package:warm_app/class.dart";
import "package:warm_app/api.dart";


class HomePage extends StatefulWidget {
  final String uid;

  const HomePage({
    required this.uid,
    super.key,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedMonitor;
  num iArchValue = 0;
  bool readingsVisible = false;
  bool isLoading = false;
  List<Revitalization> remedy = [];
  List<String> monitors = [];
  Map<String, Map<String, num>> monitorData = {};

  @override
  void initState() {
    super.initState();
    setState(() => isLoading = true);
    getMonitorData();
    Timer.periodic(const Duration(minutes: 1), (timer) => getMonitorData());
  }

  Future getMonitorData() async {
    var data = await getCurrentMonitorDataFromAllLocations(token);

    setState(() {
      monitorData = data;
      monitors = monitorData.keys.toList(growable: false);
      isLoading = false;

      if (selectedMonitor != null) {
        updateData(selectedMonitor!);
      }
    });
  }

  void updateData(String monitor) {
    if (isLoading) {
      return;
    }
    setState(() {
      selectedMonitor = monitor;
      iArchValue = calculateIArchValue(monitorData[monitor]!);
      remedy = calculateRevitalizationIArchValues(monitorData[monitor]!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isLoading ? null : AppTitle(),
        automaticallyImplyLeading: false,
      ),
      body: isLoading ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text("Please wait while the data is being loaded", style: TextStyle(fontSize: 16)),
          ],
        ),
      ) : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MonitorDropdown(
                monitors: monitors,
                selectedMonitor: selectedMonitor,
                onMonitorSelected: updateData,
              ),
              SizedBox(height: 25),
              if (selectedMonitor != null) ...[
                Center(
                  child: ElevatedButton(
                    onPressed: () => setState(() => readingsVisible = !readingsVisible),
                    child: Text(readingsVisible ? 'Hide Monitor Data' : 'View Monitor Data'),
                  ),
                ),
                if (readingsVisible) ...[
                    MonitorDataTable(monitorData: monitorData[selectedMonitor]!),
                  ],
                  SizedBox(height: 25),
                  IArchDisplay(iArchValue: iArchValue),
                  SizedBox(height: 25),
                  RemediationTable(remedy: remedy)
                ],
              ],
            ),
          ),
        ),
    );
  }
}

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          children: [
            const TextSpan(text: "I"),
            WidgetSpan(
              child: Transform.translate(
                offset: const Offset(0.0, 3.0),
                child: const Text(
                  "arch",
                  style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const TextSpan(text: " Monitor"),
          ],
        ),
      )
    );
  }
}

class MonitorDropdown extends StatelessWidget {
  final List<String> monitors;
  final String? selectedMonitor;
  final Function(String) onMonitorSelected;

  const MonitorDropdown({
    required this.monitors,
    required this.selectedMonitor,
    required this.onMonitorSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: true,
      hint: Text("Select a Monitor"),
      value: selectedMonitor,
      onChanged: (String? newValue) {
        if (newValue != null) {
          onMonitorSelected(newValue);
        }
      },
      items: monitors.map((String key) {
        return DropdownMenuItem<String>(
          value: key,
          child: Text(key),
        );
      }).toList(),
    );
  }
}

class IArchDisplay extends StatelessWidget {
  final num iArchValue;

  const IArchDisplay({
    required this.iArchValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "Current I"),
            WidgetSpan(
              child: Transform.translate(
                offset: const Offset(0.0, 3.0),
                child: const Text(
                  "arch",
                  style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TextSpan(
              text: " Number = ${iArchValue.toStringAsFixed(0)}",
            ),
          ],
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      )
    );
  }
}

class MonitorDataTable extends StatelessWidget {
  final Map<String, num> monitorData;

  const MonitorDataTable({
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
                Text(
                  "${value.displayName} (${value.unit})",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              DataCell(
                Text(
                  value.reading.toStringAsFixed(value.decimalPoint),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, backgroundColor: value.color),
                ),
              ),
            ]
          );
        }).toList(),
        columnSpacing: 40,
        dataRowMinHeight: 15,
        dataRowMaxHeight: 30,
        headingRowHeight: 20,
        dividerThickness: 0.01,
      )
    );
  }
}

class RemediationTable extends StatelessWidget {
  final List<Revitalization> remedy;

  const RemediationTable({
    required this.remedy,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DataTable(
        columns: [
          DataColumn(
            label: Text(
              "Option",
              style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            columnWidth: FixedColumnWidth(82.8),
          ),
          DataColumn(
            label: Text(
              "Remediation Condition",
              style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
              softWrap: true,
              textAlign: TextAlign.center,
            )
          ),
          DataColumn(
            label: Flexible(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "New I"),
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
        rows: List.generate(
          remedy.length,
          (int index) => DataRow(
            cells: [
              DataCell(Center(child: Text("${index + 1}"))),
              DataCell(
                Text(
                  remedy[index].condition,
                  softWrap: true,
                )
              ),
              DataCell(Center(child: Text(remedy[index].iArch.toStringAsFixed(0)))),
            ],
          ),
        ),
        columnSpacing: 15,
        dataRowMaxHeight: 60,
      )
    );
  }
}
