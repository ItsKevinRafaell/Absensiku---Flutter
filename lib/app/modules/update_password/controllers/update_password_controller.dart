import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController oldPasswordC = TextEditingController();
  TextEditingController newPasswordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePassword() async {
    isLoading.value = true;
    if (oldPasswordC.text.isNotEmpty &&
        newPasswordC.text.isNotEmpty &&
        confirmPasswordC.text.isNotEmpty) {
      if (newPasswordC.text == confirmPasswordC.text) {
        if (oldPasswordC.text != newPasswordC.text) {
          isLoading.value = true;
          try {
            // print('berhasil');
            String emailUser = auth.currentUser!.email!;
            await auth.signInWithEmailAndPassword(
                email: emailUser, password: oldPasswordC.text);
            await auth.currentUser!.updatePassword(newPasswordC.text);
            Get.back();
            Get.snackbar('Berhasil', 'Berhasil Memperbarui Kata Sandi',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                icon: Icon(FontAwesomeIcons.checkCircle));
          } on FirebaseAuthException catch (e) {
            isLoading.value = false;
            if (e.code == 'wrong-password') {
              Get.snackbar('Terjadi Kesalahan', 'Kata Sandi Lama Salah!',
                  backgroundColor: Color.fromARGB(255, 250, 87, 75),
                  colorText: Colors.white,
                  icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
            } else {
              Get.snackbar(
                  'Terjadi Kesalahan',
                  'Tidak Dapat Memperbarui Kata Sandi,'
                      '${e.code.toLowerCase()}',
                  backgroundColor: Color.fromARGB(255, 250, 87, 75),
                  colorText: Colors.white,
                  icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
            }
          }
        } else {
          Get.snackbar('Terjadi Kesalahan',
              'Kata Sandi Baru Harus Berbeda Dengan Kata Sandi Lama!',
              backgroundColor: Color.fromARGB(255, 250, 87, 75),
              colorText: Colors.white,
              icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
        }
      } else {
        Get.snackbar('Terjadi Kesalahan',
            'Kata Sandi Baru Dan Konfirmasi Kata Sandi Harus Sama!',
            backgroundColor: Color.fromARGB(255, 250, 87, 75),
            colorText: Colors.white,
            icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Data Tidak Boleh Kosong!',
          backgroundColor: Color.fromARGB(255, 250, 87, 75),
          colorText: Colors.white,
          icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
    }
  }
}
