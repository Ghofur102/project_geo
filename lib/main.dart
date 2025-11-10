import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum Geolocator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends StatefulWidget {
  @override
  Position? _currentPosition;
  String? _errorMessage;

  // koordinat PNB
  final double _pnbLatitude = -6.895747;
  final double _pnbLongitude = 107.610149;

  
}