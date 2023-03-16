import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

DateTime? start;
DateTime end = DateTime.now();

class AllPresenceController extends GetxController {
  Future<QuerySnapshot<Map<String, dynamic>>> getPresence() async {
    if (start == null) {
      return await firestore
          .collection("Pegawai")
          .doc(auth.currentUser!.uid)
          .collection('Absensi')
          .where('tanggal', isLessThan: end.toIso8601String())
          .orderBy('tanggal', descending: false)
          .get();
    } else {
      return await firestore
          .collection("Pegawai")
          .doc(auth.currentUser!.uid)
          .collection('Absensi')
          .where('tanggal', isGreaterThan: start!.toIso8601String())
          .where('tanggal',
              isLessThan: end.add(Duration(days: 1)).toIso8601String())
          .orderBy('tanggal', descending: false)
          .get();
    }
  }

  void pickDate(DateTime pickStart, DateTime pickEnd) {
    start = pickStart;
    end = pickEnd;
    update();
    Get.back();
  }
}
