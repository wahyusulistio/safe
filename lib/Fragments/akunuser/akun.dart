import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/akunuser/admin/daftarjenistest.dart';
import 'package:safe/Fragments/akunuser/admin/managetest.dart';
import 'package:safe/Fragments/dialogconfirm.dart';
import 'package:safe/Fragments/akunuser/historypeserta.dart';
import 'package:safe/Fragments/kelasfasil/kelasfasil.dart';
import 'package:safe/Pages/LoginSignupPage2.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';

class Akun extends StatefulWidget {
  @override
  _AkunState createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  ApiService apiService = Get.find(tag: 'apiserv1');

  String nama = "";
  String nip = "";
  String role = "";
  String foto="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SecureStorageHelper.getListString("userinfo")
        .then((value) {
      setState(() {
        if (value != null) {
          nama = value[2].toString();
          nip = value[3].toString();
          role = value[6].toString();
          foto=value[5].toString();
          print("role daro storage:" + role);
        } else {
          //print("username1 $value");
        }
      });
    });
  }

  /*void GetInfoUser() async {

    List<String>? userinfo = await SecureStorageHelper.getListString("userinfo" + authService.getUserId());
    if(userinfo!=null){
      setState(() {
        nama = userinfo[2].toString();
        nip = userinfo[3].toString();
        role=userinfo[5].toString();
      });
    }

  }*/

  @override
  Widget build(BuildContext context) {
    return
        //SafeArea(
        //child:
        Scaffold(
          //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Akun"),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.white,
      //backgroundColor: Color(0xff7bb61c),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Card(
              child: Container(
                height: (MediaQuery.of(context).size.height * 0.4) - 80,
                width: MediaQuery.of(context).size.width,
                //color: Colors.grey.withOpacity(0.8),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.1),
                  child: Column(children: [
                    CachedNetworkImage(
                      imageUrl:  foto,
                      imageBuilder: (context, imageProvider) => Container(
                        width: MediaQuery.of(context).size.height * 0.2,
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/blank_avatar.png",
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.width * 0.2,
                      ),//Icon(Icons.error),

                      //placeholder: CircularProgressIndicator(),
                      //errorWidget: Icon(Icons.error),
                    ),
                    /*CircleAvatar(
                      radius: MediaQuery.of(context).size.height * 0.1,
                      backgroundImage: new NetworkImage(
                          "https://sisdm.bpk.go.id/photo/$nip/sm.jpg"),
                    ),*/
                    Text(
                      nama,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    ),
                    /*Text(
                      "Bidang Keahlian",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    )*/
                  ]),
                ),
              ),
            ),
            Card(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                //color: Colors.grey.withOpacity(0.8),
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height/15,
                          //flex: 2,
                          child: Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.02),
                            child: InkWell(
                              onTap: () {
                                //Get.to(() => RiwayatKonsultasi());
                                Get.to(()=>HistoryPeserta());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: FaIcon(FontAwesomeIcons.book,
                                            size:
                                                MediaQuery.of(context).size.width *
                                                    0.08),
                                      )),
                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      children: [
                                        Text("Riwayat Test Anda",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: FaIcon(FontAwesomeIcons.angleRight,
                                            size:
                                                MediaQuery.of(context).size.width *
                                                    0.08),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 10,
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                        ),
                        // Expanded(
                        //   flex: 2,
                        //   child: Padding(
                        //     padding: EdgeInsets.all(
                        //         MediaQuery.of(context).size.width * 0.02),
                        //     child: InkWell(
                        //       onTap: () {
                        //         //Get.to(() => RiwayatExpert());
                        //       },
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Expanded(
                        //               flex: 1,
                        //               child: Align(
                        //                 alignment: Alignment.centerLeft,
                        //                 child: FaIcon(FontAwesomeIcons.calendarAlt,
                        //                     size:
                        //                         MediaQuery.of(context).size.width *
                        //                             0.08),
                        //               )),
                        //           Expanded(
                        //             flex: 5,
                        //             child: Row(
                        //               children: [
                        //                 Text("Jadwal Expert",
                        //                     style: TextStyle(
                        //                         fontSize: MediaQuery.of(context)
                        //                                 .size
                        //                                 .width *
                        //                             0.05)),
                        //               ],
                        //             ),
                        //           ),
                        //           Expanded(
                        //               flex: 1,
                        //               child: Align(
                        //                 alignment: Alignment.centerRight,
                        //                 child: FaIcon(FontAwesomeIcons.angleRight,
                        //                     size:
                        //                         MediaQuery.of(context).size.width *
                        //                             0.08),
                        //               )),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // const Divider(
                        //   height: 10,
                        //   thickness: 1,
                        //   indent: 10,
                        //   endIndent: 10,
                        // ),
                        role=="admin" ? Container(
                          height: MediaQuery.of(context).size.height/15,
                          //flex: 2,
                          child: Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: FaIcon(FontAwesomeIcons.bookmark,
                                          size: MediaQuery.of(context).size.width *
                                              0.08),
                                    )),
                                Expanded(
                                        flex: 5,
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(() => DaftarJenisTest());
                                          },
                                          child: Row(
                                            children: [
                                              Text("Riwayat Semua Pegawai",
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05)),
                                            ],
                                          ),
                                        ),
                                      ),
                                Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: FaIcon(FontAwesomeIcons.angleRight,
                                          size: MediaQuery.of(context).size.width *
                                              0.08),
                                    )),
                              ],
                            ),
                          ),
                        ) : SizedBox(),
                        role=="admin" ? const Divider(
                          height: 10,
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                        ):SizedBox(),
                        role=="admin" ? Container(
                          height: MediaQuery.of(context).size.height/15,
                          //flex: 2,
                          child: Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: FaIcon(FontAwesomeIcons.cogs,
                                          size: MediaQuery.of(context).size.width *
                                              0.08),
                                    )),
                                Expanded(
                                  flex: 5,
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(()=>ManageAssessment());
                                    },
                                    child: Row(
                                      children: [
                                        Text("Tools Assessment",
                                            style: TextStyle(
                                                fontSize:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.05)),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: FaIcon(FontAwesomeIcons.angleRight,
                                          size: MediaQuery.of(context).size.width *
                                              0.08),
                                    )),
                              ],
                            ),
                          ),
                        ) : SizedBox(),
                        role=="admin" ? const Divider(
                          height: 10,
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                        ):SizedBox(),
                        Container(
                          height: MediaQuery.of(context).size.height/15,
                          //flex: 2,
                          child: Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.02),
                            child: InkWell(
                              onTap: () async {

                                //copy semua firebase docs ke sql server
                                //ubah status reservasi jd 5 (selesai)
                                //tampilkan pilihan rating
                                var datares = await Get.defaultDialog(
                                  content: MyDialogConfirm(
                                      info: "Signout dari Aplikasi ini?"),
                                  titleStyle: TextStyle(fontSize: 0),
                                );
                                Map<String, dynamic> json =
                                jsonDecode(datares.toString());
                                if (json["respon"] == "ya") {
                                  apiService.logout();
                                  Get.off(() => LoginSignupPage2());
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: FaIcon(FontAwesomeIcons.signOutAlt,
                                            size:
                                                MediaQuery.of(context).size.width *
                                                    0.08),
                                      )),
                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      children: [
                                        Text("Keluar",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: FaIcon(FontAwesomeIcons.angleRight,
                                            size:
                                                MediaQuery.of(context).size.width *
                                                    0.08),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    //);
  }
}
