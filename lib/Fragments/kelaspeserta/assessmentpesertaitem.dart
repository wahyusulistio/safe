import 'dart:convert';
import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/assessment/belbin/belbinintro.dart';
import 'package:safe/Fragments/assessment/belbin/belbinintro_copy.dart';
import 'package:safe/Fragments/assessment/mbti/mbtiintro.dart';
import 'package:safe/Fragments/assessment/sosiometri/sosiometrilembarjawaban.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Fragments/dialogmenukelas.dart';
import 'package:safe/Fragments/kelaspeserta/kelaspeserta.dart';
import 'package:safe/Models/HasilBelbin.dart';
import 'package:safe/Models/HasilSosiometriTBJFPAP2022.dart';
import 'package:safe/Models/IndAssessment.dart';
import 'package:safe/Models/Pertanyaan.dart';
import 'package:safe/Models/Peserta.dart';
import 'package:safe/Models/PilihanJawaban.dart';
import 'package:safe/Models/testkelasgrouping.dart';
//import 'package:haloexpert/Pages/DetilInbox.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:safe/Models/Kelas.dart';

class AssessmentPesertaItem extends StatefulWidget {
  const AssessmentPesertaItem({Key? key, required this.indasmnt})
      : super(key: key);

  final TestKelasGrouping indasmnt;

  @override
  State<AssessmentPesertaItem> createState() => _AssessmentPesertaItemState();
}

class _AssessmentPesertaItemState extends State<AssessmentPesertaItem> {
  ApiService apiService = Get.find(tag: 'apiserv1');
  static String jwttoken = "";
  String nama = "";
  String nip = "";
  String role = "";
  int expanded = 0;
  late TestKelasGrouping indasmnt;
  bool isSwitched = false;
  bool groupset = false;
  List<String> tempgroupinglist = <String>["Grouping1", "Grouping2"];
  String selectedgrouping = "";
  List<HasilBelbin> hb=<HasilBelbin>[];
  //List<HasilSosiometriTBJFPAP2022> hs=<HasilSosiometriTBJFPAP2022>[];
  bool cekSosiometriPeserta=false;
  bool cekBelbinPeserta=false;
  bool isLoading=false;

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
          //getHasilBelbin();
          //getHasilSosiometri();
        } else {
          //print("username1 $value");
        }
      });
    });
  }

  Future<void> getHasilBelbin() async {
    var req = await apiService.cekBelbin(user: nip,
        idkelas: indasmnt.idkelas, iddiklat: indasmnt.iddiklat,
        idmatadiklat: indasmnt.idmatadiklat, idtest: indasmnt.idtest);

    //List<HasilSosiometriTBJFPAP2022> tasmnt=<HasilSosiometriTBJFPAP2022>[];
    if (json.decode(req.body)['data'] != null) {
      print("masuk 123");
      if(json.decode(req.body)['data'].length>0){
        setState((){
          cekBelbinPeserta=true;
          print("masuk 234 "+cekSosiometriPeserta.toString());
        });
      }
    }

    if(cekBelbinPeserta)
      {
        var req = await apiService.getSkorBelbin(user: nip,
            idkelas: indasmnt.idkelas, iddiklat: indasmnt.iddiklat,
            idmatadiklat: indasmnt.idmatadiklat, idtest: indasmnt.idtest,
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

  Future<void> getHasilSosiometri() async {
    var req = await apiService.cekSosiometriPeserta(user: nip,
        idkelas: indasmnt.idkelas, iddiklat: indasmnt.iddiklat,
        idmatadiklat: indasmnt.idmatadiklat, idtest: indasmnt.idtest);

    //List<HasilSosiometriTBJFPAP2022> tasmnt=<HasilSosiometriTBJFPAP2022>[];
    if (json.decode(req.body)['data'] != null) {
      print("masuk 123");
      if(json.decode(req.body)['data'].length>0){
        setState((){
          cekSosiometriPeserta=true;
          print("masuk 234 "+cekSosiometriPeserta.toString());
        });
      }
    }
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
      onTap: () async {
        if (indasmnt.jenistes == "0") {
          setState((){
            isLoading=true;
          });
          await getHasilSosiometri();
          if(cekSosiometriPeserta){
            setState((){
              isLoading=false;
            });
            Get.defaultDialog(
              content: MyDialogInfo(info: "Maaf Anda sudah mengisi tool ini sebelumnya."),
              titleStyle: TextStyle(fontSize: 0),
            );
          }
          else
            {
              List<Pertanyaan> pertanyaansosiometri = <Pertanyaan>[];
              pertanyaansosiometri=await getSoalTest(indasmnt.idtest);
              ScrollController _sc = new ScrollController();
              //late var tList; //= List.generate(a, (i) => List(b), growable: false);
              List<Peserta> anggotakelompok = <Peserta>[];
              anggotakelompok=await getPesertaLainDiGrup(indasmnt.idtest);
              print("masuk jmlh anggota kelompok "+anggotakelompok.length.toString());
              int indexaktif = 0;
              var tList = List.generate(pertanyaansosiometri.length,
                      (i) => List.filled(anggotakelompok.length, 0, growable: false),
                  growable: false);
              setState((){
                isLoading=false;
              });
              Get.to(() => SosiometriLembarJawaban(
                anggotakelompok: anggotakelompok,
                nilaianggota: tList,
                listpertanyaan: pertanyaansosiometri,
                indexaktif: indexaktif,
                tkg: indasmnt,) //SosiometriSoal()
              );
            }
        } else if (indasmnt.jenistes == "1") {
          setState((){
            isLoading=true;
          });
          await getHasilBelbin();
          List<Pertanyaan> pertanyaanbelbin = <Pertanyaan>[];
          int indexaktif = 0;
          List<List<PilihanJawaban>> pilihanjawaban = <List<PilihanJawaban>>[];
          List<List<int>> bobotjawaban = <List<int>>[];
          List<PilihanJawaban> tjawab=<PilihanJawaban>[];
          List<int> tbobot=<int>[];
          if(cekBelbinPeserta==false){
            pertanyaanbelbin=await getSoalTest(indasmnt.idtest);
            for(int p=0;p<pertanyaanbelbin.length;p++){
              tjawab=await getPilihanJawaban(pertanyaanbelbin[p].idpertanyaan);
              pilihanjawaban.add(tjawab);
              tbobot=List.generate(tjawab.length, (index) => 0);
              bobotjawaban.add(tbobot);
            }
            setState((){
              isLoading=false;
            });
            Get.to(() => BelbinIntro2(
              listpertanyaan: pertanyaanbelbin,
              pilihanjawaban: pilihanjawaban,
              bobotjawaban: bobotjawaban,
              indexaktif: 0,
              statustest: 0,
              tkg: indasmnt,
              hb: hb,
              cekstatus: cekBelbinPeserta,
            ));
          }
          else
            {
              setState((){
                isLoading=false;
              });
              Get.to(() => BelbinIntro2(
                listpertanyaan: pertanyaanbelbin,
                pilihanjawaban: pilihanjawaban,
                bobotjawaban: bobotjawaban,
                indexaktif: 0,
                statustest: 0,
                tkg: indasmnt,
                hb: hb,
                cekstatus: cekBelbinPeserta,
              ));
            }
        }
        else if (indasmnt.jenistes == "2") {
          Get.to(()=>MBTIIntro(idtest: indasmnt.idtest,nip: nip, tkg:
          TestKelasGrouping(idtest: indasmnt.idtest, idgrouping: indasmnt.idgrouping,
              iddiklat: indasmnt.iddiklat, idmatadiklat: indasmnt.idmatadiklat,
              idkelas: indasmnt.idkelas, inclass: indasmnt.inclass,
              ingroup: indasmnt.ingroup, jenistes: "2",
              namates: indasmnt.namates, status: "1"),));
        }
      },
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

  Future<List<Pertanyaan>> getSoalTest(String idtest) async {
    var req = await apiService.getSoalTest(user: nip,
        idtest: idtest);

    List<Pertanyaan> tsoal=<Pertanyaan>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        tsoal.add(Pertanyaan.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    return tsoal;
  }

  Future<List<PilihanJawaban>> getPilihanJawaban(String idpertanyaan) async {
    var req = await apiService.getPilihanJawaban(user: nip,
        idpertanyaan: idpertanyaan);

    List<PilihanJawaban> tjawaban=<PilihanJawaban>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        tjawaban.add(PilihanJawaban.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    return tjawaban;
  }

  Future<List<Peserta>> getPesertaLainDiGrup(String idtest) async {
    var req = await apiService.getPesertaLainDiGroup(user: nip,
        idgrouping: indasmnt.idgrouping);

    print(req.body);
    List<Peserta> tpsrt=<Peserta>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        tpsrt.add(Peserta.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    return tpsrt;
  }
}
