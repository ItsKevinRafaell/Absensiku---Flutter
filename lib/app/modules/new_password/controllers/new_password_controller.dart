import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPasswordC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  Future<void> newPassword() async {
    isLoading.value = true;
    if (newPasswordC.text.isNotEmpty) {
      if (newPasswordC.text.length != '123456') {
        try {
          await auth.currentUser!.updatePassword(newPasswordC.text);

          String email = auth.currentUser!.email!;
          await auth.signOut();
          auth.signInWithEmailAndPassword(
              email: email, password: newPasswordC.text);

          Get.offAllNamed(Routes.HOME);
          Get.snackbar('Berhasil', 'Berhasil Membuat Kata Sandi Baru!',
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white,
                                        icon:
                                            Icon(FontAwesomeIcons.checkCircle));
        } on FirebaseAuthException catch (e) {
          isLoading.value = false;
          {
            if (e.code == 'weak-password') {
              Get.snackbar(
                  'Terjadi Kesalahan', 'Setidaknya Memiliki 6 Karakter',
            backgroundColor: Color.fromARGB(255, 250, 87, 75),
            colorText: Colors.white,
            icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
            }
          }
        } catch (e) {
          isLoading.value = false;
          Get.snackbar('Terjadi Kesalahan',
              'Tidak Dapat Menggubah Password, Silahkan Hubungi Admin',
            backgroundColor: Color.fromARGB(255, 250, 87, 75),
            colorText: Colors.white,
            icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
        }
      } else {
        isLoading.value = false;
        Get.snackbar('Terjadi Kesalahan',
            'Password Tidak Boleh Sama Seperti Sebelumnya!',
            backgroundColor: Color.fromARGB(255, 250, 87, 75),
            colorText: Colors.white,
            icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
      }
    } else {
      isLoading.value = false;
      Get.snackbar('Terjadi Kesalahan ', 'Password Baru Wajib Di Isi!',
            backgroundColor: Color.fromARGB(255, 250, 87, 75),
            colorText: Colors.white,
            icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
    }
  }
}
