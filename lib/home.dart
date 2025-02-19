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
  String? selectedSensor;
  num? iArchValue;
  List<Revitalization> remedy = [];
  
  final Map<String, Map<String, num>> sensorData = {
    "Sensor A": {
      "PM2.5": 56,
      "PM10": 70,
      "TVOC": 300,
      "CO2": 600,
      "RH": 35,
      "T": 73,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
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
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton(
                isExpanded: true,
                hint: Text("Select a Sensor"),
                value: selectedSensor,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSensor = newValue;
                    iArchValue = calculateIArchValue(sensorData[selectedSensor]!);
                    remedy = calculateRevitalizationIArchValues(sensorData[selectedSensor]!);
                  });
                },
                items: sensorData.keys.map((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(key),
                  );
                }).toList(),
              ),
              SizedBox(height: 25),
              selectedSensor != null
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: "Baseline I"),
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
                            text: " = ${iArchValue?.toStringAsFixed(0) ?? "Calculating..."}",
                          ),
                        ],
                        style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    )
                  ),
                  SizedBox(height: 25),
                  ...sensorData[selectedSensor]!.entries.map((entry) {
                    SensorDisplayUnit sensorDisplay = getDisplayName(entry.key);
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "${sensorDisplay.displayName} (${sensorDisplay.unit}): ${entry.value.toStringAsFixed(sensorDisplay.decimalPoint)}",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }),
                  SizedBox(height: 25),
                  DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          "Option",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                      DataColumn(
                        label: Flexible(
                          child: Text(
                            "Remediation Condition",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                            ),
                            softWrap: true,
                          )
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
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold
                              )
                            ),
                            softWrap: true,
                          )
                        ),
                      ),
                    ],
                    rows: List.generate(
                      remedy.length,
                      (int index) => DataRow(
                        cells: [
                          DataCell(
                            Center(
                              child: Text(remedy[index].option),
                            )
                          ),
                          DataCell(
                            Text(remedy[index].condition, softWrap: true)
                          ),
                          DataCell(
                            Center(
                              child: Text(remedy[index].iArch.toStringAsFixed(0)),
                            )
                          ),
                        ],
                        
                      )
                    ),
                    columnSpacing: 10,
                    dataRowMaxHeight: 60,
                  ),
                ],
              )
              : Center(
                child: Text(""),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
