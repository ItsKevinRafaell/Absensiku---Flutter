import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import '../controllers/forget_password_controller.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  const ForgetPasswordView({Key? key}) : super(key: key);
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
            margin: EdgeInsets.only(top: 260),
            height: 700,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
              ),
            ),
            child: SizedBox(
              height: 500,
              child: ListView(
                padding: const EdgeInsets.only(
                    top: 30, left: 30, right: 30, bottom: 30),
                children: [
                  Text(
                    'Masukkan Email',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 27,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Kami akan mengirimkan tautan untuk memperbarui password anda',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    style: TextStyle(fontFamily: 'Poppins'),
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
                  const SizedBox(height: 10),
                  Obx(() => ElevatedButton(
                      onPressed: () {
                        if (controller.isLoading.isFalse) {
                          controller.sendEmail();
                        }
                      },
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ))),
                      child: Text(
                          controller.isLoading.value == true
                              ? 'Tunggu...'
                              : 'Kirim Email',
                          style: TextStyle(fontFamily: 'Poppins'))))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
