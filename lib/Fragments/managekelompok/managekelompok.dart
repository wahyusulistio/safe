import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/managekelompok/dialognamagrouping.dart';
import 'package:safe/Fragments/managekelompok/managekelompokitem.dart';
import 'package:safe/Models/Grouping.dart';
import 'package:safe/Models/Kelas.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:safe/Utilities/navigator_key.dart';

class ManageKelompok extends StatefulWidget {
  const ManageKelompok({Key? key, required this.kls}) : super(key: key);

  final Kelas kls;
  @override
  State<ManageKelompok> createState() => _ManageKelompokState();
}

class _ManageKelompokState extends State<ManageKelompok> {
  ApiService apiService = Get.find(tag: 'apiserv1');
  String nama = "";
  String nip = "";
  String role = "";

  late Kelas kls;
  late List<Grouping> groupings = <Grouping>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kls=widget.kls;
    //WidgetsBinding.instance.addObserver(this);
    SecureStorageHelper.getListString("userinfo").then((value) {
      setState(() {
        if (value != null) {
          nama = value[2].toString();
          nip = value[3].toString();
          role = value[6].toString();
          getGrouping();
        } else {
          //print("username1 $value");
        }
      });
    });

    //registerNotification();
    //GetJwtDll();
  }

  Future<void> getGrouping() async {
    var req = await apiService.getGroupingKelas(nip, kls.id_kelas);
    print(req.body);

    List<Grouping> tgrouping=<Grouping>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        //print("data:"+json.decode(req.body)['data'][i]);
        tgrouping.add(Grouping.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    print("jumlah "+tgrouping.length.toString());
    groupings.clear();
    setState((){
      groupings=tgrouping;
    });
    // groupings.add(Grouping(
    //   groupingid: "grouping1",
    //   groupingname: "grouping1",
    //   kelasid: "1",
    // )
    // );
    // groupings.add(Grouping(
    //   groupingid: "grouping2",
    //   groupingname: "grouping2",
    //   kelasid: "2",
    // )
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.teal,
      appBar: AppBar(
        //elevation: 0.1,
        backgroundColor: Colors.teal,
        title: Text("Manage Kelompok"),
        /*actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        )
      ],*/
      ),
      body: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
        //child: SingleChildScrollView(
          child: ListView.builder(
            //controller: ,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: groupings.length,
            itemBuilder: (BuildContext context, int index) {
              print("masuk atas grouping");
              return ManageKelompokItem(grouping: groupings[index], kls: kls,);  //makeCard(mails[index]);
            },
          ),
        //),
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
                      child:
                      MyDialogNamaGrouping(user: nip, kls: kls, currname: ""),
                    ),
                  ),
                  //Text("Maaf tidak ada jadwal konsultasi saat ini. Silahkan lakukan reservasi terlebih dahulu."),
                  //titleStyle: TextStyle(fontSize: 0),
                );
              });
          setState((){
            getGrouping();
          });
        },
      ),
      //bottomNavigationBar: makeBottom,
    );
  }
}
