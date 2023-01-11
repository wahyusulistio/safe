import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:safe/Fragments/dialogconfirm.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Models/Pertanyaan.dart';
import 'package:safe/Models/Peserta.dart';
import 'package:safe/Models/testkelasgrouping.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';

class SosiometriLembarJawaban extends StatefulWidget {
  SosiometriLembarJawaban(
      {Key? key,
      required this.anggotakelompok,
      required this.nilaianggota,
      required this.listpertanyaan,
      required this.indexaktif,
      required this.tkg})
      : super(key: key);

  final List<Pertanyaan> listpertanyaan;
  final List<Peserta> anggotakelompok;
  final List<List<int>> nilaianggota;
  final int indexaktif;
  final TestKelasGrouping tkg;

  @override
  State<SosiometriLembarJawaban> createState() =>
      _SosiometriLembarJawabanState();
}

class _SosiometriLembarJawabanState extends State<SosiometriLembarJawaban> {
  ApiService apiService = Get.find(tag: 'apiserv1');
  String nama = "";
  String nip = "";
  String role = "";
  List<Peserta> anggotakelompok = <Peserta>[];
  late List<int> indexanggota;
  late List<List<int>> nilaianggota;
  late List<Pertanyaan> listpertanyaan;
  int jmlhpeserta = 0;
  int indexa = 0;
  late TestKelasGrouping tkg;
  bool isLoading=false;
  //late var tList; //= List.generate(a, (i) => List(b), growable: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tkg = widget.tkg;
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
    anggotakelompok = widget.anggotakelompok;
    indexanggota = List.generate(
        anggotakelompok.length, (j) => (1 + j)); // ["1", "2", "3"];
    nilaianggota = widget
        .nilaianggota; //List.generate(anggotakelompok.length, (index) => 0);
    jmlhpeserta = anggotakelompok.length;
    indexa = widget.indexaktif;
    listpertanyaan = widget.listpertanyaan;

    // tList = List.generate(anggotakelompok.length,
    //     (i) => List.filled(anggotakelompok.length, 0, growable: false),
    //     growable: false);
  }

  @override
  Widget build(BuildContext context) {
    //return
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Sosiometri"),
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
                    child: Text((indexa + 1).toString() +
                        "/" +
                        listpertanyaan.length.toString()))),
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
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            SosiometriLembarJawaban(
                                      anggotakelompok: anggotakelompok,
                                      nilaianggota: nilaianggota,
                                      listpertanyaan: listpertanyaan,
                                      indexaktif: indexa - 1,
                                      tkg: tkg,
                                    ),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ));
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
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          nilaianggota[indexa] = List.generate(
                              anggotakelompok.length, (index) => 0);
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Reset',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ), // <-- Text
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () async {
                        if (indexa == listpertanyaan.length - 1) {
                          print(nilaianggota);
                          var datares = await Get.defaultDialog(
                            content:
                                MyDialogConfirm(info: "Submit penilaian Anda?"),
                            titleStyle: TextStyle(fontSize: 0),
                          );
                          Map<String, dynamic> json =
                              jsonDecode(datares.toString());
                          if (json["respon"] == "ya") {
                            bool isvalid=cekValiditasAll(nilaianggota);
                            if(isvalid){
                              setState((){
                                isLoading=true;
                              });
                              for (int i = 0; i < listpertanyaan.length; i++) {
                                for(int j=0; j<anggotakelompok.length;j++){
                                  await apiService.addResponPeserta(
                                      user: nip,
                                      idtest: tkg.idtest,
                                      idkelas: tkg.idkelas,
                                      idpertanyaan: listpertanyaan[i].idpertanyaan,
                                      respon: getJsonRespon(i, listpertanyaan,
                                          anggotakelompok, nilaianggota),
                                      nilai: getNilai(i, j, anggotakelompok, nilaianggota),
                                      //bobot: "",
                                      iddiklat: tkg.iddiklat,
                                      idmatadiklat: tkg.idmatadiklat,
                                      atribut1: anggotakelompok[j].niplama);
                                }
                              }
                              setState((){
                                isLoading=false;
                              });
                              await Get.defaultDialog(
                                content: MyDialogInfo(
                                    info: "Sosiometri telah disubmit"),
                                titleStyle: TextStyle(fontSize: 0),
                              );
                              Get.back();
                            }
                            else{
                              await Get.defaultDialog(
                                content: MyDialogInfo(
                                    info: "Masih terdapat peserta yang belum dinilai"),
                                titleStyle: TextStyle(fontSize: 0),
                              );
                            }
                          }
                        } else {
                          print(nilaianggota);
                          Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        SosiometriLembarJawaban(
                                            anggotakelompok: anggotakelompok,
                                            nilaianggota: nilaianggota,
                                            listpertanyaan: listpertanyaan,
                                            indexaktif: indexa + 1,
                                        tkg: tkg,),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ));
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            indexa == listpertanyaan.length - 1
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
                            indexa == listpertanyaan.length - 1
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
          children:[ Container(
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
                  Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.teal,
                        child: SingleChildScrollView(
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Html(
                              data: listpertanyaan[indexa].pertanyaan,
                              style: {
                                "p":Style(color: Colors.white, textAlign: TextAlign.justify),
                                "ul":Style(color: Colors.white, textAlign: TextAlign.justify),
                                "li":Style(color: Colors.white, textAlign: TextAlign.justify),
                              },
                            ),
                            // AutoSizeText(
                            //   listpertanyaan[indexa].pertanyaan,
                            //   maxLines: 3,
                            //   style: TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 20,
                            //   ),
                            //   textAlign: TextAlign.center,
                            // ),
                          )),
                        ),
                      )),
                  Expanded(
                    flex: 3,
                    child: HorizontalDataTable(
                      leftHandSideColumnWidth:
                          (MediaQuery.of(context).size.width) * 0.3,
                      rightHandSideColumnWidth:
                          (MediaQuery.of(context).size.width) * 0.6,
                      isFixedHeader: true,
                      headerWidgets: _getTitleWidget(),
                      leftSideItemBuilder: _generateFirstColumnRow,
                      rightSideItemBuilder: _generateRightHandSideColumnRow,
                      itemCount: anggotakelompok.length,
                      rowSeparatorWidget: const Divider(
                        color: Colors.black54,
                        height: 1.0,
                        thickness: 0.0,
                      ),
                      leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                      rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
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
    headers.add(
        _getTitleItemWidget("Nama", MediaQuery.of(context).size.width * 0.4));
    for (int i = 0; i < anggotakelompok.length; i++) {
      headers.add(_getTitleItemWidget(indexanggota[i].toString(),
          MediaQuery.of(context).size.width * 0.6 / (anggotakelompok.length)));
    }
    return headers;
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: AutoSizeText(anggotakelompok[index].fullname, maxLines: 2),
      width: MediaQuery.of(context).size.width * 0.4,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    List<Widget> lines = [];
    for (int i = 0; i < anggotakelompok.length; i++) {
      lines.add(Container(
        child: Radio(
          value: anggotakelompok.length - i,
          groupValue: nilaianggota[indexa][index], //"row" + (i + 1).toString(),
          onChanged: (Object? value) {
            if (cekRadioValid(
                nilaianggota[indexa], index, int.parse(value.toString()))) {
              setState(() {
                nilaianggota[indexa][index] = int.parse(value.toString());
              });
            } else {
              Get.defaultDialog(
                content: MyDialogInfo(info: "Pilihan tidak valid!"),
                titleStyle: TextStyle(fontSize: 0),
              );
            }
          },
        ),
        width:
            MediaQuery.of(context).size.width * 0.6 / (anggotakelompok.length),
        height: 52,
        //color: Colors.teal,
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
      ));
    }
    return Row(children: lines);
  }

  bool cekRadioValid(List<int> listnilai, int index, int nilai) {
    bool status = true;
    for (int i = 0; i < listnilai.length; i++) {
      if (index == i)
        continue;
      else {
        if (listnilai[i] == nilai) status = false;
      }
    }
    return status;
  }

  String getJsonRespon(int indexpertanyaan, List<Pertanyaan> pertanyaans,
      List<Peserta> pesertas, List<List<int>> nilais) {
    String responstring = '';
    responstring += '{';
    responstring =
        responstring + '"' + pertanyaans[indexpertanyaan].idpertanyaan + '":';
    responstring += '[';
    for (int j = 0; j < pesertas.length; j++) {
      responstring += '{';
      responstring += '"nip"';
      responstring += ':';
      responstring += '"' + pesertas[j].niplama + '",';
      responstring += '"nilai"';
      responstring += ':';
      responstring += '"' + nilais[indexpertanyaan][j].toString() + '"';
      responstring += '}';
      if (j < pesertas.length - 1) {
        responstring += ',';
      }
    }
    responstring += ']';
    responstring += "}";
    print(responstring);
    return responstring;
  }

  String getNilai(int indexpertanyaan, int indexpeserta,
      List<Peserta> pesertas, List<List<int>> nilais){

    int intervaltarget=2; //saat ini diseragamkan (3-1) = (nilai max - nilai min)
    int pembagiinterval=pesertas.length-1;
    double nilaipeserta=((nilais[indexpertanyaan][indexpeserta]-1)*intervaltarget/pembagiinterval) + 1;
    return nilaipeserta.toStringAsFixed(2);
  }

  bool cekValiditasAll(List<List<int>> nilai){
    bool valid=true;
    for(int i=0;i<nilai.length;i++){
      for(int j=0;j<nilai[i].length;j++){
        if(nilai[i][j]==0)
          {
            valid=false;
            break;
          }
      }
    }
    return valid;
  }
}
