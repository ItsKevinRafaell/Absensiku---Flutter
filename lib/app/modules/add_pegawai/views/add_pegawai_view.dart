import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import '../controllers/add_pegawai_controller.dart';

class AddPegawaiView extends GetView<AddPegawaiController> {
  const AddPegawaiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 0, 140, 255),
              Colors.purple,
              Colors.pink
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            // borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 200),
              height: 700,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                ),
              ),
              child: SizedBox(
                height: 700,
                child: ListView(
                  padding: const EdgeInsets.only(
                      top: 30, left: 30, right: 30, bottom: 30),
                  children: [
                    Icon(
                      FontAwesomeIcons.userPlus,
                      color: Colors.black,
                      size: 45,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Silahkan Isi Data Untuk Menambahkan Pegawai',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Isi NIP, Nama Dan Email Pegawai',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(255, 87, 87, 87),
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25),
                    SizedBox(height: 8),
                    TextField(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      autocorrect: false,
                      controller: controller.nipC,
                      decoration: const InputDecoration(
                        labelText: 'NIP',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(height: 8),
                    TextField(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      autocorrect: false,
                      controller: controller.namaC,
                      decoration: const InputDecoration(
                        labelText: 'Nama',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(height: 8),
                    TextField(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      autocorrect: false,
                      controller: controller.tugasC,
                      decoration: const InputDecoration(
                        labelText: 'Jabatan',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(height: 8),
                    TextField(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      autocorrect: false,
                      controller: controller.emailC,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(height: 15),
                    ElevatedButton(
                        onPressed: () async {
                          if (controller.isLoading.isFalse) {
                            await controller.addPegawai();
                          }
                          // print('tap');
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ))),
                        child: Text(
                          controller.isLoading.isTrue
                              ? 'Loading...'
                              : 'Tambah Pegawai',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
