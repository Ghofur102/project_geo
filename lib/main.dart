import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum Geolocator (Dasar)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // --- Variabel State Utama ---
  Position? _currentPosition; // Menyimpan data lokasi
  String? _errorMessage; // Menyimpan pesan error
  StreamSubscription<Position>? _positionStream; // Penyimpan stream

  // Variabel untuk Latihan 1 dan 2 telah dihapus dari versi ini
  String? _currentAddress; // Menyimpan alamat (Latihan 2)

  @override
  void dispose() {
    // PENTING: Selalu batalkan stream saat widget dihancurkan
    _positionStream?.cancel();
    super.dispose();
  }

  Future<Position> _getPermissionAndLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Cek apakah layanan lokasi (GPS) di perangkat aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Jika tidak aktif, kirim error
      return Future.error('Layanan lokasi tidak aktif. Harap aktifkan GPS.');
    }

    // 2. Cek izin lokasi dari aplikasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Jika ditolak, minta izin
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Jika tetap ditolak, kirim error
        return Future.error('Izin lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Jika ditolak permanen, kirim error
      return Future.error(
        'Izin lokasi ditolak permanen. Harap ubah di pengaturan aplikasi.',
      );
    }

    // 3. Jika izin diberikan, ambil lokasi saat ini
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void _handleGetLocation() async {
    try {
      Position position = await _getPermissionAndLocation();
      setState(() {
        _currentPosition = position;
        _errorMessage = null; // Hapus error jika sukses
      });

      getAddressFromLatLng(position); // Panggil fungsi untuk mendapatkan alamat

      // Fungsi Latihan 1 & 2 dihapus dari sini
    } catch (e) {
      setState(() {
        _errorMessage = e.toString(); // Tampilkan error di UI
      });
    }
  }

  void _handleStartTracking() {
    _positionStream?.cancel();

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update setiap ada pergerakan 10 meter
    );

    try {
      // Mulai mendengarkan stream
      _positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) {
        setState(() {
          _currentPosition = position;
          _errorMessage = null;
        });
        getAddressFromLatLng(position); // Panggil fungsi untuk mendapatkan alamat
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _handleStopTracking() {
    _positionStream?.cancel(); // Hentikan stream
    setState(() {
      _errorMessage = "Pelacakan dihentikan.";
    });
  }
  void getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Gagal mendapatkan alamat: $e";
      });
    }
  }

  // --- TAMPILAN (UI) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Praktikum Geolocator (Dasar)")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 50, color: Colors.blue),
                const SizedBox(height: 16),

                // --- Area Tampilan Informasi ---
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 150),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tampilkan Error
                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),

                      const SizedBox(height: 16),

                      // Tampilkan Posisi (Lat/Lng)
                      if (_currentPosition != null)
                        Text(
                          "Lat: ${_currentPosition!.latitude}\nLng: ${_currentPosition!.longitude}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      const SizedBox(height: 16),
                      // Tampilkan Alamat (Latihan 2)
                      if (_currentAddress != null)
                        Text(
                          "Alamat: $_currentAddress",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Tombol Dapatkan Lokasi Sekarang
                ElevatedButton.icon(
                  icon: const Icon(Icons.location_searching),
                  label: const Text('Dapatkan Lokasi Sekarang'),
                  onPressed: _handleGetLocation,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Tombol Mulai/Hentikan Pelacakan
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Mulai Lacak'),
                      onPressed: _handleStartTracking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.stop),
                      label: const Text('Henti Lacak'),
                      onPressed: _handleStopTracking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}