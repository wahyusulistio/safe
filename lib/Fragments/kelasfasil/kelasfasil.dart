import 'dart:convert';
import 'dart:math';

//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/kelasfasil/dialogtambahkelas.dart';
import 'package:safe/Utilities/Debouncer.dart';
import 'package:safe/Fragments/dialogconfirm.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Fragments/kelasfasil/kelasitem.dart';
import 'package:safe/Models/Kelas.dart';
import 'package:safe/Pages/LoginSignupPage2.dart';
//import 'package:haloexpert/Models/Mail.dart';
//import 'package:haloexpert/Models/PushNotification.dart';
//import 'package:haloexpert/Pages/DetilInbox.dart';
import 'package:safe/Utilities/ApiService.dart';
//import 'package:haloexpert/Utilities/FirebaseAuthService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:haloexpert/Fragments/inboxitem.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:safe/Utilities/navigator_key.dart';

class KelasFasilitator extends StatefulWidget {
  @override
  _KelasFasilitatorState createState() => _KelasFasilitatorState();
}

class _KelasFasilitatorState extends State<KelasFasilitator>
    with WidgetsBindingObserver {
  /*ChatModel destChat = ChatModel(
    name: "Kishor",
    isGroup: false,
    currentMessage: "Hi Kishor",
    time: "13:00",
    icon: "person.svg",
    id: 2,
  );
  ChatModel sourceChat = ChatModel(
    name: "Dev Stack",
    isGroup: false,
    currentMessage: "Hi Everyone",
    time: "4:00",
    icon: "person.svg",
    id: 1,
  );*/

  ApiService apiService = Get.find(tag: 'apiserv1');
  //static String jwttoken = "";
  String nama = "";
  String nip = "";
  String role = "";
  static int page = 0;
  ScrollController _sc = new ScrollController();
  bool isLoading = false;
  late List<Kelas> kelasfasils = <Kelas>[];
  late List<Kelas> _hasilfiltered=<Kelas>[];
  final _debouncer = Debouncer(milliseconds: 500);
  String searchfilter = "";
  int bulan=DateTime.now().month;
  int tahun=DateTime.now().year;
  List months =
  ['Jan', 'Feb', 'Mar', 'Apr', 'May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  String selectedmonth="";
  TextEditingController tecdate=TextEditingController();
  //late FirebaseMessaging messaging;
  //String jwt="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedmonth=months[DateTime.now().month-1].toString()+" "+DateTime.now().year.toString();
    //WidgetsBinding.instance.addObserver(this);
    SecureStorageHelper.getListString("userinfo").then((value) {
      setState(() {
        if (value != null) {
          nama = value[2].toString();
          nip = value[3].toString();
          role = value[6].toString();
          getKelasFasil();
        } else {
          //print("username1 $value");
        }
      });
    });

    //registerNotification();
    //GetJwtDll();
  }

  Future<void> getKelasFasil() async {
    setState((){
      kelasfasils.clear();
      _hasilfiltered.clear();
      isLoading=true;
    });
    var req = await apiService.getKelasFasilitator(nip, bulan, tahun);
    print("nip "+nip);

    List<Kelas> tkelas=<Kelas>[];
    print("kelas fasil "+req.body);
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        //print("data:"+json.decode(req.body)['data'][i]);
        tkelas.add(Kelas.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    setState((){
      kelasfasils.addAll(tkelas);
      _hasilfiltered.addAll(tkelas);
      isLoading=false;
    });
    // kelasfasils.add(Kelas(
    //   namakelas: "Kelas 1 Angkatan I",
    //   namadiklat: "Diklat JFPAP",
    //   namamatadiklat: "SPI",
    //   lokasi: "Badiklat",
    //   tglmulai: "2022/02/01",
    //   tglselesai: "2022/10/31",
    // ));
    // kelasfasils.add(Kelas(
    //   namakelas: "Kelas 2 Angkatan I",
    //   namadiklat: "Diklat JFPAP",
    //   namamatadiklat: "APB",
    //   lokasi: "Badiklat",
    //   tglmulai: "2022/02/01",
    //   tglselesai: "2022/10/31",
    // ));
  }

  // void _getMoreData(int index) async {
  //   if (!isLoading) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //
  //
  //     print("jwttoken $jwttoken");
  //     print("nip user $nip");
  //     var req = await apiService.inboxUser(nip, role,
  //         page.toString());
  //
  //     List<Mail> tList = <Mail>[];
  //     print(json.decode(req.body));
  //     if (json.decode(req.body)['records'] != null) {
  //       for (int i = 0; i < json.decode(req.body)['records'].length; i++) {
  //         tList.add(Mail.fromJSON(json.decode(req.body)['records'][i]));
  //       }
  //     }
  //
  //     //Expert expdummy=Expert(nip: "240003979", nipbaru: "196707112005011007", nmpeg: "Arno Sukarno");
  //     //tList.add(expdummy);
  //
  //     setState(() {
  //       isLoading = false;
  //       if (page == 0) mails.clear();
  //       mails.addAll(tList);
  //       //filteredusers=users;
  //       print("page baru $page");
  //       page++;
  //     });
  //   }
  // }
/*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb61ca7),
      body: TextButton(
        child: Text("Start Chat"),
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IndividualPage(
                    chatModel: destChat,
                    sourchat: sourceChat,
                  )));
        },
      ),
    );
  }*/

  /*_getRequests()async{

  }*/

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      //_getMoreData(0);
      getKelasFasil();
    }
  }

  // Widget getMailIcon(Mail mail){
  //   if(mail.inboxstat=="2")
  //     return
  //       Icon(FontAwesomeIcons.envelopeOpen,
  //                 size:
  //                 MediaQuery.of(context).size.width *
  //                     0.08,color: Colors.white);
  //   else if(mail.inboxstat=="3")
  //     return Icon(FontAwesomeIcons.envelopeOpenText,
  //               size:
  //               MediaQuery.of(context).size.width *
  //                   0.08, color: Colors.white,);
  //   else
  //     return Icon(FontAwesomeIcons.envelope,
  //               size:
  //               MediaQuery.of(context).size.width *
  //                   0.08, color: Colors.white,);
  // }

  void searchPeserta() {
    setState((){
      _hasilfiltered.clear();
    });

    List<Kelas> tlistkelas = kelasfasils
        .where((element) =>
    element.namakelas.toLowerCase().contains(searchfilter.toLowerCase()) ||
        element.namadiklat.toLowerCase().contains(searchfilter.toLowerCase()) ||
        element.namamatadiklat.toLowerCase().contains(searchfilter.toLowerCase())
    )
        .toList();
    setState(() {
      _hasilfiltered=tlistkelas;
      // for(int i=0;i<tlistkelas.length;i++){
      //   print(tlistkelas[i].namamatadiklat);
      //   _hasilfiltered.add(tlistkelas[i]);
      // }
      //kelasfasils=_hasilfiltered;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ListTile makeListTile(Mail mail) => ListTile(
    //       contentPadding:
    //           EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    //       leading: Container(
    //         padding: EdgeInsets.only(right: 12.0),
    //         decoration: new BoxDecoration(
    //             border: new Border(
    //                 right: new BorderSide(width: 1.0, color: Colors.white24))),
    //         child: getMailIcon(mail),
    //         /*Icon(
    //           Icons.autorenew,
    //           color: Colors.white,
    //           size: MediaQuery.of(context).size.width * 0.04,
    //         ),*/
    //       ),
    //       title: Text(
    //         mail.title,
    //         style: TextStyle(
    //             color: Colors.white,
    //             fontWeight: FontWeight.bold,
    //             fontSize: max(MediaQuery.of(context).size.width * 0.03, 15)),
    //       ),
    //       // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
    //
    //       subtitle: Row(
    //         children: <Widget>[
    //           /*Expanded(
    //           flex: 1,
    //           child: Container(
    //             // tag: 'hero',
    //             child: LinearProgressIndicator(
    //                 backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
    //                 value: lesson.indicatorValue,
    //                 valueColor: AlwaysStoppedAnimation(Colors.green)),
    //           )),*/
    //           Expanded(
    //             flex: 4,
    //             child: Padding(
    //                 padding: EdgeInsets.only(left: 0.0),
    //                 child: Text(mail.datereceived,
    //                     style: TextStyle(
    //                         color: Colors.white,
    //                         fontSize: max(
    //                             MediaQuery.of(context).size.width * 0.02,
    //                             10)))),
    //           )
    //         ],
    //       ),
    //       trailing: Icon(Icons.keyboard_arrow_right,
    //           color: Colors.white,
    //           size: MediaQuery.of(context).size.width * 0.04),
    //       onTap: () async {
    //         var val= await Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>DetailPage(mail: mail,namauser: nama,
    //             nipuser: nip, harijam: mail.harijam,)),);
    //             //.then((val){
    //           if(mail.inboxtype=="4" || mail.inboxtype=="5" || mail.inboxtype=="2" || mail.inboxtype=="7" ||
    //               mail.inboxtype=="9" || mail.inboxtype=="10" || mail.inboxtype=="11") {
    //             print("masuk update stat 3");
    //             setState(() {
    //               apiService.updateStatInbox(mail.inboxid,
    //                   "3", "");
    //             });
    //           }
    //           else if(mail.inboxtype=="3" ){
    //             if(val=="4"){
    //               setState(() {
    //                 apiService.updateStatInbox(mail.inboxid,
    //                   "3", "");
    //               });
    //             }
    //             else{
    //               if(mail.inboxstat=="1")
    //               {
    //                 setState(() {
    //                  apiService.updateStatInbox(mail.inboxid,
    //                     "2","");
    //                 });
    //               }
    //             }
    //           }
    //           else{
    //             print("masuk update stat 2");
    //             if(val=="3"){
    //               setState(() {
    //                  apiService.updateStatInbox(mail.inboxid,
    //                     "3", "terima");
    //               });
    //             }
    //             else if(val=="4"){
    //               setState(() {
    //                  apiService.updateStatInbox(mail.inboxid,
    //                     "3", "tolak");
    //               });
    //             }
    //             else{
    //               if(mail.inboxstat=="1")
    //                 {
    //                   setState(() {
    //                      apiService.updateStatInbox(mail.inboxid,
    //                         "2","");
    //                   });
    //                 }
    //             }
    //           }
    //           setState(() {
    //             print("masuk update setstate");
    //             page=0;
    //             _getMoreData(page);
    //           });
    //               //val?_getRequests():null
    //             //});
    //         /*Get.to(()=>DetailPage(mail: mail))!.then((value){
    //           setState(() {
    //
    //           });
    //         });*/
    //         //print("kembali dari detailpage");
    //         /*setState(() {
    //           if(mail.inboxtype!="1") {
    //             print("masuk update stat 3");
    //             apiService.updateStatInbox(mail.inboxid,
    //                 "3",
    //                 jwttoken);
    //           }
    //           else{
    //             print("masuk update stat 2");
    //             apiService.updateStatInbox(mail.inboxid,
    //                 "2",
    //                 jwttoken);
    //           }
    //         });*/
    //
    //         /*Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) => DetailPage(lesson: lesson)));*/
    //       },
    //     );

    // Card makeCard(Mail mail) => Card(
    //       elevation: 8.0,
    //       margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    //       child: Container(
    //         decoration: BoxDecoration(color: mail.inboxstat=="3"?Colors.grey:Colors.teal.shade500),
    //         child: InboxItem(mail: mail,), //makeListTile(mail),
    //       ),
    //     );

    final makeBody = Container(
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    //child: InkWell(
                    //   onTap: () async {
                    //     print("masuk pilih bulan");
                    //     // var selected = await showMonthYearPicker(
                    //     //   context: context,
                    //     //   initialDate: DateTime.now(),
                    //     //   firstDate: DateTime(2019),
                    //     //   lastDate: DateTime(2023),
                    //     // );
                    //     // if(selected!=null)
                    //     //   {
                    //     //     setState((){
                    //     //       selectedmonth= months[selected.month-1]+" "+selected.year;
                    //     //     });
                    //     //   }
                    //   },
                      child: TextField(
                        readOnly: true,
                        textAlign: TextAlign.center,
                        controller: tecdate,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            //prefixIcon: Icon(Icons.search),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.teal),
                            hintText: months[DateTime.now().month-1].toString()+" "+DateTime.now().year.toString(),
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
                                //_hasilfiltered.clear();
                                searchPeserta();
                              });
                            }
                            //perform search here
                          });
                        },
                        onTap: () async {
                              var selected = await showMonthYearPicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2019),
                                lastDate: DateTime(2023),
                              );
                              if(selected!=null)
                                {
                                  tecdate.text=months[selected.month-1].toString()+" "+selected.year.toString();
                                  setState((){
                                    bulan=selected.month;
                                    tahun=selected.year;
                                    getKelasFasil();
                                  });
                                }
                        },
                      ),
                    //)
                ),
                SizedBox(width: 10,),
                Expanded(
                  flex: 5,
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
                          //setState(() {
                            searchPeserta();
                          //});
                        }
                        //perform search here
                      });
                    },
                  ),
                ),
              ],
            )
          ),
          SizedBox(height: 10,),
          _hasilfiltered.length>0 ? Container(
            height: MediaQuery.of(context).size.height*4 / 5-70,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              itemCount: _hasilfiltered.length,
              itemBuilder: (BuildContext context, int index) {
                print("ini "+_hasilfiltered[index].namamatadiklat);
                return KelasItem(kelas: _hasilfiltered[index], key: UniqueKey(),); //makeCard(mails[index]);
              },
              controller: _sc,
            ),
          ) : (isLoading==true ? Center(child: CircularProgressIndicator())  :
          Center(
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
                  child: AutoSizeText("Maaf tidak ada Kelas yang Anda fasilitasi saat ini.",
                    maxLines: 2, textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
          )
          ),
        ],
      )
    );

    /*final makeBottom = Container(
      height: 55.0,
      child: BottomAppBar(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.blur_on, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.hotel, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.account_box, color: Colors.white),
              onPressed: () {},
            )
          ],
        ),
      ),
    );*/
    final topAppBar = AppBar(
      //elevation: 0.1,
      backgroundColor: Colors.teal,
      title: Text("Manage Kelas Fasilitator"),
      // actions: [
      //   IconButton(
      //       icon: FaIcon(
      //         FontAwesomeIcons.signOutAlt,
      //         size: 24,
      //         color: Colors.white,
      //       ),
      //       onPressed: () async {
      //         //copy semua firebase docs ke sql server
      //         //ubah status reservasi jd 5 (selesai)
      //         //tampilkan pilihan rating
      //         var datares = await Get.defaultDialog(
      //           content: MyDialogConfirm(
      //               info: "Signout dari Aplikasi ini?"),
      //           titleStyle: TextStyle(fontSize: 0),
      //         );
      //         Map<String, dynamic> json =
      //         jsonDecode(datares.toString());
      //         if (json["respon"] == "ya") {
      //           apiService.logout();
      //           Get.off(() => LoginSignupPage2());
      //         }
      //       }),
      // ],
      /*actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        )
      ],*/
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: topAppBar,
      body: makeBody,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var output=await showDialog(
              context: navigatorKey.currentContext!,
              builder: (context) {
            print("masuk sini");
            return AlertDialog(
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                child:
                MyDialogTambahKelas(
                  nip: nip,
                ),
              ),
              //Text("Maaf tidak ada jadwal konsultasi saat ini. Silahkan lakukan reservasi terlebih dahulu."),
              //titleStyle: TextStyle(fontSize: 0),
            );
          });
          //Map<String, dynamic> json = jsonDecode(output);
          if(output=="true"){
            setState((){
              getKelasFasil();
            });
          }
        },
        backgroundColor: Colors.white,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 30,
          child: CircleAvatar(
            backgroundColor: Colors.teal,
            radius: 22,
            child: Icon(Icons.add),
          ), //Icon(Icons.add),
        ),
      ),
      //bottomNavigationBar: makeBottom,
    );
  }
}
