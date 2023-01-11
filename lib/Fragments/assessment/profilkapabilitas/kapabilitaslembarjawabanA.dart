import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:safe/Fragments/assessment/belbin/belbinhasilfasilitator.dart';
import 'package:safe/Fragments/assessment/belbin/belbinhasilpeserta.dart';
import 'package:safe/Fragments/assessment/profilkapabilitas/kapabilitaspetunjukB.dart';
import 'package:safe/Fragments/dialogconfirm.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Models/HasilBelbin.dart';
import 'package:safe/Models/IndAssessment.dart';
import 'package:safe/Models/Pertanyaan.dart';
import 'package:safe/Models/PilihanJawaban.dart';
import 'package:safe/Models/testkelasgrouping.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';

class KapabilitasLembarJawabanA extends StatefulWidget {
  KapabilitasLembarJawabanA(
      {Key? key,
      required this.listpertanyaanpart1,
        required this.listpertanyaanpart2,
      required this.indexaktif,
      //required this.pilihanjawaban,
      required this.jawabanpesertapart1,
        required this.jawabanpesertapart2,
        required this.indasmnt})
      : super(key: key);

  final List<Pertanyaan> listpertanyaanpart1;
  final List<Pertanyaan> listpertanyaanpart2;
  //final List<List<PilihanJawaban>> pilihanjawaban;
  final List<int> jawabanpesertapart1;
  final List<int> jawabanpesertapart2;
  final int indexaktif;
  final IndAssessment indasmnt;

  @override
  State<KapabilitasLembarJawabanA> createState() => _KapabilitasLembarJawabanAState();
}

class _KapabilitasLembarJawabanAState extends State<KapabilitasLembarJawabanA> {
  ApiService apiService = Get.find(tag: 'apiserv1');
  String nama = "";
  String nip = "";
  String role = "";
  late IndAssessment indasmnt;
  late List<Pertanyaan> listpertanyaan1;
  late List<Pertanyaan> listpertanyaan2;
  //late List<List<PilihanJawaban>> pilihanjawaban;
  late List<int> jawabanpeserta1;
  late List<int> jawabanpeserta2;
  //List<TextEditingController> tecs = <TextEditingController>[];
  final _controller=TextEditingController();
  int indexa = 0;
  String masalahvalid = "";
  bool isLoading=false;
  //bool getReset=false;
  //late var tList; //= List.generate(a, (i) => List(b), growable: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indexa = widget.indexaktif;
    listpertanyaan1 = widget.listpertanyaanpart1;
    listpertanyaan2 = widget.listpertanyaanpart2;
    //pilihanjawaban = widget.pilihanjawaban;
    jawabanpeserta1 = widget.jawabanpesertapart1;
    jawabanpeserta2 = widget.jawabanpesertapart2;
    print("set bobot dl");
    indasmnt=widget.indasmnt;
    SecureStorageHelper.getListString("userinfo").then((value) {
      setState(() {
        if (value != null) {
          nama = value[2].toString();
          nip = value[3].toString();
          role = value[6].toString();
        } else {
          //print("username1 $value");
        }
      });
    });
    //print(bobotjawaban);

    // for (int i = 0; i < 10; i++) {
    //   tecs.add(TextEditingController());
    // }
  }

  @override
  Widget build(BuildContext context) {
    //return
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: (indexa==0 ? Text("Angket A Part I") : Text("Angket A Part II")) ,
          backgroundColor: Colors.teal,
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
          actions: [
            Center(
                child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text("10.00"))),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
            color: Colors.teal,
            child: Container(
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: indexa != 0
                        ? InkWell(
                            onTap: () async {
                              //bool validitas = cekIsianValid(bobotjawaban[indexa]);
                              //if(validitas){
                                Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                          KapabilitasLembarJawabanA(
                                            listpertanyaanpart1: listpertanyaan1,
                                            listpertanyaanpart2: listpertanyaan2,
                                            indexaktif: indexa - 1,
                                            //pilihanjawaban: pilihanjawaban,
                                            jawabanpesertapart1: jawabanpeserta1,
                                            jawabanpesertapart2: jawabanpeserta2,
                                            indasmnt: indasmnt,
                                          ),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ));
                              // } else {
                              //   await Get.defaultDialog(
                              //     content: MyDialogInfo(info: masalahvalid),
                              //     titleStyle: TextStyle(fontSize: 0),
                              //   );
                              // }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  // <-- Icon
                                  Icons.arrow_back_ios_new,
                                  size: 24.0, color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Prev',
                                  style: TextStyle(color: Colors.white),
                                ), // <-- Text
                              ],
                            ),
                          )
                        : Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () async {
                        if (indexa == 1) {
                          //bool validitas = cekIsianValid(bobotjawaban[indexa]);
                          //if(validitas){
                            var datares = await Get.defaultDialog(
                              content:
                              MyDialogConfirm(info: "Submit jawaban Anda untuk Angket A?"),
                              titleStyle: TextStyle(fontSize: 0),
                            );
                            Map<String, dynamic> json =
                            jsonDecode(datares.toString());
                            if (json["respon"] == "ya") {
                              // setState((){
                              //   isLoading=true;
                              // });
                              // for(int i=0;i<(indexa==0 ? listpertanyaan1 : listpertanyaan2).length;i++){
                              //   //for(int j=0;j<pilihanjawaban[i].length;j++){
                              //     if((indexa==0? jawabanpeserta1  : jawabanpeserta2)[i]!=""){
                              //       await apiService.addResponPeserta(
                              //           user: nip,
                              //           idtest: indasmnt.asmntid,
                              //           idkelas: "53C38222-CEC8-43DD-B1CD-CD5ED07D2EDC",
                              //           idpertanyaan: (indexa==0 ? listpertanyaan1 : listpertanyaan2)[i].idpertanyaan,
                              //           respon: (indexa==0? jawabanpeserta1  : jawabanpeserta2)[i].toString(),
                              //           nilai: "0",
                              //           bobot: "0",
                              //           iddiklat: "0",
                              //           idmatadiklat: "0",
                              //           atribut1: "0");
                              //     }
                              //   //}
                              // }
                              // setState((){
                              //   isLoading=false;
                              // });
                              await Get.defaultDialog(
                                content:
                                MyDialogInfo(info: "Angket A telah disubmit"),
                                titleStyle: TextStyle(fontSize: 0),
                              );

                              //Get.back();

                              Get.off(()=>KapabilitasPetunjukB(indasmnt: indasmnt,));
                            }
                          // } else {
                          //   await Get.defaultDialog(
                          //     content: MyDialogInfo(info: masalahvalid),
                          //     titleStyle: TextStyle(fontSize: 0),
                          //   );
                          // }
                        } else {
                          var req = await apiService.getSoalTestPerGrup(user: nip,
                              idtest: indasmnt.asmntid, idgrup: "2");

                          List<Pertanyaan> tsoal=<Pertanyaan>[];
                          if (json.decode(req.body)['data'] != null) {
                            for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
                              tsoal.add(Pertanyaan.fromJSON(json.decode(req.body)['data'][i]));
                            }
                          }

                          //validasi isian
                          //bool validitas = cekIsianValid(bobotjawaban[indexa]);
                          //if (validitas) {
                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          KapabilitasLembarJawabanA(
                                            listpertanyaanpart1: listpertanyaan1,
                                            listpertanyaanpart2: listpertanyaan2,
                                            indexaktif: indexa + 1,
                                            //pilihanjawaban: pilihanjawaban,
                                            jawabanpesertapart1: jawabanpeserta1,
                                            jawabanpesertapart2: jawabanpeserta2,
                                    //pilihanjawaban: pilihanjawaban,
                                            indasmnt: indasmnt,
                                  ),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ));
                          // } else {
                          //   await Get.defaultDialog(
                          //     content: MyDialogInfo(info: masalahvalid),
                          //     titleStyle: TextStyle(fontSize: 0),
                          //   );
                          // }
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            indexa == 1
                                ? 'Submit'
                                : 'Next',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ), // <-- Text
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            // <-- Icon
                            indexa == 1
                                ? Icons.check
                                : Icons.arrow_forward_ios,
                            size: 24.0, color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Directionality(
                  //   textDirection: TextDirection.rtl,
                  //   child: ElevatedButton.icon(
                  //     style: ElevatedButton.styleFrom(primary: Colors.white),
                  //     icon: Icon(Icons.arrow_forward_ios_sharp, color: Colors.teal),
                  //     label: Text(
                  //       'Next',
                  //       style: TextStyle(color: Colors.teal),
                  //     ), // <-- Text
                  //   ),
                  // ),
                ],
              ),
            )),
        body: Stack(
          children: [Container(
            height: MediaQuery.of(context).size.height,
            //decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
            // child: ListView.builder(
            //   scrollDirection: Axis.vertical,
            //   shrinkWrap: false,
            //   itemCount: pertanyaansosiometri.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     return SosiometriItem(pertanyaan: pertanyaansosiometri[index]);  //makeCard(mails[index]);
            //   },
            //   //controller: _sc,
            // ),
            //child: Container(
            // constraints: BoxConstraints(
            //   maxHeight: double.infinity,
            // ),
            child: Column(
                //mainAxisSize: MainAxisSize.min,
                //mainAxisSize: MainAxisSize.max,
                children: [
                  // Expanded(
                  //     flex: 2,
                  //     child: Container(
                  //       padding: EdgeInsets.symmetric(vertical: 20),
                  //       color: Colors.teal,
                  //       child: SingleChildScrollView(
                  //         child: Center(
                  //             child: Padding(
                  //           padding: EdgeInsets.symmetric(horizontal: 20),
                  //               child: Html(
                  //                 data: listpertanyaan[indexa].pertanyaan,
                  //                 style: {
                  //                   "p":Style(color: Colors.white, textAlign: TextAlign.justify),
                  //                 },
                  //               ),
                  //           // child: AutoSizeText(
                  //           //   listpertanyaan[indexa].pertanyaan,
                  //           //   maxLines: 10,
                  //           //   style: TextStyle(
                  //           //     color: Colors.white,
                  //           //     fontSize: 20,
                  //           //   ),
                  //           //   textAlign: TextAlign.center,
                  //           // ),
                  //         )),
                  //       ),
                  //     )),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        child: HorizontalDataTable(
                          leftHandSideColumnWidth:
                          (MediaQuery.of(context).size.width) * 0.5,
                          rightHandSideColumnWidth:
                          (MediaQuery.of(context).size.width) * 0.5,
                          isFixedHeader: true,
                          headerWidgets: _getTitleWidget(),
                          leftSideItemBuilder: _generateFirstColumnRow,
                          rightSideItemBuilder: _generateRightHandSideColumnRow,
                          itemCount: (indexa==0 ? listpertanyaan1 : listpertanyaan2).length,
                          rowSeparatorWidget: const Divider(
                            color: Colors.black54,
                            height: 1.0,
                            thickness: 0.0,
                          ),
                          leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                          rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
            isLoading ? Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ) : Container()
          ],
        ),
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    List<Widget> headers = [];
    headers.add(_getTitleItemWidget(
        "Pernyataan", MediaQuery.of(context).size.width * 0.5));
    headers.add(_getTitleItemWidget("SS", MediaQuery.of(context).size.width * 0.4/5));
    headers.add(_getTitleItemWidget("S", MediaQuery.of(context).size.width * 0.4/5));
    headers.add(_getTitleItemWidget("RR", MediaQuery.of(context).size.width * 0.4/5));
    headers.add(_getTitleItemWidget("TS", MediaQuery.of(context).size.width * 0.4/5));
    headers.add(_getTitleItemWidget("STS", MediaQuery.of(context).size.width * 0.4/5));
    // for (int i = 0; i < anggotakelompok.length; i++) {
    //   headers.add(_getTitleItemWidget(indexanggota[i].toString(),
    //       MediaQuery.of(context).size.width * 0.6 / (anggotakelompok.length)));
    // }
    return headers;
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.03)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    //print("generate dulu");
    return Container(
      margin: EdgeInsets.all(5),
      child: AutoSizeText((indexa==0 ? listpertanyaan1 : listpertanyaan2)[index].pertanyaan, maxLines: 4,),
      width: MediaQuery.of(context).size.width * 0.5,
      height: 70,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    List<Widget> lines = [];
    for (int i = 0; i < 5; i++) {
      lines.add(Container(
        child: Radio(
          value: 5-i,
          groupValue: (indexa==0 ? jawabanpeserta1 : jawabanpeserta2)[index], //"row" + (i + 1).toString(),
          onChanged: (Object? value) {
            setState(() {
              (indexa==0 ? jawabanpeserta1 : jawabanpeserta2)[index] = int.parse(value.toString());
            });
          },
        ),
        width:
        MediaQuery.of(context).size.width * 0.4/5,
        height: 80,
        //color: Colors.teal,
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
      ));
    }
    return Row(children: lines);
  }

  bool cekIsianValid(List<int> listnilai) {
    bool status = true;
    int countisian = 0;
    int sumisian = 0;
    for (int i = 0; i < listnilai.length; i++) {
      if (listnilai[i] > 0) {
        countisian += 1;
      }
      sumisian += listnilai[i];
      print("jumlah "+sumisian.toString());
    }
    if (countisian < 2 || countisian > 9 || sumisian != 10) {
      status = false;
      if (countisian < 2)
        masalahvalid = "Jumlah isian kurang!";
      else if (countisian > 9)
        masalahvalid = "Jumlah isian terlalu banyak!";
      else if (sumisian != 10)
        masalahvalid = "Jumlah nilai isian tidak 10!";
    }
    return status;
  }

  String getJsonRespon(int indexpertanyaan, List<Pertanyaan> pertanyaans,
      List<List<PilihanJawaban>> pilihanjawaban, List<String> jawaban) {
    String responstring = '';
    responstring += '{';
    responstring =
        responstring + '"' + pertanyaans[indexpertanyaan].idpertanyaan + '":';
    responstring + '"' + jawaban[indexpertanyaan] + '":';

    responstring += "}";
    print(responstring);
    return responstring;
  }
}
