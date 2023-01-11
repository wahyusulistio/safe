import 'dart:convert';
import 'dart:developer' as developer;

//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
//import 'package:safe/Fragments/dialoginfo.dart';
// import 'package:safe/Models/PushNotification.dart';
//import 'package:safe/Models/ScheduledNotif.dart';
import 'package:safe/Pages/ErrorPage.dart';
//import 'package:safe/Pages/LoginSignupPage.dart';
import 'package:safe/Pages/LoginSignupPage2.dart';
import 'package:safe/Pages/landing_page.dart';
import 'package:safe/Utilities/ApiService.dart';
//import 'package:safe/Utilities/FirebaseAuthService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
//import 'package:safe/Utilities/notification_service.dart';
import 'package:overlay_support/overlay_support.dart';
//import 'LoginPage.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key, this.onSubmit} ) : super(key: key);
  //final BaseAuth auth;
  //final int activeTab;
  final Function? onSubmit;

  //final int currentTab;
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus { NOT_DETERMINED, LOGGED_OUT, LOGGED_IN, ERROR }

class _RootPageState extends State<RootPage> with TickerProviderStateMixin {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  //FirebaseAuthService authService = //new FirebaseAuthService();
  //Get.put(FirebaseAuthService(), tag: 'firebaseauth1', permanent: true);
  ApiService apiserv =
  Get.put(ApiService(), tag: 'apiserv1', permanent: true);//ApiService();
  Duration get loginTime => Duration(milliseconds: 5000);
  final GlobalKey _loginCardKey = GlobalKey();
  late AnimationController _loadingController;
  static const loadingDuration = Duration(milliseconds: 400);
  late AnimationController _logoController;
  late AnimationController _titleController;
  // Card specific animations
  late Animation<double> _flipAnimation;
  late Animation<double> _cardSizeAnimation;
  late Animation<double> _cardSize2AnimationX;
  late Animation<double> _cardSize2AnimationY;
  late Animation<double> _cardRotationAnimation;
  late Animation<double> _cardOverlayHeightFactorAnimation;
  late Animation<double> _cardOverlaySizeAndOpacityAnimation;
  late AnimationController _routeTransitionController;
  late AnimationController _formLoadingController;
  static const cardSizeScaleEnd = .2;
  static String uid="";

  //FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

  late int currentTab=1;
  //late FirebaseMessaging messaging;

  //PushNotification? _notificationInfo;

  // checkforInitialMessage() async{
  //   RemoteMessage? initialmessage=await FirebaseMessaging.instance.getInitialMessage();
  //   if(initialmessage!=null){
  //     //if(initialmessage.data['time']==null)
  //       //{
  //
  //     PushNotification notification=PushNotification(
  //             title:initialmessage.notification!.title,
  //             body:initialmessage.notification!.body,
  //             dataTitle:initialmessage.data['title'],
  //             dataBody:initialmessage.data['body']);
  //
  //     print("masuk message saat aplikasi ditutup");
  //         //print("time: ${initialmessage.data['time']}");
  //
  //         if(mounted){
  //           setState(() {
  //             _notificationInfo=notification;
  //           });
  //         }
  //       //}
  //     /*else{
  //       NotificationService().scheduleNotificationForBirthday(
  //           ScheduledNotif("Title", DateTime.parse(initialmessage.data['time']),true, "Desc"),
  //           "Notif has an upcoming birthday!");
  //     }*/
  //
  //
  //   }
  //
  // }

  // void registerNotification() async{
  //   await Firebase.initializeApp();
  //   //messaging=FirebaseMessaging.instance;
  //
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     badge: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //
  //   if(settings.authorizationStatus==AuthorizationStatus.authorized){
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //
  //       PushNotification notification=PushNotification(
  //               title:message.notification!.title,
  //               body:message.notification!.body,
  //               dataTitle:message.data['title'],
  //               dataBody:message.data['body']);
  //
  //       //if(FlutterAppBadger.)
  //           if(mounted){
  //             //print("notification:${notification.body}");
  //             //print("time: ${message.data['time']}");
  //             setState(() {
  //               _notificationInfo=notification;
  //             });
  //           }
  //
  //           if(notification!=null){
  //             // showSimpleNotification(
  //             //     Text(notification.title!),
  //             //     leading: Text("HE"),
  //             //     subtitle: Text(notification.body!),
  //             //     background: Colors.cyan.shade700,
  //             //     duration: Duration(seconds: 2)
  //             // );
  //             Get.defaultDialog(
  //               content: MyDialogInfo(info: message.notification!.body.toString()),
  //               //Text("Maaf tidak ada jadwal konsultasi saat ini. Silahkan lakukan reservasi terlebih dahulu."),
  //               titleStyle: TextStyle(fontSize: 0),
  //             );
  //             print("masuk message saat aplikasi dibuka");
  //           }
  //
  //       // if(message.data['title']=="chat baru"){
  //       //   SecureStorageHelper.setStringValue(
  //       //       "adachatbaru", "ya");
  //       //   setState(() {
  //       //
  //       //   });
  //       // }
  //
  //       // }
  //       /*lse{
  //         NotificationService().scheduleNotificationForBirthday(
  //             ScheduledNotif("Title", DateTime.parse(message.data['time']),true, "Desc"),
  //             "Notif has an upcoming birthday!");
  //       }*/
  //     });
  //
  //
  //
  //
  //
  //     // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     //   if(message.data['time']==null){
  //     //     PushNotification notification=PushNotification(
  //     //         title:message.notification!.title,
  //     //         body:message.notification!.body,
  //     //         dataTitle:message.data['title'],
  //     //         dataBody:message.data['body']);
  //     //     print("time: ${message.data['time']}");
  //     //
  //     //     if(mounted){
  //     //       setState(() {
  //     //         _notificationInfo=notification;
  //     //       });
  //     //     }
  //     //   }
  //     //   else
  //     //   {
  //     //     NotificationService().scheduleNotificationForBirthday(
  //     //         ScheduledNotif("Title", DateTime.parse(message.data['time']),true, "Desc"),
  //     //         "Notif has an upcoming birthday!");
  //     //   }
  //     // });
  //   }
  //   else{
  //     print("permission denied");
  //   }
  // }

  /*Future<dynamic> _onDidReceiveLocalNotification(
      int id,
      String? title,
      String? body,
      String? payload) async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
                title: Text(title ?? ''),
                content: Text(body ?? ''),
                actions: [
                  TextButton(
                      child: Text("Ok"),
                      onPressed: () async {
                        NotificationService().handleApplicationWasLaunchedFromNotification(payload ?? '');
                      }
                  )
                ]
            )
    );
  }*/

  @override
  void initState() {

    //registerNotification();

    //checkforInitialMessage();

    super.initState();

    Map<String, dynamic> parseIdToken(String? idToken) {
      if (idToken == null) {
        return {};
      }

      final parts = idToken.split(r'.');
      assert(parts.length == 3);

      return jsonDecode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
    }

    //SecureStorageHelper.getStringValue("uid").then((value2){
      //uid=value2.toString();
      SecureStorageHelper.getListString("userinfo").then((value)
      {
        if (value != null) {
          //rint("masik tidak null value");
          Future.delayed(loginTime).then((_) async {
            try {
              //final AuthorizationTokenResponse? result = await apiserv.login();
              //     await appAuth.authorizeAndExchangeCode(
              //   AuthorizationTokenRequest(
              //     OIDC_CLIENT_ID,
              //     OIDC_REDIRECT_URI,
              //     serviceConfiguration: _serviceConfiguration,
              //     scopes: OIDC_SCOPES,
              //     preferEphemeralSession: false,
              //   ),
              // );
              print("nip:"+value[3].toString());
              TokenResponse? tr=await apiserv.relogin();
              //final idToken = parseIdToken(tr!.idToken);

              //print("token:"+tr!.accessToken!);
              developer.log(tr!.accessToken!, name: 'id.go.bpk.haloexpert');

              if (tr!.refreshToken != null) {
                SecureStorageHelper.setStringValue(
                    "idtoken", tr.idToken.toString());
                //resultreq = result;
                final idToken = parseIdToken(tr.idToken);
                //idToken=parseIdToken(result.idToken);

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

                SecureStorageHelper.setStringValue(
                    "jwttoken", tr.accessToken.toString());

                SecureStorageHelper.setStringValue(
                    "refresh_token", tr.refreshToken.toString());

                //FirebaseMessaging.instance.subscribeToTopic(idToken["info"]["NIP"]);
                //FirebaseMessaging.instance.subscribeToTopic("safe");
                var res=await apiserv.roleUser(idToken["info"]["NIP"]);
                String role="user";
                String foto="";
                if (json.decode(res.body)['data'] != null) {
                  //print("jmlh recent ${json.decode(res.body)['records'].length}");
                  Map<String, dynamic> datarole = json.decode(res.body)['data'];
                  if(datarole["role"]=="admin")
                  {
                    //FirebaseMessaging.instance.subscribeToTopic("Admin");
                    role="admin";
                  }
                  foto=datarole["image"];
                }

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

                SecureStorageHelper.setListString("userinfo" + uid, userinfo);


                // setState(() {
                //   isBusy = false;
                //   isLoggedIn = true;
                //   name = idToken['name'];
                // });
                setState(() {
                  authStatus = AuthStatus.LOGGED_IN;
                });

              }
            } on Exception catch (e) {
              //print("mgkn tidak sambung vpn");
              setState(() {
                authStatus = AuthStatus.LOGGED_OUT;//.ERROR;
              });
            }
            return;
          });
          // setState(() {
          //   authStatus = AuthStatus.LOGGED_IN;
          // });
        } else {
          //print("masik null value");
          setState(() {
            authStatus = AuthStatus.LOGGED_OUT;
          });
        }
      });
    //});

    _loadingController = AnimationController(
      vsync: this,
      duration: loadingDuration,
    )..addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        _logoController.forward();
        _titleController.forward();
      }
      if (status == AnimationStatus.reverse) {
        _logoController.reverse();
        _titleController.reverse();
      }
    });
    _logoController = AnimationController(
      vsync: this,
      duration: loadingDuration,
    );
    _titleController = AnimationController(
      vsync: this,
      duration: loadingDuration,
    );

    _formLoadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1150),
      reverseDuration: const Duration(milliseconds: 300),
    );

    _routeTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    /*FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved ketika aplikasi sedang terbuka");
      //print(event.notification!.body);


    });*/
    /*FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked! open app');

      Get.off(LandingPage(currenttab: 1));
    });*/
  }



  /*void initMessaging() {
    var androiInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInit = IOSInitializationSettings();
    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initSetting);
    var androidDetails =
    AndroidNotificationDetails('1', 'channelName');
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification=message.notification;
      AndroidNotification? android=message.notification?.android;
      if(notification!=null && android!=null){
        flutterLocalNotificationsPlugin.show(
            notification.hashCode, notification.title, notification.body, generalNotificationDetails);
      }});
  }*/

  /*Future _showNotificationWithDefaultSound(String title, String message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_id', 'channel_name',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      '$title',
      '$message',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }*/

  /*notifpermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }*/

  String getUsername(String user){
    if(user.contains("@bpk.go.id"))
      return user;
    else
      return user+"@bpk.go.id";
  }

  /*@override
  void initState() {
    print("masik init");
    SecureStorageHelper.getListString("userinfo").then((value)
    {
      if (value != null) {
        print("masik tidak null value");
        Future.delayed(loginTime).then((_) async {
          try {
            print('$value');
            var req = await apiserv.login(value[0], value[1]);
            if (req.statusCode == 200) {
              print("masik 200");
              //var user = User.fromReqBody(req.body);
              print(req.body);
              Map<String, dynamic> json = jsonDecode(req.body);
              if (json['Validated'] == true) {
              List<String> userinfo = // List<String>.filled(6,0);
                [
              value[0],
              value[1],
              json["Nama"],
              json["NIPLama"],
              json["NIPBaru"],
              json["NamaUnitKerja"],
              json["KodeUnitKerja"]
            ];
            SecureStorageHelper.setListString("userinfo", userinfo);

                // SecureStorageHelper.setStringValue("username", value[0]);
                // SecureStorageHelper.setStringValue("pswrd", value[1]);
                // SecureStorageHelper.setStringValue("nama", json['Nama']);
                // SecureStorageHelper.setStringValue(
                //     "niplama", json['NIPLama']);
                // SecureStorageHelper.setStringValue(
                //     "nipbaru", json['NIPBaru']);
                // SecureStorageHelper.setStringValue(
                //     "unker", json['NamaUnitKerja']);
                print("berhasil login");
                setState(() {
                  authStatus = AuthStatus.LOGGED_IN;
                });
              } else {
                print("user pass salah");
                setState(() {
                  authStatus = AuthStatus.LOGGED_OUT;
                });
              }
            } else {
              print("error teknis");
              setState(() {
                authStatus = AuthStatus.ERROR;
              });
            }
          } on Exception catch (e) {
            print("mgkn tidak sambung vpn");
            setState(() {
              authStatus = AuthStatus.ERROR;
            });
          }
          return;
        });
      } else {
        print("masik null value");
        setState(() {
          authStatus = AuthStatus.LOGGED_OUT;
        });
      }
    });
    super.initState();
  }*/

  Widget progressScreenWidget() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //print("username2 $authStatus");
    //initState();
    //var formController = _formLoadingController;
    //final userValidator =
    //    widget.userValidator ?? FlutterLogin.defaultEmailValidator;
    //final passwordValidator =
    //    widget.passwordValidator ?? FlutterLogin.defaultPasswordValidator;

    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return progressScreenWidget();
        break;
      case AuthStatus.LOGGED_OUT:
        return LoginSignupPage2();
        break;
      case AuthStatus.LOGGED_IN:
        print("current tab saat ini $currentTab");

        //Future.delayed(const Duration(milliseconds: 500), () {
        //});
        return LandingPage(currenttab: currentTab, );
        break;
      case AuthStatus.ERROR:
        return ErrPage();
        break;
      default:
        return progressScreenWidget();
    }

    /*return LoginPage(
            key: _loginCardKey,
            loadingController: _loadingController,
            userValidator: (value) {
              if (!value!.contains('@') || !value.endsWith('.com')) {
                return "Email must contain '@' and end with '.com'";
              }
              return null;
            },
            passwordValidator: (value) {
              if (value!.isEmpty) {
                return 'Password is empty';
              }
              return null;
            },
            onSubmitCompleted: () {
              _forwardChangeRouteAnimation(_loginCardKey).then((_) {
                Get.off(LandingPage(currenttab: 0));
              });
            },
            ); //LoginScreen(); //LoginSignupPage();*/
  }

}
