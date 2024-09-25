import 'package:filmvault/provider/favourite_provider.dart';
import 'package:filmvault/provider/show_provider.dart';
import 'package:filmvault/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ShowProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => FavouriteProvider(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Gotham', // netflix font
      ),
      home: const SplashScreen(),
    );
  }
}
