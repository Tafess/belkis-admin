import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  
  static const String id='dashboard-screen';
  const DashboardScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      child: const Text(
        'Dashboard',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 36,
        ),
      ),
    );
  }
}
