import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/dialogconfirm.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Models/IndAssessment.dart';
import 'package:safe/Models/Kelas.dart';
import 'package:safe/Models/testkelasgrouping.dart';
import 'package:safe/Utilities/ApiService.dart';

class MyDialogJoinKelas extends StatefulWidget {
  const MyDialogJoinKelas({Key? key, required this.nip}) : super(key: key);

  final String nip;

  @override
  State<MyDialogJoinKelas> createState() => _MyDialogJoinKelasState();
}

class _MyDialogJoinKelasState extends State<MyDialogJoinKelas> {
  ApiService apiService = Get.find(tag: 'apiserv1');

  String nip="";
  TextEditingController tecnama=TextEditingController();
  TextEditingController tecdate1=TextEditingController();
  List<String> months =
  ['Jan', 'Feb', 'Mar', 'Apr', 'May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  int tglmulai=DateTime.now().day;
  int bulanmulai=DateTime.now().month;
  int tahunmulai=DateTime.now().year;
  int tglselesai=DateTime.now().day;
  int bulanselesai=DateTime.now().month;
  int tahunselesai=DateTime.now().year;
  String lokasi = "Badiklat";
  List<String> tmptdiklat=['Badiklat', 'BDM', 'BDY', 'BDB','BDG','Perwakilan', 'Eksternal'];
  bool isLoading=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nip=widget.nip;
  }

  @override
  Widget build(BuildContext context) {
    return //new Scaffold(
      // appBar: new AppBar(
      //   backgroundColor: Colors.white,
      //   centerTitle: true,
      //   title: new Text(
      //     'Available Tools',
      //     style: TextStyle(color: Colors.black),
      //   ),
      // ),
      //body:
      Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Text("Join Kelas"),
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(
                flex: 1,
                  child: Text("Kode Kelas:"),
              ),
              SizedBox(width: 10,),
              Expanded(
                flex: 3,
                  child: TextField(
                    controller: tecnama,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white70),
                  ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          // Row(
          //   children: [
          //     Expanded(
          //       flex: 1,
          //       child: Text("Tgl Mulai:"),
          //     ),
          //     SizedBox(width: 10,),
          //     Expanded(
          //       flex: 3,
          //       child: TextField(readOnly: true,
          //         //textAlign: TextAlign.center,
          //         controller: tecdate1,
          //         autocorrect: false,
          //         enableSuggestions: false,
          //         decoration: InputDecoration(
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(10.0),
          //             ),
          //             //prefixIcon: Icon(Icons.search),
          //             filled: true,
          //             //hintStyle: TextStyle(color: Colors.teal),
          //             hintText: DateTime.now().day.toString()+" "+
          //                 months[DateTime.now().month-1].toString()+" "+
          //                 DateTime.now().year.toString(),
          //             fillColor: Colors.white70),
          //         onTap: () async {
          //           DateTimeRange? selected = await showDateRangePicker(
          //             context: context,
          //             //initialDate: DateTime.now(),
          //             firstDate: DateTime(DateTime.now().year - 5),
          //             lastDate: DateTime(DateTime.now().year + 5),
          //             initialDateRange: DateTimeRange(
          //                 start: DateTime(tahunmulai, bulanmulai, tglmulai),
          //                 end: DateTime(tahunselesai, bulanselesai, tglselesai)),
          //           );
          //           if(selected!=null)
          //           {
          //             tecdate1.text=selected.start.day.toString()+" "+
          //                 months[selected.start.month-1].toString()+" "+
          //                 selected.start.year.toString() +" s.d. "+
          //                 selected.end.day.toString()+" "+
          //                 months[selected.end.month-1].toString()+" "+
          //                 selected.end.year.toString();
          //             setState((){
          //               tglmulai=selected.start.day;
          //               bulanmulai=selected.start.month;
          //               tahunmulai=selected.start.year;
          //               tglselesai=selected.end.day;
          //               bulanselesai=selected.end.month;
          //               tahunselesai=selected.end.year;
          //               //getKelasFasil();
          //             });
          //           }
          //         },
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(height: 10,),
          // Row(
          //   children: [
          //     Expanded(
          //       flex: 1,
          //       child: Text("Lokasi:"),
          //     ),
          //     SizedBox(width: 10,),
          //     Expanded(
          //       flex: 3,
          //       child: DropdownButtonFormField<String>(
          //         value: lokasi,
          //         decoration: InputDecoration(
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(10.0),
          //             ),
          //             //prefixIcon: Icon(Icons.search),
          //             filled: true,
          //             //hintStyle: TextStyle(color: Colors.teal),
          //             hintText: DateTime.now().day.toString()+" "+
          //                 months[DateTime.now().month-1].toString()+" "+
          //                 DateTime.now().year.toString(),
          //             fillColor: Colors.white70),
          //         icon: const Icon(Icons.arrow_downward),
          //         elevation: 16,
          //         //style: const TextStyle(color: Colors.teal),
          //         onChanged: (String? value) {
          //           // This is called when the user selects an item.
          //           setState(() {
          //             lokasi = value!;
          //           });
          //         },
          //         items: tmptdiklat.map<DropdownMenuItem<String>>((String value) {
          //           return DropdownMenuItem<String>(
          //             value: value,
          //             child: Text(value),
          //           );
          //         }).toList(),
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(height: 10,),
          ElevatedButton(
            child: Text("Submit"),
            onPressed: () async {
              String isupdate="false";
              var req=await apiService.getKelasPenyelenggaraan(
                  nip, tecnama.text);

              if (jsonDecode(req.body)['data'] != null &&
                  jsonDecode(req.body)['data'].length!=0) {
                Map<String, dynamic> jsoncek =
                jsonDecode(req.body)['data'][0];
                String namakelas = jsoncek["nama_kelas"];
                String idkelas=jsoncek["id_kelas"];
                var datares = await Get.defaultDialog(
                  content:
                  MyDialogConfirm(info: "Join Kelas "+namakelas+" ?"),
                  titleStyle: TextStyle(fontSize: 0),
                );
                Map<String, dynamic> json =
                jsonDecode(datares.toString());
                if (json["respon"] == "ya") {
                  setState((){
                    isLoading=true;
                  });
                  await apiService.addKelasPeserta(
                      nip, idkelas, nip);

                  setState((){
                    isLoading=false;
                  });
                  await Get.defaultDialog(
                    content:
                    MyDialogInfo(info: "Anda telah berhasil join ke kelas "+namakelas+"."),
                    titleStyle: TextStyle(fontSize: 0),
                  );
                  isupdate="true";
                  Get.back(result: isupdate);
                }
                // await apiService.addKelasFasilitator(nip, idkelas, iddiklat, nip, 'fasilitator');
              }
              else{
                await Get.defaultDialog(
                  content:
                  MyDialogInfo(info: "Kelas tidak ditemukan!"),
                  titleStyle: TextStyle(fontSize: 0),
                );
              }
              //String isupdate="false";
              // String text = jsonEncode({
              //   'namakelas': tecnama.text,
              //   'tglmulai': tahunmulai.toString()+"-"+bulanmulai.toString()+"-"+tglmulai.toString(),
              //   'tglselesai': tahunselesai.toString()+"-"+bulanselesai.toString()+"-"+tglselesai.toString(),
              //   'lokasi': lokasi,
              // });
              // var datares = await Get.defaultDialog(
              //   content:
              //   MyDialogConfirm(info: "Buat Kelas?"),
              //   titleStyle: TextStyle(fontSize: 0),
              // );
              // Map<String, dynamic> json =
              // jsonDecode(datares.toString());
              // if (json["respon"] == "ya") {
              //   setState((){
              //     isLoading=true;
              //   });
              //   var req=await apiService.addKelasPenyelenggaraan(
              //       nip, tecnama.text, tahunmulai.toString()+"-"+bulanmulai.toString()+"-"+tglmulai.toString(),
              //     tahunselesai.toString()+"-"+bulanselesai.toString()+"-"+tglselesai.toString(), lokasi);
              //
              //   if (jsonDecode(req.body)['data'] != null) {
              //     Map<String, dynamic> jsoncek =
              //     jsonDecode(req.body)['data'][0];
              //     String idkelas = jsoncek["id_kelas"];
              //     String iddiklat = jsoncek["id_diklat"];
              //     await apiService.addKelasFasilitator(nip, idkelas, iddiklat, nip, 'fasilitator');
              //     isupdate="true";
              //   }
              //
              //   setState((){
              //     isLoading=false;
              //   });
              //   await Get.defaultDialog(
              //     content:
              //     MyDialogInfo(info: "Kelas telah disubmit, dan Anda telah ditambahkan sebagai fasilitator."),
              //     titleStyle: TextStyle(fontSize: 0),
              //   );
              }
              //Get.back(result: isupdate);
            //},
          )
        ],
      );
    //);
  }

}
