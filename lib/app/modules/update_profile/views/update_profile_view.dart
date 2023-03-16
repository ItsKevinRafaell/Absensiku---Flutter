import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  UpdateProfileView({Key? key}) : super(key: key);
  Map<String, dynamic> user = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.emailC.text = user['email'];
    controller.namaC.text = user['nama'];
    controller.nipC.text = user['nip'];

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
              gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple, Colors.pink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
          child: Padding(
            padding: const EdgeInsets.only(top: 120.0),
            child: Center(
              child: SizedBox(
                height: 790,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.only(
                        top: 30, left: 30, right: 30, bottom: 30),
                    children: [
                      Icon(
                        FontAwesomeIcons.userEdit,
                        size: 40,
                        color: Colors.black,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Silahkan Isi Data Untuk Memperbarui Data Profil',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text('Anda Hanya Dapat Mengubah Nama Dan Foto Profil',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                              fontFamily: 'Poppins'),
                          textAlign: TextAlign.center),
                      SizedBox(height: 25),
                      TextField(
                        style: TextStyle(
                            color: Color.fromARGB(255, 170, 170, 170)),
                        readOnly: true,
                        autocorrect: false,
                        controller: controller.nipC,
                        decoration: const InputDecoration(
                          labelText: 'NIP',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        style: TextStyle(fontFamily: 'Poppins'),
                        autocorrect: false,
                        controller: controller.namaC,
                        decoration: const InputDecoration(
                          labelText: 'Nama',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        style: TextStyle(
                            color: Color.fromARGB(255, 170, 170, 170),
                            fontFamily: 'Poppins'),
                        readOnly: true,
                        autocorrect: false,
                        controller: controller.emailC,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          'Foto Profile',
                          style: TextStyle(
                              color: Color.fromARGB(255, 88, 88, 88),
                              fontSize: 14,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GetBuilder<UpdateProfileController>(
                                builder: (c) {
                                  if (c.image != null) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          ClipOval(
                                            child: Container(
                                              height: 80,
                                              width: 80,
                                              child: Image.file(
                                                File(c.image!.path),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                controller
                                                    .deleteProfile(user['uid']);
                                              },
                                              child: Text('Hapus',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins'))),
                                        ],
                                      ),
                                    );
                                  } else {
                                    if (user['foto'] != null) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            ClipOval(
                                              child: Container(
                                                height: 80,
                                                width: 80,
                                                child: Image.network(
                                                  user['foto'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  controller.deleteProfile(
                                                      user['uid']);
                                                },
                                                child: Text('Hapus',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Poppins'))),
                                          ],
                                        ),
                                      );
                                    } else
                                      return Text('Tidak Ada Foto Profil',
                                          style:
                                              TextStyle(fontFamily: 'Poppins'));
                                  }
                                },
                              ),
                              TextButton(
                                onPressed: () => controller.pickImage(),
                                child: Text('Pilih Gambar',
                                    style: TextStyle(fontFamily: 'Poppins')),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () async {
                            if (controller.isLoading.isFalse) {
                              await controller.updateProfile(user["uid"]);
                            }
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ))),
                          child: Text(
                              controller.isLoading.isTrue
                                  ? 'Loading...'
                                  : 'Perbarui Profil',
                              style: TextStyle(fontFamily: 'Poppins')))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
