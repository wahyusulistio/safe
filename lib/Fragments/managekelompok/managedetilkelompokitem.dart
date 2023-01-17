import 'dart:convert';
import 'dart:math';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/dialogconfirm.dart';
import 'package:safe/Fragments/managekelompok/dialogpesertakelompok.dart';
import 'package:safe/Models/Group.dart';
import 'package:safe/Models/Grouping.dart';
import 'package:safe/Models/Peserta.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:safe/Models/Kelas.dart';
import 'package:safe/Utilities/navigator_key.dart';

class ManageDetilKelompokItem extends StatefulWidget {
  const ManageDetilKelompokItem(
      {Key? key,
      required this.group,
      required this.kls,
      required this.grouping})
      : super(key: key);

  final Group group;
  final Kelas kls;
  final Grouping grouping;

  @override
  State<ManageDetilKelompokItem> createState() =>
      _ManageDetilKelompokItemState();
}

class _ManageDetilKelompokItemState extends State<ManageDetilKelompokItem> {
  ApiService apiService = Get.find(tag: 'apiserv1');
//  static String jwttoken = "";
  String nama = "";
  String nip = "";
  String role = "";
  int expanded = 0;
  late Group group;
  late Kelas kls;
  late Grouping grouping;
  bool isSwitched = false;
  bool groupset = false;
  bool isExist = true;
  // List<Peserta> psrts = <Peserta>[Peserta(fullname: "fullname1", niplama: "niplama1", nipbaru: "nipbaru1"),
  //   Peserta(fullname: "fullname2", niplama: "niplama2", nipbaru: "nipbaru2"),
  //   Peserta(fullname: "fullname3", niplama: "niplama3", nipbaru: "nipbaru3")];

  List<Peserta> psrtkelasall = <Peserta>[];

  List<Peserta> psrts = <Peserta>[];
  String selectedgrouping = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    group = widget.group;
    kls = widget.kls;
    grouping = widget.grouping;
    SecureStorageHelper.getListString("userinfo").then((value) {
      setState(() {
        if (value != null) {
          nama = value[2].toString();
          nip = value[3].toString();
          role = value[6].toString();

          getPesertaInGroup();
          //getPesertaInKelas();
        } else {
          //print("username1 $value");
        }
      });
    });
  }

  Future<void> getPesertaInGroup() async {
    //print("groupingid "+widget.grouping.groupingid);
    var req =
        await apiService.getPesertaInGroup(user: nip, idgroup: group.groupid);
    //print(req.body);
    List<Peserta> tpsrts = <Peserta>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        //print("data:"+json.decode(req.body)['data'][i]);
        tpsrts.add(Peserta.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    //print("jumlah "+tgrouping.length.toString());
    psrts.clear();
    setState(() {
      psrts = tpsrts;
    });
  }

  Future<void> getPesertaInKelas() async {
    //print("groupingid "+widget.grouping.groupingid);
    var req =
        await apiService.getPesertaInKelasNonGroup(user: nip, idkelas: kls.id_kelas, idgrouping: grouping.groupingid);
    //print(req.body);
    List<Peserta> tpsrts = <Peserta>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        //print("data:"+json.decode(req.body)['data'][i]);
        tpsrts.add(Peserta.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    //print("jumlah "+tgrouping.length.toString());
    psrtkelasall.clear();
    setState(() {
      psrtkelasall = tpsrts;
    });
  }

  ExpansionTile makeListTile(Group group) {
    return ExpansionTile(
      //contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: getGroupIcon(group),
        /*Icon(
              Icons.autorenew,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.04,
            ),*/
      ),
      title: Text(
        group.groupname,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: max(MediaQuery.of(context).size.width * 0.03, 15)),
      ),
      trailing: expanded == 0
          ? Icon(Icons.keyboard_arrow_down,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.04)
          : Icon(Icons.keyboard_arrow_up,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.04),
      onExpansionChanged: (bool expanding) {
        if (expanding == true)
          setState(() {
            expanded = 1;
          });
        else
          setState(() {
            expanded = 0;
          });
      },
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      // subtitle: Row(
      //   children: <Widget>[
      //     /*Expanded(
      //         flex: 1,
      //         child: Container(
      //           // tag: 'hero',
      //           child: LinearProgressIndicator(
      //               backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
      //               value: lesson.indicatorValue,
      //               valueColor: AlwaysStoppedAnimation(Colors.green)),
      //         )),*/
      //     Expanded(
      //       flex: 4,
      //       child: Padding(
      //           padding: EdgeInsets.only(left: 0.0, bottom: 5, top: 5),
      //           child: Text(indasmnt.asmntname,
      //               style: TextStyle(
      //                   color: Colors.white,
      //                   fontSize: max(
      //                       MediaQuery.of(context).size.width * 0.02, 10)))),
      //     ),
      //
      //     // Expanded(
      //     //   flex: 4,
      //     //   child: Padding(
      //     //       padding: EdgeInsets.only(left: 0.0),
      //     //       child: Text(kelas.namamatadiklat,
      //     //           style: TextStyle(
      //     //               color: Colors.white,
      //     //               fontSize: max(
      //     //                   MediaQuery.of(context).size.width * 0.02, 10)))),
      //     // )
      //   ],
      // ),
      children: [
        (kls.id_diklat == grouping.diklatid &&
                kls.id_matadiklat == grouping.matadiklatid)
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                height: 1,
                color: Colors.white,
              )
            : Container(),
        // (kls.id_diklat == grouping.diklatid &&
        //         kls.id_matadiklat == grouping.matadiklatid) ?
        ListTile(
                // leading: CircleAvatar(
                //   backgroundColor: Colors.blue,
                // ),
                title: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      onPressed: () async {
                        await getPesertaInKelas();
                        var data = await showDialog(
                            context: navigatorKey.currentContext!,
                            builder: (context) {
                              print("masuk sini");
                              return AlertDialog(
                                content: SingleChildScrollView(
                                  child: MyDialogPesertaKelompok(
                                    pesertas: psrts,
                                    kls: kls,
                                    pesertainkelas: psrtkelasall,
                                    grup: group,
                                  ),
                                ),
                                //Text("Maaf tidak ada jadwal konsultasi saat ini. Silahkan lakukan reservasi terlebih dahulu."),
                                //titleStyle: TextStyle(fontSize: 0),
                              );
                            });
                        setState(() {
                          psrts.addAll(data);
                        });
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.plusCircle,
                        color: Colors.teal,
                      ),
                      label: Text(
                        'Peserta',
                        style: TextStyle(color: Colors.teal),
                      ), // <-- Text
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      onPressed: () async {
                        var datares = await Get.defaultDialog(
                          content: MyDialogConfirm(
                              info: "Yakin hapus kelompok ini?"),
                          titleStyle: TextStyle(fontSize: 0),
                        );
                        Map<String, dynamic> json =
                            jsonDecode(datares.toString());

                        if (json["respon"] == "ya") {
                          await apiService.deletePesertaInGroup(
                              user: nip, idgruppeserta: group.groupid);
                          await apiService.deleteGroup(
                              user: nip, idgruppeserta: group.groupid);
                          setState(() {
                            isExist = false;
                          });
                        }
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.trash,
                        color: Colors.teal,
                      ),
                      label: Text(
                        'Hapus',
                        style: TextStyle(color: Colors.teal),
                      ), // <-- Text
                    ),
                  ),
                ],
              )
        ),
        //    : Container(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: 1,
          color: Colors.white,
        ),
        ListTile(
          // leading: CircleAvatar(
          //   backgroundColor: Colors.blue,
          // ),
          title: psrts.length > 0
              ? SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    // mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: getWidget(psrts),
                  ),
                )
              : Text(
                  "Belum ada peserta",
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ],
      // onTap: () {
      //   Get.defaultDialog(
      //     //ReservasiAlert(context)
      //     content: MyDialogMenuKelas(), //showFilter(context),
      //     titleStyle: TextStyle(fontSize: 0),
      //     confirmTextColor: Colors.white,
      //     buttonColor: Colors.teal,
      //   );
      // },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isExist
        ? Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.teal.shade500),
              child: makeListTile(group),
            ),
          )
        : Container();
  }

  Widget getGroupIcon(Group group) {
    return Icon(
      FontAwesomeIcons.users,
      size: (MediaQuery.of(context).size.width <
              MediaQuery.of(context).size.height)
          ? MediaQuery.of(context).size.width * 0.08
          : MediaQuery.of(context).size.height * 0.08,
      color: Colors.white,
    );
  }

  List<Widget> getWidget(List<Peserta> lp) {
    List<Bubble> lb = <Bubble>[];
    print("masuk buat bubble");
    for (int i = 0; i < lp.length; i++) {
      lb.add(
        Bubble(
            color: Color.fromRGBO(212, 234, 244, 1.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(lp[i].fullname,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.0)),
                // (kls.id_diklat == grouping.diklatid &&
                //     kls.id_matadiklat == grouping.matadiklatid)
                //     ?
                InkWell(
                  onTap: () async {
                    await apiService.deletePesertaDariGroup(user: nip, idgruppeserta: group.groupid, nippeserta: lp[i].niplama);
                    getPesertaInGroup();
                    setState((){
                      getWidget(psrts);
                    });
                  },
                    child: Icon(Icons.close, size: 11.0)),
                    //: Container(),
              ],
            )),
      );
    }
    return lb;
  }
}
