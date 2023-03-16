import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxInt pageIndex = 0.obs;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    yield* firestore
        .collection("Pegawai")
        .doc(auth.currentUser!.uid)
        .snapshots();
  }

  void signOut() async {
    await auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
    pageIndex.value = 0;
  }

  void addPegawai() {
    Get.toNamed(Routes.ADD_PEGAWAI);
  }

  void newPassword() {
    Get.toNamed(Routes.UPDATE_PASSWORD);
  }

  void updateProfile() {
    Get.toNamed(Routes.UPDATE_PROFILE);
  }
}
