import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:presence/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';
import 'package:intl/intl.dart';
import '../../../controllers/page_index_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();
  RxInt pageIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: null,
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasData) {
                Map<String, dynamic> user = snapshot.data!.data()!;
                String defaultImage =
                    "https://ui-avatars.com/api/?name=${user['nama']}";
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple, Colors.pink],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    // borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView(
                    // padding: EdgeInsets.all(20),
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
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
                            SizedBox(width: 13),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Container(
                                  width: 240,
                                  child: Text(
                                    'Selamat Datang,',
                                    style: TextStyle(
                                      color: Colors.grey[50],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.2),
                                          offset: Offset(0.5, 0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 260,
                                  child: Text(
                                    user['nama'],
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      height: 1.4, // adjus
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.2),
                                          offset: Offset(0.5, 0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 240,
                                  child: Text(
                                    user['tugas'] + ' - ' + user['nip'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      height: 1.1, // adjus
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.2),
                                          offset: Offset(0.5, 0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                // Container(
                                //   width: 200,
                                //   child: Text(
                                //     user['lokasi'] != null
                                //         ? user['lokasi']
                                //         : 'Tidak Ada Lokasi',
                                //     style: TextStyle(
                                //         fontSize: 12, fontFamily: 'Poppins'),
                                //   ),
                                // )
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            // gradient: LinearGradient(
                            //     colors: [Colors.blue, Colors.purple],
                            //     begin: Alignment.topLeft,
                            //     end: Alignment.bottomRight),
                            color: Colors.grey[50],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(6.0, 6.0),
                                blurRadius: 3.0,
                                spreadRadius: 1.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                  stream: controller.streamTodayAbsen(),
                                  builder: (context, snapToday) {
                                    if (snapToday.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    Map<String, dynamic>? dataToday =
                                        snapToday.data?.data();
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.clock,
                                                  color: Colors.green,
                                                ),
                                                SizedBox(height: 5),
                                                Text('Masuk',
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Text(
                                                  (dataToday?['masuk'] == null
                                                      ? '-'
                                                      : '${DateFormat.jms().format(DateTime.parse(dataToday!['masuk']['tanggal']))}'),
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                            Container(
                                              width: 2,
                                              height: 40,
                                              color: Colors.black,
                                            ),
                                            Column(
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.clock,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(height: 5),
                                                Text('Keluar',
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Text(
                                                  (dataToday?['keluar'] == null
                                                      ? '-'
                                                      : '${DateFormat.jms().format(DateTime.parse(dataToday!['keluar']['tanggal']))}'),
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Lokasi Terakhir:',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                user['lokasi'] != null
                                                    ? '📍' + user['lokasi']
                                                    : 'Tidak Ada Lokasi',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25),
                        child: Divider(
                          color: Colors.grey[50],
                          thickness: 2,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('5 Hari Terakhir',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      fontFamily: 'Poppins')),
                              TextButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.ALL_PRESENCE);
                                  },
                                  child: Text(
                                    'Lihat Semua',
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 0),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: controller.streamLastAbsen(),
                          builder: (context, snapAbsen) {
                            if (snapAbsen.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (snapAbsen.data?.docs.length == 0 ||
                                snapAbsen.data?.docs == null) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                ),
                                height: 400,
                                child: Center(
                                  child: Text(
                                    'Tidak Ada Riwayat Absensi',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Container(
                              // height: 800,
                              padding: EdgeInsets.only(bottom: 143),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapAbsen.data?.docs.length,
                                itemBuilder: ((context, index) {
                                  Map<String, dynamic> data = snapAbsen
                                      .data!.docs.reversed
                                      .toList()[index]
                                      .data();
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      elevation: 5,
                                      child: InkWell(
                                        onTap: () {
                                          Get.toNamed(Routes.DETAIL_PRESENCE,
                                              arguments: data);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]!,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.clock,
                                                    color: Colors.green,
                                                    size: 17,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    ' Masuk',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 120.0),
                                                    child: Text(
                                                      '${DateFormat.yMMMMd().format(DateTime.parse(data['tanggal']))}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Poppins'),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              // SizedBox(height: 3),
                                              Text(
                                                data['masuk'] != null
                                                    ? '${DateFormat.jms().format(DateTime.parse(data['masuk']['tanggal']))}'
                                                    : '-',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Poppins'),
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.clock,
                                                    color: Colors.red,
                                                    size: 18,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text('Keluar',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Poppins')),
                                                ],
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                data['keluar'] != null
                                                    ? '${DateFormat.jms().format(DateTime.parse(data['keluar']['tanggal']))}'
                                                    : '-',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Poppins'),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          })
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text('Data Kosong'),
                );
              }
            }),
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
            initialActiveIndex: 0,
            onTap: (int i) => pageC.changePage(i),
          ),
        ));
  }
}
