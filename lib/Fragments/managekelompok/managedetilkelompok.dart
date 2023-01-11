import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/managekelompok/dialognamakelompok.dart';
import 'package:safe/Fragments/managekelompok/managedetilkelompokitem.dart';
import 'package:safe/Models/Group.dart';
import 'package:safe/Models/Grouping.dart';
import 'package:safe/Models/Kelas.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/Debouncer.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:safe/Utilities/navigator_key.dart';

class ManageDetilKelompok extends StatefulWidget {
  const ManageDetilKelompok(
      {Key? key, required this.grouping, required this.kls})
      : super(key: key);

  final Grouping grouping;
  final Kelas kls;
  @override
  State<ManageDetilKelompok> createState() => _ManageDetilKelompokState();
}

class _ManageDetilKelompokState extends State<ManageDetilKelompok> {
  ApiService apiService = Get.find(tag: 'apiserv1');
  String nama = "";
  String nip = "";
  String role = "";

  final _debouncer = Debouncer(milliseconds: 500);
  late Grouping grouping;
  late Kelas kls;
  late List<Group> groups = <Group>[];
  String searchfilter = "";

  Future<void> getDetilGroup() async {
    //print("groupingid "+widget.grouping.groupingid);
    setState((){
      groups.clear();
    });
    var req;
    if(searchfilter!="")
      req = await apiService.getKelompokPesertaGrouping(
          user: nip, idgrouping: grouping.groupingid, keywordpeserta: searchfilter);
    else
      req = await apiService.getKelompokGrouping(
        user: nip, idgrouping: grouping.groupingid);
    //print(req.body);
    List<Group> tgroup = <Group>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        //print("data:"+json.decode(req.body)['data'][i]);
        tgroup.add(Group.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    //print("jumlah "+tgrouping.length.toString());

    setState(() {
      groups = tgroup;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    grouping = widget.grouping;
    kls = widget.kls;
    //WidgetsBinding.instance.addObserver(this);
    SecureStorageHelper.getListString("userinfo").then((value) {
      setState(() {
        if (value != null) {
          nama = value[2].toString();
          nip = value[3].toString();
          role = value[6].toString();
          getDetilGroup();
        } else {
          //print("username1 $value");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.teal,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //elevation: 0.1,
        backgroundColor: Colors.teal,
        title: Text("Manage Detil Kelompok"),
        /*actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        )
      ],*/
      ),
      body: Container(
        // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
        height: MediaQuery.of(context).size.height,
        width:  MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
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
                        setState((){
                          getDetilGroup();
                        });
                      }
                      //perform search here
                    });
                  },
                ),
              ),
            ),
            Expanded(
              flex: 8,
              //child: SingleChildScrollView(
                //height: MediaQuery.of(context).size.height-150,
                //padding: EdgeInsets.only(bottom: 10),
                child: Container(
                  child: ListView.builder(
                    //controller: ,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: groups.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ManageDetilKelompokItem(
                        group: groups[index],
                        kls: kls,
                        grouping: grouping,
                      ); //makeCard(mails[index]);
                    },
                  ),
                ),
              //),
            ),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
        onPressed: () async {
          await showDialog(
              context: navigatorKey.currentContext!,
              builder: (context) {
                //print("masuk sini");
                return AlertDialog(
                  content: Container(
                    height: 500,
                    width: 500,
                    child: SingleChildScrollView(
                      child: MyDialogNamaKelompok(
                        user: nip,
                        currname: "",
                        grouping: grouping,
                      ),
                    ),
                  ),
                  //Text("Maaf tidak ada jadwal konsultasi saat ini. Silahkan lakukan reservasi terlebih dahulu."),
                  //titleStyle: TextStyle(fontSize: 0),
                );
              });
          setState(() {
            getDetilGroup();
          });
        },
      ),
      //bottomNavigationBar: makeBottom,
    );
  }
}
