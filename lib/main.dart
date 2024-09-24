import 'package:filmvault/components/show_tile.dart';
import 'package:filmvault/provider/show_provider.dart';
import 'package:filmvault/screen/home_screen.dart';
import 'package:filmvault/screen/index_screen.dart';
import 'package:filmvault/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ShowProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IndexScreen(),
    );
  }
}
