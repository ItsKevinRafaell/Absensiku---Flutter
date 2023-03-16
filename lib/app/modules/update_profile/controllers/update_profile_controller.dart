import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presence/app/routes/app_pages.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nipC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();

  XFile? image;
  void pickImage() async {
    XFile? newImage = await picker.pickImage(source: ImageSource.gallery);
    if (newImage != null) {
      print(newImage.name);
      print(newImage.name.split('.').last);
      print(newImage.path);
      image = newImage; // update the value of image with the new XFile
      // Upload image to firebase
      // await uploadImage(image);
    } else {
      print('null');
    }
    update();
  }

  Future<void> updateProfile(String uid) async {
    isLoading.value = true;

    if (namaC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      try {
        Map<String, dynamic> data = {
          'nama': namaC.text,
        };
        if (image != null) {
          File file = File(image!.path);

          String ext = image!.name.split('.').last;

          await storage.ref('Foto Profil/$uid/foto_profil.').putFile(file);
          String urlImage = await storage
              .ref('Foto Profil/$uid/foto_profil.')
              .getDownloadURL();

          data.addAll({'foto': urlImage});
        }
        await firestore.collection('Pegawai').doc(uid).update(data);
        image = null;
        Get.offAllNamed(Routes.PROFILE);
        Get.snackbar('Berhasil', "Data berhasil diperbarui",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            icon: Icon(FontAwesomeIcons.checkCircle));
      } catch (e) {
        Get.snackbar('Terjadi Kesalahan', 'Gagal Memperbarui Data',
            backgroundColor: Color.fromARGB(255, 250, 87, 75),
            colorText: Colors.white,
            icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
      } finally {
        isLoading.value = true;
      }
    }
  }

  void deleteProfile(String uid) async {
    try {
      firestore.collection('Pegawai').doc(uid).update({
        'foto': FieldValue.delete(),
      });
      Get.back();
      Get.snackbar('Berhasil', 'Berhasil Menghapus Foto Profil',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(FontAwesomeIcons.checkCircle));
    } catch (e) {
      Get.snackbar('Terjadi Kesalahan', 'Gagal Menghapus Foto Profil',
          backgroundColor: Color.fromARGB(255, 250, 87, 75),
          colorText: Colors.white,
          icon: Icon(FontAwesomeIcons.cancel, color: Colors.white));
    } finally {
      update();
    }
  }
}
