import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/assessment/B5P/B5Phasilpeserta.dart';
//import 'package:safe/Fragments/assessment/B5P/B5Plembarjawaban.dart';
//import 'package:safe/Fragments/assessment/B5P/B5Plembarjawaban.dart';
import 'package:safe/Fragments/assessment/b5p/b5plembarjawaban.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Models/HasilB5P.dart';
import 'package:safe/Models/Pertanyaan.dart';
import 'package:safe/Models/PilihanJawaban.dart';
import 'package:safe/Models/testkelasgrouping.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';

class B5PIntro extends StatefulWidget {
  B5PIntro(
      {Key? key,
      required this.nip,
      required this.idtest,
      required this.tkg})
      : super(key: key);

  TestKelasGrouping tkg;
  final String nip;
  final String idtest;

  @override
  State<B5PIntro> createState() => _B5PIntroState();
}

class _B5PIntroState extends State<B5PIntro> {

  List<Pertanyaan> listpertanyaan = <Pertanyaan>[];
  List<List<PilihanJawaban>> pilihanjawaban = <List<PilihanJawaban>>[];
  List<List<int>> bobotjawaban = <List<int>>[];
  List<HasilB5P> hb=<HasilB5P>[];
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
    //initializeB5P();
    getHasilB5P(idtest).then((value) {
      setState((){
      });
    });
  }

  Future<void> initializeB5P() async {
    setState((){
      isLoading=true;
    });
    listpertanyaan= await getSoalTest(idtest);
    List<PilihanJawaban> tjawab=<PilihanJawaban>[];
    //List<int> tbobot=<int>[];
    tjawab=await getPilihanJawaban(tkg.jenistes);
    for(int p=0;p<listpertanyaan.length;p++){
      List<PilihanJawaban> tjawab1=<PilihanJawaban>[];
      tjawab1.add(tjawab[p]);
      //tjawab1.add(tjawab[p*2+1]);
      pilihanjawaban.add(tjawab1);
      //tbobot=List.generate(tjawab.length, (index) => 0);
      //bobotjawaban.add(tbobot);
    }
    setState((){
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Intro B5P"),
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
                      data: """<p>Tes ini terdiri atas 25 nomor soal.</p>
<p>Masing-masing nomor memiliki dua sisi pernyataan.</p>
<p>Anda diharapkan dapat memilih skala yang paling sesuai dengan diri Anda diantara dua penyataan tersebut pada setiap nomor soal.</p>
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
                          //Get.to(()=>HasilB5PPeserta(hb: hb,));
                          await Get.defaultDialog(
                            content:
                            MyDialogInfo(info: "Anda telah melakukan tes ini dalam kurun waktu kurang dari 180 hari. Silahkan lihat hasil tes sebelumnya pada bagian history di menu Akun Anda."),
                            titleStyle: TextStyle(fontSize: 0),
                          );
                        }
                        else{
                          await initializeB5P();
                          Get.off(() => B5PLembarJawaban(
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
                        MediaQuery.of(context).size.width * 0.06 :
                        MediaQuery.of(context).size.height * 0.06,
                        height: (MediaQuery.of(context).size.width<MediaQuery.of(context).size.height) ?
                        MediaQuery.of(context).size.width * 0.06 :
                        MediaQuery.of(context).size.height * 0.06,
                        child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),),
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

  Future<void> getHasilB5P(String idtest) async {
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
