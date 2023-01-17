import 'dart:convert';
import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/dialogconfirm.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Fragments/dialogmenukelas.dart';
import 'package:safe/Models/Grouping.dart';
import 'package:safe/Models/IndAssessment.dart';
import 'package:safe/Models/Test.dart';
import 'package:safe/Models/testkelasgrouping.dart';
//import 'package:haloexpert/Pages/DetilInbox.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:safe/Models/Kelas.dart';

class ManageTestItem extends StatefulWidget {
  const ManageTestItem({Key? key, required this.indasmnt}) : super(key: key);

  final Test indasmnt;

  @override
  State<ManageTestItem> createState() => _ManageTestItemState();
}

class _ManageTestItemState extends State<ManageTestItem> {
  ApiService apiService = Get.find(tag: 'apiserv1');
  String nama = "";
  String nip = "";
  String role = "";
  late Test indasmnt;

  //bool isSwitched = false;
  bool status = false;
  bool inclass = false;
  bool ingroup = false;
  bool nonclass = false;
  bool statusawal = false;
  bool inclassawal = false;
  bool ingroupawal = false;
  bool nonclassawal = false;
  bool ischange = false;
//  bool groupset=false;
  //List<Grouping> lgrouping = <Grouping>[];
  //Grouping? selectedgrouping;
  //late String selectedidgrouping;
  int expanded = 0;

  //late List<Peserta> psrts;
  //late List<Peserta> psrtall;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indasmnt = widget.indasmnt;
    status = indasmnt.status == "1" ? true : false;
    inclass = indasmnt.inclass == "1" ? true : false;
    ingroup = indasmnt.ingroup == "1" ? true : false;
    nonclass = indasmnt.nonclass == "1" ? true : false;
    statusawal = indasmnt.status == "1" ? true : false;
    inclassawal = indasmnt.inclass == "1" ? true : false;
    ingroupawal = indasmnt.ingroup == "1" ? true : false;
    nonclassawal = indasmnt.nonclass == "1" ? true : false;
    //isSwitched = indasmnt.status=="1" ? true : false;
    //selectedidgrouping=indasmnt.idgrouping;
    //selectedgrouping=getSelectedGrouping(indasmnt.idgrouping)!;
    //print("widgetnya "+widget.indasmnt.namates);
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

  // Grouping? getSelectedGrouping(String id){
  //   for(int i=0;i<lgrouping.length;i++){
  //     if(lgrouping[i].groupingid==id){
  //       return lgrouping[i];
  //     }
  //   }
  //   return null;
  // }

  ExpansionTile makeListTile(Test indasmnt) {
    //print("itu "+kelas.namamatadiklat);
    return ExpansionTile(
      //contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: getAssessmentIcon(indasmnt),
        /*Icon(
              Icons.autorenew,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.04,
            ),*/
      ),
      title: Text(
        indasmnt.namatest,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: max(MediaQuery.of(context).size.width * 0.03, 15)),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      // subtitle: Column(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   crossAxisAlignment: CrossAxisAlignment.start,
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
      //     Container(
      //       //flex: 4,
      //       child: Padding(
      //           padding: EdgeInsets.only(left: 0.0, bottom: 5, top: 5),
      //           child: Text(kelas.namadiklat,
      //               style: TextStyle(
      //                   color: Colors.white,
      //                   fontSize: max(
      //                       MediaQuery.of(context).size.width * 0.02, 10)))),
      //     ),
      //     Container(
      //       //flex: 4,
      //       child: Padding(
      //           padding: EdgeInsets.only(left: 0.0),
      //           child: Text(kelas.namamatadiklat,
      //               style: TextStyle(
      //                   color: Colors.white,
      //                   fontSize: max(
      //                       MediaQuery.of(context).size.width * 0.02, 10)))),
      //     ),
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
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: 1,
          color: Colors.white,
        ),
        ListTile(
            onTap: () {},
            title: Text(
              'Status Aktif',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Switch(
              value: status,
              onChanged: (value) {
                setState(() {
                  status = value;
                  ischange = cekChange();
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            )),
        status
            ? Container(
                child: Column(
                children: makeAtributWidget(),
              ))
            : Container(),
        Container(
          //margin: EdgeInsets.symmetric(horizontal: 5),
          height: 1,
          color: Colors.white,
        ),
        Container(
          color: ischange ? Colors.white : Colors.teal,
          child: ListTile(
              tileColor: ischange ? Colors.teal : Colors.white,
              onTap: () async {
                if (ischange) {
                  var datares = await Get.defaultDialog(
                    content:
                    MyDialogConfirm(info: "Ubah info Test?"),
                    titleStyle: TextStyle(fontSize: 0),
                  );
                  Map<String, dynamic> json =
                  jsonDecode(datares.toString());
                  if (json["respon"] == "ya"){
                    var hasilcek = await apiService.updateTest(
                        user: nip,
                        idtest: indasmnt.idtest,
                        status: this.status ? "1" : "0",
                        inclass: this.inclass ? "1" : "0",
                        ingroup: this.ingroup ? "1" : "0",
                        nonclass: this.nonclass ? "1" : "0",);
                    Map<String, dynamic> jsoncek =
                    jsonDecode(hasilcek.body.toString());
                    String stat = jsoncek["status"];
                    if(stat=="200")
                    {
                      Get.defaultDialog(
                        content: MyDialogInfo(info: "Info Test berhasil diubah."),
                        titleStyle: TextStyle(fontSize: 0),
                      );
                      setState(() {
                        ischange=false;
                      });
                    }
                  }
                }
              },
              title: Text(
                'Simpan',
                style: TextStyle(color: ischange ? Colors.teal : Colors.white),
                textAlign: TextAlign.center,
              ),
              trailing: Icon(
                Icons.check_box,
                color: Colors.white,
              )),
        )
      ],
      trailing: expanded == 0
          ? Icon(Icons.keyboard_arrow_down,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.04)
          : Icon(Icons.keyboard_arrow_up,
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

  List<Widget> makeAtributWidget() {
    List<Widget> widgets = <Widget>[];

    widgets.add(Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 1,
      color: Colors.white,
    ));
    widgets.add(ListTile(
        onTap: () {},
        title: Text(
          'Available di Kelas',
          style: TextStyle(color: Colors.white),
        ),
        trailing: Switch(
          value: inclass,
          onChanged: (value) {
            setState(() {
              inclass = value;
              ischange = cekChange();
            });
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        )));
    widgets.add(Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 1,
      color: Colors.white,
    ));
    widgets.add(ListTile(
        onTap: () {},
        title: Text('Perlu Group', style: TextStyle(color: Colors.white)),
        trailing: Switch(
          value: ingroup,
          onChanged: (value) {
            setState(() {
              ingroup = value;
              ischange = cekChange();
            });
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        )));
    widgets.add(Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 1,
      color: Colors.white,
    ));
    widgets.add(ListTile(
        onTap: () {},
        title:
            Text('Available Non Class', style: TextStyle(color: Colors.white)),
        trailing: Switch(
          value: nonclass,
          onChanged: (value) {
            setState(() {
              nonclass = value;
              ischange = cekChange();
            });
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        )));

    return widgets;
  }
  // ListTile makeListTile(Test indasmnt) {
  //   //print("ni nama nya 2 "+indasmnt.namates);
  //   return ListTile(
  //     //contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  //     leading: Container(
  //       padding: EdgeInsets.only(right: 12.0),
  //       decoration: new BoxDecoration(
  //           border: new Border(
  //               right: new BorderSide(width: 1.0, color: Colors.white24))),
  //       child: getAssessmentIcon(indasmnt),
  //       /*Icon(
  //             Icons.autorenew,
  //             color: Colors.white,
  //             size: MediaQuery.of(context).size.width * 0.04,
  //           ),*/
  //     ),
  //     title: Text(
  //       indasmnt.namates,
  //       style: TextStyle(
  //           color: Colors.white,
  //           fontWeight: FontWeight.bold,
  //           fontSize: max(MediaQuery.of(context).size.width * 0.03, 15)),
  //     ),
  //     trailing: Switch(
  //       value: isSwitched,
  //       onChanged: (value) {
  //         setState(() {
  //           //print("update status");
  //           apiService.updateAssessmentInClass(
  //               user: nip,
  //               idtest: indasmnt.idtest,
  //               idkelas: indasmnt.idkelas,
  //               iddiklat: indasmnt.iddiklat,
  //               idmatadiklat: indasmnt.idmatadiklat,
  //               idgrouping: indasmnt.idgrouping,
  //               status: value==true ? "1" : "0");
  //           isSwitched = value;
  //         });
  //       },
  //       activeTrackColor: Colors.lightGreenAccent,
  //       activeColor: Colors.green,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    //print("tu nama tesnya "+indasmnt.namates);
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.teal.shade500),
        child: makeListTile(
            indasmnt), //indasmnt.ingroup=="1" ? makeExpansionTile(indasmnt) : makeListTile(indasmnt),
      ),
    );
  }

  bool cekChange() {
    bool adaperubahan = false;
    if (status != statusawal ||
        inclass != inclassawal ||
        ingroup != ingroupawal ||
        nonclass != nonclassawal)
      adaperubahan = true;
    else
      adaperubahan = false;

    return adaperubahan;
  }

  Widget getAssessmentIcon(Test indasmnt) {
    return Icon(
      FontAwesomeIcons.chartSimple,
      size: (MediaQuery.of(context).size.width <
              MediaQuery.of(context).size.height)
          ? MediaQuery.of(context).size.width * 0.08
          : MediaQuery.of(context).size.height * 0.08,
      color: Colors.white,
    );
  }
}
