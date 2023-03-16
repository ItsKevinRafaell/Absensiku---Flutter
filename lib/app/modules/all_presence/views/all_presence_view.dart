import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../routes/app_pages.dart';
import '../controllers/all_presence_controller.dart';

class AllPresenceView extends GetView<AllPresenceController> {
  const AllPresenceView({Key? key}) : super(key: key);
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
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          // borderRadius: BorderRadius.circular(20),
        ),
        child: GetBuilder<AllPresenceController>(
            builder: (c) => StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      SizedBox(height: 120),
                      FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          future: controller.getPresence(),
                          builder: (context, snap) {
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (snap.data?.docs.length == 0 ||
                                snap.data?.docs == null) {
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

                            return Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 30.0),
                                      child: Text(
                                        'Riwayat Seluruh Absensi',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontFamily: 'Poppins'),
                                      ),
                                    ),
                                    Expanded(
                                        child: ListView.builder(
                                      padding: EdgeInsets.all(20),
                                      itemCount: snap.data?.docs.length,
                                      itemBuilder: ((context, index) {
                                        Map<String, dynamic> data = snap
                                            .data!.docs.reversed
                                            .toList()[index]
                                            .data();
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Material(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            elevation: 5,
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
                                                            fontFamily:
                                                                'Poppins'),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 100.0),
                                                        child: Text(
                                                          '${DateFormat.yMMMMd().format(DateTime.parse(data['tanggal']))}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
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
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black,
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
                                        );
                                      }),
                                    )),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  );
                })),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.dialog(
              Dialog(
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: 400,
                  child: SfDateRangePicker(
                    monthViewSettings:
                        DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                    selectionMode: DateRangePickerSelectionMode.range,
                    showActionButtons: true,
                    onCancel: () => Get.back(),
                    onSubmit: (obj) {
                      if (obj != null) {
                        if ((obj as PickerDateRange).endDate != null) {
                          controller.pickDate(obj.startDate!, obj.endDate!);
                        }
                      }
                    },
                  ),
                ),
              ),
            );
          },
          child: Icon(FontAwesomeIcons.calendarAlt)),
    );
  }
}
