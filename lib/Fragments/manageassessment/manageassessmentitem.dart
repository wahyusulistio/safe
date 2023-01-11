import 'dart:convert';
import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Fragments/dialogmenukelas.dart';
import 'package:safe/Models/Grouping.dart';
import 'package:safe/Models/IndAssessment.dart';
import 'package:safe/Models/testkelasgrouping.dart';
//import 'package:haloexpert/Pages/DetilInbox.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:safe/Models/Kelas.dart';

class ManageAssessmentItem extends StatefulWidget {
  const ManageAssessmentItem({Key? key, required this.indasmnt}) : super(key: key);

  final TestKelasGrouping indasmnt;

  @override
  State<ManageAssessmentItem> createState() => _ManageAssessmentItemState();
}

class _ManageAssessmentItemState extends State<ManageAssessmentItem> {
  ApiService apiService = Get.find(tag: 'apiserv1');
  String nama = "";
  String nip = "";
  String role = "";
  late TestKelasGrouping indasmnt;

  bool isSwitched = false;
  bool groupset=false;
  List<Grouping> lgrouping = <Grouping>[];
  Grouping? selectedgrouping;
  //late String selectedidgrouping;
  int expanded=0;

  //late List<Peserta> psrts;
  //late List<Peserta> psrtall;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indasmnt = widget.indasmnt;
    isSwitched = indasmnt.status=="1" ? true : false;
    //selectedidgrouping=indasmnt.idgrouping;
    //selectedgrouping=getSelectedGrouping(indasmnt.idgrouping)!;
    //print("widgetnya "+widget.indasmnt.namates);
    SecureStorageHelper.getListString("userinfo").then((value) {
      setState(() {
        if (value != null) {
          nama = value[2].toString();
          nip = value[3].toString();
          role = value[6].toString();
          getGroupingKelas();
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

  Future<void> getGroupingKelas() async {
    var req = await apiService.getGroupingKelas(nip, indasmnt.idkelas);
    //print(req.body);

    List<Grouping> tasmnt = <Grouping>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        //print("data:"+json.decode(req.body)['data'][i]);
        tasmnt.add(Grouping.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    //print("jumlah "+tgrouping.length.toString());
    setState(() {
      lgrouping.clear();
      lgrouping = tasmnt;
    });

    print("lgrouping :"+lgrouping.length.toString());
    for(int i=0;i<lgrouping.length;i++){
      print("lgrouping id " +lgrouping[i].groupingid);
      print("indasmnt id " +indasmnt.idgrouping);
      if(lgrouping[i].groupingid==indasmnt.idgrouping){
        print("masuk set grouping awal");
        setState((){
          selectedgrouping=lgrouping[i];
        });
        break;
      }
    }
  }

  ExpansionTile makeExpansionTile(TestKelasGrouping indasmnt) {
    //print("ni nama nya 1 "+indasmnt.namates);
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
        indasmnt.namates,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: max(MediaQuery.of(context).size.width * 0.03, 15)),
      ),
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: 1,
          color: Colors.white,
        ),
        ListTile(
            title: Row(
              children: [
                Expanded(
                  flex: 2,
                    child: Text("Pilih Grouping", style: TextStyle(color: Colors.white),),
                ),
                Expanded(
                  flex: 4,
                  child: Theme(
                    data: ThemeData(
                      textTheme: TextTheme(subtitle1: TextStyle(color: Colors.white)),
                    ),
                    child: DropdownSearch<Grouping>(
                      items: lgrouping,
                      // popupProps: PopupPropsMultiSelection.menu(
                      //   showSelectedItems: true,
                      //   disabledItemFn: (String s) => s.startsWith('I'),
                      // ),
                      //showSelectedItems: true,
                      itemAsString: (Grouping? p) => p!.groupingname,
                      onChanged:(Grouping? data){
                        //print("masuk onchanged");
                        updateGrouping(indasmnt, data);
                        selectedgrouping=data;
                      } ,
                      showSearchBox: true,
                      selectedItem: selectedgrouping,
                      showClearButton: true,
                    ),
                  ),
                ),
              ],
            )
        ),
      ],
      trailing: Switch(
        value: isSwitched,
        onChanged: (value) {
          if(value==true){
            if(selectedgrouping==null && indasmnt.ingroup==1){
              Get.defaultDialog(
                content: MyDialogInfo(info: "Assessment ini memerlukan Grouping!"),
                titleStyle: TextStyle(fontSize: 0),
              );
            }
            else
              {
                setState(() {
                  //print("update status");
                  apiService.updateAssessmentInClass(
                      user: nip,
                      idtest: indasmnt.idtest,
                      idkelas: indasmnt.idkelas,
                      iddiklat: indasmnt.iddiklat,
                      idmatadiklat: indasmnt.idmatadiklat,
                      idgrouping: selectedgrouping?.groupingid,
                      status: "1");
                  isSwitched = value;
                });
              }
          }
          else{
            setState(() {
              //print("update status");
              apiService.updateAssessmentInClass(
                  user: nip,
                  idtest: indasmnt.idtest,
                  idkelas: indasmnt.idkelas,
                  iddiklat: indasmnt.iddiklat,
                  idmatadiklat: indasmnt.idmatadiklat,
                  idgrouping: indasmnt.idgrouping,
                  status: "0");
              isSwitched = value;
            });
          }
          // if(indasmnt.ingroup=="1" ){
          //     Get.defaultDialog(
          //       content: MyDialogInfo(info: "Assessment ini memerlukan Grouping!"),
          //       titleStyle: TextStyle(fontSize: 0),
          //     );
          // }
          // else
          //   {
          //     setState(() {
          //       isSwitched = value;
          //     });
          //   }
        },
        activeTrackColor: Colors.lightGreenAccent,
        activeColor: Colors.green,
      ),
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
    );
  }

  ListTile makeListTile(TestKelasGrouping indasmnt) {
    //print("ni nama nya 2 "+indasmnt.namates);
    return ListTile(
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
        indasmnt.namates,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: max(MediaQuery.of(context).size.width * 0.03, 15)),
      ),
      trailing: Switch(
        value: isSwitched,
        onChanged: (value) {
          setState(() {
            //print("update status");
            apiService.updateAssessmentInClass(
                user: nip,
                idtest: indasmnt.idtest,
                idkelas: indasmnt.idkelas,
                iddiklat: indasmnt.iddiklat,
                idmatadiklat: indasmnt.idmatadiklat,
                idgrouping: indasmnt.idgrouping,
                status: value==true ? "1" : "0");
            isSwitched = value;
          });
        },
        activeTrackColor: Colors.lightGreenAccent,
        activeColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //print("tu nama tesnya "+indasmnt.namates);
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.teal.shade500),
        child: makeExpansionTile(indasmnt), //indasmnt.ingroup=="1" ? makeExpansionTile(indasmnt) : makeListTile(indasmnt),
      ),
    );
  }

  Widget getAssessmentIcon(TestKelasGrouping indasmnt) {
    return Icon(
      FontAwesomeIcons.checkSquare,
      size: (MediaQuery.of(context).size.width<MediaQuery.of(context).size.height) ?
      MediaQuery.of(context).size.width * 0.08 :
      MediaQuery.of(context).size.height * 0.08,
      color: Colors.white,
    );
  }

  void updateGrouping(TestKelasGrouping tkg, Grouping? grpg){
    apiService.updateAssessmentInClass(
        user: nip,
        idtest: tkg.idtest,
        idkelas: tkg.idkelas,
        iddiklat: tkg.iddiklat,
        idmatadiklat: tkg.idmatadiklat,
        idgrouping: grpg?.groupingid,
        status: tkg.status);
  }
}
