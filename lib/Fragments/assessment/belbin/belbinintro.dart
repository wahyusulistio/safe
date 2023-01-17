import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/assessment/belbin/belbinhasilpeserta.dart';
import 'package:safe/Fragments/assessment/belbin/belbinlembarjawaban.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Models/HasilBelbin.dart';
import 'package:safe/Models/Pertanyaan.dart';
import 'package:safe/Models/PilihanJawaban.dart';
import 'package:safe/Models/testkelasgrouping.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';

class BelbinIntro extends StatefulWidget {
  BelbinIntro(
      {Key? key,
      required this.nip,
      required this.idtest,
      required this.tkg})
      : super(key: key);

  TestKelasGrouping tkg;
  final String nip;
  final String idtest;

  @override
  State<BelbinIntro> createState() => _BelbinIntroState();
}

class _BelbinIntroState extends State<BelbinIntro> {

  List<Pertanyaan> listpertanyaan = <Pertanyaan>[];
  List<List<PilihanJawaban>> pilihanjawaban = <List<PilihanJawaban>>[];
  List<List<int>> bobotjawaban = <List<int>>[];
  List<HasilBelbin> hb=<HasilBelbin>[];
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
    //initializeBelbin();
    getHasilBelbin(idtest).then((value) {
      setState((){
      });
    });
  }

  Future<void> initializeBelbin() async {
    setState((){
      isLoading=true;
    });
    listpertanyaan= await getSoalTest(idtest);
    List<PilihanJawaban> tjawab=<PilihanJawaban>[];
    List<int> tbobot=<int>[];
    for(int p=0;p<listpertanyaan.length;p++){
      tjawab=await getPilihanJawaban(listpertanyaan[p].idpertanyaan);
      pilihanjawaban.add(tjawab);
      tbobot=List.generate(tjawab.length, (index) => 0);
      bobotjawaban.add(tbobot);
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
        title: Text("Intro Belbin"),
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
                      data: """<p>Tes ini terdiri atas 7 soal cerita, dan pada masing-masing soal cerita terdapat 10 pernyataan. Pernyataan-pernyataan tersebut tidak ada yang benar ataupun salah.</p>

<p>Ketentuan untuk mengerjakan tes ini adalah:</p>

<ul>
	<li>Pada masing-masing soal cerita pilihlah 2-9 pernyataan yang paling sesuai dengan diri Anda.</li>
	<li>Berilah nilai pada pernyataan-pernyataan yang telah Anda pilih. Yang harus Anda perhatikan, total nilai pada masing-masing soal cerita haruslah berjumlah 10</li>
</ul>
                      """,
                      style: {
                        "p":Style(color: Colors.white, textAlign: TextAlign.justify),
                        "ul":Style(color: Colors.white, textAlign: TextAlign.justify),
                        "li":Style(color: Colors.white, textAlign: TextAlign.justify),
                      },
                    ),
                    // child: Column(
                    //   children: [
                    //     Padding(
                    //       padding: EdgeInsets.all(10),
                    //       child: Text(
                    //         "Belbin  ....... .. .... ........"
                    //         "...... ... .... ...... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "........ ......",
                    //         style: TextStyle(fontSize: 15, color: Colors.white),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsets.all(10),
                    //       child: Text(
                    //         "Untuk mengisi form Belbin ini maka Anda ..."
                    //         "...... ... .... ...... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "........ ......",
                    //         style: TextStyle(fontSize: 15, color: Colors.white),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsets.all(10),
                    //       child: Text(
                    //         "Untuk mengisi form Belbin ini maka Anda ..."
                    //         "...... ... .... ...... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "........ ......",
                    //         style: TextStyle(fontSize: 15, color: Colors.white),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsets.all(10),
                    //       child: Text(
                    //         "Untuk mengisi form Belbin ini maka Anda ..."
                    //         "...... ... .... ...... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "........ ......",
                    //         style: TextStyle(fontSize: 15, color: Colors.white),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsets.all(10),
                    //       child: Text(
                    //         "Untuk mengisi form Belbin ini maka Anda ..."
                    //         "...... ... .... ...... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "......... .......... ....... "
                    //         "........ ......",
                    //         style: TextStyle(fontSize: 15, color: Colors.white),
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
                          //Get.to(()=>HasilBelbinPeserta(hb: hb,));
                          await Get.defaultDialog(
                            content:
                            MyDialogInfo(info: "Anda telah melakukan tes ini dalam kurun waktu kurang dari 180 hari. Silahkan lihat hasil tes sebelumnya pada bagian history di menu Akun Anda."),
                            titleStyle: TextStyle(fontSize: 0),
                          );
                        }
                        else{
                          await initializeBelbin();
                          Get.off(() => BelbinLembarJawaban(
                              listpertanyaan: listpertanyaan,
                              indexaktif: indexaktif,
                              pilihanjawaban: pilihanjawaban,
                              bobotjawaban: bobotjawaban,
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

  Future<List<PilihanJawaban>> getPilihanJawaban(String idpertanyaan) async {
    var req = await apiService.getPilihanJawaban(user: widget.nip,
        idpertanyaan: idpertanyaan);

    List<PilihanJawaban> tjawaban=<PilihanJawaban>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        tjawaban.add(PilihanJawaban.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    return tjawaban;
  }

  Future<void> getHasilBelbin(String idtest) async {
    setState((){
      isLoading=true;
    });
    var req = await apiService.cekBelbin(user: nip,
        idkelas: "", iddiklat: "",
        idmatadiklat: "", idtest: idtest);

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
