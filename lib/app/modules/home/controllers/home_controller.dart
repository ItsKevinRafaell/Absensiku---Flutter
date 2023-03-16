import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    yield* firestore
        .collection("Pegawai")
        .doc(auth.currentUser!.uid)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamLastAbsen() async* {
    yield* firestore
        .collection("Pegawai")
        .doc(auth.currentUser!.uid)
        .collection('Absensi')
        .orderBy('tanggal', descending: false)
        .limitToLast(5)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTodayAbsen() async* {
    String TodayID =
        DateFormat.yMd().format(DateTime.now()).replaceAll('/', '-');

    yield* firestore
        .collection("Pegawai")
        .doc(auth.currentUser!.uid)
        .collection('Absensi')
        .doc(TodayID)
        .snapshots();
  }
}
