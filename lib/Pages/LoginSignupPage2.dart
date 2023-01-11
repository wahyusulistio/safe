import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Pages/landing_page.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class LoginSignupPage2 extends StatefulWidget {
  LoginSignupPage2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _LoginSignupPage2State();

  String? userValidator(value) {
    if (value!.isEmpty || value.length <= 2) {
      return 'Username is too short!';
    }
    return null;
  }
}

class _LoginSignupPage2State extends State<LoginSignupPage2> {
  final _formKey = new GlobalKey<FormState>();
  late AuthorizationTokenResponse resultreq;

  final FlutterAppAuth appAuth = FlutterAppAuth();
  static const OIDC_ISSUER = 'https://sso.bpk.go.id/auth/realms/Main';
  static const OIDC_BASE_URL = OIDC_ISSUER + '/protocol/openid-connect';
  static const OIDC_REDIRECT_URI = 'id.go.bpk.safe://login-callback';

  static const OIDC_CLIENT_ID = 'mobileapp';
  static const OIDC_SCOPES = ['openid', 'offline_access', 'profile'];
  static const OIDC_USERINFO = OIDC_BASE_URL + '/userinfo';
  static const OIDC_LOGOUT_URL = OIDC_BASE_URL + '/logout';

  final AuthorizationServiceConfiguration? _serviceConfiguration =
      const AuthorizationServiceConfiguration(
          authorizationEndpoint: OIDC_BASE_URL + '/auth',
          tokenEndpoint: OIDC_BASE_URL + '/token');

//  late Future<crypto.AsymmetricKeyPair> futureKeyPair;
//  late crypto.AsymmetricKeyPair keyPair;

  ApiService apiserv = ApiService();

  Duration get loginTime => Duration(milliseconds: 2250);

  bool _isObscure = true;
  late TextEditingController _nameController;
  late TextEditingController _passController;
  bool isLoading = false;

  bool isBusy = false;
  bool isLoggedIn = false;
  String? errorMessage;
  String? name;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _passController = TextEditingController();
  }

  // Future<String> _authUser(String field1, String field2) {
  //   return Future.delayed(loginTime).then((_) async {})
  //     try {
  //       var username = field1;
  //       var userpwd = field2;
  //       var req = await apiserv.login(getUsername(username), userpwd, "").timeout(const Duration(seconds: 3));
  //       if (req.statusCode == 200) {
  //         Map<String, dynamic> json = jsonDecode(req.body);
  //         if (json['validated'] == true) {
  //           List<String> userinfo = // List<String>.filled(6,0);
  //               [
  //             getUsername(username),
  //             field2,
  //             json["nama"],
  //             json["usernip"],
  //             json["usernipbaru"],
  //             json["userrole"],
  //             json["email"],
  //             json["unker"],
  //           ];
  //           //SecureStorageHelper.setListString("userinfo", userinfo);
  //
  //           await authService
  //               .signUpWithEmailAndPassword(getUsername(username), "K4l1b4t4#")
  //               .then((result) async {
  //             if (result != null) {
  //               if (result != "exist") {
  //                 print("user baru dibuat");
  //               } else {
  //                 await authService.signInWithEmailAndPassword(
  //                     getUsername(username), "K4l1b4t4#");
  //                 print("user berhasil signin");
  //               }
  //             } else {
  //               print("masalah koneksi firebase");
  //             }
  //           });
  //           //print(credential);
  //           var uid = authService.getUserId();
  //
  //           SecureStorageHelper.setStringValue("uid", uid);
  //           SecureStorageHelper.setListString("userinfo" + uid, userinfo);
  //           print("userinfo$uid");
  //           //SecureStorageHelper.setStringValue(
  //           //    "pwd" + uid, userpwd);
  //           SecureStorageHelper.setStringValue(
  //               "jwttoken" + uid, json["jwttoken"]);
  //           SecureStorageHelper.setStringValue(
  //               "refreshtoken" + uid, json["refreshtoken"]);
  //
  //           print("uid: $uid");
  //           print("jwttoken:" + json["jwttoken"]);
  //           print("usernip:" + json["usernip"]);
  //           String? devfcmtoken = await FirebaseMessaging.instance.getToken();
  //           print("subscribe to: ${json['usernip']}");
  //           //FirebaseMessaging.instance.unsubscribeFromTopic(json["usernip"]);
  //           FirebaseMessaging.instance.subscribeToTopic(json["usernip"]);
  //           FirebaseMessaging.instance.subscribeToTopic("HaloExpert");
  //           if (json["userrole"] == "admin") {
  //             FirebaseMessaging.instance.subscribeToTopic("Admin");
  //           }
  //           print("fcmtoken:" + devfcmtoken!);
  //
  //         } else
  //           return "User tidak ditemukan, pastikan Anda memasukkan user dan password yang sesuai!";
  //       } else {
  //         return "User tidak ditemukan, pastikan Anda memasukkan user dan password yang sesuai!";
  //         //Fluttertoast.showToast(
  //         //    msg:
  //         //        "User tidak ditemukan, pastikan Anda memasukkan user dan password yang sesuai!"); //pushError();
  //       }
  //     } on Exception catch (e) {
  //       print(e.toString());
  //       return "Koneksi gagal, pastikan Anda terhubung dengan jaringan BPK!";
  //     }
  //     return "";
  //   });
  // }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(2.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  /*Future<File> file(String filename) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = p.join(dir.path+"/assets/images/", filename);
    return File(pathName);
  }*/

  /*Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
      getKeyPair() async {
    var helper = RsaKeyHelper();
    return await helper.computeRSAKeyPair(helper.getSecureRandom());
  }*/

  //hanya untuk ujicoba tanpa jaringan BPK
  /*Future<String> _authUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      try {
        var req = true; //await apiserv.login(getUsername(data.name), data.password);
        if (req) {
          //Map<String, dynamic> json = jsonDecode(req.body);
          if (true) {
            List<String> userinfo = // List<String>.filled(6,0);
                [
              "wahyu.sulistio@bpk.go.id",
              "wahyu",
              "240007449",
              "198707162009061001",
              "namaunitkerja"
            ];

            await authService
                .signUpWithEmailAndPassword(getUsername(data.name)+"@bpk.go.id", "K4l1b4t4#")
                .then((result) async {
              if (result != null) {
                if (result != "exist") {
                  print("user baru dibuat");
                } else {
                  await authService.signInWithEmailAndPassword(
                      getUsername(data.name), "K4l1b4t4#");
                  print("user berhasil signin");
                }
              } else {
                print("masalah koneksi firebase");
              }
            });

            await FirebaseChatCore.instance.createUserInFirestore(
              types.User(
                firstName: data.name,
                id: authService.getUserId(),
                //imageUrl: 'https://i.pravatar.cc/300?u=$_email',
                lastName: data.name,
              ),
            );

            //print(credential);
            SecureStorageHelper.setListString(
                "userinfo" + authService.getUserId(), userinfo);
            SecureStorageHelper.setStringValue(
                "pwd" + authService.getUserId(), "1234567890");

            String? devfcmtoken = await FirebaseMessaging.instance.getToken();
            print("token:" + devfcmtoken!);

            /*SecureStorageHelper.getStringValue(
                    "prvkey" + authService.getUserId())
                .then((value) {
              if (value == null) {
                setState(() {
                  futureKeyPair = getKeyPair();
                });
                final encrypter= enc.Encrypter(enc.RSA(publicKey:keyPair.publicKey, privateKey:keyPair.privateKey));
                print("prvkey:");
                print("pubkey:" + keyPair.publicKey.toString());
              }
              else
                print("value prvkey: "+value);
            });*/
          } else
            return "User tidak ditemukan, pastikan Anda memasukkan user dan password yang sesuai!";
        } else {
          Fluttertoast.showToast(
              msg:
                  "Terjadi kendala teknis, silahkan hubungi Admin Anda!"); //pushError();
        }
      } on Exception catch (e) {
        print(e.toString());
        return "Koneksi gagal, pastikan Anda terhubung dengan jaringan BPK!";
      }
      return "";
    });
  }*/

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return "";
    });
  }

  /*@override
  Widget build(BuildContext context) {
    return FlutterLogin(
        key: _formKey,
        title: '''KONSULTASI DENGAN AHLI
        DIMANA SAJA''',
        logo: 'assets/images/icon_app.png', //ecorp-lightblue.png
        hideSignUpButton: true,
        hideForgotPasswordButton: true,
        onLogin: _authUser,
        onSignup: _authUser,
        onSubmitAnimationCompleted: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LandingPage(
                    key: UniqueKey(),
                    currenttab: 0,
                  )));
        },
        onRecoverPassword: _recoverPassword,
        theme: LoginTheme(
          titleStyle: TextStyle(
              color: Colors.greenAccent,
              fontFamily: 'Quicksand',
              letterSpacing: 4,
              fontSize: 12,
              fontWeight: FontWeight.bold
          ),
        )
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      //backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: new AssetImage("assets/images/bg_login_page2.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(alignment: Alignment.center, children: [
            /*SvgPicture.asset(
              'assets/images/bg_login_page2.svg',
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),*/
            // Container(
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: new AssetImage("assets/images/bg_login_page2.png"),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.height * 0.20,
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.5),
                //margin: const EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: new AssetImage(
                      "assets/images/bpk_corpu_logo.png",
                    ),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height / 16),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "v1.0.3",
                  style: TextStyle(
                      fontSize: (MediaQuery.of(context).size.width<MediaQuery.of(context).size.height) ?
                      MediaQuery.of(context).size.width * 0.04 :
                      MediaQuery.of(context).size.height * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                /*child: Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  width: MediaQuery.of(context).size.height * 0.20,
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height/8),
                  //margin: const EdgeInsets.only(top: 10.0),
                  child: Text("v1.0.0"),
                ),*/
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.20),
                Text(
                  "S A f E",
                  style: TextStyle(
                      fontSize: (MediaQuery.of(context).size.width<MediaQuery.of(context).size.height) ?
                      MediaQuery.of(context).size.width * 0.1 :
                      MediaQuery.of(context).size.height * 0.1,
                      fontWeight: FontWeight.bold,
                  color: Colors.white),
                ),
                // Image.asset(
                //   "assets/images/logo_text.png",
                //   width: MediaQuery.of(context).size.width * 0.70,
                // ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.05,
                // ),
                Text(
                  "Self Assessment for Empowerment",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                // Text(
                //   "DARI MANA SAJA, KAPAN SAJA",
                //   style: TextStyle(
                //       fontSize: MediaQuery.of(context).size.width * 0.045,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.white),
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Card(
                    elevation: 8.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.4,
                      padding: EdgeInsets.all(
                          (MediaQuery.of(context).size.width<MediaQuery.of(context).size.height) ?
                          MediaQuery.of(context).size.width * 0.05 :
                          MediaQuery.of(context).size.height * 0.05
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Silahkan login dengan menggunakan akun BPK Anda.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:
                              (MediaQuery.of(context).size.width<MediaQuery.of(context).size.height) ?
                              MediaQuery.of(context).size.width * 0.05:
                              MediaQuery.of(context).size.height * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.010,
                          ),
                          isLoggedIn
                              ? DecoratedBox(
                                  decoration: BoxDecoration(
                                    // gradient: LinearGradient(colors: [
                                    //   Colors.amber.shade400,
                                    //   Colors.amber,
                                    //   Colors.amber.shade600,
                                    //   //add more colors
                                    // ]),
                                    borderRadius: BorderRadius.circular(20),
                                    // boxShadow: <BoxShadow>[
                                    //   BoxShadow(
                                    //       color: Color.fromRGBO(
                                    //           0, 0, 0, 0.57), //shadow for button
                                    //       blurRadius: 5) //blur radius of shadow
                                    // ]
                                  ),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.amber
                                            .shade600, //Colors.transparent,
                                        //onSurface: Colors.amber, //Colors.transparent,
                                        //shadowColor: Colors.amber.shade600, //Colors.transparent,
                                        //make color or elevated button transparent,
                                      ),
                                      onPressed: () {
                                        // setState(() {
                                        //   isLoading = true;
                                        // });
                                        // String outauth = await _authUser(
                                        //     _nameController.text, _passController.text);
                                        // if (outauth == "") {
                                        //   setState(() {
                                        //     isLoading = false;
                                        //   });
                                        //   Get.off(() => LandingPage(
                                        //         currenttab: 0,
                                        //       ));
                                        // } else {
                                        //   setState(() {
                                        //     isLoading = false;
                                        //   });
                                        //   Get.defaultDialog(
                                        //     content: MyDialogInfo(info: outauth),
                                        //     //Text("Maaf tidak ada jadwal konsultasi saat ini. Silahkan lakukan reservasi terlebih dahulu."),
                                        //     titleStyle: TextStyle(fontSize: 0),
                                        //   );
                                        // }

                                        logoutAction();
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        alignment: Alignment.center,
                                        child: isLoading
                                            ? _buildProgressIndicator()
                                            : Text("Logout"),
                                        // child: Padding(
                                        //   padding:EdgeInsets.only(
                                        //     top: 18,
                                        //     bottom: 18,
                                        //   ),
                                        //   child:Text("Login"),
                                        // ),
                                      )))
                              : DecoratedBox(
                                  decoration: BoxDecoration(
                                    // gradient: LinearGradient(colors: [
                                    //   Colors.amber.shade400,
                                    //   Colors.amber,
                                    //   Colors.amber.shade600,
                                    //   //add more colors
                                    // ]),
                                    borderRadius: BorderRadius.circular(20),
                                    // boxShadow: <BoxShadow>[
                                    //   BoxShadow(
                                    //       color: Color.fromRGBO(
                                    //           0, 0, 0, 0.57), //shadow for button
                                    //       blurRadius: 5) //blur radius of shadow
                                    // ]
                                  ),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.amber
                                            .shade600, //Colors.transparent,
                                        //onSurface: Colors.amber, //Colors.transparent,
                                        //shadowColor: Colors.amber.shade600, //Colors.transparent,
                                        //make color or elevated button transparent,
                                      ),
                                      onPressed: () {
                                        // setState(() {
                                        //   isLoading = true;
                                        // });
                                        // String outauth = await _authUser(
                                        //     _nameController.text, _passController.text);
                                        // if (outauth == "") {
                                        //   setState(() {
                                        //     isLoading = false;
                                        //   });
                                        //   Get.off(() => LandingPage(
                                        //         currenttab: 0,
                                        //       ));
                                        // } else {
                                        //   setState(() {
                                        //     isLoading = false;
                                        //   });
                                        //   Get.defaultDialog(
                                        //     content: MyDialogInfo(info: outauth),
                                        //     //Text("Maaf tidak ada jadwal konsultasi saat ini. Silahkan lakukan reservasi terlebih dahulu."),
                                        //     titleStyle: TextStyle(fontSize: 0),
                                        //   );
                                        // }

                                        loginAction();
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        alignment: Alignment.center,
                                        child: isLoading
                                            ? _buildProgressIndicator()
                                            : Text("Login"),
                                        // child: Padding(
                                        //   padding:EdgeInsets.only(
                                        //     top: 18,
                                        //     bottom: 18,
                                        //   ),
                                        //   child:Text("Login"),
                                        // ),
                                      ))),
                          // SizedBox(
                          //   height: MediaQuery.of(context).size.height * 0.010,
                          // ),
                          // Text(name ?? ""),
                        ],
                      ),
                    ))
              ],
            ),

            //)
          ]),
        ),
      ),
    );
  }

  Map<String, dynamic> parseIdToken(String? idToken) {
    if (idToken == null) {
      return {};
    }

    final parts = idToken.split(r'.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      isLoading = true;
      errorMessage = '';
    });

    Future.delayed(loginTime).then((_) async {
      try {
        final AuthorizationTokenResponse? result = await apiserv.login();
        //     await appAuth.authorizeAndExchangeCode(
        //   AuthorizationTokenRequest(
        //     OIDC_CLIENT_ID,
        //     OIDC_REDIRECT_URI,
        //     serviceConfiguration: _serviceConfiguration,
        //     scopes: OIDC_SCOPES,
        //     preferEphemeralSession: false,
        //   ),
        // );

        if (result!.refreshToken != null) {
          SecureStorageHelper.setStringValue(
              "idtoken", result.idToken.toString());
          //resultreq = result;
          final idToken = parseIdToken(result.idToken);
          //idToken=parseIdToken(result.idToken);

          print("token:" + result.accessToken!);
          developer.log(result.accessToken!, name: 'id.go.bpk.safe');
          print(idToken["name"]);

          //print(idToken["info"]["NIP"]);

          //Map<String, dynamic> json = jsonDecode(idToken["info"]);

          // await authService
          //     .signUpWithEmailAndPassword(idToken["info"]["Email"], "K4l1b4t4#")
          //     .then((result) async {
          //   if (result != null) {
          //     if (result != "exist") {
          //       print("user baru dibuat");
          //     } else {
          //       await authService.signInWithEmailAndPassword(
          //           idToken["info"]["Email"], "K4l1b4t4#");
          //       print("user berhasil signin");
          //     }
          //   } else {
          //     print("masalah koneksi firebase");
          //   }
          // });
          //print(credential);
          //var uid = authService.getUserId();

          //print("uid:"+uid);
          SecureStorageHelper.setStringValue(
              "jwttoken", result.accessToken.toString());
          print("access token :" + result.accessToken.toString());

          SecureStorageHelper.setStringValue(
              "refresh_token", result.refreshToken.toString());
          print("refresh token:" + result.refreshToken.toString());

          //FirebaseMessaging.instance.subscribeToTopic(idToken["info"]["NIP"]);
          //FirebaseMessaging.instance.subscribeToTopic("safe");
          var res = await apiserv.roleUser(idToken["info"]["NIP"]);
          String role = "user";
          String foto="";
          if (json.decode(res.body)['data'] != null) {
            //print("jmlh recent ${json.decode(res.body)['records'].length}");
            Map<String, dynamic> datarole = json.decode(res.body)['data'];
            //print("rolenya adalah " + datarole["role"]);
            if (datarole["role"] == "admin") {
              //FirebaseMessaging.instance.subscribeToTopic("Admin");
              role = "admin";
            }
            foto=datarole["image"];
          }

          print("username:" + idToken["preferred_username"]);
          List<String> userinfo = // List<String>.filled(6,0);
              [
            idToken["preferred_username"],
            "",
            idToken["name"],
            idToken["info"]["NIP"],
            idToken["info"]["NIPBaru"],
            foto,
            role,
            idToken["info"]["Email"],
            idToken["info"]["NamaUnitKerja"],
          ];

          //SecureStorageHelper.setStringValue("uid", uid);
          SecureStorageHelper.setListString("userinfo", userinfo);

          setState(() {
            isBusy = false;
            isLoading = false;
            isLoggedIn = true;
            name = idToken['name'];
          });

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LandingPage(
                        key: UniqueKey(),
                        currenttab: 1,
                      )));
        }
      } catch (e, s) {
        print('login error: $e - stack: $s');

        setState(() {
          isBusy = false;
          isLoading = false;
          isLoggedIn = false;
          errorMessage = e.toString();
        });
      }
    });
  }

  Future<bool> endSession(String idToken) async {
    //work like logout method
    try {
      await appAuth.endSession(EndSessionRequest(
          idTokenHint: idToken,
          issuer: OIDC_ISSUER,
          postLogoutRedirectUrl: OIDC_REDIRECT_URI,
          allowInsecureConnections: true));
    } catch (err) {
      print(err);
      return false;
    }
    return true;
  }

  void logoutAction() async {
    //await http
    //    .get(Uri.parse(OIDC_LOGOUT_URL + '?redirect_uri=http://localhost'));
    //await http
    //    .get(Uri.parse(OIDC_LOGOUT_URL + "?redirect_uri=http://localhost"));

    // String idtoken = (await SecureStorageHelper.getStringValue("idtoken"))!;
    // await SecureStorageHelper.removeValue(
    //     "refresh_token"+authService.getUserId()); //secureStorage.delete(key: 'refresh_token');
    // await SecureStorageHelper.removeValue(
    //     "refresh_token"+authService.getUserId()); //secureStorage.delete(key: 'refresh_token');
    //
    // await endSession(idtoken);

    apiserv.logout();

    setState(() {
      isLoggedIn = false;
      isBusy = false;
      name = "";
    });
  }

  String getUsername(String user) {
    if (user.contains("@bpk.go.id"))
      return user;
    else
      return user + "@bpk.go.id";
  }
}
