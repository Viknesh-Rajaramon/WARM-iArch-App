import "package:flutter/material.dart";

import "package:warm_app/class.dart";
import "package:warm_app/const.dart";
import "package:warm_app/routes.dart";
import "package:warm_app/util.dart";

class RemediationTable extends StatefulWidget {
  final List<Revitalization> remedy;

  const RemediationTable({
    required this.remedy,
    super.key,
  });

  @override
  RemediationTableCellState createState() => RemediationTableCellState();
}

class RemediationTableCellState extends State<RemediationTable> {
  late List<Revitalization> sortedRemedy;

  @override
  void initState() {
    super.initState();
    _sortRemedies();
  }

  @override
  void didUpdateWidget(covariant RemediationTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.remedy != widget.remedy) {
      _sortRemedies();
    }
  }

  void _sortRemedies() {
    sortedRemedy = List.of(widget.remedy);
    sortedRemedy.sort((a, b) {
      int cmp = a.iArch.compareTo(b.iArch);
      return cmp == 0 ? a.option.compareTo(b.option) : cmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DataTable(
        columns: [
          DataColumn(label: _buildHeaderText("Remediation Technique")),
          DataColumn(label: _buildHeaderText("New I", subscript: "arch", suffix: " Number"), columnWidth: FixedColumnWidth(101)),
        ],
        rows: widget.remedy.map(_buildDataRow).toList(),
        columnSpacing: 15,
        dataRowMinHeight: 70,
        dataRowMaxHeight: double.infinity,
        headingRowHeight: 65,
        border: const TableBorder(
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

  Widget _buildHeaderText(String text, {String? subscript, String? suffix}) {
    return Expanded(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          children: [
            TextSpan(text: text),
            if (subscript != null) _buildSubscriptText(subscript),
            if (suffix != null) TextSpan(text: suffix),
          ],
        ),
      ),
    );
  }

  WidgetSpan _buildSubscriptText(String text) {
    return WidgetSpan(
      child: Transform.translate(
        offset: const Offset(0.0, 4.0),
        child: Text(
          text,
          style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  DataRow _buildDataRow(Revitalization item) {
    return DataRow(
      cells: [
        DataCell(_buildRemediationCell(item.condition)),
        DataCell(Center(child: _buildIArchCell(item.iArch))),
      ]
    );
  }

  Widget _buildRemediationCell(String condition) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              condition,
              softWrap: true,
              style: const TextStyle(fontSize: 14, color: Colors.black)
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, size: 16, color: Colors.black),
            onPressed: () => showPopupMessage(context, condition),
          ),
        ],
      ),
    );
  }

  Widget _buildIArchCell(num iArch) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
      decoration: BoxDecoration(color: getIArchColor(iArch)),
      child: Text(
        iArch.toStringAsFixed(0),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
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
      builder: (context) {
        return AlertDialog(
          title: const Text("Steps to implement Remediation Technique"),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          content: _buildPopupContent(remediationStep),
          actions: [_buildCloseButton()],
          scrollable: true,
        );
      },
    );
  }

  Widget _buildPopupContent(List<String> steps) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < steps.length; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${i + 1}.",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
              ),
              const SizedBox(width: 5),
              Expanded(child: Text(steps[i], style: const TextStyle(fontSize: 16))),
            ],
          ),
        const SizedBox(height: 30),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              "To learn more about how to implement each step, visit our ",
              style: TextStyle(color: Colors.black, fontSize: 16)
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.faq),
              child: const Text(
                "FAQ page",
                style: TextStyle(color: Colors.blue, fontSize: 16, decoration: TextDecoration.underline, decorationColor: Colors.blue)
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCloseButton() {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text(
        "Close",
        style: TextStyle(color: Color.fromARGB(255, 28, 117, 188))
      ),
    );
  }
}
