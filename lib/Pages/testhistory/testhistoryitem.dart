import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/dialogmenukelas.dart';
import 'package:safe/Fragments/manageassessment/manageassessment.dart';
import 'package:safe/Fragments/managehasil/managehasilasmnt.dart';
import 'package:safe/Fragments/managekelompok/managekelompok.dart';
//import 'package:haloexpert/Pages/DetilInbox.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:safe/Models/Kelas.dart';

class TestHistoryItem extends StatefulWidget {
  const TestHistoryItem({Key? key, required this.kelas}) : super(key: key);

  final Kelas kelas;

  @override
  State<TestHistoryItem> createState() => _TestHistoryItemState();
}

class _TestHistoryItemState extends State<TestHistoryItem> {
  ApiService apiService = Get.find(tag: 'apiserv1');
  static String jwttoken = "";
  String nama = "";
  String nip = "";
  String role = "";
  int expanded=0;
  late Kelas kelas1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kelas1 = widget.kelas;
    SecureStorageHelper.getListString("userinfo").then((value) {
      setState(() {
        if (value != null) {
          nama = value[2].toString();
          nip = value[3].toString();
          role = value[6].toString();
        } else {
          //print("username1 $value");
        }
      });
    });
  }

  ExpansionTile makeListTile(Kelas kelas) {
    return ExpansionTile(
      //contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: getKelasIcon(kelas),
        /*Icon(
              Icons.autorenew,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.04,
            ),*/
      ),
      title: Text(
        kelas.namakelas,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: max(MediaQuery.of(context).size.width * 0.03, 15)),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /*Expanded(
              flex: 1,
              child: Container(
                // tag: 'hero',
                child: LinearProgressIndicator(
                    backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                    value: lesson.indicatorValue,
                    valueColor: AlwaysStoppedAnimation(Colors.green)),
              )),*/
          Container(
            //flex: 4,
            child: Padding(
                padding: EdgeInsets.only(left: 0.0, bottom: 5, top: 5),
                child: Text(kelas.namadiklat,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: max(
                            MediaQuery.of(context).size.width * 0.02, 10)))),
          ),
          Container(
            //flex: 4,
            child: Padding(
                padding: EdgeInsets.only(left: 0.0),
                child: Text(kelas.namamatadiklat,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: max(
                            MediaQuery.of(context).size.width * 0.02, 10)))),
          ),
          // Expanded(
          //   flex: 4,
          //   child: Padding(
          //       padding: EdgeInsets.only(left: 0.0),
          //       child: Text(kelas.namamatadiklat,
          //           style: TextStyle(
          //               color: Colors.white,
          //               fontSize: max(
          //                   MediaQuery.of(context).size.width * 0.02, 10)))),
          // )
        ],
      ),
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: 1,
          color: Colors.white,
        ),
        ListTile(
            onTap: () {
              Get.to(() => ManageKelompok(kls: kelas,));
              //Get.to(() => DaftarExpert());
            },
            // leading: CircleAvatar(
            //   backgroundColor: Colors.blue,
            // ),
            title: Text(
          'Manage Kelompok',
          style: TextStyle(color: Colors.white),
        )),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: 1,
          color: Colors.white,
        ),
        ListTile(
            onTap: () {
              Get.to(() => ManageAssessment(kls: kelas,));
              //Get.to(() => DaftarExpert());
            },
            // leading: CircleAvatar(
            //   backgroundColor: Colors.red,
            // ),
            title: Text(
          'Manage Assessment',
          style: TextStyle(color: Colors.white),
        )),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: 1,
          color: Colors.white,
        ),
        ListTile(
          onTap: (){
            Get.to(()=>ManageHasilAsmnt(kls: kelas,));
          },
            // leading: CircleAvatar(
            //   backgroundColor: Colors.amber,
            // ),
            title: Text('Lihat Hasil', style: TextStyle(color: Colors.white))),
      ],
      trailing: expanded == 0 ? Icon(Icons.keyboard_arrow_down,
          color: Colors.white, size: MediaQuery.of(context).size.width * 0.04) :
      Icon(Icons.keyboard_arrow_up,
          color: Colors.white, size: MediaQuery.of(context).size.width * 0.04),
      onExpansionChanged: (bool expanding){
        if(expanding==true)
          setState(() {
            expanded=1;
          });
        else
          setState(() {
            expanded=0;
          });
      },
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
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.teal.shade500),
        child: makeListTile(kelas1),
      ),
    );
  }

  Widget getKelasIcon(Kelas kelas) {
    return Icon(
      FontAwesomeIcons.chalkboardTeacher,
      size: (MediaQuery.of(context).size.width<MediaQuery.of(context).size.height) ?
      MediaQuery.of(context).size.width * 0.08 :
      MediaQuery.of(context).size.height * 0.08,
      color: Colors.white,
    );
  }
}
