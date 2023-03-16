import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presence/app/modules/home/controllers/home_controller.dart';

import '../../../routes/app_pages.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddPegawai = false.obs;
  TextEditingController nipC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();
  TextEditingController tugasC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
    if (passAdminC.text.isNotEmpty) {
      isLoadingAddPegawai.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;

        UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passAdminC.text,
        );

        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "123456",
        );

        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;

          await firestore.collection("Pegawai").doc(uid).set({
            "nama": namaC.text,
            "nip": nipC.text,
            "email": emailC.text,
            "uid": uid,
            "role": "pegawai",
            'tugas': tugasC.text,
            "createdAt": DateTime.now().toIso8601String(),
          });

          await userCredential.user!.sendEmailVerification();

          await auth.signOut();

          UserCredential userCredentialAdmin =
              await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passAdminC.text,
          );

          Get.back();
          Get.back();
          isLoadingAddPegawai.value = false;
          Get.snackbar('Berhasil', 'Berhasil Menambahkan Pegawai',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              icon: Icon(FontAwesomeIcons.checkCircle));
        }

        print(userCredential);
      } on FirebaseAuthException catch (e) {
        isLoadingAddPegawai.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar("Terjadi Kesalahan", "Password terlalu lemah",
              backgroundColor: Color.fromARGB(255, 250, 87, 75),
              colorText: Colors.white,
              icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar(
              "Terjadi Kesalahan", "Pegawai sudah terdaftar, silahkan login",
              backgroundColor: Color.fromARGB(255, 250, 87, 75),
              colorText: Colors.white,
              icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Terjadi Kesalahan',
              'Password Salah, Tidak Dapat Memvalidasi Admin',
              backgroundColor: Color.fromARGB(255, 250, 87, 75),
              colorText: Colors.white,
              icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
        } else {
          Get.snackbar('Terjadi Kesalahan', "${e.code} ${e.message}",
              backgroundColor: Color.fromARGB(255, 250, 87, 75),
              colorText: Colors.white,
              icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
        }
      } catch (e) {
        isLoadingAddPegawai.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak Dapat Menambahkan Pegawai",
            backgroundColor: Color.fromARGB(255, 250, 87, 75),
            colorText: Colors.white,
            icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
      }
    } else {
      isLoading.value = false;
      Get.snackbar(
          'Terjadi Kesalahan', 'Password Wajib Di Isi Untuk Keperluan Validasi',
          backgroundColor: Color.fromARGB(255, 250, 87, 75),
          colorText: Colors.white,
          icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
    }
  }

  Future<void> addPegawai() async {
    isLoading.value = true;
    if (nipC.text.isNotEmpty &&
        namaC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        tugasC.text.isNotEmpty) {
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
                        Text('Validasi Admin',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins')),
                        Text("Silahkan Masukan Password Admin",
                            style: TextStyle(fontFamily: 'Poppins')),
                        SizedBox(height: 10),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        TextField(
                          controller: passAdminC,
                          autocorrect: false,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              )),
                        ),
                        const SizedBox(height: 20),
                        //Buttons
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                                child: Obx(
                              () => ElevatedButton(
                                  onPressed: () async {
                                    if (isLoadingAddPegawai.isFalse) {
                                      await prosesAddPegawai();
                                      isLoading.value = false;
                                    }
                                  },
                                  child: Text(
                                      isLoadingAddPegawai.value == true
                                          ? "Loading..."
                                          : "Submit",
                                      style: TextStyle(fontFamily: 'Poppins'))),
                            )),
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
      Get.snackbar("Terjadi Kesalahan", "Data tidak boleh kosong",
          backgroundColor: Color.fromARGB(255, 250, 87, 75),
          colorText: Colors.white,
          icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
    }
  }
}
