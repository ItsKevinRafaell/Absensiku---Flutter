import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';

class PageIndexController extends GetxController {
  // RxInt pageIndex = i.obs;
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void changePage(int i) async {
    switch (i) {
      case 1:
        Map<String, dynamic> dataResponse = await determinePosition();
        if (dataResponse['error'] != true) {
          Position position = dataResponse['position'];

          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          double distance = Geolocator.distanceBetween(
              -1.2495105, 116.8733436, position.latitude, position.longitude);

          String lokasi =
              '${placemarks[3].street}, ${placemarks[3].subLocality}, ${placemarks[3].locality}';

          await absensi(position, lokasi, distance);
          await updatePosition(position, lokasi);
        } else {
          Get.snackbar('Terjadi Kesalahan', dataResponse['message']);
        }
        break;
      case 2:
        Get.offNamed(Routes.PROFILE);

        break;
      default:
        Get.offNamed(Routes.HOME);
        break;
    }
    // set the active index to the new page index
    pageIndex.value = i;
  }

  Future<void> absensi(
      Position position, String lokasi, double distance) async {
    String uid = await auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colAbsensi =
        await firestore.collection('Pegawai').doc(uid).collection('Absensi');

    QuerySnapshot<Map<String, dynamic>> snapAbsensi = await colAbsensi.get();

    DateTime now = DateTime.now();
    String TodayDocID = DateFormat.yMd().format(now).replaceAll('/', '-');

    String status = distance <= 450 ? 'Dalam Area' : 'Luar Area';

    Text validasi = Text(
      'Validasi Absensi',
      style: TextStyle(fontFamily: 'Poppins'),
    );

    try {
      if (snapAbsensi.docs.length == 0) {
        Get.dialog(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Material(
                      color: Colors.white,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "Validasi Absensi",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Apakah Kamu Yakin Ingin Mengisi Absensi-Masuk Hari Ini, Sekarang?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          //Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  child: const Text(
                                    'Tidak',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(0, 45),
                                    primary: Color.fromARGB(255, 236, 77, 77),
                                    onPrimary: const Color(0xFFFFFFFF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => Get.back(),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  child: const Text(
                                    'Iya',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(0, 45),
                                    primary: Color.fromARGB(255, 108, 199, 111),
                                    onPrimary: const Color(0xFFFFFFFF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await colAbsensi.doc(TodayDocID).set({
                                      'tanggal': now.toIso8601String(),
                                      'masuk': {
                                        'tanggal': now.toIso8601String(),
                                        'latitude': position.latitude,
                                        'longitude': position.longitude,
                                        'lokasi': lokasi,
                                        'status': status,
                                        'jarak': distance
                                      }
                                    });
                                    Get.back();
                                    Get.snackbar('Berhasil',
                                        'Absen Masuk Kamu Hari Ini Telah Di Simpan',
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white,
                                        icon:
                                            Icon(FontAwesomeIcons.checkCircle));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        DocumentSnapshot<Map<String, dynamic>> todayDoc =
            await colAbsensi.doc(TodayDocID).get();

        if (todayDoc.exists) {
          Map<String, dynamic>? dataPresenceToday = todayDoc.data();
          if (dataPresenceToday?["keluar"] != null) {
            Get.snackbar('Sukses',
                'Anda Sudah Absen Masuk & Keluar Hari Ini, Silahkan Absen Kembali DI Esok Hari',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                icon: Icon(FontAwesomeIcons.checkCircle));
          } else {
            Get.dialog(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Material(
                          color: Colors.white,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                "Validasi Absensi",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                "Apakah Kamu Yakin Ingin Mengisi Absensi-Keluar Hari Ini, Sekarang?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 20),
                              //Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      child: const Text('Tidak',
                                          style:
                                              TextStyle(fontFamily: 'Poppins')),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(0, 45),
                                        primary:
                                            Color.fromARGB(255, 236, 77, 77),
                                        onPrimary: const Color(0xFFFFFFFF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () => Get.back(),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      child: const Text('Iya',
                                          style:
                                              TextStyle(fontFamily: 'Poppins')),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(0, 45),
                                        primary:
                                            Color.fromARGB(255, 108, 199, 111),
                                        onPrimary: const Color(0xFFFFFFFF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await colAbsensi
                                            .doc(TodayDocID)
                                            .update({
                                          'keluar': {
                                            'tanggal': now.toIso8601String(),
                                            'latitude': position.latitude,
                                            'longitude': position.longitude,
                                            'lokasi': lokasi,
                                            'status': status,
                                            'jarak': distance
                                          }
                                        });
                                        Get.back();
                                        Get.snackbar('Berhasil',
                                            'Absen Masuk Kamu Hari Ini Telah Di Simpan',
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                            icon: Icon(
                                                FontAwesomeIcons.checkCircle));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          Get.dialog(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Material(
                        color: Colors.white,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              "Validasi Absensi",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Apakah Kamu Yakin Ingin Mengisi Absensi-Masuk Hari Ini, Sekarang?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            //Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    child: const Text(
                                      'Tidak',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(0, 45),
                                      primary: Color.fromARGB(255, 236, 77, 77),
                                      onPrimary: const Color(0xFFFFFFFF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () => Get.back(),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    child: const Text(
                                      'Iya',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(0, 45),
                                      primary:
                                          Color.fromARGB(255, 108, 199, 111),
                                      onPrimary: const Color(0xFFFFFFFF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () async {
                                      await colAbsensi.doc(TodayDocID).set({
                                        'tanggal': now.toIso8601String(),
                                        'masuk': {
                                          'tanggal': now.toIso8601String(),
                                          'latitude': position.latitude,
                                          'longitude': position.longitude,
                                          'lokasi': lokasi,
                                          'status': status,
                                          'jarak': distance
                                        }
                                      });
                                      Get.back();
                                      Get.snackbar('Berhasil',
                                          'Absen Masuk Kamu Hari Ini Telah Di Simpan',
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
                                          icon: Icon(
                                              FontAwesomeIcons.checkCircle));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      Get.snackbar('', 'erro $e');
    }
  }

  Future<void> updatePosition(Position position, String lokasi) async {
    String uid = await auth.currentUser!.uid;

    await firestore.collection('Pegawai').doc(uid).update({
      "koordinat": {
        "latitude": position.latitude,
        "longitude": position.longitude,
      },
      "lokasi": lokasi
    });
    print('ini berhasil');
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
      return {
        "message":
            "Gagal Mendapatkan Lokasi User, Silahkan Aktifkan GPS Terlebih Dahulu.",
        "error": true
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return {
          "message":
              "Gagal Mendapatkan Lokasi User, Akses GPS Di Tolak. Silahkan Aktifkan GPS Terlebih Dahulu.",
          "error": true
        };
        // return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "Gagal Mendapatkan Lokasi User, Silahkan Aktifkan GPS Terlebih Dahulu.",
        "error": true
      };
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {"position": position, "message": "Berhasil.", "error": false};
  }
}
