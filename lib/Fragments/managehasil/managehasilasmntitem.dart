import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/assessment/b5p/b5phasilfasilitator.dart';
import 'package:safe/Fragments/assessment/belbin/belbinhasilfasilitator.dart';
import 'package:safe/Fragments/assessment/mbti/mbtihasilfasilitator.dart';
import 'package:safe/Fragments/assessment/sosiometri/sosiometrihasilfasilitator.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Fragments/dialogmenukelas.dart';
import 'package:safe/Models/IndAssessment.dart';
import 'package:safe/Models/testkelasgrouping.dart';
//import 'package:haloexpert/Pages/DetilInbox.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:safe/Models/Kelas.dart';

class ManageHasilAsmntItem extends StatefulWidget {
  const ManageHasilAsmntItem({Key? key, required this.indasmnt}) : super(key: key);

  final TestKelasGrouping indasmnt;

  @override
  State<ManageHasilAsmntItem> createState() => _ManageHasilAsmntItemState();
}

class _ManageHasilAsmntItemState extends State<ManageHasilAsmntItem> {
  ApiService apiService = Get.find(tag: 'apiserv1');
  static String jwttoken = "";
  String nama = "";
  String nip = "";
  String role = "";
  int expanded=0;
  late TestKelasGrouping indasmnt;
  bool isSwitched = false;
  bool groupset=false;
  List<String> tempgroupinglist = <String>["Grouping1", "Grouping2"];
  String selectedgrouping="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indasmnt = widget.indasmnt;
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

  ListTile makeListTile(TestKelasGrouping indasmnt) {
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
      onTap: (){
        if(indasmnt.jenistes=="0")
          {
            Get.to(()=>SosiometriHasillFasilitator(tkg: indasmnt,));
          }
        else if(indasmnt.jenistes=="1"){
          Get.to(()=>BelbinHasillFasilitator(tkg: indasmnt,));
        }
        else if(indasmnt.jenistes=="2"){
          Get.to(()=>MBTIHasillFasilitator(tkg: indasmnt,));
        }
        else if(indasmnt.jenistes=="3"){
          Get.to(()=>B5PHasillFasilitator(tkg: indasmnt,));
        }
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
      // children: [
      //   Container(
      //     margin: EdgeInsets.symmetric(horizontal: 5),
      //     height: 1,
      //     color: Colors.white,
      //   ),
      //   ListTile(
      //       // leading: CircleAvatar(
      //       //   backgroundColor: Colors.blue,
      //       // ),
      //       title: Row(
      //         children: [
      //           Expanded(
      //             flex: 2,
      //               child: Text("Pilih Grouping", style: TextStyle(color: Colors.white),),
      //           ),
      //           Expanded(
      //             flex: 4,
      //             child: Theme(
      //               data: ThemeData(
      //                 textTheme: TextTheme(subtitle1: TextStyle(color: Colors.white)),
      //               ),
      //               child: DropdownSearch<String>(
      //                 //mode: Mode.MENU,
      //                 items: tempgroupinglist,
      //                 showClearButton: true,
      //                 clearButton: FaIcon(FontAwesomeIcons.times, color: Colors.white,),
      //                 dropDownButton: Icon(
      //                   Icons.arrow_drop_down,
      //                   color: Colors.white, // <-- SEE HERE
      //                 ),
      //                 maxHeight: 300,
      //                 //onFind: (String? filter) => _selectBidKeahlian(filter!),
      //                 //enabledBorder:
      //                 dropdownSearchDecoration: InputDecoration(
      //                   //labelText: "Grouping",
      //                   contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
      //                   enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),),
      //                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),),
      //                 ),
      //                 selectedItem: selectedgrouping != "" ? selectedgrouping : null,
      //                 onChanged: (String? data) {
      //                   selectedgrouping = data != null ? data : "";
      //                 },
      //                 showSearchBox: false,
      //               ),
      //             ),
      //           ),
      //         ],
      //       )
      //   ),
      // ],
      trailing: Icon(Icons.arrow_forward, color: Colors.white,),
      // onExpansionChanged: (bool expanding){
      //   if(expanding==true)
      //     setState(() {
      //       expanded=1;
      //     });
      //   else
      //     setState(() {
      //       expanded=0;
      //     });
      // },
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
        child: makeListTile(indasmnt),
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
}
