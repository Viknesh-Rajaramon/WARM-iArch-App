import "package:flutter/material.dart";
import "package:warm_app/backend/util.dart";

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
          style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          children: [
            const TextSpan(text: "Current I"),
            _buildSubscriptText("arch"),
            const TextSpan(text: " Number = "),
            _buildIArchContainer(iArchValue),
          ],
        ),
      )
    );
  }

  WidgetSpan _buildSubscriptText(String text) {
    return WidgetSpan(
      child: Transform.translate(
        offset: const Offset(0.0, 4.0),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  WidgetSpan _buildIArchContainer(num value) {
    return WidgetSpan(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        decoration: BoxDecoration(
          color: getIArchColor(value),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          value.toStringAsFixed(0),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
