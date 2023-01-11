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
import 'package:safe/Fragments/dialogconfirm.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Models/HasilBelbin.dart';
import 'package:safe/Models/Pertanyaan.dart';
import 'package:safe/Models/PilihanJawaban.dart';
import 'package:safe/Models/testkelasgrouping.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';

class BelbinLembarJawaban extends StatefulWidget {
  BelbinLembarJawaban(
      {Key? key,
      required this.listpertanyaan,
      required this.indexaktif,
      required this.pilihanjawaban,
      required this.bobotjawaban, required this.tkg})
      : super(key: key);

  final List<Pertanyaan> listpertanyaan;
  final List<List<PilihanJawaban>> pilihanjawaban;
  final List<List<int>> bobotjawaban;
  final int indexaktif;
  final TestKelasGrouping tkg;

  @override
  State<BelbinLembarJawaban> createState() => _BelbinLembarJawabanState();
}

class _BelbinLembarJawabanState extends State<BelbinLembarJawaban> {
  ApiService apiService = Get.find(tag: 'apiserv1');
  String nama = "";
  String nip = "";
  String role = "";
  late TestKelasGrouping tkg;
  late List<Pertanyaan> listpertanyaan;
  late List<List<PilihanJawaban>> pilihanjawaban;
  late List<List<int>> bobotjawaban;
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
    listpertanyaan = widget.listpertanyaan;
    pilihanjawaban = widget.pilihanjawaban;
    bobotjawaban = widget.bobotjawaban;
    print("set bobot dl");
    tkg=widget.tkg;
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
          title: Text("Belbin"),
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
                            onTap: () async {
                              bool validitas = cekIsianValid(bobotjawaban[indexa]);
                              if(validitas){
                                Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                          BelbinLembarJawaban(
                                            listpertanyaan: listpertanyaan,
                                            indexaktif: indexa - 1,
                                            pilihanjawaban: pilihanjawaban,
                                            bobotjawaban: bobotjawaban,
                                            tkg: tkg,
                                          ),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ));
                              } else {
                                await Get.defaultDialog(
                                  content: MyDialogInfo(info: masalahvalid),
                                  titleStyle: TextStyle(fontSize: 0),
                                );
                              }
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
                        if (indexa == listpertanyaan.length - 1) {
                          bool validitas = cekIsianValid(bobotjawaban[indexa]);
                          if(validitas){
                            var datares = await Get.defaultDialog(
                              content:
                              MyDialogConfirm(info: "Submit jawaban Anda?"),
                              titleStyle: TextStyle(fontSize: 0),
                            );
                            Map<String, dynamic> json =
                            jsonDecode(datares.toString());
                            if (json["respon"] == "ya") {
                              setState((){
                                isLoading=true;
                              });
                              for(int i=0;i<listpertanyaan.length;i++){
                                for(int j=0;j<pilihanjawaban[i].length;j++){
                                  if(bobotjawaban[i][j]>0){
                                    await apiService.addResponPeserta(
                                        user: nip,
                                        idtest: tkg.idtest,
                                        idkelas: tkg.idkelas,
                                        idpertanyaan: listpertanyaan[i].idpertanyaan,
                                        respon: getJsonRespon(i, listpertanyaan,
                                            pilihanjawaban, bobotjawaban),
                                        nilai: bobotjawaban[i][j].toString(),
                                        //bobot: "",
                                        iddiklat: tkg.iddiklat,
                                        idmatadiklat: tkg.idmatadiklat,
                                        atribut1: pilihanjawaban[i][j].atribut1);
                                  }
                                }
                              }
                              setState((){
                                isLoading=false;
                              });
                              await Get.defaultDialog(
                                content:
                                MyDialogInfo(info: "Belbin telah disubmit"),
                                titleStyle: TextStyle(fontSize: 0),
                              );
                              //Get.back();
                              var req = await apiService.getSkorBelbin(user: nip,
                                  idkelas: tkg.idkelas, iddiklat: tkg.iddiklat,
                                  idmatadiklat: tkg.idmatadiklat, idtest: tkg.idtest,
                              nippeserta: nip);

                              List<HasilBelbin> thb=<HasilBelbin>[];
                              if (jsonDecode(req.body)['data'] != null) {
                                for (int i = 0; i < jsonDecode(req.body)['data'].length; i++) {
                                  thb.add(HasilBelbin.fromJSON(jsonDecode(req.body)['data'][i]));
                                }
                              }
                              Get.off(()=>HasilBelbinPeserta(hb: thb,));
                            }
                          } else {
                            await Get.defaultDialog(
                              content: MyDialogInfo(info: masalahvalid),
                              titleStyle: TextStyle(fontSize: 0),
                            );
                          }
                        } else {
                          //validasi isian
                          bool validitas = cekIsianValid(bobotjawaban[indexa]);
                          if (validitas) {
                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          BelbinLembarJawaban(
                                    listpertanyaan: listpertanyaan,
                                    indexaktif: indexa + 1,
                                    bobotjawaban: bobotjawaban,
                                    pilihanjawaban: pilihanjawaban,
                                            tkg: tkg,
                                  ),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ));
                          } else {
                            await Get.defaultDialog(
                              content: MyDialogInfo(info: masalahvalid),
                              titleStyle: TextStyle(fontSize: 0),
                            );
                          }
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
                  Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        color: Colors.teal,
                        child: SingleChildScrollView(
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Html(
                                  data: listpertanyaan[indexa].pertanyaan,
                                  style: {
                                    "p":Style(color: Colors.white, textAlign: TextAlign.justify),
                                  },
                                ),
                            // child: AutoSizeText(
                            //   listpertanyaan[indexa].pertanyaan,
                            //   maxLines: 10,
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: HorizontalDataTable(
                        leftHandSideColumnWidth:
                            (MediaQuery.of(context).size.width) * 0.75,
                        rightHandSideColumnWidth:
                            (MediaQuery.of(context).size.width) * 0.2,
                        isFixedHeader: true,
                        headerWidgets: _getTitleWidget(),
                        leftSideItemBuilder: _generateFirstColumnRow,
                        rightSideItemBuilder: _generateRightHandSideColumnRow,
                        itemCount: pilihanjawaban[0].length,
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
        "Pilihan Jawaban", MediaQuery.of(context).size.width * 0.75));
    headers.add(
        _getTitleItemWidget("Bobot", MediaQuery.of(context).size.width * 0.2));
    // for (int i = 0; i < anggotakelompok.length; i++) {
    //   headers.add(_getTitleItemWidget(indexanggota[i].toString(),
    //       MediaQuery.of(context).size.width * 0.6 / (anggotakelompok.length)));
    // }
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
    print("generate dulu");
    return Container(
      margin: EdgeInsets.all(5),
      child: AutoSizeText(pilihanjawaban[indexa][index].pilihanjawaban, maxLines: 4,),
      width: MediaQuery.of(context).size.width * 0.8,
      height: 60,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    //print("indexnya 123 "+index.toString());
    //TextEditingController _controller=new TextEditingController();
    return Container(
      margin: EdgeInsets.all(5),
      child: TextFormField(
        initialValue: bobotjawaban[indexa][index]==0 ? "" : bobotjawaban[indexa][index].toString(),
        //controller: _controller,
        // onTap: (){
        //   _controller.selection=TextSelection(baseOffset: 0, extentOffset: _controller.value.text.length);
        // },
        onChanged: (value) {
          try{
            bobotjawaban[indexa][index]=int.parse(value);
          }
          on Exception catch(ex){
            bobotjawaban[indexa][index]=0;
          }
        },
        textAlign: TextAlign.center,
        //controller: tecs[index],
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.teal),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.teal),
              borderRadius: BorderRadius.circular(5),
            )),

        keyboardType: Platform.isIOS? TextInputType.numberWithOptions(signed: true) :TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ], //
      ),
      width: MediaQuery.of(context).size.width * 0.2,
      height: 60,
      //color: Colors.teal,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
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
      List<List<PilihanJawaban>> pilihanjawaban, List<List<int>> nilais) {
    String responstring = '';
    responstring += '{';
    responstring =
        responstring + '"' + pertanyaans[indexpertanyaan].idpertanyaan + '":';
    responstring += '[';
    for (int j = 0; j < pilihanjawaban[indexpertanyaan].length; j++) {
      responstring += '{';
      responstring += '"idpj"';
      responstring += ':';
      responstring += '"' + pilihanjawaban[indexpertanyaan][j].idpilihanjawaban + '",';
      responstring += '"nilai"';
      responstring += ':';
      responstring += '"' + nilais[indexpertanyaan][j].toString() + '"';
      responstring += '}';
      if (j < pilihanjawaban[indexpertanyaan].length - 1) {
        responstring += ',';
      }
    }
    responstring += ']';
    responstring += "}";
    print(responstring);
    return responstring;
  }
}
