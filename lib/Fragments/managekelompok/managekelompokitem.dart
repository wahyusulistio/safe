import 'dart:convert';
import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/dialogconfirm.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Fragments/dialogmenukelas.dart';
import 'package:safe/Fragments/managekelompok/managedetilkelompok.dart';
import 'package:safe/Models/Grouping.dart';
import 'package:safe/Models/IndAssessment.dart';
//import 'package:haloexpert/Pages/DetilInbox.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:safe/Models/Kelas.dart';

class ManageKelompokItem extends StatefulWidget {
  const ManageKelompokItem({Key? key, required this.grouping, required this.kls}) : super(key: key);

  final Grouping grouping;
  final Kelas kls;

  @override
  State<ManageKelompokItem> createState() => _ManageKelompokItemState();
}

class _ManageKelompokItemState extends State<ManageKelompokItem> {
  ApiService apiService = Get.find(tag: 'apiserv1');
  //static String jwttoken = "";
  String nama = "";
  String nip = "";
  String role = "";
  int expanded=0;
  late Grouping grouping;
  late Kelas kls;
  bool isSwitched = false;
  bool groupset=false;
  List<String> tempgroupinglist = <String>["Grouping1", "Grouping2"];
  String selectedgrouping="";
  bool isExist=true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState((){
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    grouping = widget.grouping;
    kls=widget.kls;
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

  ExpansionTile makeListTile(Grouping grouping) {
    print("masuk list grouping");
    return ExpansionTile(
      //contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: getGroupingIcon(grouping),
        /*Icon(
              Icons.autorenew,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.04,
            ),*/
      ),
      title: Text(
        grouping.groupingname,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: max(MediaQuery.of(context).size.width * 0.03, 15)),
      ),
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
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: 1,
          color: Colors.white,
        ),
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
                    onPressed: () {
                      Get.to(()=>ManageDetilKelompok(grouping: grouping, kls: kls,));
                    },
                    icon: FaIcon(FontAwesomeIcons.binoculars, color: Colors.teal,),
                    label: Text('Detail', style: TextStyle(color: Colors.teal),), // <-- Text
                  ),
                ),
                (kls.id_diklat==grouping.diklatid && kls.id_matadiklat==grouping.matadiklatid) ? SizedBox(width: 10,) : Container(),
                (kls.id_diklat==grouping.diklatid && kls.id_matadiklat==grouping.matadiklatid) ? Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                    onPressed: () async {
                      var datares = await Get.defaultDialog(
                        content:
                        MyDialogConfirm(info: "Yakin hapus Grouping ini?"),
                        titleStyle: TextStyle(fontSize: 0),
                      );
                      Map<String, dynamic> json =
                      jsonDecode(datares.toString());

                      if (json["respon"] == "ya") {
                        //await apiService.deletePesertaInGroup(user: nip, idgruppeserta: group.groupid);
                        await apiService.deleteGrouping(user: nip, idgrouping: grouping.groupingid);
                        setState((){
                          isExist=false;
                        });
                      }
                    },
                    icon: FaIcon(FontAwesomeIcons.trash, color: Colors.teal,),
                    label: Text('Hapus', style: TextStyle(color: Colors.teal),), // <-- Text
                  ),
                ) : Container(),
              ],
            )
        ),
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
    return isExist ? Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.teal.shade500),
        child: makeListTile(grouping),
      ),
    ) : Container();
  }

  Widget getGroupingIcon(Grouping grouping) {
    return Icon(
      FontAwesomeIcons.users,
      size: (MediaQuery.of(context).size.width<MediaQuery.of(context).size.height) ?
      MediaQuery.of(context).size.width * 0.08 :
      MediaQuery.of(context).size.height * 0.08,
      color: Colors.white,
    );
  }
}
