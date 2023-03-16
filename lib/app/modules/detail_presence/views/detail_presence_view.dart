import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/detail_presence_controller.dart';

class DetailPresenceView extends GetView<DetailPresenceController> {
  // const DetailPresenceView({Key? key}) : super(key: key);
  final Map<String, dynamic> data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    print(data);
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
            child: ListView(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 20.0, right: 20, bottom: 20),
              children: [
                Container(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Center(
                          child: Text(
                              "${DateFormat.yMMMMEEEEd().format(DateTime.parse(data['tanggal']))}",
                              style: const TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins')),
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 2,
                      ),
                      SizedBox(height: 20),
                      Text("Masuk : ",
                          style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins')),
                      Text(
                        'Jam : ${DateFormat.jms().format(DateTime.parse(data['masuk']['tanggal']))}',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      Text('Lokasi : ${data['masuk']['lokasi']}',
                          style: TextStyle(fontFamily: 'Poppins')),
                      Text(
                          'Jarak: ${data['masuk']['jarak'].toString().split('.').first} m',
                          style: TextStyle(fontFamily: 'Poppins')),
                      Text('Status: ${data['masuk']['status']}',
                          style: TextStyle(fontFamily: 'Poppins')),
                      SizedBox(height: 10),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Keluar : ",
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                          data['keluar']?['tanggal'] == null
                              ? 'Jam: - '
                              : 'Jam : ${DateFormat.jms().format(DateTime.parse(data['keluar']['tanggal']))}',
                          style: TextStyle(fontFamily: 'Poppins')),
                      Text(
                          data['keluar']?['lokasi'] == null
                              ? 'Lokasi: -  '
                              : 'Lokasi : ${data['keluar']['lokasi']}',
                          style: TextStyle(fontFamily: 'Poppins')),
                      Text(
                          data['keluar']?['jarak'] == null
                              ? 'Jarak: -'
                              : 'Jarak: ${data['keluar']['jarak'].toString().split('.').first} m',
                          style: TextStyle(fontFamily: 'Poppins')),
                      Text(
                          data['keluar']?['status'] == null
                              ? 'Status: -'
                              : 'Status: ${data['keluar']['status']}',
                          style: TextStyle(fontFamily: 'Poppins')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
