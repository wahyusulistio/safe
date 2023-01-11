import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/assessment/belbin/belbinhasilpeserta.dart';
import 'package:safe/Fragments/assessment/belbin/belbinlembarjawaban.dart';
import 'package:safe/Fragments/assessment/profilkapabilitas/kapabilitaspetunjukA.dart';
import 'package:safe/Models/HasilBelbin.dart';
import 'package:safe/Models/IndAssessment.dart';
import 'package:safe/Models/Pertanyaan.dart';
import 'package:safe/Models/PilihanJawaban.dart';
import 'package:safe/Models/testkelasgrouping.dart';

class KapabilitasIntro extends StatelessWidget {
  const KapabilitasIntro(
      {Key? key, required this.indasmnt,})
      : super(key: key);

  //final String idtest;
  final IndAssessment indasmnt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Tes Profil Kapabilitas"),
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
                      data: """<p style="text-align: center;"><strong>PENGANTAR</strong></p>
<p>&nbsp;</p>
<p style="text-align: justify;"><span style="font-weight: 400;">Pada buku persoalan ini terdapat dua bagian persoalan.</span></p>
<p style="text-align: justify;">&nbsp;</p>
<p style="text-align: justify;"><span style="font-weight: 400;">Persoalan A memuat beberapa pernyataan yang sifatnya </span><em><span style="font-weight: 400;">self report questionnaire.</span></em></p>
<p style="text-align: justify;"><span style="font-weight: 400;">Pada bagian A, saudara diminta untuk menjawab setiap pernyataan dengan memilih opsi pilihan yang sesuai dengan kondisi dan keadaan saudara.</span></p>
<p style="text-align: justify;">&nbsp;</p>
<p style="text-align: justify;"><span style="font-weight: 400;">Persoalan B memuat beberapa pertanyaan yang memuat pilihan jawaban benar dan pilihan jawaban salah.</span></p>
<p style="text-align: justify;"><span style="font-weight: 400;">Pada bagian B, saudara diminta untuk menjawab setiap persoalan dengan cara memilih satu jawaban yang paling benar diantara pilihan jawaban lainnya.</span></p>
<p style="text-align: justify;">&nbsp;</p>
<p style="text-align: justify;"><span style="font-weight: 400;">Semua hasil pengisian saudara akan menjadi milik kami dan akan digunakan sebagai bank data profil pegawai BPK. Mohon kesungguhan dan keseriusan saudara dalam mengerjakan setiap persoalan.</span></p>
<p style="text-align: justify;"><span style="font-weight: 400;">Bacalah dengan seksama dan teliti.</span></p>
<p>&nbsp;</p>
<p style="text-align: center;"><strong>Selamat mengerjakan.</strong></p>""",
                      style: {
                        "p":Style(color: Colors.white, textAlign: TextAlign.justify),
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
                        Get.to(()=>KapabilitasPetunjukA(indasmnt: indasmnt,));
                      },
                      child: Row(
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
}
