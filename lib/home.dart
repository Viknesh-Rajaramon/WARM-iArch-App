import "dart:async";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:warm_app/calculation.dart";
import "package:warm_app/class.dart";
import "package:warm_app/api.dart";
import "package:warm_app/app_title.dart";
import "package:warm_app/monitor_dropdown.dart";
import "package:warm_app/iarch_display.dart";
import "package:warm_app/monitor_data.dart";
import "package:warm_app/remediation.dart";
import "package:warm_app/iarch_average_display.dart";

import "package:warm_app/db/database.dart";
import "package:warm_app/db/project.dart";
import "package:warm_app/db/monitor.dart";
import "package:warm_app/db/user.dart";

class HomePage extends StatefulWidget {
  final User userData;

  const HomePage({
    required this.userData,
    super.key,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User userData;
  String token = "";
  Map<int, String> locationIdsPlantower = {};
  String lastUpdated = DateTime.now().millisecondsSinceEpoch.toString();

  bool isLoading = true;
  Map<String, Map<String, num>> monitorData = {};
  String? selectedMonitor;
  num iArchValue = 0;
  bool readingsVisible = false;
  List<Revitalization> remedy = [];

  @override
  void initState() {
    super.initState();
    userData = widget.userData;
    
    getProjectDataFromDB();
    getMonitorDataSafely();
  }

  Future<void> getProjectDataFromDB() async {
    final results = await Future.wait([getTokenFromProjectId(userData.projectId), getLocationIdsAndPlantowerSerialByProjectId(userData.projectId)]);

    if (mounted) {
      setState(() {
        token = results[0] as String;
        locationIdsPlantower = results[1] as Map<int, String>;
      });
      DatabaseService().closeConnection();
    }
  }

  void getMonitorDataSafely() {
    Timer.periodic(const Duration(minutes: 1), (timer) => getMonitorData());

    Future.doWhile(() async {
      if (token != "") {
        await getMonitorData();
        return false;
      }

      await Future.delayed(Duration(milliseconds: 100));
      return true;
    });
  }

  Future<void> getMonitorData() async {
    if (token == "") {
      return;
    }

    var data = await getCurrentMonitorDataFromAllLocations(token, locationIdsPlantower);

    if (mounted) {
      setState(() {
        monitorData = data;
        isLoading = false;

        if (selectedMonitor != null) {
          updateData(selectedMonitor!);
        }
      });
    }
  }

  void updateData(String monitor) {
    if (isLoading) {
      return;
    }

    final monitorValues = monitorData[monitor];
    if (monitorValues != null) {
      setState(() {
        selectedMonitor = monitor;
        lastUpdated = monitorValues["timestamp"].toString();
        iArchValue = calculateIArchValue(monitorValues);
        remedy = calculateRevitalizationIArchValues(monitorValues);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isLoading ? null : AppBar(
        title: AppTitle(name: userData.firstName, email: userData.email, timestamp: lastUpdated),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 28, 117, 188),
        systemOverlayStyle: const SystemUiOverlayStyle(systemStatusBarContrastEnforced: true),
        toolbarHeight: 120,
      ),
      body: isLoading ? loadingBar() : buildContent(),
    );
  }

  Widget loadingBar() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color.fromARGB(255, 28, 117, 188),
          ),
          SizedBox(height: 15),
          Text(
            "Please wait while the data is being loaded",
            style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 18, fontWeight: FontWeight.bold)
          ),
        ],
      ),
    );
  }

  Widget buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MonitorDropdown(
              monitors: monitorData.keys.toList(growable: false),
              selectedMonitor: selectedMonitor,
              onMonitorSelected: updateData,
            ),
            const SizedBox(height: 25),
            if (selectedMonitor != null) ...[
              Center(
                child: ElevatedButton(
                  onPressed: () => setState(() => readingsVisible = !readingsVisible),
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Color.fromARGB(255, 28, 117, 188))),
                  child: Text(
                    readingsVisible ? "Hide Monitor Data" : "View Monitor Data",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (readingsVisible) ...[
                const SizedBox(height: 25),
                MonitorData(monitorData: monitorData[selectedMonitor]!),
              ],
              const SizedBox(height: 25),
              IArchDisplay(iArchValue: iArchValue),
              const SizedBox(height: 25),
              IArchAverageTable(locationId: monitorData[selectedMonitor]!["locationId"]!, token: token, plantowerSerial: monitorData[selectedMonitor]!["plantower"]!),
              const SizedBox(height: 25),
              RemediationTable(remedy: remedy),
              const SizedBox(height: 25),
            ],
          ],
        ),
      ),
    );
  }
}
