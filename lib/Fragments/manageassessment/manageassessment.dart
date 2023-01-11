import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/manageassessment/dialoglistassessment.dart';
import 'package:safe/Fragments/manageassessment/manageassessmentitem.dart';
import 'package:safe/Models/IndAssessment.dart';
import 'package:safe/Models/Kelas.dart';
import 'package:safe/Models/testkelasgrouping.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:safe/Utilities/navigator_key.dart';

class ManageAssessment extends StatefulWidget {
  const ManageAssessment({Key? key, required this.kls}) : super(key: key);

  final Kelas kls;
  @override
  State<ManageAssessment> createState() => _ManageAssessmentState();
}

class _ManageAssessmentState extends State<ManageAssessment> {
  ApiService apiService = Get.find(tag: 'apiserv1');
  String nama = "";
  String nip = "";
  String role = "";
  late Kelas kls;
  List<TestKelasGrouping> indasmntsadded = <TestKelasGrouping>[];

  List<IndAssessment> indasmnts = <IndAssessment>[];
  //late final _items;
  List<IndAssessment> _selectedAsmnts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kls = widget.kls;
    SecureStorageHelper.getListString("userinfo").then((value) {
      setState(() {
        if (value != null) {
          nama = value[2].toString();
          nip = value[3].toString();
          role = value[6].toString();
          getAvailAssessmentKelas();
          getAddedAssessmentKelas();
          // _items = indasmnts
          //     .map((_indasmnt) => MultiSelectItem<IndAssessment>(
          //         _indasmnt, _indasmnt.asmntname))
          //     .toList();
          //setInitialValue();
        } else {
          //print("username1 $value");
        }
      });
    });
  }

  Future<void> getAvailAssessmentKelas() async {
    var req = await apiService.getAvailAssessmentInClass(user: nip);
    print(req.body);

    List<IndAssessment> tasmnt = <IndAssessment>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        //print("data:"+json.decode(req.body)['data'][i]);
        tasmnt.add(IndAssessment.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    //print("jumlah "+tgrouping.length.toString());
    setState(() {
      indasmnts.clear();
      indasmnts = tasmnt;
    });
  }

  Future<void> getAddedAssessmentKelas() async {
    var req = await apiService.getAssessmentAddedInClass(
        user: nip,
        idkelas: kls.id_kelas,
        iddiklat: kls.id_diklat,
        idmatadiklat: kls.id_matadiklat);
    print(req.body);

    List<TestKelasGrouping> tasmnt = <TestKelasGrouping>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        print("data existing "+i.toString());
        tasmnt.add(TestKelasGrouping.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    //print("jumlah "+tgrouping.length.toString());
    setState(() {
      indasmntsadded.clear();
      indasmntsadded = tasmnt;
      //_selectedAsmnts=tasmnt;
    });

    //setInitialValue();
  }
  
  // void setInitialValue(){
  //   print("masuk set initial value");
  //   for(int i=0;i<indasmntsadded.length;i++){
  //     for(int j=0;j<indasmnts.length;j++){
  //       print("indasmntsadded "+i.toString()+":"+ indasmntsadded[i].asmntid);
  //       print("indasmnts "+j.toString()+":"+ indasmnts[j].asmntid);
  //       if(indasmntsadded[i].asmntid==indasmnts[j].asmntid){
  //         print("ada yg sama");
  //         //setState((){
  //           _selectedAsmnts.add(indasmnts[j]);
  //         //});
  //         break;
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.teal,
      appBar: AppBar(
        //elevation: 0.1,
        backgroundColor: Colors.teal,
        title: Text("Manage Assessment"),
        /*actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        )
      ],*/
      ),
      body: Container(
        // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: false,
          itemCount: indasmntsadded.length,
          itemBuilder: (context, index) {
            print("testnya "+index.toString()+" "+indasmntsadded[index].namates);
            return ManageAssessmentItem(
                indasmnt: indasmntsadded[index]); //makeCard(mails[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
        onPressed: () async {
          await showDialog(
              context: navigatorKey.currentContext!,
              builder: (context) {
                print("masuk sini");
                return AlertDialog(
                  backgroundColor: Colors.teal,
                  content: SingleChildScrollView(
                    child:
                    MyDialogListAssessment(
                      nip: nip,
                      kls: kls,
                      indasmnts: indasmnts,
                      selectedindasmnts: indasmntsadded,
                    ),
                  ),
                  //Text("Maaf tidak ada jadwal konsultasi saat ini. Silahkan lakukan reservasi terlebih dahulu."),
                  //titleStyle: TextStyle(fontSize: 0),
                );
              });
          setState((){
          //indasmntsadded=[];
            indasmntsadded.clear();
            getAddedAssessmentKelas();
          });
        },
      ),
      //bottomNavigationBar: makeBottom,
    );
  }

  // void _showMultiSelect(BuildContext context) async {
  //   await showDialog(
  //     context: context,
  //     builder: (ctx) {
  //       //print("jumlah tools "+_selectedAsmnts.length.toString());
  //       return MultiSelectDialog(
  //         height: MediaQuery.of(context).size.height * 0.4,
  //         items: _items,
  //         initialValue: [indasmnts[0]], //_selectedAsmnts,
  //         onConfirm: (List<IndAssessment> values) async {
  //           print("jumlah dipilih "+values.length.toString());
  //           for (int i = 0; i < values.length; i++) {
  //             await apiService.addAssessmentInClass(
  //                 user: nip,
  //                 idtest: values[i].asmntid,
  //                 idkelas: kls.id_kelas,
  //                 iddiklat: kls.id_diklat,
  //                 idmatadiklat: kls.id_matadiklat);
  //           }
  //           getAddedAssessmentKelas();
  //         },
  //       );
  //     },
  //   );
  // }
}
