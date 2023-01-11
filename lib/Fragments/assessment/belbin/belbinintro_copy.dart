import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/assessment/belbin/belbinhasilpeserta.dart';
import 'package:safe/Fragments/assessment/belbin/belbinlembarjawaban.dart';
import 'package:safe/Models/HasilBelbin.dart';
import 'package:safe/Models/Pertanyaan.dart';
import 'package:safe/Models/PilihanJawaban.dart';
import 'package:safe/Models/testkelasgrouping.dart';

class BelbinIntro2 extends StatelessWidget {
  BelbinIntro2(
      {Key? key,
      required this.listpertanyaan,
      required this.pilihanjawaban,
      required this.bobotjawaban,
      required this.indexaktif,
        required this.statustest, required this.tkg, required this.hb, required this.cekstatus})
      : super(key: key);

  TestKelasGrouping tkg;
  final List<Pertanyaan> listpertanyaan;
  final List<List<PilihanJawaban>> pilihanjawaban;
  final List<List<int>> bobotjawaban;
  final List<HasilBelbin> hb;
  final int indexaktif;
  final int statustest;
  final bool cekstatus;

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
                      onPressed: () {
                        if(hb.length>0){
                          Get.to(()=>HasilBelbinPeserta(hb: hb,));
                        }
                        else{
                          Get.off(() => BelbinLembarJawaban(
                              listpertanyaan: listpertanyaan,
                              indexaktif: indexaktif,
                              pilihanjawaban: pilihanjawaban,
                              bobotjawaban: bobotjawaban,
                          tkg: tkg,));
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cekstatus ?'Hasil Test':'Mulai Test',
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
