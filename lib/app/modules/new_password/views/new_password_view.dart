import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({Key? key}) : super(key: key);
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
            Get.toNamed(Routes.LOGIN);
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
            margin: EdgeInsets.only(top: 320),
            height: 700,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
              ),
            ),
            child: SizedBox(
              // height: 700,
              child: ListView(
                padding: const EdgeInsets.only(
                    top: 30, left: 30, right: 30, bottom: 30),
                children: [
                  Text(
                    'Silahkan Isi Kata Sandi Baru Anda',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                  // SizedBox(height: 5),
                  Text(
                    'Minimal Di Isi Dengan 6 Karakter',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 5),
                  //   child: Text(
                  //     'Masukkan Kata Sandi:',
                  //     style: TextStyle(
                  //         fontSize: 15, color: Color.fromARGB(255, 87, 87, 87)),
                  //   ),
                  // ),
                  const SizedBox(height: 8),
                  TextField(
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                    autocorrect: false,
                    controller: controller.newPasswordC,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Kata Sandi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => ElevatedButton(
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
                        onPressed: () async {
                          if (controller.isLoading.value == false) {
                            await controller.newPassword();
                          }
                        },
                        child: Text(controller.isLoading.value == true
                            ? 'Tunggu...'
                            : 'Masuk')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
