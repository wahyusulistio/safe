import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:safe/Fragments/assessment/belbin/belbinhasilpeserta.dart';
//import 'package:safe/Fragments/assessment/MBTI/MBTIhasilfasilitator.dart';
import 'package:safe/Fragments/assessment/mbti/mbtihasilfasilitator.dart';
//import 'package:safe/Fragments/assessment/MBTI/MBTIhasilpeserta.dart';
import 'package:safe/Fragments/assessment/mbti/mbtihasilpeserta.dart';
import 'package:safe/Fragments/dialogconfirm.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Models/HasilMBTI.dart';
import 'package:safe/Models/Pertanyaan.dart';
import 'package:safe/Models/PilihanJawaban.dart';
import 'package:safe/Models/testkelasgrouping.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MBTILembarJawaban extends StatefulWidget {
  MBTILembarJawaban(
      {Key? key,
      required this.listpertanyaan,
      required this.indexaktif,
      required this.pilihanjawaban,
      //required this.bobotjawaban,
      required this.tkg})
      : super(key: key);

  final List<Pertanyaan> listpertanyaan;
  final List<List<PilihanJawaban>> pilihanjawaban;
  //final List<List<int>> bobotjawaban;
  final int indexaktif;
  final TestKelasGrouping tkg;

  @override
  State<MBTILembarJawaban> createState() => _MBTILembarJawabanState();
}

class _MBTILembarJawabanState extends State<MBTILembarJawaban> {
  ApiService apiService = Get.find(tag: 'apiserv1');
  String nama = "";
  String nip = "";
  String role = "";
  late TestKelasGrouping tkg;
  late List<Pertanyaan> listpertanyaan;
  late List<List<PilihanJawaban>> pilihanjawaban;
  late List<int> jawabanpeserta;
//  late List<List<int>> bobotjawaban;
  //List<TextEditingController> tecs = <TextEditingController>[];
  final _controller = TextEditingController();
  int indexa = 0;
  String masalahvalid = "";
  bool isLoading = false;
  int nomortidakvalid = 0;
  final scrollDirection = Axis.vertical;
  late AutoScrollController controller;
  //bool getReset=false;
  //late var tList; //= List.generate(a, (i) => List(b), growable: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indexa = widget.indexaktif;
    listpertanyaan = widget.listpertanyaan;
    pilihanjawaban = widget.pilihanjawaban;
    //bobotjawaban = widget.bobotjawaban;
    print("set bobot dl");
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
    //print(bobotjawaban);

    // for (int i = 0; i < 10; i++) {
    //   tecs.add(TextEditingController());
    // }
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    print("masuk controller");
    jawabanpeserta = List.generate(listpertanyaan.length, (j) => -1);
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
          title: Text("MBTI"),
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
          // actions: [
          //   Center(
          //       child: Padding(
          //           padding: EdgeInsets.only(right: 20),
          //           child: Text((indexa + 1).toString() +
          //               "/" +
          //               listpertanyaan.length.toString()))),
          // ],
        ),
        // bottomNavigationBar: BottomAppBar(
        //     color: Colors.teal,
        //     child: Container(
        //       height: 56,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         mainAxisSize: MainAxisSize.min,
        //         children: <Widget>[
        //           Expanded(
        //             flex: 1,
        //             child: indexa != 0
        //                 ? InkWell(
        //                     onTap: () async {
        //                       bool validitas = cekIsianValid(bobotjawaban[indexa]);
        //                       if(validitas){
        //                         Navigator.pushReplacement(
        //                             context,
        //                             PageRouteBuilder(
        //                               pageBuilder:
        //                                   (context, animation1, animation2) =>
        //                                   MBTILembarJawaban(
        //                                     listpertanyaan: listpertanyaan,
        //                                     indexaktif: indexa - 1,
        //                                     pilihanjawaban: pilihanjawaban,
        //                                     bobotjawaban: bobotjawaban,
        //                                     tkg: tkg,
        //                                   ),
        //                               transitionDuration: Duration.zero,
        //                               reverseTransitionDuration: Duration.zero,
        //                             ));
        //                       } else {
        //                         await Get.defaultDialog(
        //                           content: MyDialogInfo(info: masalahvalid),
        //                           titleStyle: TextStyle(fontSize: 0),
        //                         );
        //                       }
        //                     },
        //                     child: Row(
        //                       mainAxisSize: MainAxisSize.min,
        //                       children: [
        //                         Icon(
        //                           // <-- Icon
        //                           Icons.arrow_back_ios_new,
        //                           size: 24.0, color: Colors.white,
        //                         ),
        //                         SizedBox(
        //                           width: 5,
        //                         ),
        //                         Text(
        //                           'Prev',
        //                           style: TextStyle(color: Colors.white),
        //                         ), // <-- Text
        //                       ],
        //                     ),
        //                   )
        //                 : Container(),
        //           ),
        //           Expanded(
        //             flex: 1,
        //             child: Container(
        //             ),
        //           ),
        //           Expanded(
        //             flex: 1,
        //             child: InkWell(
        //               onTap: () async {
        //                 if (indexa == listpertanyaan.length - 1) {
        //                   bool validitas = cekIsianValid(bobotjawaban[indexa]);
        //                   if(validitas){
        //                     var datares = await Get.defaultDialog(
        //                       content:
        //                       MyDialogConfirm(info: "Submit jawaban Anda?"),
        //                       titleStyle: TextStyle(fontSize: 0),
        //                     );
        //                     Map<String, dynamic> json =
        //                     jsonDecode(datares.toString());
        //                     if (json["respon"] == "ya") {
        //                       setState((){
        //                         isLoading=true;
        //                       });
        //                       for(int i=0;i<listpertanyaan.length;i++){
        //                         for(int j=0;j<pilihanjawaban[i].length;j++){
        //                           if(bobotjawaban[i][j]>0){
        //                             await apiService.addResponPeserta(
        //                                 user: nip,
        //                                 idtest: tkg.idtest,
        //                                 idkelas: tkg.idkelas,
        //                                 idpertanyaan: listpertanyaan[i].idpertanyaan,
        //                                 respon: getJsonRespon(i, listpertanyaan,
        //                                     pilihanjawaban, bobotjawaban),
        //                                 nilai: bobotjawaban[i][j].toString(),
        //                                 //bobot: "",
        //                                 iddiklat: tkg.iddiklat,
        //                                 idmatadiklat: tkg.idmatadiklat,
        //                                 atribut1: pilihanjawaban[i][j].atribut1);
        //                           }
        //                         }
        //                       }
        //                       setState((){
        //                         isLoading=false;
        //                       });
        //                       await Get.defaultDialog(
        //                         content:
        //                         MyDialogInfo(info: "MBTI telah disubmit"),
        //                         titleStyle: TextStyle(fontSize: 0),
        //                       );
        //                       //Get.back();
        //                       var req = await apiService.getSkorMBTI(user: nip,
        //                           idkelas: tkg.idkelas, iddiklat: tkg.iddiklat,
        //                           idmatadiklat: tkg.idmatadiklat, idtest: tkg.idtest,
        //                       nippeserta: nip);
        //
        //                       List<HasilMBTI> thb=<HasilMBTI>[];
        //                       if (jsonDecode(req.body)['data'] != null) {
        //                         for (int i = 0; i < jsonDecode(req.body)['data'].length; i++) {
        //                           thb.add(HasilMBTI.fromJSON(jsonDecode(req.body)['data'][i]));
        //                         }
        //                       }
        //                       Get.off(()=>HasilMBTIPeserta(hb: thb,));
        //                     }
        //                   } else {
        //                     await Get.defaultDialog(
        //                       content: MyDialogInfo(info: masalahvalid),
        //                       titleStyle: TextStyle(fontSize: 0),
        //                     );
        //                   }
        //                 } else {
        //                   //validasi isian
        //                   bool validitas = cekIsianValid(bobotjawaban[indexa]);
        //                   if (validitas) {
        //                     Navigator.pushReplacement(
        //                         context,
        //                         PageRouteBuilder(
        //                           pageBuilder:
        //                               (context, animation1, animation2) =>
        //                                   MBTILembarJawaban(
        //                             listpertanyaan: listpertanyaan,
        //                             indexaktif: indexa + 1,
        //                             bobotjawaban: bobotjawaban,
        //                             pilihanjawaban: pilihanjawaban,
        //                                     tkg: tkg,
        //                           ),
        //                           transitionDuration: Duration.zero,
        //                           reverseTransitionDuration: Duration.zero,
        //                         ));
        //                   } else {
        //                     await Get.defaultDialog(
        //                       content: MyDialogInfo(info: masalahvalid),
        //                       titleStyle: TextStyle(fontSize: 0),
        //                     );
        //                   }
        //                 }
        //               },
        //               child: Row(
        //                 mainAxisSize: MainAxisSize.min,
        //                 mainAxisAlignment: MainAxisAlignment.end,
        //                 children: [
        //                   Text(
        //                     indexa == listpertanyaan.length - 1
        //                         ? 'Submit'
        //                         : 'Next',
        //                     style: TextStyle(
        //                       color: Colors.white,
        //                     ),
        //                   ), // <-- Text
        //                   SizedBox(
        //                     width: 5,
        //                   ),
        //                   Icon(
        //                     // <-- Icon
        //                     indexa == listpertanyaan.length - 1
        //                         ? Icons.check
        //                         : Icons.arrow_forward_ios,
        //                     size: 24.0, color: Colors.white,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //           // Directionality(
        //           //   textDirection: TextDirection.rtl,
        //           //   child: ElevatedButton.icon(
        //           //     style: ElevatedButton.styleFrom(primary: Colors.white),
        //           //     icon: Icon(Icons.arrow_forward_ios_sharp, color: Colors.teal),
        //           //     label: Text(
        //           //       'Next',
        //           //       style: TextStyle(color: Colors.teal),
        //           //     ), // <-- Text
        //           //   ),
        //           // ),
        //         ],
        //       ),
        //     )),
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
                    child: ListView.builder(
                      //itemCount: filteredexpert.length,
                      scrollDirection: scrollDirection,
                      controller: controller,
                      itemCount: listpertanyaan.length,
                      itemBuilder: (BuildContext context, int index) {
                        //final Expert2 exp = filteredexpert[index];
                        if (index == listpertanyaan.length) {
                          //isLoading=true;
                          return CircularProgressIndicator();
                        } else {
                          return Card(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 10.0,
                                  top: 5.0,
                                  bottom: 5.0,
                                  right: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      child: Text((index + 1).toString()),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 80,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Radio(
                                                value: 0,
                                                groupValue: jawabanpeserta[
                                                    index], //"row" + (i + 1).toString(),
                                                onChanged: (Object? value) {
                                                  setState(() {
                                                    jawabanpeserta[index] = 0;
                                                  });
                                                },
                                              ),
                                              //SizedBox(width: 10,),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                //height: 10,
                                                //color: Colors.red,
                                                child: AutoSizeText(
                                                  "A. " +
                                                      pilihanjawaban[index][0]
                                                          .pilihanjawaban,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              //AutoSizeText(pilihanjawaban[index][0].pilihanjawaban,
                                              //  maxLines: 2,overflow: TextOverflow.ellipsis,),
                                              //Text(pilihanjawaban[index][0].pilihanjawaban),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: 1,
                                                groupValue: jawabanpeserta[
                                                    index], //"row" + (i + 1).toString(),
                                                onChanged: (Object? value) {
                                                  setState(() {
                                                    jawabanpeserta[index] = 1;
                                                  });
                                                },
                                              ),
                                              //SizedBox(width: 10,),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                //height: 10,
                                                //color: Colors.green,
                                                child: AutoSizeText(
                                                  "B. " +
                                                      pilihanjawaban[index][1]
                                                          .pilihanjawaban,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              //AutoSizeText(pilihanjawaban[index][1].pilihanjawaban,
                                              //  maxLines: 2,overflow: TextOverflow.ellipsis,),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                      //controller: _sc,
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
                          //cek status pengisian semua pertanyaan
                          bool allvalid = cekIsianValid(jawabanpeserta);
                          if (allvalid == false) {
                            await Get.defaultDialog(
                              content: MyDialogInfo(
                                  info: "Soal no " +
                                      nomortidakvalid.toString() +
                                      " tidak valid!"),
                              titleStyle: TextStyle(fontSize: 0),
                            );
                            print("scroll ke nomor " +
                                nomortidakvalid.toString());
                            await controller.scrollToIndex(nomortidakvalid,
                                preferPosition: AutoScrollPosition.begin);
                          } else {
                            var datares = await Get.defaultDialog(
                              content: MyDialogConfirm(info: "Submit jawaban?"),
                              titleStyle: TextStyle(fontSize: 0),
                            );
                            Map<String, dynamic> json =
                                jsonDecode(datares.toString());
                            if (json["respon"] == "ya") {
                              //simpan jawaban peserta

                              setState(() {
                                isLoading = true;
                              });
                              await Future.wait([
                                for (int i = 0; i < listpertanyaan.length; i++)
                                  //for(int j=0;j<pilihanjawaban[i].length;j++){
                                  //if(bobotjawaban[i][j]>0){
                                  apiService.addResponPeserta(
                                      user: nip,
                                      idtest: tkg.idtest,
                                      idkelas: tkg.idkelas,
                                      idpertanyaan:
                                          listpertanyaan[i].idpertanyaan,
                                      respon: jawabanpeserta[i].toString(),
                                      nilai: "1",
                                      //bobot: "",
                                      iddiklat: tkg.iddiklat,
                                      idmatadiklat: tkg.idmatadiklat,
                                      atribut1: pilihanjawaban[i]
                                              [jawabanpeserta[i]]
                                          .atribut1),
                                //}
                                //}
                              ]).then((v) {
                                setState(() {
                                  isLoading = false;
                                });
                              }, onError: (err) {
                                Get.defaultDialog(
                                  content:
                                  MyDialogInfo(info: "Terdapat permasalahan dalam proses penyimpanan jawaban!"),
                                  titleStyle: TextStyle(fontSize: 0),
                                );
                              });

                              await Get.defaultDialog(
                                content:
                                MyDialogInfo(info: "MBTI telah disubmit"),
                                titleStyle: TextStyle(fontSize: 0),
                              );
                              //Get.back();
                              var req = await apiService.getSkorMBTI(
                                  user: nip,
                                  idkelas: tkg.idkelas,
                                  iddiklat: tkg.iddiklat,
                                  idmatadiklat: tkg.idmatadiklat,
                                  idtest: tkg.idtest,
                                  nippeserta: nip,
                                tglpengisian: DateTime.now().year.toString()+"-"+
                                    DateTime.now().month.toString().padLeft(2,'0')+"-"+
                                    DateTime.now().day.toString().padLeft(2,'0')
                              );

                              List<HasilMBTI> thb = <HasilMBTI>[];
                              if (jsonDecode(req.body)['data'] != null) {
                                for (int i = 0;
                                    i < jsonDecode(req.body)['data'].length;
                                    i++) {
                                  thb.add(HasilMBTI.fromJSON(
                                      jsonDecode(req.body)['data'][i]));
                                }
                              }
                              Get.off(() => HasilMBTIPeserta(
                                    hb: thb,
                                  ));
                            }
                          }
                        },
                        child: isLoading
                            ? SizedBox(
                                width: (MediaQuery.of(context).size.width <
                                        MediaQuery.of(context).size.height)
                                    ? MediaQuery.of(context).size.width * 0.08
                                    : MediaQuery.of(context).size.height * 0.08,
                                height: (MediaQuery.of(context).size.width <
                                        MediaQuery.of(context).size.height)
                                    ? MediaQuery.of(context).size.width * 0.08
                                    : MediaQuery.of(context).size.height * 0.08,
                                child: new CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.teal),
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Submit Jawaban',
                                    style: TextStyle(
                                      color: Colors.teal,
                                    ),
                                  ), // <-- Text
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

  // Widget _generateFirstColumnRow(BuildContext context, int index) {
  //   print("generate dulu");
  //   return Container(
  //     margin: EdgeInsets.all(5),
  //     child: AutoSizeText(pilihanjawaban[indexa][index].pilihanjawaban, maxLines: 4,),
  //     width: MediaQuery.of(context).size.width * 0.8,
  //     height: 60,
  //     padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //     alignment: Alignment.centerLeft,
  //   );
  // }

  // Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
  //   //print("indexnya 123 "+index.toString());
  //   //TextEditingController _controller=new TextEditingController();
  //   return Container(
  //     margin: EdgeInsets.all(5),
  //     child: TextFormField(
  //       initialValue: bobotjawaban[indexa][index]==0 ? "" : bobotjawaban[indexa][index].toString(),
  //       //controller: _controller,
  //       // onTap: (){
  //       //   _controller.selection=TextSelection(baseOffset: 0, extentOffset: _controller.value.text.length);
  //       // },
  //       onChanged: (value) {
  //         try{
  //           bobotjawaban[indexa][index]=int.parse(value);
  //         }
  //         on Exception catch(ex){
  //           bobotjawaban[indexa][index]=0;
  //         }
  //       },
  //       textAlign: TextAlign.center,
  //       //controller: tecs[index],
  //       decoration: InputDecoration(
  //           enabledBorder: OutlineInputBorder(
  //             borderSide: const BorderSide(width: 1, color: Colors.teal),
  //             borderRadius: BorderRadius.circular(5),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderSide: const BorderSide(width: 1, color: Colors.teal),
  //             borderRadius: BorderRadius.circular(5),
  //           )),
  //
  //       keyboardType: Platform.isIOS? TextInputType.numberWithOptions(signed: true) :TextInputType.number,
  //       inputFormatters: <TextInputFormatter>[
  //         FilteringTextInputFormatter.digitsOnly,
  //         LengthLimitingTextInputFormatter(1),
  //       ], //
  //     ),
  //     width: MediaQuery.of(context).size.width * 0.2,
  //     height: 60,
  //     //color: Colors.teal,
  //     padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //     alignment: Alignment.center,
  //   );
  // }

  bool cekIsianValid(List<int> listjawaban) {
    bool status = true;
    int countisian = 0;
    int sumisian = 0;

    for (int i = 0; i < listjawaban.length; i++) {
      if (listjawaban[i] == -1) {
        status = false;
        nomortidakvalid = i + 1;
        break;
      }
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
      responstring +=
          '"' + pilihanjawaban[indexpertanyaan][j].idpilihanjawaban + '",';
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
