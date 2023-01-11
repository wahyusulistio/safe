import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe/Models/Group.dart';
import 'package:safe/Models/Kelas.dart';
import 'package:safe/Models/Peserta.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';

class MyDialogPesertaKelompok extends StatefulWidget {
  MyDialogPesertaKelompok({
    Key? key,
    required this.pesertas, required this.kls, required this.pesertainkelas, required this.grup,
  }) : super(key: key);

  final List<Peserta> pesertas; // = <Expertise>[];
  final List<Peserta> pesertainkelas; // = <Expertise>[];
  final Kelas kls;
  final Group grup;

  @override
  _MyDialogPesertaKelompokState createState() => new _MyDialogPesertaKelompokState();
}

class _MyDialogPesertaKelompokState extends State<MyDialogPesertaKelompok> {
  // List<Peserta> psrts = [Peserta(fullname: "fullname1", niplama: "niplama1", nipbaru: "nipbaru1"),
  //   Peserta(fullname: "fullname2", niplama: "niplama2", nipbaru: "nipbaru2"),
  //   Peserta(fullname: "fullname3", niplama: "niplama3", nipbaru: "nipbaru3"),
  //   Peserta(fullname: "fullname4", niplama: "niplama4", nipbaru: "nipbaru4")];
  ApiService apiService = Get.find(tag: 'apiserv1');
  List<Peserta> psrts=<Peserta>[];
  late List<Peserta> psrtall;
  late Group grup;
//  static String jwttoken = "";
  String nama = "";
  String nip = "";
  String role = "";

  List<Peserta> selected = <Peserta>[];


  @override
  void initState() {
    super.initState();

    //psrts=widget.pesertas;
    psrtall=widget.pesertainkelas;
    grup=widget.grup;
    SecureStorageHelper.getListString("userinfo").then((value) {
      setState(() {
        if (value != null) {
          nama = value[2].toString();
          nip = value[3].toString();
          role = value[6].toString();
          //getGrouping();
        } else {
          //print("username1 $value");
        }
      });
    });

    // psrts = [Peserta(fullname: "fullname1", niplama: "niplama1", nipbaru: "nipbaru1"),
    //   Peserta(fullname: "fullname2", niplama: "niplama2", nipbaru: "nipbaru2"),
    //   Peserta(fullname: "fullname3", niplama: "niplama3", nipbaru: "nipbaru3"),
    //   Peserta(fullname: "fullname4", niplama: "niplama4", nipbaru: "nipbaru4")]; //widget.pesertas;

    // for(int i=0;i<psrts.length;i++)
    //   {
    //     for(int j=0;j<psrtall.length;j++)
    //       {
    //         if(psrts[i].niplama==psrtall[j].niplama){
    //           selected.add(psrtall[j]);
    //           break;
    //         }
    //       }
    //   }
    //selected=widget.pesertas;
    //List<Expertise> tList = <Expertise>[];
    //List<String> bidkeahlianList = <String>[];
    //List<String> level1List = <String>[];
    //List<String> level2List = <String>[];
    //print("response expertise:" + req.body);
    //if (json.decode(req.body)['records'] != null) {
    // for (int i = 0; i < exps.length; i++) {
    //   //tList.add(Expertise.fromJSON(json.decode(req.body)['records'][i]));
    //   kelkeahlian.add(exps[i].kelkeahlian);
    //   //bidkeahlian.add(exps[i].bidkeahlian);
    //   //level1.add(exps[i].level1);
    //   //level2.add(exps[i].level2);
    // }
    //}

    //level1 = level1.toSet().toList();
    //level2 = level2.toSet().toList();
    //bidkeahlian = bidkeahlian.toSet().toList();
    // kelkeahlian = kelkeahlian.toSet().toList();
    //
    // _updatefilterdialog();

    //print("jumlah exps="+exps.length.toString());
  }

  // void _updatefilterdialog() async {
  //   List<Expertise> searched = <Expertise>[];
  //   List<String> bidkeahlianList = <String>[];
  //   List<String> level1List = <String>[];
  //   List<String> level2List = <String>[];
  //
  //   //print("filterdialog:$bidkeahlianfilter dan $level1filter");
  //   if (kelkeahlianfilter != "") {
  //     searched = exps
  //         .where((i) => i.kelkeahlian
  //         .toLowerCase()==kelkeahlianfilter.toLowerCase())
  //         .toList();
  //     print("masuk1 filter:" + searched.length.toString());
  //     for (int i = 0; i < searched.length; i++) {
  //       bidkeahlianList.add(searched[i].bidkeahlian);
  //       level1List.add(searched[i].level1);
  //       level2List.add(searched[i].level2);
  //     }
  //
  //     bidkeahlianList=bidkeahlianList.toSet().toList();
  //     level1List = level1List.toSet().toList();
  //     level2List = level2List.toSet().toList();
  //   } else {
  //     searched = exps;
  //     for (int i = 0; i < searched.length; i++) {
  //       bidkeahlianList.add(searched[i].bidkeahlian);
  //       level1List.add(searched[i].level1);
  //       level2List.add(searched[i].level2);
  //     }
  //     print("masuk2 filter:" + searched.length.toString());
  //     bidkeahlianList=bidkeahlianList.toSet().toList();
  //     level1List = level1List.toSet().toList();
  //     level2List = level2List.toSet().toList();
  //   }
  //
  //   if (bidkeahlianfilter != "") {
  //     level2List.clear();
  //     level1List.clear();
  //     searched = exps
  //         .where((i) =>
  //     i.bidkeahlian.toLowerCase()==bidkeahlianfilter.toLowerCase() &&
  //         i.kelkeahlian.toLowerCase()==kelkeahlianfilter.toLowerCase())
  //         .toList();
  //     print("masuk2 filter:" + level1List.toString());
  //     for (int i = 0; i < searched.length; i++) {
  //       level1List.add(searched[i].level1);
  //       level2List.add(searched[i].level2);
  //     }
  //
  //     level1List = level1List.toSet().toList();
  //     level2List = level2List.toSet().toList();
  //   } /*else {
  //     searched = exps;
  //     for (int i = 0; i < searched.length; i++) {
  //       level1List.add(searched[i].level1);
  //       level2List.add(searched[i].level2);
  //     }
  //     print("masuk2 filter:" + searched.length.toString());
  //     level1List = level1List.toSet().toList();
  //     level2List = level2List.toSet().toList();
  //   }*/
  //
  //   if (level1filter != "") {
  //     level2List.clear();
  //     searched = exps
  //         .where((i) =>
  //     i.level1.toLowerCase()==level1filter.toLowerCase() &&
  //         i.bidkeahlian.toLowerCase()==bidkeahlianfilter.toLowerCase() &&
  //         i.kelkeahlian.toLowerCase()==kelkeahlianfilter.toLowerCase())
  //         .toList();
  //     print("masuk3 filter:" + searched.length.toString());
  //     for (int i = 0; i < searched.length; i++) {
  //       level2List.add(searched[i].level2);
  //     }
  //     level2List = level2List.toSet().toList();
  //   }
  //
  //   setState(() {
  //     print("masuk5 filter:" + searched.length.toString());
  //     //isLoading = false;
  //     bidkeahlian=bidkeahlianList;
  //     level1 = level1List;
  //     level2 = level2List;
  //   });
  // }

  _getContent() {
    return Column(
      children: [
        DropdownSearch<Peserta>.multiSelection(
          items: psrtall,
          // popupProps: PopupPropsMultiSelection.menu(
          //   showSelectedItems: true,
          //   disabledItemFn: (String s) => s.startsWith('I'),
          // ),
          //showSelectedItems: true,
          itemAsString: (Peserta? p) => p!.fullname,
          onChanged:(List<Peserta>? data){
            //print(data);
            psrts=data!;
          } ,
          showSearchBox: true,
          selectedItems: selected,
          showClearButton: true,
        ),
        SizedBox(height: 10),
        // DropdownSearch<String>(
        //   //mode: Mode.MENU,
        //   items: bidkeahlian,
        //   showClearButton: true,
        //   maxHeight: 300,
        //   //onFind: (String? filter) => _selectBidKeahlian(filter!),
        //   dropdownSearchDecoration: InputDecoration(
        //     labelText: "--Bidang Keahlian--",
        //     contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
        //     border: OutlineInputBorder(),
        //   ),
        //   selectedItem: bidkeahlianfilter != "" ? bidkeahlianfilter : null,
        //   //itemAsString: (Expertise exp)=>exp.bidkeahlianAsString(),
        //   //onChanged: (String? data)=>_selectBidKeahlian(data!),
        //   /*onSaved: (String? data) {
        //     _selectBidKeahlian(data!);
        //     bidkeahlianfilter = data;
        //   },*/
        //   onChanged: (String? data) {
        //     /*setState(() {
        //       bidkeahlianfilter = data != null ? data : "";
        //       _updatefilterdialog();
        //     });*/
        //     bidkeahlianfilter = data != null ? data : "";
        //     _updatefilterdialog();
        //     //bidkeahlianfilter = data!=null?data:"";
        //     //_selectBidKeahlian(data!=null?data:"");
        //   },
        //   showSearchBox: true,
        // ),
//         SizedBox(height: 10),
//         DropdownSearch<String>(
//           //mode: Mode.MENU,
//           showClearButton: true,
//           items: level1,
//           maxHeight: 300,
//           //onFind: (String? filter) => getData(filter),
//           dropdownSearchDecoration: InputDecoration(
//             labelText: "--Level 1--",
//             contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
//             border: OutlineInputBorder(),
//           ),
//           selectedItem: level1filter != "" ? level1filter : null,
//           //itemAsString: (Expertise exp)=>exp.bidkeahlianAsString(),
//           //onChanged: print,
//           /*onSaved: (String? data) {
//             _selectLevel1(data!);
//             level1filter = data;
//           },*/
//           onChanged: (String? data) {
// /*            setState(() {
//               level1filter = data != null ? data : "";
//               //_selectLevel1(data!=null?data:"");
//               _updatefilterdialog();
//             });*/
//             level1filter = data != null ? data : "";
//             //_selectLevel1(data!=null?data:"");
//             _updatefilterdialog();
//           },
//           showSearchBox: true,
//         ),
//         SizedBox(height: 10),
//         DropdownSearch<String>(
//           //mode: Mode.MENU,
//           showClearButton: true,
//           items: level2,
//           maxHeight: 300,
//           //onFind: (String? filter) => getData(filter),
//           dropdownSearchDecoration: InputDecoration(
//             labelText: "--Level 2--",
//             contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
//             border: OutlineInputBorder(),
//           ),
//           selectedItem: level2filter != "" ? level2filter : null,
//           //itemAsString: (Expertise exp)=>exp.bidkeahlianAsString(),
//           //onChanged: print,
//           onChanged: (String? data) {
//             level2filter = data != null ? data : "";
//           },
//           showSearchBox: true,
//         ),
        ElevatedButton(
          child: Text("Submit"),
          onPressed: () async {
            //await apiService.deletePesertaInGroup(user: nip, idgruppeserta: grup.groupid);
            for(int i=0;i<psrts.length;i++)
              {
                print("masuk tambah peserta");
                 apiService.addPesertaInGroup(user: nip, idgruppeserta: grup.groupid, nippeserta: psrts[i].niplama, namapeserta: psrts[i].fullname);
              }
            // String text = jsonEncode({
            //   'kelkeahlianfilter':'kelkeahlianfilter',
            // });
            Get.back(result: psrts);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }
}