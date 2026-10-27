import 'package:flutter/material.dart';
import 'package:real_time_loc/home_screen.dart';

class RealTimeLocApp extends StatefulWidget {
  const RealTimeLocApp({super.key});

  @override
  State<RealTimeLocApp> createState() => _RealTimeLocAppState();
}

class _RealTimeLocAppState extends State<RealTimeLocApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}
