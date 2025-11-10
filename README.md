# project_geo

# Tugas 1: Geocoding (Alamat dari Koordinat)

Saat ini kita hanya menampilkan Lat/Lng. Buatlah agar aplikasi menampilkan alamat (nama jalan, kota, dll) dari koordinat yang didapat. Petunjuk:
1. Anda sudah menambahkan paket geocoding di pubspec.yaml.
2. Import paketnya: import ’package:geocoding/geocoding.dart’;
3. Buat variabel String? currentAddress; di MyHomePageState.
4. Buat fungsi baru getAddressFromLatLng(Position position).
5. Panggil fungsi getAddressFromLatLng( currentPosition!) di dalam getLocation dan startTracking (di dalam .listen()) setelah setState untuk currentPosition.
6. Tampilkan currentAddress di UI Anda, di bawah Lat/Lng.

# Penjelasan Fungsi getAddressFromLatLng
1. Fungsi bertipe void yang berarti tidak mengembalikan nilai apapun.
2. Menerima 1 parameter bertipe Position dengan nama position, menampung nilai dari latitude dan longitude dalam Position.
3. Didalamnya ada try catch untuk mengatur error, saat kode mengalami masalah apapun maka akan menjalankan kode didalam catch yakni memberi nilai pada variabel _errorMessage dengan setState.
4. Didalam try, variabel placemarks bertipe list yang menampung nilai bertipe Placemark yakni tipe data yang menampung informasi dari latitude dan longitude termasuk alamat.
5. variabel placemarks memanggil fungsi await placemarkFromCoordinates(latitude, longitude).
6. Dilakukan pengecekan apakah placemarks apakah ada isinya, jika tidak kosong maka ambil index ke-0 dari placemarks, masukkan ke dalam variabel place dengan tipe Placemark.
7. Kemudia perbarui _currentAddress dengan setState, masukkan kombinasi dari place.street (nama jalan), place.locality, place administrativeArea, dan place.country (negara)

Berikut kodenya:
![alt text](image.png)

# Screenshoot Hasil
![alt text](c50149d2-d0df-400e-89da-d4119a7d3c64.jpg)

