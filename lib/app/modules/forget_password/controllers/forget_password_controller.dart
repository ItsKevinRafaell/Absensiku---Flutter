import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void sendEmail() async {
    if (emailC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.back();
        Get.snackbar(
            'Berhasil', 'Tautan Email Telah Dikirim, Silahkan Cek Email Anda',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            icon: Icon(FontAwesomeIcons.checkCircle));
      } catch (e) {
        Get.snackbar('Terjadi Kesalahan', 'Tidak Dapat Mengirimkan Email',
            backgroundColor: Color.fromARGB(255, 250, 87, 75),
            colorText: Colors.white,
            icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Email Tidak Boleh Kosong',
          backgroundColor: Color.fromARGB(255, 250, 87, 75),
          colorText: Colors.white,
          icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
      isLoading.value = false;
    }
  }
}
