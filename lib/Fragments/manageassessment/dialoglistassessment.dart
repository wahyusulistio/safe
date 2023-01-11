import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:safe/Models/IndAssessment.dart';
import 'package:safe/Models/Kelas.dart';
import 'package:safe/Models/testkelasgrouping.dart';
import 'package:safe/Utilities/ApiService.dart';

class MyDialogListAssessment extends StatefulWidget {
  const MyDialogListAssessment({Key? key, required this.indasmnts, required this.selectedindasmnts, required this.nip, required this.kls}) : super(key: key);

  final String nip;
  final Kelas kls;
  final List<IndAssessment> indasmnts;
  final List<TestKelasGrouping> selectedindasmnts;
  @override
  State<MyDialogListAssessment> createState() => _MyDialogListAssessmentState();
}

class _MyDialogListAssessmentState extends State<MyDialogListAssessment> {
  ApiService apiService = Get.find(tag: 'apiserv1');

  List<IndAssessment> indasmnts=<IndAssessment>[];
  List<TestKelasGrouping> selectedindasmnts=<TestKelasGrouping>[];
  List<bool> indexcheckbox=<bool>[];
  List<bool> newindexcheckbox=<bool>[];
  late Kelas kls;

  String nip="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nip=widget.nip;
    kls=widget.kls;
    indasmnts=widget.indasmnts;
    selectedindasmnts=widget.selectedindasmnts;
    indexcheckbox=List.generate(indasmnts.length, (index) => false);
    newindexcheckbox=List.generate(indasmnts.length, (index) => false);
    setValCheckbox();
  }

  void setValCheckbox(){
    for(int i=0;i<selectedindasmnts.length;i++){
      for(int j=0;j<indasmnts.length;j++){
        if(selectedindasmnts[i].idtest==indasmnts[j].asmntid){
          indexcheckbox[j]=true;
          newindexcheckbox[j]=true;
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return //new Scaffold(
      // appBar: new AppBar(
      //   backgroundColor: Colors.white,
      //   centerTitle: true,
      //   title: new Text(
      //     'Available Tools',
      //     style: TextStyle(color: Colors.black),
      //   ),
      // ),
      //body:
      Column(
        children: [
          Container(
            color: Colors.teal,
            height: MediaQuery.of(context).size.height*0.3,
          width: MediaQuery.of(context).size.width*0.7,
          child: ListView.builder(
              itemCount: indasmnts.length,
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                  child: new Container(
                    padding: new EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        new CheckboxListTile(
                            //activeColor: Colors.pink[300],
                            //dense: true,
                            //font change
                            title: new Text(
                              indasmnts[index].asmntname,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5),
                            ),
                            value: newindexcheckbox[index],
                            // secondary: Container(
                            //   height: 50,
                            //   width: 50,
                            //   child: Icon(
                            //     FontAwesomeIcons.checkSquare,
                            //     size: MediaQuery.of(context).size.width * 0.08,
                            //     color: Colors.teal,
                            //   ),
                            // ),
                            onChanged: (bool? val) {
                              itemChange(val!, index);
                            })
                      ],
                    ),
                  ),
                );
              }),
        ),
          ElevatedButton(
            child: Text("Submit"),
            onPressed: () async {
              //selectedindasmnts.clear();
              for (int i = 0; i < indasmnts.length; i++) {
                if(indexcheckbox[i]!=newindexcheckbox[i]){
                  if(newindexcheckbox[i]==true){
                    //selectedindasmnts.add(value)
                    await apiService.addAssessmentInClass(
                        user: nip,
                        idtest: indasmnts[i].asmntid,
                        idkelas: kls.id_kelas,
                        iddiklat: kls.id_diklat,
                        idmatadiklat: kls.id_matadiklat);
                  }
                  else{
                    await apiService.deleteAssessmentInClass(
                        user: nip,
                        idtest: indasmnts[i].asmntid,
                        idkelas: kls.id_kelas,
                        iddiklat: kls.id_diklat,
                        idmatadiklat: kls.id_matadiklat);
                  }
                }
              }
              Get.back();
            },
          )
        ],
      );
    //);
  }

  void itemChange(bool val, int index) {
    setState(() {
      newindexcheckbox[index]=val;
    });
  }
}
