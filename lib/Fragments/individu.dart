import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/dialogconfirm.dart';
import 'package:safe/Fragments/dialoginfo.dart';
import 'package:safe/Fragments/kelaspeserta/kelaspeserta.dart';
import 'package:safe/Fragments/nonclassactiveasmnt.dart';
import 'package:safe/Pages/LoginSignupPage2.dart';
//import 'package:haloexpert/Fragments/dialoginfo.dart';
//import 'package:haloexpert/Models/Mail.dart';
//import 'package:haloexpert/Models/PushNotification.dart';
//import 'package:haloexpert/Pages/DetilInbox.dart';
import 'package:safe/Utilities/ApiService.dart';
//import 'package:haloexpert/Utilities/FirebaseAuthService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:haloexpert/Fragments/inboxitem.dart';

class Individu extends StatefulWidget {
  @override
  _IndividuState createState() => _IndividuState();
}

class _IndividuState extends State<Individu>  with WidgetsBindingObserver {
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

  //FirebaseAuthService authService = Get.find(tag: 'firebaseauth1');
  ApiService apiService = Get.find(tag: 'apiserv1');
  static String jwttoken = "";
  String nama = "";
  String nip = "";
  String role="";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SecureStorageHelper.getListString("userinfo")
        .then((value) {
      setState(() {
        if (value != null) {
          nama = value[2].toString();
          nip = value[3].toString();
          role=value[6].toString();
        } else {
          //print("username1 $value");
        }
      });
    });


  }


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
      //height: MediaQuery.of(context).size.height * 0.8, //200,
      child: Padding(
        padding: EdgeInsets.all(
            20),
        child: GridView.count(
          shrinkWrap: true,
            //scrollDirection: Axis.vertical,
            // childAspectRatio: MediaQuery.of(context).size.width /
            //     (MediaQuery.of(context).size.height*0.8 / 2),
            // crossAxisCount: 1,
            childAspectRatio:
            (MediaQuery.of(context).size.width<MediaQuery.of(context).size.height) ?
            MediaQuery.of(context).size.width /(MediaQuery.of(context).size.height*0.8 / 2) :
            (MediaQuery.of(context).size.height) / (MediaQuery.of(context).size.width*0.6/3) ,
            crossAxisCount: (MediaQuery.of(context).size.width<MediaQuery.of(context).size.height) ? 1 : 2,
            //main
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KelasPeserta(

                          )
                      ));
                },
                child: Card(
                  color: Colors.white,
                  elevation: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/grid1.jpg"),
                            fit: BoxFit.fill,
                            alignment: Alignment.topCenter),
                        borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                            )), //.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            // SizedBox(
                            //   height: 40,
                            // ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context)
                                    .size
                                    .width,
                                decoration: BoxDecoration(
                                    color:
                                    Colors.teal.withOpacity(0.5),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),)
                                ),
                                child: Text(
                                  "On Class",
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize:
                                      MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.05,
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
              InkWell(
                onTap: () {
                  Get.to(()=>NonClassActiveAsmnt());
                  // Get.defaultDialog(
                  //   content: MyDialogInfo(info: "Maaf tidak assessment individu Non-Class saat ini."),
                  //   titleStyle: TextStyle(fontSize: 0),
                  // );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/grid2.jpg"),
                            fit: BoxFit.fill,
                            alignment: Alignment.topCenter),
                        borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                            )),
                    child: Padding(
                      padding:
                      EdgeInsets.all(0),
                      child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                //height: MediaQuery.of(context)
                                //    .size.height*0.01,
                                decoration: BoxDecoration(
                                    color: Colors.teal
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                        )
                                ),
                                child: Text(
                                  "Non Class",
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize:
                                      MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.05,
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
            ]
        ),
      ),
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
      title: Text("Asesmen Individu"),
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
      //bottomNavigationBar: makeBottom,
    );
  }

}
