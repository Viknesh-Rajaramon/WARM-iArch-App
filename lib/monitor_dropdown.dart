import "package:flutter/material.dart";

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
    return Center(
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 28, 117, 188),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            isExpanded: true,
            hint: const Text(
              "Select a Monitor",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            value: selectedMonitor,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 30),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onMonitorSelected(newValue);
              }
            },
            selectedItemBuilder: (BuildContext context) {
              return monitors.map((String key) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    key,
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList();
            },
            items: List.generate(monitors.length, (index) {
              String key = monitors[index];
              return DropdownMenuItem<String>(
                value: key,
                child: Text(key),
              );
            }),
          )
        )
      )
    );
  }
}
