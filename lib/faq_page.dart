import "package:flutter/material.dart";

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FAQ",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Color.fromARGB(255, 28, 117, 188),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          faq(faq1),
          faq(faq2),
          faq(faq3),
          faq(faq4),
          faq(faq5),
          faq(faq6),
          faq(faq7),
        ],
      ),
    );
  }
}

Widget faq(Function() func) {
  String question = "";
  List<Widget> answer = [];

  (question, answer) = func();
  
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    color: Color.fromARGB(255, 28, 117, 188),
    child: ExpansionTile(
      collapsedBackgroundColor: Color.fromARGB(255, 28, 117, 188),
      collapsedTextColor: Colors.white,
      collapsedIconColor: Colors.white,
      backgroundColor: Color.fromARGB(255, 28, 117, 188),
      textColor: Colors.white,
      iconColor: Colors.white,
      title: Text(
        question,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: answer,
    ),
  );
}

Widget bulletPoint(String boldText, String normalText, bool isBulletPoint, {bool isSubBulletPoint = false}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isBulletPoint) ...[
          if (isSubBulletPoint) ...[
            const SizedBox(width: 25),
          ],
          Text(
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

(String, List<Widget>) faq1() {
  String question = "What is a CR Box?";
  List<Widget> answer = [
    Padding(padding: EdgeInsets.all(16.0),
      child: Text(
        "A Corsi-Rosenthal Box (CR Box) is a do-it-yourself (DIY) air purifier which reduces airborne pollutants. It is made from common components like a box fan and MERV 13 filters, making it an affordable solution for improving indoor air quality.",
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
  ];
  return (question, answer);
}

(String, List<Widget>) faq2() {
  String question = "What does a CR Box collect?";
  List<Widget> answer = [
    Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "A CR Box collects particulate matter, i.e., microscopic solids or liquid droplets that are so small that they can be inhaled and cause serious health issues.",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          bulletPoint("Fine particulate matter (PM 2.5): ", "Small particles with diameters 2.5 µm and smaller.", true),
          const SizedBox(height: 20),
          bulletPoint("Large particulate matter (PM 10): ", "Large particles like dust with diameters 10 um and smaller.", true),
        ]
      )
    )
  ];

  return (question, answer);
}

(String, List<Widget>) faq3() {
  String question = "How does a CR Box collect particles?";
  List<Widget> answer = [
    Padding(padding: EdgeInsets.all(16.0),
      child: Text(
        "The CR Box draws air through MERV 12 filters using a box fan. The filter captures particles, and the fan circulates the clean air back into the room.",
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
  ];
  return (question, answer);
}

(String, List<Widget>) faq4() {
  String question = "How to build a CR Box?";
  List<Widget> answer = [
    Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bulletPoint("Materials Needed: ", "Four MERV 13 filters (20'x 20\"x 2\"), one box fan (20'), cardboard (from the bon packaging), duct tape, cardboard shroud for the fan (optional)", false),
          const SizedBox(height: 20),
          bulletPoint("Steps to build a CR Box:", "", false),
          const SizedBox(height: 15),
          numberedPoint(1, "Prepare the Filters: ", "Ensure all filters have their airflow arrows pointing inward."),
          const SizedBox(height: 20),
          numberedPoint(2, "Assemble the Box:", ""),
          bulletPoint("", "Connect the filters together in a cube shape using duct tape, ensuring the airflow arrows point inward.", true, isSubBulletPoint: true),
          const SizedBox(height: 10),
          bulletPoint("", "Use cardboard to create the bottom of the cube.", true, isSubBulletPoint: true),
          const SizedBox(height: 20),
          numberedPoint(3, "Install the Fan:", ""),
          bulletPoint("", "Place the box fan on top of the cube, ensuring it blows air outward", true, isSubBulletPoint: true),
          const SizedBox(height: 10),
          bulletPoint("", "Seal the edges around the fan with duct tape to prevent air leaks.", true, isSubBulletPoint: true),
          const SizedBox(height: 20),
          numberedPoint(4, "Optional: Add a shroud", ""),
          bulletPoint("", "Cut a cardboard shroud to fit over the fan to improve efficiency by reducing backflow.", true, isSubBulletPoint: true),
          const SizedBox(height: 20),
          numberedPoint(5, "Finally, ", "ensure all gaps are sealed with duct tape and place the CR Box in the room."),
          const SizedBox(height: 30),
          bulletPoint("Impact: ", "Installing a single CR box reduces approximately 40% PM 2.5 and PM 10 levels.", false),
        ]
      )
    )
  ];

  return (question, answer);
}

(String, List<Widget>) faq5() {
  String question = "How to install Activated Carbon Sheets (DIY Setup)?";
  List<Widget> answer = [
    Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          numberedPoint(1, "", "Purchase activated carbon sheets designed for air purification."),
          const SizedBox(height: 10),
          numberedPoint(2, "", "Use a cardboard or plastic frame to hold the sheets in place. Ensure the frame allows for airflow through the carbon."),
          const SizedBox(height: 10),
          numberedPoint(3, "", "Place the frame near a fan or air purifier outlet to maximize airflow through the carbon. OR installing activated carbon sheets around the CR Box frame and using Velcro fastener to secure the sheets in position."),
          const SizedBox(height: 10),
          numberedPoint(4, "", "Regularly check VOC levels and replace the carbon sheets as needed."),
          const SizedBox(height: 20),
          bulletPoint("Impact: ", "Installing and using activated carbon filters can reduce TVOC levels by 80%.", false),
        ]
      )
    )
  ];

  return (question, answer);
}

(String, List<Widget>) faq6() {
  String question = "How to increase ventilation in your room?";
  List<Widget> answer = [
    Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          numberedPoint(1, "", "Open windows and doors on opposite sides of your house to create a cross-ventilation system helping air to circulate, reducing CO\u2082 levels."),
          const SizedBox(height: 10),
          numberedPoint(2, "", "Use fans to circulate air and increase ventilation."),
          const SizedBox(height: 10),
          numberedPoint(3, "", "Ensure exhaust fans are installed and used during cooking and bathing to remove moisture and pollutants."),
          const SizedBox(height: 10),
          numberedPoint(4, "", "Natural ventilation option: if possible, plant trees or shrubs to increase natural airflow around your home."),
          const SizedBox(height: 20),
          bulletPoint("Impact: ", "Increasing ventilation can decrease around 50% reduction in CO\u2082 levels.", false),
        ]
      )
    )
  ];

  return (question, answer);
}

(String, List<Widget>) faq7() {
  String question = "How to reduce relative humidity in your room?";
  List<Widget> answer = [
    Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(
            "Install a dehumidifier that takes moisture out of the air in your home.",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          bulletPoint("Impact: ", "Installing and using a dehumidifier can reduce the relative humidity by 20%.", false),
        ]
      )
    )
  ];

  return (question, answer);
}
