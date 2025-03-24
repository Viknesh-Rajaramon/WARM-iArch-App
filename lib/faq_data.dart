import "package:flutter/material.dart";

final List<FaqData> faqData = [
  FaqData(
    "What is a CR box?",
    const Text(
      "A Corsi-Rosenthal box (CR box) is a do-it-yourself (DIY) air purifier which reduces airborne pollutants. It is made from common components like a box fan and MERV 13 air filters, making it an affordable solution for improving indoor air quality.",
      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
    )
  ),
  FaqData(
    "What does a CR box collect?",
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "A CR box collects particulate matter, i.e., microscopic solids or liquid droplets that are so small that some of them can be inhaled and cause serious health issues.",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        bulletPoint("Fine particulate matter (PM\u2082\u002e\u2085): ", "Small particles with diameters of 2.5 µm and smaller.", true),
        const SizedBox(height: 20),
        bulletPoint("Large particulate matter (PM\u2081\u2080): ", "Large particles with diameters of 10 µm and smaller.", true),
      ]
    )
  ),
  FaqData(
    "How does a CR box collect particles?",
    const Text(
      "The CR box draws air through the air filters (MERV 13) using a box fan. The filter captures particles, and the fan circulates the clean air back into the room.",
      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
    )
  ),
  FaqData(
    "How to build a CR box?",
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bulletPoint("Materials Needed: ", "Four MERV 13 air filters (20' x 20\" x 2\"), one box fan (20'), cardboard (from the bon packaging), duct tape, cardboard shroud for the fan (optional)", false),
        const SizedBox(height: 20),
        bulletPoint("Steps to build a CR box:", "", false),
        const SizedBox(height: 15),
        numberedPoint(1, "Prepare the Filters: ", "Ensure all filters have their airflow arrows pointing inward."),
        const SizedBox(height: 20),
        numberedPoint(2, "Assemble the box:", ""),
        bulletPoint("", "Connect the filters together in a cube shape using duct tape, ensuring the airflow arrows point inward.", true, isSubBulletPoint: true),
        const SizedBox(height: 10),
        bulletPoint("", "Use cardboard to create the bottom of the cube.", true, isSubBulletPoint: true),
        const SizedBox(height: 20),
        numberedPoint(3, "Install the fan:", ""),
        bulletPoint("", "Place the box fan on top of the cube, ensuring it blows air outward", true, isSubBulletPoint: true),
        const SizedBox(height: 10),
        bulletPoint("", "Seal the edges around the fan with duct tape to prevent air leaks.", true, isSubBulletPoint: true),
        const SizedBox(height: 20),
        numberedPoint(4, "Optional: Add a shroud", ""),
        bulletPoint("", "Cut a cardboard shroud to fit over the fan to improve efficiency by reducing backflow.", true, isSubBulletPoint: true),
        const SizedBox(height: 20),
        numberedPoint(5, "Finally, ", "ensure all gaps are sealed with duct tape and place the CR box in the room."),
        const SizedBox(height: 30),
        bulletPoint("Impact: ", "Installing a single CR box reduces PM\u2082\u002e\u2085 and PM\u2081\u2080 levels by approximately 40%.", false),
      ]
    )
  ),
  FaqData(
    "How to install Activated Carbon Sheets (DIY Setup)?",
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        numberedPoint(1, "", "Obtain activated carbon sheets designed for air purification."),
        const SizedBox(height: 10),
        numberedPoint(2, "", "Wrap the activated carbon sheet around the CR box. Use two Velcro fasteners to secure the activated carbon sheet in position."),
        const SizedBox(height: 10),
        numberedPoint(3, "", "Check the VOC level and replace the carbon sheets as needed."),
        const SizedBox(height: 20),
        bulletPoint("Impact: ", "Installing and using activated carbon filters can reduce TVOC levels by approximately 80%.", false),
      ]
    )
  ),
  FaqData(
    "How to increase ventilation in your room?",
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        numberedPoint(1, "", "Open windows and doors on opposite sides of your house to create a cross-ventilation system helping air to circulate, reducing CO\u2082 levels."),
        const SizedBox(height: 10),
        numberedPoint(2, "", "Use fans to circulate air and increase ventilation."),
        const SizedBox(height: 10),
        numberedPoint(3, "", "Ensure exhaust fans are installed and used during cooking and bathing to remove moisture and pollutants."),
        const SizedBox(height: 20),
        bulletPoint("Impact: ", "Increasing ventilation can reduce CO\u2082 levels by a varying amount depending on ventilation changes.", false),
      ]
    )
  ),
  FaqData(
    "How to reduce relative humidity in your room?",
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Install a dehumidifier that takes moisture out of the air in your home.",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        bulletPoint("Impact: ", "Installing and using a dehumidifier can reduce the relative humidity by a varying amount depending on the dehumidification efficiency.", false),
      ]
    )
  ),
];

class FaqData {
  final String question;
  final Widget answer;

  const FaqData(this.question, this.answer);
}

Widget bulletPoint(String boldText, String normalText, bool isBulletPoint, {bool isSubBulletPoint = false}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (isBulletPoint) ...[
        if (isSubBulletPoint) ...[
          const SizedBox(width: 25),
        ],
        const Text(
          "\u2022",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
        ),
        const SizedBox(width: 10),
      ],
      Expanded(
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: boldText,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: normalText,
              ),
            ],
          ),
        ),
      ),
    ]
  );
}

Widget numberedPoint(int number, String boldText, String normalText) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "$number.",
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
      ),
      const SizedBox(width: 10),
      Expanded(
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: boldText,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: normalText,
              ),
            ],
          ),
        ),
      ),
    ]
  );
}
