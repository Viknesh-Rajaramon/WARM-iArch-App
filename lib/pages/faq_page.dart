import "package:flutter/material.dart";

import "package:warm_app/backend/faq_data.dart";

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
        backgroundColor: const Color.fromARGB(255, 28, 117, 188),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: faqData.length,
        itemBuilder: (context, index) => FAQItem(faq: faqData[index]),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final FaqData faq;

  const FAQItem({
    required this.faq,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: const Color.fromARGB(255, 28, 117, 188),
      child: ExpansionTile(
        collapsedBackgroundColor: const Color.fromARGB(255, 28, 117, 188),
        collapsedTextColor: Colors.white,
        collapsedIconColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 28, 117, 188),
        textColor: Colors.white,
        iconColor: Colors.white,
        title: Text(
          faq.question,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: faq.answer,
          ),
        ],
      ),
    );
  }
}
