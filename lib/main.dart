import 'package:flutter/material.dart';
import 'package:locator2/screens/home_screen.dart';
import 'package:locator2/screens/web_screen.dart';

void main() {
  runApp(const MyApp());
}

double lat = 0;
double long = 0;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/' : (context) => const HomePage(),
        'map' : (context) => const MapPage(),
      },
    );
  }
}
