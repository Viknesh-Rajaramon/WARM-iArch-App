import "package:flutter/material.dart";
import "package:warm_app/calculation.dart";
import "package:warm_app/util.dart";
import "package:warm_app/class.dart";


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedMonitor;
  num iArchValue = 0;
  bool readingsVisible = false;
  List<Revitalization> remedy = [];
  
  final Map<String, Map<String, num>> monitorData = {
    "Monitor A": {
      "PM2.5": 56,
      "PM10": 70,
      "TVOC": 300,
      "CO2": 600,
      "RH": 35,
      "T": 73,
    },
  };

  void updateData(String monitor) {
    setState(() {
      readingsVisible = false;
      selectedMonitor = monitor;
      iArchValue = calculateIArchValue(monitorData[monitor]!);
      remedy = calculateRevitalizationIArchValues(monitorData[monitor]!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTitle(),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MonitorDropdown(
                monitors: monitorData.keys.toList(),
                selectedMonitor: selectedMonitor,
                onMonitorSelected: updateData,
              ),
              SizedBox(height: 25),
              if (selectedMonitor != null) ...[
                IArchDisplay(iArchValue: iArchValue),
                SizedBox(height: 25),
                Center(
                  child: ElevatedButton(
                    onPressed: () => setState(() => readingsVisible = !readingsVisible),
                    child: Text(readingsVisible ? 'Hide Monitor Data' : 'View Monitor Data'),
                  ),
                ),
                if (readingsVisible) MonitorDataTable(monitorData: monitorData[selectedMonitor]!),
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
        rows: monitorData.entries.map((entry) {
          SensorDisplayUnit sensorDisplay = getDisplayName(entry.key);
          return DataRow(
            cells: [
              DataCell(
                Text(
                  "${sensorDisplay.displayName} (${sensorDisplay.unit})",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              DataCell(
                Text(
                  entry.value.toStringAsFixed(sensorDisplay.decimalPoint),
                  style: TextStyle(fontSize: 16),
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
