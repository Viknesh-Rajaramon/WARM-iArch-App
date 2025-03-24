import "package:flutter/material.dart";
import "package:warm_app/util.dart";

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
            WidgetSpan(
              child: Transform.translate(
                offset: const Offset(0.0, 5.0),
                child: const Text(
                  "arch",
                  style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const TextSpan(text: " Number = "),
            WidgetSpan(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                decoration: BoxDecoration(
                  color: getIArchColor(iArchValue),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  iArchValue.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
