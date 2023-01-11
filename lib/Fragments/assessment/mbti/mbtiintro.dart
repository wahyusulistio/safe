import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/assessment/MBTI/MBTIhasilpeserta.dart';
//import 'package:safe/Fragments/assessment/MBTI/MBTIlembarjawaban.dart';
import 'package:safe/Fragments/assessment/mbti/mbtilembarjawaban.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Models/HasilMBTI.dart';
import 'package:safe/Models/Pertanyaan.dart';
import 'package:safe/Models/PilihanJawaban.dart';
import 'package:safe/Models/testkelasgrouping.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';

class MBTIIntro extends StatefulWidget {
  MBTIIntro(
      {Key? key,
      required this.nip,
      required this.idtest,
      required this.tkg})
      : super(key: key);

  TestKelasGrouping tkg;
  final String nip;
  final String idtest;

  @override
  State<MBTIIntro> createState() => _MBTIIntroState();
}

class _MBTIIntroState extends State<MBTIIntro> {

  List<Pertanyaan> listpertanyaan = <Pertanyaan>[];
  List<List<PilihanJawaban>> pilihanjawaban = <List<PilihanJawaban>>[];
  List<List<int>> bobotjawaban = <List<int>>[];
  List<HasilMBTI> hb=<HasilMBTI>[];
  int indexaktif=0;
  int statustest=0;
  bool isLoading=false;
  bool cekstatus=false;
  late TestKelasGrouping tkg;
  String nip="";
  String idtest="";
  ApiService apiService = Get.find(tag: 'apiserv1');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nip=widget.nip;
    idtest=widget.idtest;
    tkg=widget.tkg;
    // if(widget.tkg!=null)
    //   {
    //     tkg=widget.tkg;
    //   }
    //initializeMBTI();
    getHasilMBTI(idtest).then((value) {
      setState((){
      });
    });
  }

  Future<void> initializeMBTI() async {
    listpertanyaan= await getSoalTest(idtest);
    List<PilihanJawaban> tjawab=<PilihanJawaban>[];
    //List<int> tbobot=<int>[];
    tjawab=await getPilihanJawaban(tkg.jenistes);
    for(int p=0;p<listpertanyaan.length;p++){
      List<PilihanJawaban> tjawab1=<PilihanJawaban>[];
      tjawab1.add(tjawab[p*2]);
      tjawab1.add(tjawab[p*2+1]);
      pilihanjawaban.add(tjawab1);
      //tbobot=List.generate(tjawab.length, (index) => 0);
      //bobotjawaban.add(tbobot);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Intro MBTI"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          color: Colors.teal,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                flex: 10,
                child: Container(
                  //color: Colors.amber,
                  //height: MediaQuery.of(context).size.height - 150,
                  child: SingleChildScrollView(
                    child: Html(
                      data: """<p>Tes ini terdiri atas 60 nomor soal.</p>
<p>Masing-masing nomor memiliki dua pernyataan (Pernyataan A dan B).</p>
<p>Pilihlah salah satu pernyataan yang paling sesuai dengan diri Anda pada setiap nomor soal.</p>
<p>Anda HARUS memilih salah satu yang paling dominan pada diri Anda.</p>
<p>Pastikan seluruh nomor terisi tanpa terlewat.</p>
                      """,
                      style: {
                        "p":Style(color: Colors.white, textAlign: TextAlign.justify),
                        "ul":Style(color: Colors.white, textAlign: TextAlign.justify),
                        "li":Style(color: Colors.white, textAlign: TextAlign.justify),
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1,
                child: Container(color: Colors.white),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  //color: Colors.cyanAccent,
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      onPressed: () async {
                        if(cekstatus){
                          //Get.to(()=>HasilMBTIPeserta(hb: hb,));
                          await Get.defaultDialog(
                            content:
                            MyDialogInfo(info: "Anda telah melakukan tes ini dalam kurun waktu kurang dari 180 hari. Silahkan lihat hasil tes sebelumnya pada bagian history di menu Akun Anda."),
                            titleStyle: TextStyle(fontSize: 0),
                          );
                        }
                        else{
                          await initializeMBTI();
                          Get.off(() => MBTILembarJawaban(
                              listpertanyaan: listpertanyaan,
                              indexaktif: indexaktif,
                              pilihanjawaban: pilihanjawaban,
                              //bobotjawaban: bobotjawaban,
                          tkg: widget.tkg,));
                        }
                      },
                      child: isLoading ?
                      SizedBox(
                        width: (MediaQuery.of(context).size.width<MediaQuery.of(context).size.height) ?
                        MediaQuery.of(context).size.width * 0.08 :
                        MediaQuery.of(context).size.height * 0.08,
                        height: (MediaQuery.of(context).size.width<MediaQuery.of(context).size.height) ?
                        MediaQuery.of(context).size.width * 0.08 :
                        MediaQuery.of(context).size.height * 0.08,
                        child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),),
                      ): Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Mulai Test',
                            style: TextStyle(
                              color: Colors.teal,
                            ),
                          ), // <-- Text
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            // <-- Icon
                            Icons.start,
                            size: 24.0, color: Colors.teal,
                          ),
                        ],
                      ), // <-- Text
                    ),
                  ),
                  //height: 50,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Pertanyaan>> getSoalTest(String idtest) async {
    var req = await apiService.getSoalTest(user: widget.nip,
        idtest: idtest);

    List<Pertanyaan> tsoal=<Pertanyaan>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        tsoal.add(Pertanyaan.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    return tsoal;
  }

  Future<List<PilihanJawaban>> getPilihanJawaban(String idjenistest) async {
    var req = await apiService.getPilihanJawaban2(user: widget.nip,
        idjenistest: idjenistest);

    List<PilihanJawaban> tjawaban=<PilihanJawaban>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        tjawaban.add(PilihanJawaban.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    return tjawaban;
  }

  Future<void> getHasilMBTI(String idtest) async {
    setState((){
      isLoading=true;
    });
    var req = await apiService.cekStatusTest(user: nip, idtest: idtest);

    //List<HasilSosiometriTBJFPAP2022> tasmnt=<HasilSosiometriTBJFPAP2022>[];
    if (json.decode(req.body)['data'] != null) {
      print("masuk 123");
      if(json.decode(req.body)['data'].length>0){
        setState((){
          cekstatus=true;
          //print("masuk 234 "+cekSosiometriPeserta.toString());
        });
      }
    }

    setState((){
      isLoading=false;
    });
  }
}
