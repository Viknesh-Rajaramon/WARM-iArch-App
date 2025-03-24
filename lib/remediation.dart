import "package:flutter/material.dart";

import "package:warm_app/class.dart";
import "package:warm_app/const.dart";
import "package:warm_app/routes.dart";
import "package:warm_app/util.dart";

class RemediationTable extends StatefulWidget {
  final List<Revitalization> remedy;

  const RemediationTable({
    Key? key,
    required this.remedy,
  }) : super(key: key);

  @override
  _RemediationTableCellState createState() => _RemediationTableCellState();
}

class _RemediationTableCellState extends State<RemediationTable> {
  @override
  Widget build(BuildContext context) {
    widget.remedy.sort((a, b) {
      int cmp = a.iArch.compareTo(b.iArch);
      return cmp == 0 ? a.option.compareTo(b.option) : cmp;
    });

    return Center(
      child: DataTable(
        columns: [
          DataColumn(
            label: Expanded(
              child: const Text(
                "Remediation Technique",
                style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(text: "New I"),
                    WidgetSpan(
                      child: Transform.translate(
                        offset: const Offset(0.0, 5.0),
                        child: const Text(
                          "arch",
                          style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const TextSpan(text: " Number"),
                  ],
                  style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)
                ),
                softWrap: true,
                textAlign: TextAlign.center,
              )
            ),
            columnWidth: FixedColumnWidth(101),
          ),
        ],
        rows: widget.remedy.map((item) {
          return DataRow(
            cells: [
              DataCell(
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.condition,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline, size: 16, color: Colors.black),
                        onPressed: () => showPopupMessage(context, item.condition),
                      ),
                    ]
                  ),
                ),
              ),
              DataCell(
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: getIArchColor(item.iArch),
                    ),
                    child: Text(
                      item.iArch.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  )
                )
              ),
            ],
          );
        }).toList(),
        columnSpacing: 15,
        dataRowMinHeight: 70,
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

  void showPopupMessage(BuildContext context, String condition) {
    final remediationStep = remediationSteps[condition];

    if (remediationStep == null || remediationStep.isEmpty) {
      return;
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Steps to implement Remediation Technique"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(remediationStep.length, (index) {
                return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index + 1}.",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          remediationStep[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                );
              }),
              const SizedBox(height: 30),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    "To learn more about how to implement each step, visit our ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.faq),
                    child: Text(
                      "FAQ page",
                      style: const TextStyle(color: Colors.blue, fontSize: 16, decoration: TextDecoration.underline, decorationColor: Colors.blue),
                    ),
                  ),
                ],
              ),
            ]
          ),
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
