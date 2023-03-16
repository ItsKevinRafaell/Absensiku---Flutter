import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxInt pageIndex = 0.obs;
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        final credential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passwordC.text);

        if (credential.user != null) {
          if (credential.user!.emailVerified == true) {
            if (passwordC.text == '123456') {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
              pageIndex.value = 0;
              Get.snackbar('Berhasil', 'Anda Telah Berhasil Masuk',
                  backgroundColor: Color.fromARGB(255, 117, 228, 121),
                  colorText: Colors.black,
                  icon: Icon(FontAwesomeIcons.checkCircle));
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
                                "Verifikasi Email",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                "Silahkan Verifikasi Email Anda Untuk Melanjutkan Proses Login",
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
                                        style: TextStyle(fontFamily: 'Poppins'),
                                      ),
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
                                      child: const Text(
                                        'Kirim Email Verifikasi',
                                        style: TextStyle(fontFamily: 'Poppins'),
                                        textAlign: TextAlign.center,
                                      ),
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
                                        try {
                                          await credential.user!
                                              .sendEmailVerification();
                                          Get.back();
                                          Get.snackbar('Berhasil',
                                              'Berhasil Mengirim Ulang Email Verifikasi',
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              icon: Icon(FontAwesomeIcons
                                                  .checkCircle));
                                          isLoading.value = false;
                                        } catch (e) {
                                          isLoading.value = false;
                                          Get.snackbar('Terjadi Kesalahan',
                                              'Tidak Dapat Mengirim Ulang Email Verifikasi',
                                              backgroundColor: Color.fromARGB(
                                                  255, 250, 87, 75),
                                              colorText: Colors.white,
                                              icon: Icon(
                                                  FontAwesomeIcons.cancel,
                                                  color: Colors.white));
                                        }
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
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar('Terjadi Kesalahan', 'User Tidak Di Temukan',
              backgroundColor: Color.fromARGB(255, 250, 87, 75),
              colorText: Colors.white,
              icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
              'Terjadi Kesalahan', 'Password Salah, Silahkan Coba Kembali',
              backgroundColor: Color.fromARGB(255, 250, 87, 75),
              colorText: Colors.white,
              icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
        } else if (e.code == 'invalid-email') {
          Get.snackbar('Terjadi Kesalahan', 'Email Tidak Valid',
              backgroundColor: Color.fromARGB(255, 250, 87, 75),
              colorText: Colors.white,
              icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
        } else if (e.code == 'too-many-requests') {
          Get.snackbar('Terjadi Kesalahan',
              'Terlalu Banyak Permintaan, Silahkan Coba Lagi Nanti',
              backgroundColor: Color.fromARGB(255, 250, 87, 75),
              colorText: Colors.white,
              icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
        } else {
          Get.snackbar('Terjadi Kesalahan', 'Error: ${e.code}',
              backgroundColor: Color.fromARGB(255, 250, 87, 75),
              colorText: Colors.white,
              icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
        }
      } catch (e) {
        Get.snackbar('Terjadi Kesalahan', 'Error: $e',
            backgroundColor: Color.fromARGB(255, 250, 87, 75),
            colorText: Colors.white,
            icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
      }
    }
  }
}
