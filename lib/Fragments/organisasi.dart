import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:safe/Fragments/dialogconfirm.dart';
//import 'package:safe/Models/ExtRes.dart';
import 'package:safe/Pages/LoginSignupPage2.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:safe/Models/OrgAssessment.dart';

class Organisasi extends StatefulWidget {
  Organisasi({Key? key}) : super(key: key);

//  static String jwttoken="";

  @override
  State<Organisasi> createState() => _OrganisasiState();
}

class _OrganisasiState extends State<Organisasi> {
  bool isLoading = false;


  final ApiService apiserv =
  Get.put(ApiService(), tag: 'apiserv1', permanent: true);
//ApiService();
  List<OrgAssessment> resources=<OrgAssessment>[];

  @override
  void initState() {
    // TODO: implement initState
    getExtResource();
    super.initState();

  }

  // void GetJwtDll() async {
  void getExtResource() async {
    setState((){
      isLoading=true;
      resources.clear();
    });

    //jwttoken = (await SecureStorageHelper.getStringValue(
    //    "jwttoken" + authService.getUserId()))!;
    var req = await apiserv.readOrgAsmnt();

    List<OrgAssessment> tList = <OrgAssessment>[];
    //print(json.decode(req.body));
    if (json.decode(req.body)['records'] != null) {
      for (int i = 0; i < json.decode(req.body)['records'].length; i++) {
        tList.add(OrgAssessment.fromJSON(json.decode(req.body)['records'][i]));
      }
    }

    setState(() {
      resources.addAll(tList);
      isLoading=false;
    });

    //return Future.value("Data download successfully");
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Asesmen Organisasi"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        child:(isLoading==false && resources.length>0) ? ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: false,
          itemCount: resources.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: (){
                launch(resources[index].asmntlink);
              },
              child: Card(
                //semanticContainer: true,
                //clipBehavior: Clip.antiAliasWithSaveLayer,
                child:CachedNetworkImage(
                  imageUrl:  resources[index].asmntimg,
                  fit: BoxFit.fill,
                  height: 75,
                ),
                //Image.network(resources[index].imglink,fit: BoxFit.fill, height: 75,),
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                //lessons[index]
              ),
            );
          },
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
                child: AutoSizeText("Maaf tidak ada assessment organisasi saat ini.",
                  maxLines: 2, textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
        )
        ),
      ),
      //bottomNavigationBar: makeBottom,
    );
  }

/*@override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getExtResource(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return  _buildProgressIndicator();
        }
        else{
          if(snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.teal,
                  title: Text("External Resources"),
                ),
                body: Container(
                  child:ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: false,
                    itemCount: resources.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: (){
                          launch(resources[index].reslink);
                        },
                        child: Card(
                          //semanticContainer: true,
                          //clipBehavior: Clip.antiAliasWithSaveLayer,
                          child:CachedNetworkImage(
                            imageUrl:  resources[index].imglink,
                            fit: BoxFit.fill,
                            height: 75,
                          ),
                          //Image.network(resources[index].imglink,fit: BoxFit.fill, height: 75,),
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          //lessons[index]
                        ),
                      );
                    },
                  ),
                ),
              );
            }
        }
        }
    );
  }*/
}
