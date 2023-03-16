import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';
import '../../../controllers/page_index_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    print('profil');
    return Scaffold(
        appBar: null,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple, Colors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            // borderRadius: BorderRadius.circular(20),
          ),
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamUser(),
            builder: (context, snap) {
              if (snap.hasData) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                Map<String, dynamic> user = snap.data!.data()!;
                String defaultImage =
                    "https://ui-avatars.com/api/?name=${user['nama']}";

                return Container(
                  margin: EdgeInsets.only(top: 220),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 20,
                        ),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.network(
                              user['foto'] != null
                                  ? user['foto'] != ""
                                      ? user['foto']
                                      : defaultImage
                                  : defaultImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(20),
                          children: [
                            Text(
                              '${user['nama']}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 20,
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins'),
                            ),
                            SizedBox(height: 2),
                            FractionallySizedBox(
                              widthFactor: 0.6,
                              child: Row(
                                children: [
                                  Icon(FontAwesomeIcons.userTie,
                                      color: Colors.black, size: 15),
                                  // SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${user['tugas']} - ${user['nip']}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 90, 90, 90),
                                        fontSize: 13,
                                        letterSpacing: 0.8,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 2),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 70),
                              child: Row(
                                children: [
                                  Icon(FontAwesomeIcons.envelope,
                                      color: Colors.black, size: 15),
                                  SizedBox(width: 8),
                                  Text(
                                    '${user['email']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 90, 90, 90),
                                      fontSize: 13,
                                      letterSpacing: 0.8,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Divider(
                                color: Colors.grey[500],
                                thickness: 1,
                              ),
                            ),
                            SizedBox(height: 20),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  onTap: () {
                                    Get.toNamed(Routes.UPDATE_PROFILE,
                                        arguments: user);
                                  },
                                  leading: Icon(
                                    FontAwesomeIcons.userCircle,
                                    color: Colors.black,
                                  ),
                                  title: Text('Perbarui Profil',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                ),
                                ListTile(
                                  onTap: () {
                                    controller.newPassword();
                                  },
                                  leading: Icon(
                                    IconlyBold.lock,
                                    color: Colors.black,
                                  ),
                                  title: Text('Perbarui Kata Sandi',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                ),
                                if (user['role'] == 'admin')
                                  ListTile(
                                    onTap: () {
                                      controller.addPegawai();
                                    },
                                    leading: Icon(
                                      FontAwesomeIcons.userPlus,
                                      color: Colors.black,
                                    ),
                                    title: Text('Tambah Pegawai',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ListTile(
                                  onTap: () {
                                    controller.signOut();
                                  },
                                  leading: Icon(
                                    FontAwesomeIcons.signOutAlt,
                                    color: Colors.black,
                                  ),
                                  title: Text('Keluar',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
              ;
            },
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: 0),
          child: ConvexAppBar(
            height: 60,
            gradient: LinearGradient(
              colors: [
                Colors.blue!,
                Colors.purple,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            curveSize: 80,
            items: [
              TabItem(
                icon: IconlyBold.home,
                title: 'Beranda',
              ),
              TabItem(icon: FontAwesomeIcons.camera, title: 'Absensi'),
              TabItem(
                icon: IconlyBold.profile,
                title: 'Profil',
              ),
            ],
            initialActiveIndex: pageC.pageIndex.value,
            onTap: (int i) => pageC.changePage(i),
          ),
        ));
  }
}
