import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);
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
              margin: EdgeInsets.only(top: 250),
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
                    Icon(IconlyBold.lock, size: 45, color: Colors.black),
                    SizedBox(height: 15),
                    Text(
                      'Silahkan Isi Data Untuk Memperbarui Kata Sandi',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text('Minimal Diisi Dengan 6 Karakter!',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Color.fromARGB(255, 87, 87, 87),
                              fontFamily: 'Poppins',
                              fontSize: 14,
                            ),
                        textAlign: TextAlign.center),
                    SizedBox(height: 25),
                    TextField(
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'Poppins'),
                      autocorrect: false,
                      obscureText: true,
                      controller: controller.oldPasswordC,
                      decoration: const InputDecoration(
                        labelText: 'Kata Sandi Lama',
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
                    TextField(
                      style: TextStyle(fontFamily: 'Poppins'),
                      obscureText: true,
                      autocorrect: false,
                      controller: controller.newPasswordC,
                      decoration: const InputDecoration(
                        labelText: 'Kata Sandi Baru',
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
                    TextField(
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'Poppins'),
                      obscureText: true,
                      autocorrect: false,
                      controller: controller.confirmPasswordC,
                      decoration: const InputDecoration(
                        labelText: 'Konfirmasi Kata Sandi',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                        onPressed: () {
                          if (controller.isLoading.isFalse) {
                            controller.updatePassword();
                          }
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            TextStyle(
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        child: Text(controller.isLoading.isTrue
                            ? 'Loading...'
                            : 'Perbarui Kata Sandi'))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
