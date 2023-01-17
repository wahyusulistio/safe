import 'dart:convert';
import 'dart:math';
import 'dart:developer' as developer;

//import 'package:dropdown_search/dropdown_search.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
//import 'package:haloexpert/CustomUI/flutter_chat/chat.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Fragments/akunuser/admin/historyassessment.dart';
import 'package:safe/Models/JenisTest.dart';
import 'package:safe/Models/PesertaHistoryTest.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/Debouncer.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';
//import 'package:intl/intl.dart';
//import 'package:haloexpert/Pages/root_page.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:safe/Utilities/navigator_key.dart';
import 'package:safe/Utilities/Custom_Function.dart';
//import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
//import 'package:dio/dio.dart';
//import 'IndividualPage.dart';

class DaftarJenisTest extends StatefulWidget {
  @override
  _DaftarJenisTestState createState() => _DaftarJenisTestState();

  DaftarJenisTest({this.kelkeahlianfilter});

  String? kelkeahlianfilter;
}

class _DaftarJenisTestState extends State<DaftarJenisTest> {
  /*---variabel service---*/
  ApiService apiService = Get.find(tag: 'apiserv1');
  /*---variabel service---*/

  late List<JenisTest> hist = <JenisTest>[];
  bool isloading = false;

  String nama = "";
  String nip = "";

  @override
  void initState() {
    // TODO: implement initState
    //print("uid2:" + authService.getUserId());

    print("masuk awal lagi");
    super.initState();

    SecureStorageHelper.getListString("userinfo").then((value) {
      setState(() {
        if (value != null) {
          nama = value[2].toString();
          nip = value[3].toString();
          _getMoreData();
        }
      });
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    //_sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Jenis Test"),
        backgroundColor: Colors.teal,
      ),
      //backgroundColor: Color(0xff7bb61c),
      body: Column(
        children: <Widget>[
          //CategorySelector(),
          Expanded(
              child: Container(
            height: MediaQuery.of(context).size.height, //* 0.3, //200,
            child: Padding(
              padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.040,
                  ),
              child: isloading ? _buildProgressIndicator(isloading) : GridView.count(
                  scrollDirection: Axis.vertical,
                  childAspectRatio: 2/2,
                  crossAxisCount: 2,
                  children: getTillesJenisTest(),
              ),
            ),
          )),
        ],
      ),

      resizeToAvoidBottomInset: false,
    );
  }

  void _getMoreData() async {
    //if (!isLoading) {
    setState(() {
      isloading = true;
      hist.clear();
    });

    var req = await apiService.daftarJenisTest(
      user: nip,
    );

    List<JenisTest> tList = <JenisTest>[];
    developer.log(req.body, name: 'log req body');
    //print(req.body);
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        tList.add(JenisTest.fromJSON(json.decode(req.body)['data'][i]));
        //print("expert baru ${json.decode(req.body)['records'][i]}");
      }
    }

    //if(mounted){
    setState(() {
      hist = tList;
      isloading = false;
    });

    //}
    //}
  }

  List<Widget> getTillesJenisTest() {
    List<Widget> widgets = <Widget>[];

    print("jumlah jenis test "+hist.length.toString());
    for (int i = 0; i < hist.length; i++) {
      if (hist[i].idjenistest == "1") {
        widgets.add(
          InkWell(
            onTap: () {
              Get.to(()=>HistoryAssessment(idjenistest: hist[i].idjenistest, namatest: hist[i].namajenistest,));
            },
            child: Card(
              color: Colors.white,
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/belbin.png"),
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.topCenter),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(
                            20.0))), //.all(Radius.circular(5.0))),
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.5),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),)),
                            child: Text(
                              "Belbin Test",
                              maxLines: 3,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ),
        );
      } else if (hist[i].idjenistest == "2") {
        widgets.add(
          InkWell(
            onTap: () {
              Get.to(()=>HistoryAssessment(idjenistest: hist[i].idjenistest, namatest: hist[i].namajenistest,));
            },
            child: Card(
              color: Colors.white,
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/mbti.png"),
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.topCenter),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0))),
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.5),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                )),
                            child: Text(
                              "MBTI Test",
                              maxLines: 3,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ),
        );
      } else if (hist[i].idjenistest == "3") {
        widgets.add(
          InkWell(
            onTap: () {
              Get.to(()=>HistoryAssessment(idjenistest: hist[i].idjenistest, namatest: hist[i].namajenistest,));
            },
            child: Card(
              color: Colors.white,
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/big5p.jpeg"),
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.topCenter),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    )),
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   height: 40,
                        // ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.5),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                )),
                            child: Text(
                              "Big 5 Personality",
                              maxLines: 3,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ),
        );
      }
    }

    print("isi widgets "+widgets.length.toString());
    return widgets;
  }

  Widget _buildProgressIndicator(bool par) {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: par ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
