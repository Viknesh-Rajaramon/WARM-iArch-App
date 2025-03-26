import "dart:async";
import "package:flutter/material.dart";

import "package:warm_app/backend/calculation.dart";
import "package:warm_app/backend/class.dart";
import "package:warm_app/backend/api.dart";
import "package:warm_app/components/app_title.dart";
import "package:warm_app/components/monitor_dropdown.dart";
import "package:warm_app/components/iarch_display.dart";
import "package:warm_app/components/monitor_data.dart";
import "package:warm_app/components/remediation.dart";
import "package:warm_app/components/iarch_average_display.dart";

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
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late User userData;
  String token = "";
  Map<int, String> locationIdsPlantower = {};
  String lastUpdated = DateTime.now().millisecondsSinceEpoch.toString();

  bool isLoading = true;
  Map<String, Map<String, num>> monitorData = {};
  String? selectedMonitor;
  num iArchValue = 0;
  List<num> iArchValues = [];
  List<Revitalization> remedy = [];

  final ValueNotifier<bool> readingsVisible = ValueNotifier(false);
  final ValueNotifier<bool> averageVisible = ValueNotifier(false);

  Timer? dataRefreshTimer;

  @override
  void initState() {
    super.initState();
    userData = widget.userData;
    
    getProjectDataFromDB();
    getCurrentMonitorDataSafely();
  }

  @override
  void dispose() {
    dataRefreshTimer?.cancel();
    readingsVisible.dispose();
    averageVisible.dispose();
    super.dispose();
  }

  Future<void> getProjectDataFromDB() async {
    final results = await Future.wait([
      getTokenFromProjectId(userData.projectId),
      getLocationIdsAndPlantowerSerialByProjectId(userData.projectId),
    ]);
    if (!mounted) {
      return;
    }

    setState(() {
      token = results[0] as String;
      locationIdsPlantower = results[1] as Map<int, String>;
    });

    DatabaseService().closeConnection();
  }

  void getCurrentMonitorDataSafely() {
    dataRefreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) => getCurrentMonitorData());

    Future.doWhile(() async {
      if (token.isNotEmpty) {
        await getCurrentMonitorData();
        return false;
      }

      await Future.delayed(Duration(milliseconds: 100));
      return true;
    });
  }

  Future<void> getCurrentMonitorData() async {
    if (token.isEmpty) {
      return;
    }

    var data = await getCurrentMonitorDataFromAllLocations(token, locationIdsPlantower);
    if (!mounted) {
      return;
    }

    setState(() {
      monitorData = data;
      isLoading = false;

      if (selectedMonitor != null) {
        updateData(selectedMonitor!);
      }
    });
  }

  void getHistoricMonitorDataSafely() {
    Future.doWhile(() async {
      if (token.isNotEmpty && selectedMonitor != null) {
        await getHistoricMonitorData();
        return false;
      }

      await Future.delayed(Duration(milliseconds: 100));
      return true;
    });
  }

  Future<void> getHistoricMonitorData() async {
    if (token.isEmpty || selectedMonitor == null) {
      return;
    }

    var monitorValues = monitorData[selectedMonitor];
    if (monitorValues == null) return;

    var data = await getHistoricMonitorDataByLocationId(token, monitorValues["locationId"]!, monitorValues["plantower"]!);
    if (!mounted) {
      return;
    }

    setState(() => iArchValues = data);
  }

  void updateData(String monitor) {
    if (!isLoading && monitorData.containsKey(monitor)) {
      final monitorValues = monitorData[monitor]!;

      setState(() {
        selectedMonitor = monitor;
        lastUpdated = monitorValues["timestamp"].toString();
        iArchValue = calculateIArchValue(monitorValues);
        remedy = calculateRevitalizationIArchValues(monitorValues);
        iArchValues = [];
      });

      getHistoricMonitorDataSafely();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isLoading ? null : AppBar(
        title: AppTitle(name: userData.firstName, email: userData.email, timestamp: lastUpdated),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 28, 117, 188),
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
          CircularProgressIndicator(color: Color.fromARGB(255, 28, 117, 188)),
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
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MonitorDropdown(
              monitors: monitorData.keys.toList(),
              selectedMonitor: selectedMonitor,
              onMonitorSelected: updateData,
            ),
            const SizedBox(height: 25),
            if (selectedMonitor != null) ...[
              Center(
                child: _ToggleButton(
                  label: "Monitor Data",
                  isVisible: readingsVisible,
                  child: MonitorData(monitorData: monitorData[selectedMonitor]!),
                ),
              ),
              const SizedBox(height: 25),
              IArchDisplay(iArchValue: iArchValue),
              const SizedBox(height: 25),
              Center(
                child: _ToggleButton(
                  label: "iARCH Average",
                  isVisible: averageVisible,
                  child: IArchAverageTable(iArchValues: iArchValues),
                ),
              ),
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

class _ToggleButton extends StatelessWidget {
  final String label;
  final ValueNotifier<bool> isVisible;
  final Widget child;

  const _ToggleButton({
    required this.label,
    required this.isVisible,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: isVisible,
          builder: (context, visible, _) {
            return ElevatedButton(
              onPressed: () => isVisible.value = !visible,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 28, 117, 188),
              ),
              child: Text(
                "${visible ? "Hide" : "View"} $label",
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: isVisible,
          builder: (context, visible, _) {
            return visible ? const SizedBox(height: 25) : const SizedBox.shrink();
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: isVisible,
          builder: (context, visible, _) {
            return visible ? child : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
