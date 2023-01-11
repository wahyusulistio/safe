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

class KapabilitasPetunjukB extends StatefulWidget {
  const KapabilitasPetunjukB(
      {Key? key, required this.indasmnt,})
      : super(key: key);

  final IndAssessment indasmnt;

  @override
  State<KapabilitasPetunjukB> createState() => _KapabilitasPetunjukBState();
}

class _KapabilitasPetunjukBState extends State<KapabilitasPetunjukB> {

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
                      data: """<p style="text-align: center;"><strong>PETUNJUK PENGISIAN ANGKET BAGIAN B</strong></p>
<p>&nbsp;</p>
<ol>
<li style="font-weight: 400;" aria-level="1"><span style="font-weight: 400;">Bacalah sejumlah pernyataan di bawah ini dengan teliti.</span></li>
<li style="font-weight: 400;" aria-level="1"><span style="font-weight: 400;">Saudara dimohon untuk memberikan jawaban yang menurut saudara benar pada lembar jawaban yang disediakan.</span></li>
<li style="font-weight: 400;" aria-level="1"><span style="font-weight: 400;">Angket bagian B terdiri dari 7 (tujuh) bagian yang harus saudara kerjakan.</span></li>
<li style="font-weight: 400;" aria-level="1"><span style="font-weight: 400;">Setiap bagian tes memiliki waktu masing-masing.</span></li>
<li style="font-weight: 400;" aria-level="1"><span style="font-weight: 400;">Tidak ada pengurangan nilai apabila jawaban saudara salah.</span></li>
<li style="font-weight: 400;" aria-level="1"><span style="font-weight: 400;">Hasil penelitian&nbsp; ini&nbsp; hanya&nbsp; untuk&nbsp; kepentingan&nbsp; pengumpulan data pegawai BPK.&nbsp; Identitas dari saudara akan dirahasiakan. Hasil penilaian ini tidak akan ada pengaruhnya terhadap status saudara sebagai pegawai BPK.</span></li>
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
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Angket Bagian B',
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
