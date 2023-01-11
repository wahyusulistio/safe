import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/akun.dart';
import 'package:safe/Fragments/kelasfasil/kelasfasil.dart';
import 'package:safe/Fragments/organisasi.dart';
import 'package:safe/Fragments/individu.dart';
import 'package:safe/Pages/root_page.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key, required this.currenttab}) : super(key: key);

  final int currenttab;

  @override
  State<StatefulWidget> createState() => new _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  //FirebaseAuthService authService = Get.find(tag: 'firebaseauth1');
  ApiService apiService = Get.find(tag: 'apiserv1');
  //String _username = "";
  static String usernip = "";
  String appBarTitle = "Halo Expert";
  int _selectedIndex = 1;
  final List<Widget> screens = [
    Organisasi(),
    Individu(),
    KelasFasilitator(),
    Akun()
  ];
  String recentreservasi = "";
  static String jwt = "";
//  late FirebaseMessaging messaging;

  @override
  void initState() {
    SecureStorageHelper.getListString("userinfo")
        .then((value) {
      setState(() {
        if (value != null) {
          //_username = value[5].toString();
          usernip = value[3].toString();
          //print("username3 $_username");
        } else {
          //print("username1 $value");
        }
      });
    });

    GetJWT();

    /*setState(() {
      _selectedIndex=widget.currenttab;

      print("masuk sini ganti tab");
    });*/
    _selectedIndex = widget.currenttab;
    //print("current tab $_selectedIndex");
    /*if(widget.currenttab!=0){
      _onItemTapped(_selectedIndex);
    }*/
    super.initState();
  }

  void GetJWT() async {
    jwt = (await SecureStorageHelper.getStringValue(
        "jwttoken"))!;
    //print("usernip 3333 $usernip");

  }

  _signOut() async {
    try {
      await SecureStorageHelper.removeAll();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => RootPage()));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: Colors.white,
      ),*/
      body: Center(
        child: screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Colors.teal,
          child: Container(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    icon: Icon(FontAwesomeIcons.building,
                        color:
                            _selectedIndex == 0 ? Colors.white : Colors.black),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                        appBarTitle = "Organization Assessment";
                      });
                    }),
                // IconButton(
                //     icon: Icon(FontAwesomeIcons.externalLinkAlt,
                //         color:
                //             _selectedIndex == 1 ? Colors.white : Colors.black),
                //     onPressed: () {
                //       setState(() {
                //         _selectedIndex = 1;
                //         appBarTitle = "External Resources";
                //       });
                //     }),
                //SizedBox(width: 10), // The dummy child
                // IconButton(
                //     icon: Icon(FontAwesomeIcons.mailBulk,
                //         color:
                //             _selectedIndex == 2 ? Colors.white : Colors.black),
                //     onPressed: () {
                //       setState(() {
                //         _selectedIndex = 2;
                //         appBarTitle = "Inbox";
                //       });
                //     }),
                IconButton(
                    icon: Icon(FontAwesomeIcons.user,
                        color:
                            _selectedIndex == 1 ? Colors.white : Colors.black),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                        appBarTitle = "Individu Assessment";
                      });
                    }),
                IconButton(
                    icon: Icon(FontAwesomeIcons.chalkboardTeacher,
                        color:
                        _selectedIndex == 2 ? Colors.white : Colors.black),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 2;
                        appBarTitle = "Fasilitator";
                      });
                    }),
                IconButton(
                    icon: Icon(FontAwesomeIcons.userCircle,
                        color:
                        _selectedIndex == 3 ? Colors.white : Colors.black),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 3;
                        appBarTitle = "Akun";
                      });
                    }),
              ],
            ),
          )),
      /*bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        backgroundColor: Colors.teal,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        iconSize: MediaQuery.of(context).size.width/15,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Beranda",
              backgroundColor: Colors.teal
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.externalLinkAlt),
            label: "External",
              backgroundColor: Colors.teal
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Inbox',
              backgroundColor: Colors.teal
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Akun',
              backgroundColor: Colors.teal
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),*/
      // floatingActionButton: new FloatingActionButton(
      //   onPressed: () async {
      //   },
      //   tooltip: 'Konsultasi Sekarang',
      //   child: //new Icon(Icons.chat),
      //       CircleAvatar(
      //     backgroundColor: Colors.white,
      //     radius: 30,
      //     child: CircleAvatar(
      //       backgroundColor: Colors.teal,
      //       radius: 22,
      //       child: Icon(Icons.chat),
      //     ), //Icon(Icons.add),
      //   ),
      //   elevation: 4.0,
      //   //hape: CircleBorder(),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /*void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(_selectedIndex==0)
      {
          appBarTitle="Halo Expert";
      }
      else if(_selectedIndex==1){
        appBarTitle="External Resources";
      }
      else if(_selectedIndex==2){
          appBarTitle="Inbox";
      }
      else if(_selectedIndex==3){
          appBarTitle="Akun";
      }
    });
  }*/
}
