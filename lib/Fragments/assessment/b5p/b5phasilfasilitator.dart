//import 'package:auto_size_text/auto_size_text.dart';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
//import 'package:safe/Fragments/assessment/B5P/B5Phasilpeserta.dart';
//import 'package:safe/Fragments/assessment/B5P/B5Phasilpeserta.dart';
import 'package:safe/Fragments/assessment/b5p/b5phasilpeserta.dart';
import 'package:safe/Fragments/dialogconfirm.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Models/HasilB5P.dart';
import 'package:safe/Models/HasilB5PAllRole.dart';
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

class B5PHasillFasilitator extends StatefulWidget {
  const B5PHasillFasilitator({Key? key, required this.tkg})
      : super(key: key);

  final TestKelasGrouping tkg;
  @override
  State<B5PHasillFasilitator> createState() =>
      _B5PHasillFasilitatorState();
}

class _B5PHasillFasilitatorState extends State<B5PHasillFasilitator> {
  ApiService apiService = Get.find(tag: 'apiserv1');
  String nama = "";
  String nip = "";
  String role = "";

  late TestKelasGrouping tkg;
  List<HasilB5PAllRole> _hasil = <HasilB5PAllRole>[];
  List<HasilB5PAllRole> _hasilfiltered = <HasilB5PAllRole>[];
  late HasilB5PAllRoleDataSource
      _hasilDataSource; //= HasilSosiometriTBJFPAP2022DataSource(hasilData: _hasil);

  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  String kriteriabobot = "0";
  final _debouncer = Debouncer(milliseconds: 500);
  String searchfilter = "";

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
        title: Text("Hasil B5P Test"),
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
                            ? Visibility(
                                visible: true,
                                child: SfDataGrid(
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
                                        columnName: 'namagroup',
                                        label: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Kelompok',
                                              overflow: TextOverflow.ellipsis,
                                            ))),
                                    GridColumn(
                                        columnName: 'N',
                                        label: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: const Text('N'))),
                                    GridColumn(
                                        columnName: 'E',
                                        label: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: const Text('E'))),
                                    GridColumn(
                                        columnName: 'O',
                                        label: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: const Text('O'))),
                                    GridColumn(
                                        columnName: 'A',
                                        label: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: const Text('A'))),
                                    GridColumn(
                                        columnName: 'C',
                                        label: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: const Text('C'))),
                                  ],
                                ),
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
    });
    var req = await apiService.getSkorB5PAllPeserta(
        user: nip,
        idkelas: tkg.idkelas,
        iddiklat: tkg.iddiklat,
        idmatadiklat: tkg.idmatadiklat,
        idtest: tkg.idtest);
    print(req.body);

    List<HasilB5PAllRole> tasmnt = <HasilB5PAllRole>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        print("data existing " + i.toString());
        tasmnt
            .add(HasilB5PAllRole.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    //print("jumlah "+tgrouping.length.toString());
    setState(() {
      _hasil = tasmnt;
      _hasilfiltered = tasmnt;
      _hasilDataSource = HasilB5PAllRoleDataSource(
          hasilData1: _hasilfiltered, nip1: nip, tkg1: tkg);
      //_selectedAsmnts=tasmnt;
    });
  }

  void searchPeserta() {
    List<HasilB5PAllRole> tasmnt = _hasil;
    setState(() {
      _hasilfiltered = tasmnt
          .where((element) =>
              element.nmpeg.toLowerCase().contains(searchfilter.toLowerCase()) ||
                  element.nmgroup.toLowerCase().contains(searchfilter.toLowerCase())
      )
          .toList();
      _hasilDataSource = HasilB5PAllRoleDataSource(
          hasilData1: _hasilfiltered, nip1: nip, tkg1: tkg);
    });
  }
}

class HasilB5PAllRoleDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  ApiService apiService = Get.find(tag: 'apiserv1');
  List<DataGridRow> _hasilData = <DataGridRow>[];
  String nip = "";
  late TestKelasGrouping tkg;
  late List<HasilB5PAllRole> hasilData;
  HasilB5PAllRoleDataSource(
      {required List<HasilB5PAllRole> hasilData1,
      required String nip1,
      required TestKelasGrouping tkg1}) {
    nip = nip1;
    tkg = tkg1;
    hasilData = hasilData1;
    updateDataGridRows();
  }
  void updateDataGridRows() {
    _hasilData = hasilData
        .map<DataGridRow>((HasilB5PAllRole e) =>
            DataGridRow(cells: <DataGridCell>[
              DataGridCell<String>(columnName: 'reset', value: e.nippeserta),
              DataGridCell<String>(columnName: 'nip', value: e.nippeserta),
              DataGridCell<String>(columnName: 'nipbaru', value: e.nipbaru),
              DataGridCell<String>(columnName: 'nama', value: e.nmpeg),
              DataGridCell<String>(columnName: 'namagroup', value: e.nmgroup),
              DataGridCell<String>(columnName: 'N', value: e.N),
              DataGridCell<String>(columnName: 'E', value: e.E),
              DataGridCell<String>(columnName: 'O', value: e.O),
              DataGridCell<String>(columnName: 'A', value: e.A),
              DataGridCell<String>(columnName: 'C', value: e.C),
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
        child: cell.columnName == 'nip'
            ? LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                return MaterialButton(
                    color: Colors.teal,
                    onPressed: () async {
                      var req = await apiService.getSkorB5P2(
                          user: nip,
                          idkelas: tkg.idkelas,
                          iddiklat: tkg.iddiklat,
                          idmatadiklat: tkg.idmatadiklat,
                          idtest: tkg.idtest,
                          nippeserta: row.getCells()[0].value.toString());

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
                    },
                    child: const AutoSizeText(
                      'Details',
                      maxLines: 1,
                      style: TextStyle(color: Colors.white),
                    ));
              })
            : (cell.columnName == 'reset'
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

                            var req = await apiService.getSkorB5PAllPeserta(
                                user: nip,
                                idkelas: tkg.idkelas,
                                iddiklat: tkg.iddiklat,
                                idmatadiklat: tkg.idmatadiklat,
                                idtest: tkg.idtest);

                            hasilData = <HasilB5PAllRole>[];
                            if (json.decode(req.body)['data'] != null) {
                              for (int i = 0;
                              i < json.decode(req.body)['data'].length;
                              i++) {
                                hasilData.add(HasilB5PAllRole.fromJSON(
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
                          //Get.off(()=>B5PHasillFasilitator(tkg: tkg));
                        },
                        child: const AutoSizeText(
                          'Reset',
                          maxLines: 1,
                          style: TextStyle(color: Colors.white),
                        ));
                  })
                : Text(cell.value.toString())),
      );
    }).toList());
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}
