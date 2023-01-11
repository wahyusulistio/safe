import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/assessment/belbin/belbinhasilpeserta.dart';
import 'package:safe/Fragments/assessment/belbin/belbinlembarjawaban.dart';
import 'package:safe/Fragments/assessment/profilkapabilitas/kapabilitaslembarjawabanA.dart';
import 'package:safe/Fragments/dialogconfirm.dart';
import 'package:safe/Models/HasilBelbin.dart';
import 'package:safe/Models/IndAssessment.dart';
import 'package:safe/Models/Pertanyaan.dart';
import 'package:safe/Models/PilihanJawaban.dart';
import 'package:safe/Models/testkelasgrouping.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';

class KapabilitasPetunjukA extends StatefulWidget {
  const KapabilitasPetunjukA(
      {Key? key, required this.indasmnt,})
      : super(key: key);

  final IndAssessment indasmnt;

  @override
  State<KapabilitasPetunjukA> createState() => _KapabilitasPetunjukAState();
}

class _KapabilitasPetunjukAState extends State<KapabilitasPetunjukA> {

  ApiService apiService = Get.find(tag: 'apiserv1');
  String nama = "";
  String nip = "";
  String role = "";
  List<Pertanyaan> listpertanyaan1=<Pertanyaan>[];
  List<Pertanyaan> listpertanyaan2=<Pertanyaan>[];
  //late List<List<PilihanJawaban>> pilihanjawaban;
  List<int> jawabanpeserta1=<int>[];
  List<int> jawabanpeserta2=<int>[];
  bool isLoading=false;
  late IndAssessment indasmnt;



  Future<void> getPertanyaanAngketA() async {
    setState((){
      listpertanyaan1.clear();
      listpertanyaan2.clear();
    });
    var req = await apiService.getSoalTestPerGrup(user: nip,
    idtest: indasmnt.asmntid, idgrup: "1");

    List<Pertanyaan> tsoal=<Pertanyaan>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        tsoal.add(Pertanyaan.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    setState((){
      listpertanyaan1.addAll(tsoal);
      jawabanpeserta1=List.generate(tsoal.length, (index) => 0);
    });

    var req2 = await apiService.getSoalTestPerGrup(user: nip,
        idtest: indasmnt.asmntid, idgrup: "2");

    List<Pertanyaan> tsoal2=<Pertanyaan>[];
    if (json.decode(req2.body)['data'] != null) {
      for (int i = 0; i < json.decode(req2.body)['data'].length; i++) {
        tsoal2.add(Pertanyaan.fromJSON(json.decode(req2.body)['data'][i]));
      }
    }

    setState((){
      listpertanyaan2.addAll(tsoal2);
      jawabanpeserta2=List.generate(tsoal2.length, (index) => 0);
    });

  }

  // Future<List<PilihanJawaban>> getPilihanJawaban(String idpertanyaan) async {
  //   var req = await apiService.getPilihanJawaban(user: nip,
  //       idpertanyaan: idpertanyaan);
  //
  //   List<PilihanJawaban> tjawaban=<PilihanJawaban>[];
  //   if (json.decode(req.body)['data'] != null) {
  //     for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
  //       tjawaban.add(PilihanJawaban.fromJSON(json.decode(req.body)['data'][i]));
  //     }
  //   }
  //
  //   return tjawaban;
  //}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indasmnt=widget.indasmnt;
    //indasmnt = widget.indasmnt;
    SecureStorageHelper.getListString("userinfo").then((value) {
      setState(() {
        if (value != null) {
          nama = value[2].toString();
          nip = value[3].toString();
          role = value[6].toString();
          getPertanyaanAngketA();
          //getHasilBelbin();
          //getHasilSosiometri();
        } else {
          //print("username1 $value");
        }
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Tes Profil Kapabilitas"),
        leading: //Container(),
        InkWell(
          onTap: () async {
            var datares = await Get.defaultDialog(
              content: MyDialogConfirm(info: "Keluar dari Assessment ini?"),
              titleStyle: TextStyle(fontSize: 0),
            );
            Map<String, dynamic> json = jsonDecode(datares.toString());
            if (json["respon"] == "ya") {
              Get.back();
            }
          },
          child: Icon(Icons.close),
        ),
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
                      data: """<p style="text-align: center;"><strong>PETUNJUK PENGISIAN ANGKET BAGIAN A</strong></p>
<p>&nbsp;</p>
<ol>
<li style="font-weight: 400; text-align: justify;" aria-level="1"><span style="font-weight: 400;">Bacalah sejumlah pernyataan di bawah ini dengan teliti.</span></li>
<li style="font-weight: 400; text-align: justify;" aria-level="1"><span style="font-weight: 400;">Saudara dimohon&nbsp; untuk&nbsp; memberikan&nbsp; jawaban&nbsp; secara objektif dengan memberi tanda silang (X) pada salah satu kriteria untuk setiap pernyataan yang menurut saudara paling sesuai dengan keadaan saudara.</span></li>
<li style="font-weight: 400; text-align: justify;" aria-level="1"><span style="font-weight: 400;">Setiap pernyataan tidak mengandung jawaban benar-salah, melainkan menunjukkan kesesuaian penilaian saudara terhadap isi setiap pernyataan dikaitkan dengan keadaan saudara.</span></li>
<li style="font-weight: 400; text-align: justify;" aria-level="1"><span style="font-weight: 400;">Jawabalah setiap pernyataan dengan sungguh-sungguh dan jujur. Hasil pengisian akan menggambarkan kondisi saudara saat ini.</span></li>
<li style="font-weight: 400; text-align: justify;" aria-level="1"><span style="font-weight: 400;">Pilihan jawaban yang tersedia adalah :</span></li>
</ol>
<p style="padding-left: 80px;"><strong>STS &nbsp; &nbsp; </strong><span style="font-weight: 400;">= Apabila saudara merasa </span><strong>Sangat Tidak Sesuai</strong></p>
<p style="padding-left: 80px;"><strong>TS &nbsp; &nbsp; &nbsp; </strong><span style="font-weight: 400;">= Apabila saudara merasa </span><strong>Tidak Sesuai</strong></p>
<p style="padding-left: 80px;"><strong>R &nbsp; &nbsp; &nbsp; &nbsp; = </strong><span style="font-weight: 400;">Apabila saudara merasa </span><strong>Ragu-ragu</strong></p>
<p style="padding-left: 80px;"><strong>S&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </strong><span style="font-weight: 400;">= Apabila saudara merasa </span><strong>Sesuai</strong></p>
<p style="padding-left: 80px;"><strong>SS &nbsp; &nbsp; &nbsp; </strong><span style="font-weight: 400;">= Apabila saudara merasa </span><strong>Sangat Sesuai</strong></p>
<ol start="6">
<li style="font-weight: 400; text-align: justify;" aria-level="1"><span style="font-weight: 400;">Dimohon dalam memberikan penilaian tidak ada pernyataan yang terlewatkan.</span></li>
<li style="font-weight: 400; text-align: justify;" aria-level="1"><span style="font-weight: 400;">Hasil penelitian&nbsp; ini&nbsp; hanya&nbsp; untuk&nbsp; kepentingan&nbsp; pengumpulan data pegawai BPK.&nbsp; Identitas dari saudara akan dirahasiakan. Hasil penilaian ini tidak akan ada pengaruhnya terhadap status saudara sebagai pegawai BPK.</span></li>
<li style="font-weight: 400; text-align: justify;" aria-level="1"><span style="font-weight: 400;">Waktu pengerjaan untuk Persoalan Bagian A adalah </span><strong>maksimal 30 menit</strong><span style="font-weight: 400;">.</span></li>
</ol>""",
                      style: {
                        "p":Style(color: Colors.white, textAlign: TextAlign.justify),
                        "li":Style(color: Colors.white, textAlign: TextAlign.justify),
                        "ol":Style(color: Colors.white, textAlign: TextAlign.justify),
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
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation1, animation2) =>
                                  KapabilitasLembarJawabanA(
                                    listpertanyaanpart1: listpertanyaan1,
                                    listpertanyaanpart2: listpertanyaan2,
                                    indexaktif: 0,
                                    jawabanpesertapart1: jawabanpeserta1,
                                    jawabanpesertapart2: jawabanpeserta2,
                                    //pilihanjawaban: pilihanjawaban,
                                    indasmnt: indasmnt,
                                  ),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Angket Bagian A',
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
}
