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
import 'package:safe/Fragments/assessment/b5p/b5phasilpeserta.dart';
import 'package:safe/Fragments/assessment/belbin/belbinhasilpeserta.dart';
import 'package:safe/Fragments/assessment/mbti/mbtihasilpeserta.dart';
//import 'package:haloexpert/CustomUI/flutter_chat/chat.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Models/AssessmentHistoryTest.dart';
import 'package:safe/Models/HasilB5P.dart';
import 'package:safe/Models/HasilBelbin.dart';
import 'package:safe/Models/HasilMBTI.dart';
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

class HistoryAssessment extends StatefulWidget {
  @override
  _HistoryAssessmentState createState() => _HistoryAssessmentState();

  HistoryAssessment({required this.idjenistest, required this.namatest});

  String idjenistest;
  String namatest;
}

class _HistoryAssessmentState extends State<HistoryAssessment> {
  /*---variabel service---*/
  ApiService apiService = Get.find(tag: 'apiserv1');
  /*---variabel service---*/

  /*---variabel lazy loading---*/
  static int page = 0;
  ScrollController _sc = new ScrollController();
  bool isLoading = false;
  late List<AssessmentHistoryTest> hist = <AssessmentHistoryTest>[];
  String searchfilter="";
  /*---variabel lazy loading---*/

  String nama = "";
  String nip = "";
  final _debouncer = Debouncer(milliseconds: 500);

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

          searchfilter = "";

          page = 0;
          this._getMoreData(page);
          _sc.addListener(() {
            if (_sc.position.pixels == _sc.position.maxScrollExtent) {
              _getMoreData(page);
            }
          });
        } else {
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.namatest),
        backgroundColor: Colors.teal,
      ),
      //backgroundColor: Color(0xff7bb61c),
      body: Column(
        children: <Widget>[
          //CategorySelector(),
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: TextField(
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.teal),
                          hintText: "Search",
                          fillColor: Colors.white70),
                      /*onSubmitted: (text) {
                        searchfilter = text;
                        page=0;
                        _getMoreData(page);
                      },*/
                      onChanged: (string) {
                        _debouncer.run(() {
                          //print(string);
                          if (string.characters.length >= 3 ||
                              string.characters.length == 0) {
                            searchfilter = string;
                            page = 0;
                            _getMoreData(page);
                          }
                          //perform search here
                        });
                      },
                    ),
                  ),
                  _allHistory(),
                ],
              ),
            ),
          ),
        ],
      ),

      resizeToAvoidBottomInset: false,
    );
  }

  void _getMoreData(int index) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
        if (page == 0)
          hist.clear();
      });

      print("page skrg $page");
      var req = await apiService.historyAssessment(
        user: nip,
          idjenistest: widget.idjenistest,
          search: searchfilter,
          page: page.toString());

      List<AssessmentHistoryTest> tList = <AssessmentHistoryTest>[];
      developer.log(req.body, name: 'log req body');
      //print(req.body);
      if (json.decode(req.body)['data'] != null) {
        for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
          tList.add(AssessmentHistoryTest.fromJSON(json.decode(req.body)['data'][i]));
          //print("expert baru ${json.decode(req.body)['records'][i]}");
        }
      }

      //if(mounted){
      setState(() {
        isLoading = false;
        hist=tList;
        //filteredusers=users;
        page++;
        print("page baru $page");
      });

      //}
    }
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

  Widget _allHistory() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ClipRRect(
          child: (isLoading==false && hist.length>0) ?ListView.builder(
            //itemCount: filteredexpert.length,
            itemCount: hist.length+1,
            itemBuilder: (BuildContext context, int index) {
              //final Expert2 exp = filteredexpert[index];
              if (index == hist.length||isLoading==true) {
                //isLoading=true;
                return _buildProgressIndicator(isLoading);
              } else {
                return Card(
                  child: InkWell(
                    onTap: () async {

                      if (widget.idjenistest == "0") {
                        //Get.to(()=>KapabilitasIntro(indasmnt: indasmnt,));
                      }
                      else if(widget.idjenistest=="1"){
                        var req = await apiService.getSkorBelbin(
                            user: nip,
                            idkelas: hist[index].idkelas,
                            iddiklat: hist[index].iddiklat,
                            idmatadiklat: hist[index].idmatadiklat,
                            idtest: hist[index].idtest,
                            tglpengisian: hist[index].tglisi,
                            nippeserta: hist[index].nip_peserta);

                        List<HasilBelbin> thb = <HasilBelbin>[];
                        if (json.decode(req.body)['data'] != null) {
                          for (int i = 0;
                          i < json.decode(req.body)['data'].length;
                          i++) {
                            thb.add(HasilBelbin.fromJSON(
                                json.decode(req.body)['data'][i]));
                          }
                        }
                        Get.to(() => HasilBelbinPeserta(
                          hb: thb,
                        ));
                      }
                      else if(hist[index].idtest=="2"){
                        var req = await apiService.getSkorMBTI(
                            user: nip,
                            idkelas: hist[index].idkelas,
                            iddiklat: hist[index].iddiklat,
                            idmatadiklat: hist[index].idmatadiklat,
                            idtest: hist[index].idtest,
                            tglpengisian: hist[index].tglisi,
                            nippeserta: hist[index].nip_peserta);

                        List<HasilMBTI> thb = <HasilMBTI>[];
                        if (json.decode(req.body)['data'] != null) {
                          for (int i = 0;
                          i < json.decode(req.body)['data'].length;
                          i++) {
                            thb.add(HasilMBTI.fromJSON(
                                json.decode(req.body)['data'][i]));
                          }
                        }
                        Get.to(() => HasilMBTIPeserta(
                          hb: thb,
                        ));
                      }
                      else if(hist[index].idtest=="3"){
                        var req = await apiService.getSkorB5P(
                            user: nip,
                            idkelas: hist[index].idkelas,
                            iddiklat: hist[index].iddiklat,
                            idmatadiklat: hist[index].idmatadiklat,
                            idtest: hist[index].idtest,
                            tglpengisian: hist[index].tglisi,
                            nippeserta: hist[index].nip_peserta);

                        List<HasilB5P> thb = <HasilB5P>[];
                        if (json.decode(req.body)['data'] != null) {
                          for (int i = 0;
                          i < json.decode(req.body)['data'].length;
                          i++) {
                            thb.add(HasilB5P.fromJSON(
                                json.decode(req.body)['data'][i]));
                          }
                        }
                        Get.to(() => HasilB5PPeserta(
                          hb: thb,
                        ));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 10.0, top: 5.0, bottom: 5.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height / 15,
                            child: Row(
                              children: <Widget>[
                                // ClipOval(
                                //   child: Image.memory(base64Decode(users[index].image)),
                                // ),
                                ClipOval(
                                  child: CachedNetworkImage(
                                    //imageUrl: "https://haloexpert.bpk.go.id/getphoto.php?nip="+users[index].nip
                                    //+"&expires="+users[index].expires+"&signature="+users[index].signature,
                                    imageUrl: hist[index].lokasi,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) => Center(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        child: new CircularProgressIndicator(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                         Icon(Icons.bar_chart,
                                         size: MediaQuery.of(context).size.width * 0.1,),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55 -
                                          20,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(
                                          hist[index].nip_peserta+" - "+hist[index].NM_PEG,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: TextStyle(
                                            color: Colors.teal,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    0.7 -
                                                100,
                                        child: Text(
                                          hist[index].namakelas,
                                          style: TextStyle(
                                            color: Colors.teal,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                35,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Container(
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.7 -
                                            100,
                                        child: Text(
                                          CustomFunction.BahasaTanggal(hist[index].tglisi),
                                          style: TextStyle(
                                            color: Colors.teal,
                                            fontSize: MediaQuery.of(context)
                                                .size
                                                .width /
                                                35,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),                                    ],
                                  ),
                                ),
                                //SizedBox(width: 10.0),
                                // Column(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   crossAxisAlignment: CrossAxisAlignment.end,
                                //   children: <Widget>[
                                //],
                                //),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
            controller: _sc,
          ) : ( isLoading==true ? Container(
            color: Colors.white.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ) : Center(
            child: Card(
              elevation: 20,
              color: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: 100,
                width: 200,
                //color: Colors.teal,
                child: Center(
                  child: AutoSizeText("Maaf tidak ada history untuk jenis assessment ini.",
                    maxLines: 2, textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
          )
          ),
        ),
      ),
    );
  }
}
