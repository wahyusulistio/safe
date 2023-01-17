import 'dart:convert';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/assessment/b5p/b5pintro.dart';
import 'package:safe/Fragments/assessment/belbin/belbinintro.dart';
import 'package:safe/Fragments/assessment/mbti/mbtiintro.dart';
import 'package:safe/Fragments/assessment/profilkapabilitas/kapabilitasintro.dart';
import 'package:safe/Fragments/kelaspeserta/assessmentpesertaitem.dart';
import 'package:safe/Fragments/manageassessment/manageassessmentitem.dart';
import 'package:safe/Models/HasilBelbin.dart';
import 'package:safe/Models/IndAssessment.dart';
import 'package:safe/Models/Kelas.dart';
import 'package:safe/Models/Pertanyaan.dart';
import 'package:safe/Models/PilihanJawaban.dart';
import 'package:safe/Models/testkelasgrouping.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';

class NonClassActiveAsmnt extends StatefulWidget {
  const NonClassActiveAsmnt({Key? key,}) : super(key: key);

  @override
  State<NonClassActiveAsmnt> createState() => _NonClassActiveAsmntState();
}

class _NonClassActiveAsmntState extends State<NonClassActiveAsmnt> {

  ApiService apiService = Get.find(tag: 'apiserv1');
//  static String jwttoken = "";
  String nama = "";
  String nip = "";
  String role="";
  late List<IndAssessment> indasmnts = <IndAssessment>[];
  late Kelas kls;
  bool isLoading=false;
  bool cekBelbinPeserta=false;
  List<HasilBelbin> hb=<HasilBelbin>[];

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
          role=value[6].toString();
          getNonClassActiveAsmnt();
        } else {
          //print("username1 $value");
        }
      });
    });
    //getAssessmentKelas();
  }

  Future<void> getNonClassActiveAsmnt() async {
    setState((){
      isLoading=true;
      indasmnts.clear();
    });
    var req = await apiService.getAvailAssessmentNonClass(user: nip);

    List<IndAssessment> tasmnt=<IndAssessment>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        tasmnt.add(IndAssessment.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    setState((){
      indasmnts=tasmnt;
      isLoading=false;
    });
  }

  Widget listActiveAsmnt(IndAssessment indasmnt){
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.teal.shade500),
        child: makeListTile(indasmnt),
      ),
    );
  }

  ListTile makeListTile(IndAssessment indasmnt) {
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
        indasmnt.asmntname,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: max(MediaQuery.of(context).size.width * 0.03, 15)),
      ),
      onTap: () async {
        if (indasmnt.jenistest == "0") {
          Get.to(()=>KapabilitasIntro(indasmnt: indasmnt,));
        }
        else if(indasmnt.jenistest=="1"){

          Get.to(()=>BelbinIntro(idtest: indasmnt.asmntid,nip: nip, tkg:
          TestKelasGrouping(idtest: indasmnt.asmntid, idgrouping: "",
          iddiklat: "ZZZZZZ", idmatadiklat: "",
          idkelas: "DBF4E2DD-CDDF-4D14-B1B8-278299BAF975", inclass: "",
          ingroup: "", jenistes: "1",
          namates: indasmnt.asmntname, status: "1"),));
        }
        else if(indasmnt.jenistest=="2"){

          Get.to(()=>MBTIIntro(idtest: indasmnt.asmntid,nip: nip, tkg:
          TestKelasGrouping(idtest: indasmnt.asmntid, idgrouping: "",
              iddiklat: "ZZZZZZ", idmatadiklat: "",
              idkelas: "DBF4E2DD-CDDF-4D14-B1B8-278299BAF975", inclass: "",
              ingroup: "", jenistes: "2",
              namates: indasmnt.asmntname, status: "1"),));
        }
        else if(indasmnt.jenistest=="3"){

          Get.to(()=>B5PIntro(idtest: indasmnt.asmntid,nip: nip, tkg:
          TestKelasGrouping(idtest: indasmnt.asmntid, idgrouping: "",
              iddiklat: "ZZZZZZ", idmatadiklat: "",
              idkelas: "DBF4E2DD-CDDF-4D14-B1B8-278299BAF975", inclass: "",
              ingroup: "", jenistes: "3",
              namates: indasmnt.asmntname, status: "1"),));
        }
      },
    );
  }

  Future<void> getHasilBelbin(IndAssessment indasmnt) async {
    print("masuk cek belbin");
    var req = await apiService.cekBelbin(user: nip,
        idkelas: "DBF4E2DD-CDDF-4D14-B1B8-278299BAF975", iddiklat: "ZZZZZZ",
        idmatadiklat: "", idtest: indasmnt.asmntid);

    //List<HasilSosiometriTBJFPAP2022> tasmnt=<HasilSosiometriTBJFPAP2022>[];
    if (json.decode(req.body)['data'] != null) {
      print("masuk 123");
      if(json.decode(req.body)['data'].length>0){
        setState((){
          cekBelbinPeserta=true;
          //print("masuk 234 "+cekSosiometriPeserta.toString());
        });
      }
    }

    if(cekBelbinPeserta)
    {
      var req = await apiService.getSkorBelbin2(user: nip,
          idkelas: "DBF4E2DD-CDDF-4D14-B1B8-278299BAF975", iddiklat: "ZZZZZZ",
          idmatadiklat: "", idtest: indasmnt.asmntid,
          nippeserta: nip);

      List<HasilBelbin> tasmnt=<HasilBelbin>[];
      if (json.decode(req.body)['data'] != null) {
        for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
          tasmnt.add(HasilBelbin.fromJSON(json.decode(req.body)['data'][i]));
        }
      }

      hb.clear();
      setState((){
        hb=tasmnt;
      });
    }
  }



  Widget getAssessmentIcon(IndAssessment indasmnt) {
    return isLoading == false ? Icon(
      FontAwesomeIcons.checkSquare,
      size: (MediaQuery.of(context).size.width<MediaQuery.of(context).size.height) ?
      MediaQuery.of(context).size.width * 0.08 :
      MediaQuery.of(context).size.height * 0.08,
      color: Colors.white,
    ) : SizedBox(
      width: (MediaQuery.of(context).size.width<MediaQuery.of(context).size.height) ?
      MediaQuery.of(context).size.width * 0.08 :
      MediaQuery.of(context).size.height * 0.08,
      height: (MediaQuery.of(context).size.width<MediaQuery.of(context).size.height) ?
      MediaQuery.of(context).size.width * 0.08 :
      MediaQuery.of(context).size.height * 0.08,
      child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.teal,
      appBar: AppBar(
        //elevation: 0.1,
        backgroundColor: Colors.teal,
        title: Text("Daftar Assessment NonClass Aktif"),
        /*actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        )
      ],*/
      ),
      body: Container(
        // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
        child: (isLoading==false && indasmnts.length>0) ? ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: false,
          itemCount: indasmnts.length,
          itemBuilder: (BuildContext context, int index) {
            return listActiveAsmnt(indasmnts[index]);  //makeCard(mails[index]);
          },
        ) : ( isLoading==true ? Container(
          color: Colors.white.withOpacity(0.5),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ) : Center(
          child: Card(
            elevation: 20,
            color: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: 100,
              width: 200,
              //color: Colors.teal,
              child: Center(
                child: AutoSizeText("Maaf tidak ada assessment Non Class yang available saat ini.",
                  maxLines: 3, textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
        )
        ),
      ),
      //bottomNavigationBar: makeBottom,
    );
  }
}
