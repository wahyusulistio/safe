//import 'package:auto_size_text/auto_size_text.dart';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/dialogconfirm.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Models/HasilSosiometriTBJFPAP2022.dart';
import 'package:safe/Models/testkelasgrouping.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/Debouncer.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
//import 'package:safe/Utilities/save_file_mobile.dart';
// import '../../../Utilities/save_file_mobile.dart'
//   if (dart.library.html) '../../../Utilities/save_file_web.dart' as helper;
//import 'package:safe/Utilities/save_file_web.dart';
import '../../../Utilities/mobile.dart'
    if (dart.library.html) '../../../Utilities/web.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

//import 'helper/save_file_mobile.dart'; if (dart.library.html) 'helper/save_file_web.dart';

class SosiometriHasillFasilitator extends StatefulWidget {
  const SosiometriHasillFasilitator({Key? key, required this.tkg})
      : super(key: key);

  final TestKelasGrouping tkg;
  @override
  State<SosiometriHasillFasilitator> createState() =>
      _SosiometriHasillFasilitatorState();
}

class _SosiometriHasillFasilitatorState
    extends State<SosiometriHasillFasilitator> {
  ApiService apiService = Get.find(tag: 'apiserv1');
  String nama = "";
  String nip = "";
  String role = "";

  late TestKelasGrouping tkg;
  List<HasilSosiometriTBJFPAP2022> _hasil = <HasilSosiometriTBJFPAP2022>[];
  List<HasilSosiometriTBJFPAP2022> _hasilfiltered =
      <HasilSosiometriTBJFPAP2022>[];
  late HasilSosiometriTBJFPAP2022DataSource
      _hasilDataSource; //= HasilSosiometriTBJFPAP2022DataSource(hasilData: _hasil);

  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  final _debouncer = Debouncer(milliseconds: 500);
  String searchfilter = "";
  String kriteriabobot = "0";

  @override
  void initState() {
    super.initState();
    tkg = widget.tkg;
    //HasilSosiometriTBJFPAP2022DataSource _hasilDataSource= HasilSosiometriTBJFPAP2022DataSource(hasilData: _hasil);
    SecureStorageHelper.getListString("userinfo").then((value) {
      setState(() {
        if (value != null) {
          nama = value[2].toString();
          nip = value[3].toString();
          role = value[6].toString();

          _getHasilData().whenComplete(() {
            setState(() {});
          });
        } else {
          //print("username1 $value");
        }
      });
    });
  }

  Future<void> _exportDataGridToExcel() async {
    final xlsio.Workbook workbook = _key.currentState!.exportToExcelWorkbook();

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName =
        Platform.isWindows ? '$path\\Output.xlsx' : '$path/Output.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);

    //await helper.FileSaveHelper.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
  }

  Future<void> _exportDataGridToPdf() async {
    final PdfDocument document =
        _key.currentState!.exportToPdfDocument(fitAllColumnsInOnePage: true);

    final List<int> bytes = document.saveSync();
    await saveAndLaunchFile(bytes, 'DataGrid.pdf');
    document.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Hasil Sosiometri"),
      ),
      body: Container(
        // padding: EdgeInsets.all(10),
        // margin: EdgeInsets.all(10),
        // color: Colors.teal,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            // Expanded(
            //     flex: 1,
            //     child: Container(
            //       margin: EdgeInsets.all(10),
            //       color: Colors.teal,
            //       padding: EdgeInsets.all(10),
            //       child: Column(
            //         children: [
            //           Expanded(
            //               flex: 1,
            //               child: Container(
            //                 //color: Colors.black12,
            //                 child: Row(
            //                   children: [
            //                     Expanded(
            //                         flex: 1,
            //                         child: Container(
            //                           alignment: Alignment.centerRight,
            //                           child: Text(
            //                             "Nilai Minimum :",
            //                             //maxLines: 1,
            //                             style: TextStyle(color: Colors.white),
            //                           ),
            //                         )),
            //                     Expanded(
            //                         flex: 2,
            //                         child: Container(
            //                           padding: EdgeInsets.only(left: 10, right: MediaQuery.of(context).size.width*0.4, top: 2, bottom: 6),
            //                           child: TextFormField(
            //                             style: TextStyle(color: Colors.white),
            //                             initialValue: "70",
            //                             cursorColor: Colors.white,
            //                             textAlign: TextAlign.center,
            //                             decoration: InputDecoration(
            //                                 enabledBorder: OutlineInputBorder(
            //                                   borderSide: const BorderSide(width: 1, color: Colors.white),
            //                                   borderRadius: BorderRadius.circular(5),
            //                                 ),
            //                                 focusedBorder: OutlineInputBorder(
            //                                   borderSide: const BorderSide(width: 1, color: Colors.white),
            //                                   borderRadius: BorderRadius.circular(5),
            //                                 ),
            //                             ),
            //                               keyboardType: TextInputType.number,
            //                               inputFormatters: <TextInputFormatter>[
            //                                 FilteringTextInputFormatter.digitsOnly,
            //                                 LengthLimitingTextInputFormatter(2),
            //                               ],
            //                           ),
            //                         )
            //                     ),
            //                   ],
            //                 ),
            //               )),
            //           SizedBox(height: 1,child: Container(color: Colors.white,),),
            //           Expanded(
            //               flex: 1,
            //               child: Container(
            //                 //color: Colors.blue,
            //                 child: Row(
            //                   children: [
            //                     Expanded(
            //                         flex: 1,
            //                         child: Container(
            //                           alignment: Alignment.centerRight,
            //                           child: Text(
            //                             "Bobot Terbesar :",
            //                             //maxLines: 1,
            //                             style: TextStyle(color: Colors.white),
            //                           ),
            //                         )),
            //                     Expanded(flex: 2, child: Container(
            //                       child: RadioListTile<String>(
            //                         tileColor: Colors.white,
            //                         activeColor: Colors.white,
            //                         title: const Text('Jumlah Anggota Kelompok', style: TextStyle(color: Colors.white),),
            //                         value: "1",
            //                         groupValue: kriteriabobot,
            //                         onChanged: (String? value) {
            //                           setState(() {
            //                             kriteriabobot = value.toString();
            //                           });
            //                         },
            //                       ),
            //                     )),
            //                   ],
            //                 ),
            //               )),
            //           Expanded(
            //               flex: 1,
            //               child: Container(
            //                 //color: Colors.deepOrangeAccent,
            //                 child: Row(
            //                   children: [
            //                     Expanded(
            //                         flex: 1,
            //                         child: Container(
            //                           alignment: Alignment.centerRight,
            //                           // child: AutoSizeText(
            //                           //   "Bobot Terbesar :",
            //                           //   maxLines: 1,
            //                           // ),
            //                         )),
            //                     Expanded(flex: 2, child: Container(
            //                       child: RadioListTile<String>(
            //                         tileColor: Colors.white,
            //                         activeColor: Colors.white,
            //                         title: Container(
            //                           padding: EdgeInsets.only(left: 0, right: MediaQuery.of(context).size.width*0.2, top: 2, bottom: 10),
            //                           child: TextFormField(
            //                             style: TextStyle(color: Colors.white),
            //                             readOnly: kriteriabobot=="2" ? false : true,
            //                             //enabled: kriteriabobot=="2" ? true : false,
            //                             //initialValue: "70",
            //                             cursorColor: Colors.white,
            //                             textAlign: TextAlign.center,
            //                             decoration: InputDecoration(
            //                               enabledBorder: OutlineInputBorder(
            //                                 borderSide: const BorderSide(width: 1, color: Colors.white),
            //                                 borderRadius: BorderRadius.circular(5),
            //                               ),
            //                               focusedBorder: OutlineInputBorder(
            //                                 borderSide: const BorderSide(width: 1, color: Colors.white),
            //                                 borderRadius: BorderRadius.circular(5),
            //                               ),
            //                             ),
            //                             keyboardType: TextInputType.number,
            //                             inputFormatters: <TextInputFormatter>[
            //                               FilteringTextInputFormatter.digitsOnly,
            //                               LengthLimitingTextInputFormatter(2),
            //                             ],
            //                           ),
            //                         ),
            //                         value: "2",
            //                         groupValue: kriteriabobot,
            //                         onChanged: (String? value) {
            //                           setState(() {
            //                             kriteriabobot = value.toString();
            //                           });
            //                         },
            //                       ),
            //                     )),
            //                   ],
            //                 ),
            //               )),
            //           SizedBox(height: 1,child: Container(color: Colors.white,),),
            //           Expanded(
            //               flex: 1,
            //               child: Container(
            //                 alignment: Alignment.centerLeft,
            //                 //color: Colors.white,
            //                 padding: EdgeInsets.all(10),
            //                 child: ElevatedButton(
            //                   child: Text("Proses"),
            //                   onPressed: (){
            //
            //                   },
            //                 ),
            //               )),
            //         ],
            //       ),
            //     )),
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
                      setState(() {
                        searchPeserta();
                      });
                    }
                    //perform search here
                  });
                },
              ),
            ),
            Expanded(
                flex: 2,
                child: Container(
                  //color: Colors.greenAccent,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(12.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              height: 40.0,
                              width: 150.0,
                              child: MaterialButton(
                                  color: Colors.teal,
                                  onPressed: _exportDataGridToExcel,
                                  child: const Center(
                                      child: Text(
                                    'To Excel',
                                    style: TextStyle(color: Colors.white),
                                  ))),
                            ),
                            const Padding(padding: EdgeInsets.all(20)),
                            SizedBox(
                              height: 40.0,
                              width: 150.0,
                              child: MaterialButton(
                                  color: Colors.teal,
                                  onPressed: _exportDataGridToPdf,
                                  child: const Center(
                                      child: Text(
                                    'To PDF',
                                    style: TextStyle(color: Colors.white),
                                  ))),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _hasil.length > 0
                            ? SfDataGrid(
                                key: _key,
                                source: _hasilDataSource,
                                columns: <GridColumn>[
                                  GridColumn(
                                      columnName: 'reset',
                                      label: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Reset',
                                          ))),
                                  GridColumn(
                                      columnName: 'nip',
                                      label: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'NIP',
                                          ))),
                                  GridColumn(
                                      columnName: 'nipbaru',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('NIP Baru'))),
                                  GridColumn(
                                      columnName: 'nama',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Nama',
                                            overflow: TextOverflow.ellipsis,
                                          ))),
                                  GridColumn(
                                      columnName: 'namakelompok',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Kelompok',
                                            overflow: TextOverflow.ellipsis,
                                          ))),
                                  GridColumn(
                                      columnName: 'jmlhpenilaiaktif',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child:
                                              const Text('Penilai Kerjasama'))),
                                  GridColumn(
                                      columnName: 'nilaiaktif',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child:
                                              const Text('Nilai Kerjasama'))),
                                  GridColumn(
                                      columnName: 'jmlhpenilaietika',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Penilai Etika'))),
                                  GridColumn(
                                      columnName: 'nilaietika',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Nilai Etika'))),
                                ],
                              )
                            : Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _getHasilData() async {
    setState(() {
      _hasil.clear();
      _hasilfiltered.clear();
    });
    var req = await apiService.getSkorSosiometriFasilitator(
        user: nip,
        idkelas: tkg.idkelas,
        iddiklat: tkg.iddiklat,
        idmatadiklat: tkg.idmatadiklat,
        idtest: tkg.idtest);
    print(req.body);

    List<HasilSosiometriTBJFPAP2022> tasmnt = <HasilSosiometriTBJFPAP2022>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        print("data existing " + i.toString());
        tasmnt.add(HasilSosiometriTBJFPAP2022.fromJSON(
            json.decode(req.body)['data'][i]));
      }
    }

    //print("jumlah "+tgrouping.length.toString());
    setState(() {
      _hasil = tasmnt;
      _hasilfiltered = tasmnt;
      _hasilDataSource =
          HasilSosiometriTBJFPAP2022DataSource(hasilData1: _hasilfiltered,
          nip1: nip, tkg1: tkg);
      //_selectedAsmnts=tasmnt;
    });
  }

  void searchPeserta() {
    List<HasilSosiometriTBJFPAP2022> tasmnt = _hasil;
    setState(() {
      _hasilfiltered = tasmnt
          .where((element) =>
              element.nmpeg
                  .toLowerCase()
                  .contains(searchfilter.toLowerCase()) ||
              element.namakelompok
                  .toLowerCase()
                  .contains(searchfilter.toLowerCase()))
          .toList();
      _hasilDataSource =
          HasilSosiometriTBJFPAP2022DataSource(hasilData1: _hasilfiltered,
          nip1: nip, tkg1: tkg);
    });
  }
}

class Employee {
  /// Creates the employee class with required details.
  Employee(this.id, this.name, this.designation, this.salary);

  /// Id of an employee.
  final int id;

  /// Name of an employee.
  final String name;

  /// Designation of an employee.
  final String designation;

  /// Salary of an employee.
  final int salary;
}

class HasilSosiometriTBJFPAP2022DataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  ApiService apiService = Get.find(tag: 'apiserv1');
  List<DataGridRow> _hasilData = <DataGridRow>[];
  String nip = "";
  late TestKelasGrouping tkg;
  late List<HasilSosiometriTBJFPAP2022> hasilData;

  HasilSosiometriTBJFPAP2022DataSource(
      {required List<HasilSosiometriTBJFPAP2022> hasilData1,
        required String nip1,
        required TestKelasGrouping tkg1}) {
    nip = nip1;
    tkg = tkg1;
    hasilData = hasilData1;
    updateDataGridRows();
  }

  void updateDataGridRows() {
    _hasilData = hasilData
        .map<DataGridRow>((HasilSosiometriTBJFPAP2022 e) =>
            DataGridRow(cells: <DataGridCell>[
              DataGridCell<String>(columnName: 'reset', value: e.nippeserta),
              DataGridCell<String>(columnName: 'nip', value: e.nippeserta),
              DataGridCell<String>(columnName: 'nipbaru', value: e.nipbaru),
              DataGridCell<String>(columnName: 'nama', value: e.nmpeg),
              DataGridCell<String>(
                  columnName: 'namakelompok', value: e.namakelompok),
              DataGridCell<String>(
                  columnName: 'jmlhpenilaiaktif',
                  value: e.jmlhpenilaikekatifan),
              DataGridCell<String>(
                  columnName: 'nilaiaktif',
                  value: (e.nilaiakhirkeaktifan != "null")
                      ? double.parse(e.nilaiakhirkeaktifan).toStringAsFixed(2)
                      : e.nilaiakhirkeaktifan),
              DataGridCell<String>(
                  columnName: 'jmlhpenilaietika', value: e.jmlhpenilaietika),
              DataGridCell<String>(
                  columnName: 'nilaietika',
                  value: (e.nilaiakhiretika != "null")
                      ? double.parse(e.nilaiakhiretika).toStringAsFixed(2)
                      : e.nilaiakhiretika),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _hasilData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell cell) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: cell.columnName == 'reset'
            ? LayoutBuilder(builder:
            (BuildContext context, BoxConstraints constraints) {
          return MaterialButton(
              color: Colors.teal,
              onPressed: () async {
                var datares = await Get.defaultDialog(
                  content:
                  MyDialogConfirm(info: "Reset respon "+row.getCells()[3].value.toString()+"?"),
                  titleStyle: TextStyle(fontSize: 0),
                );
                Map<String, dynamic> json1 =
                jsonDecode(datares.toString());
                if (json1["respon"] == "ya") {

                  await apiService.resetResponPeserta(
                      user: nip,
                      idkelas: tkg.idkelas,
                      iddiklat: tkg.iddiklat,
                      idmatadiklat: tkg.idmatadiklat,
                      idtest: tkg.idtest,
                      nippeserta: row.getCells()[0].value.toString());

                  var req = await apiService.getSkorSosiometriFasilitator(
                      user: nip,
                      idkelas: tkg.idkelas,
                      iddiklat: tkg.iddiklat,
                      idmatadiklat: tkg.idmatadiklat,
                      idtest: tkg.idtest);

                  hasilData = <HasilSosiometriTBJFPAP2022>[];
                  if (json.decode(req.body)['data'] != null) {
                    for (int i = 0;
                    i < json.decode(req.body)['data'].length;
                    i++) {
                      hasilData.add(HasilSosiometriTBJFPAP2022.fromJSON(
                          json.decode(req.body)['data'][i]));
                    }
                  }
                  updateDataGridRows();
                  updateDataGridSource();

                  await Get.defaultDialog(
                    content: MyDialogInfo(
                        info: "Respon Peserta telah direset."),
                    titleStyle: TextStyle(fontSize: 0),
                  );
                }
                //Get.off(()=>BelbinHasillFasilitator(tkg: tkg));
              },
              child: const AutoSizeText(
                'Reset',
                maxLines: 1,
                style: TextStyle(color: Colors.white),
              ));
        })
            : Text(cell.value.toString()),
      );
    }).toList());
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}
