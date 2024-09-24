import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  const DetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Divider(),
          ],
        ),
      ),
    );
  }
}
