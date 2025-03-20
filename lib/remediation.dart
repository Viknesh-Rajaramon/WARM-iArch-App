import "package:flutter/material.dart";

import "package:warm_app/class.dart";
import "package:warm_app/const.dart";
import "package:warm_app/util.dart";
import "package:warm_app/faq_page.dart";

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
      int cmp = num.parse(a.iArch.toStringAsFixed(0)).compareTo(num.parse(b.iArch.toStringAsFixed(0)));

      return cmp == 0 ? a.option.compareTo(b.option) : cmp;
    });

    return Center(
      child: DataTable(
        columns: [
          DataColumn(
            label: Expanded(
              child: Text(
                "Remediation Technique",
                style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
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
          widget.remedy.length,
          (int index) => DataRow(
            cells: [
              DataCell(
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.remedy[index].condition,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.info_outline, size: 16, color: Colors.black),
                        onPressed: () {
                          showPopupMessage(context, widget.remedy[index].condition);
                        },
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
                      color: getIArchColor(widget.remedy[index].iArch),
                    ),
                    child: Text(
                      widget.remedy[index].iArch.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  )
                )
              ),
            ],
          ),
        ),
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
    List<String> remediatonStep = remediationSteps[condition]!;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Steps to implement Remediation Technique"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(remediatonStep.length, (index) {
                return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index + 1}.",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          remediatonStep[index],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                );
              }),
              const SizedBox(height: 30),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "To learn more about how to implement each step, visit our ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => FAQPage()),
                      );
                    },
                    child: Text(
                      "FAQ page",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ]
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
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
