import 'package:flutter_appauth/flutter_appauth.dart';
//import 'package:flutter_web_auth/flutter_web_auth.dart';
// import 'package:openid_client/openid_client.dart';
// import 'package:openid_client/openid_client_io.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:path/path.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_appauth_platform_interface/src/token_response.dart' as resp;

//import 'package:psychotest_app/Model/TrialTest.dart';

class ApiService {
  //FirebaseAuthService authService = Get.find(tag: 'firebaseauth1');
  final FlutterAppAuth appAuth = FlutterAppAuth();
  //final FlutterWebAuth webAuth = FlutterWebAuth();

  static const OIDC_ISSUER = 'https://sso.bpk.go.id/auth/realms/Main';
  static const OIDC_BASE_URL = OIDC_ISSUER + '/protocol/openid-connect';

  static const OIDC_CLIENT_ID = 'selfassessment';
  static const OIDC_SCOPES = ['openid', 'offline_access', 'profile'];
  static const OIDC_REDIRECT_URI = 'id.go.bpk.safe://login-callback';
  static const OIDC_USERINFO = OIDC_BASE_URL + '/userinfo';
  static const OIDC_LOGOUT_URL = OIDC_BASE_URL + '/logout';

  // String scheme1= "http";
  // String host1= "hqbadiklat.bpk.go.id";
  // int port1= int.parse("7070", radix: 10);
  // String scheme1= "http";
  // String host1= "127.0.0.1";
  // int port1= int.parse("8000", radix: 10);
  String scheme1 = "https";
  String host1 = "selfassessment";
  //int port1= int.parse("8000", radix: 10);

  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };

  final AuthorizationServiceConfiguration? _serviceConfiguration =
      const AuthorizationServiceConfiguration(
          authorizationEndpoint: OIDC_BASE_URL + '/auth',
          tokenEndpoint: OIDC_BASE_URL + '/token');

  /***
   * Login dan Logout
   */
  //login dgn API BPK
  Future<AuthorizationTokenResponse?> login() async {
    final AuthorizationTokenResponse? result;
    // if (kIsWeb) {
    //   //create the client
    //   var issuer = await Issuer.discover(Uri.dataFromString(OIDC_BASE_URL + '/auth'));
    //   // create a client
    //   var client = new Client(issuer, OIDC_CLIENT_ID, clientSecret: 'c69cce54-23e1-4f6d-8f3f-ca81bf155797');
    //
    //   // create a function to open a browser with an url
    //   urlLauncher(String url) async {
    //     if (await canLaunch(url)) {
    //       await launch(url, forceWebView: true);
    //     } else {
    //       throw 'Could not launch $url';
    //     }
    //   }
    //
    //   // create an authenticator
    //   var authenticator = new Authenticator(client,
    //       scopes: OIDC_SCOPES, port: 4000, urlLancher: urlLauncher);
    //
    //   // starts the authentication
    //   result= (await authenticator.authorize()) as AuthorizationTokenResponse?;
    //
    //   // close the webview when finished
    //   closeWebView();
    // } else {
    //   // NOT running on the web! You can check for additional platforms here.
    //   result = await appAuth.authorizeAndExchangeCode(
    //     AuthorizationTokenRequest(
    //       OIDC_CLIENT_ID,
    //       clientSecret: 'c69cce54-23e1-4f6d-8f3f-ca81bf155797',
    //       OIDC_REDIRECT_URI,
    //       serviceConfiguration: _serviceConfiguration,
    //       scopes: OIDC_SCOPES,
    //       preferEphemeralSession: false,
    //     ),
    //   );
    // }
    // NOT running on the web! You can check for additional platforms here.
    result = await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        OIDC_CLIENT_ID,
        clientSecret: 'c69cce54-23e1-4f6d-8f3f-ca81bf155797',
        OIDC_REDIRECT_URI,
        serviceConfiguration: _serviceConfiguration,
        scopes: OIDC_SCOPES,
        preferEphemeralSession: false,
      ),
    );

    return result;
  }

  Future<TokenResponse?> relogin() async {
    String reftoken = await getRefreshJWT();
    print("reftoken:" + reftoken);
    final response = await appAuth.token(TokenRequest(
      OIDC_CLIENT_ID,
      clientSecret: 'c69cce54-23e1-4f6d-8f3f-ca81bf155797',
      OIDC_REDIRECT_URI,
      issuer: OIDC_ISSUER,
      refreshToken: reftoken,
    ));

    // final AuthorizationTokenResponse? result =
    // await appAuth.authorizeAndExchangeCode(
    //   AuthorizationTokenRequest(
    //     OIDC_CLIENT_ID,
    //     OIDC_REDIRECT_URI,
    //     serviceConfiguration: _serviceConfiguration,
    //     scopes: OIDC_SCOPES,
    //     preferEphemeralSession: false,
    //   ),
    // );

    return response;
  }

  //logout
  void logout() async {
    // var body = jsonEncode({'id': id, 'token': token});
    //
    // http.Response response = await http.post(Uri.http(super.logoutPath, ''),
    //     headers: super.headers, body: body);
    //
    // return response;
    String idtoken = (await SecureStorageHelper.getStringValue("idtoken"))!;

    // await SecureStorageHelper.removeValue(
    //     "jwttoken"); //secureStorage.delete(key: 'refresh_token');
    // await SecureStorageHelper.removeValue(
    //     "refresh_token"); //secureStorage.delete(key: 'refresh_token');

    await endSession(idtoken);
    await SecureStorageHelper.removeAll();
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
  /***
   * Lainnya
   */

  //memperoleh jwt token
  Future<String> getJWT() async {
    String jwt = (await SecureStorageHelper.getStringValue("jwttoken"))!;
    //print("usernip 3333 $usernip");
    return jwt;
  }

  //memperoleh jwt token
  Future<String> getRefreshJWT() async {
    String? refjwt =
        (await SecureStorageHelper.getStringValue("refresh_token"));
    //print("usernip 3333 $usernip");
    return refjwt.toString();
  }

  //set jwt token baru hasil refresh
  void setJWT(String token) {
    SecureStorageHelper.setStringValue("jwttoken", token);
  }

  void cekValidasiJwt(String jwttoken) async {
    var storedRefreshToken = await getRefreshJWT();
    try {
      final response = await appAuth.token(TokenRequest(
        OIDC_CLIENT_ID,
        clientSecret: 'c69cce54-23e1-4f6d-8f3f-ca81bf155797',
        OIDC_REDIRECT_URI,
        issuer: OIDC_ISSUER,
        refreshToken: storedRefreshToken,
      ));

      SecureStorageHelper.setStringValue(
          "jwttoken", response!.accessToken.toString());

      SecureStorageHelper.setStringValue(
          "refresh_token", response.refreshToken.toString());

      //secureStorage.write(key: 'refresh_token', value: response?.refreshToken);

    } catch (e, s) {
      print('error on refresh token: $e - stack: $s');
      //logoutAction();
    }
  }

  // //send notifikasi
  // void sendNotif(
  //     String receiverid, String title, String bodynotif, String content) async {
  //   var body = jsonEncode({
  //     "to": "/topics/" + receiverid,
  //     "notification": {
  //       "sound": "default",
  //       "body": bodynotif,
  //       "title": title,
  //       "priority": "high"
  //     },
  //     "data": {
  //       "content": content,
  //     }
  //   });
  //
  //   var uri =
  //       new Uri(scheme: "https", host: "fcm.googleapis.com", path: "/fcm/send");
  //   var head = headers;
  //   head['Authorization'] = 'key=' + dotenv.env['FCMKEY']!;
  //   //http.Response response =
  //   //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
  //   await http.post(uri, headers: head, body: body);
  // }

  Future<http.Response> readOrgAsmnt() async {
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host: "selfassessment.bpk.go.id",
        //port: int.parse("8081", radix: 10),
        path: "/api/orgassessment");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head);

    if (json.decode(response.body)['message']=="Token expired") {
      cekValidasiJwt(jwttoken);
      return readOrgAsmnt();
    } else {
      return response;
    }
  }

  /*****
   * API terkait fasilitator
   */

  //mendapatkan daftar kelas fasilitator
  Future<http.Response> getKelasFasilitator(String nip, int bulan, int tahun) async {
    var body = jsonEncode({
      'user': nip,
      'bulan':bulan,
      'tahun': tahun
    });

    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/kelasfasilitator2");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);
    print("masuk get kelas "+response.body);

    if (json.decode(response.body)['message']=="Token expired") {
      print("masuk token expired");
      cekValidasiJwt(jwttoken);
      return getKelasFasilitator(nip, bulan, tahun);
    } else {
      return response;
    }
  }

  Future<http.Response> addKelasFasilitator(String nip, String idkelas,
      String iddiklat, String nipfasilitator, String rolefasilitator) async {
    var body = jsonEncode({
      'user': nip,
      'idkelas':idkelas,
      'iddiklat':iddiklat,
      'nipfasilitator': nipfasilitator,
      'rolefasilitator': rolefasilitator
    });

    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/tambahkelasfasilitator");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);
    print("masuk get kelas "+response.body);

    if (json.decode(response.body)['message']=="Token expired") {
      print("masuk token expired");
      cekValidasiJwt(jwttoken);
      return addKelasFasilitator(nip, idkelas, iddiklat, nipfasilitator, rolefasilitator);
    } else {
      return response;
    }
  }

  /*****
   * API terkait user role
   */

  //mendapatkan role user
  Future<http.Response> roleUser(String nip) async {
    var body = jsonEncode({
      'user': nip,
      'role':'user'
    });
    print("body $body");

    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/readuser");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return roleUser(nip);
    } else {
      return response;
    }
  }

  /*****
   * API terkait peserta
   */

  //mendapatkan daftar kelas fasilitator
  Future<http.Response> getKelasPeserta(String nip) async {
    var body = jsonEncode({
      'user': nip,
    });
    print("body $body");

    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/kelaspeserta");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getKelasPeserta(nip);
    } else {
      return response;
    }
  }

  Future<http.Response> addKelasPeserta(String nip, String idkelas, String nippeserta) async {
    var body = jsonEncode({
      'user': nip,
      'idkelas': idkelas,
      'nippeserta': nippeserta
    });
    print("body $body");

    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/tambahkelaspeserta");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return addKelasPeserta(nip, idkelas, nippeserta);
    } else {
      return response;
    }
  }

  /*****
   * API terkait Kelas
   */

  Future<http.Response> getKelasPenyelenggaraan(String user, String kodekelas) async {
    var body = jsonEncode({
      'user': user,
      'classcode': kodekelas,
    });
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/readkelaspenyelenggaraan");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getKelasPenyelenggaraan(user, kodekelas);
    } else {
      return response;
    }
  }

  Future<http.Response> addKelasPenyelenggaraan(String user, String namakelas,
      String tglmulai, String tglselesai, String lokasi) async {
    var body = jsonEncode({
      'user': user,
      'namakelas': namakelas,
      'tglmulai':tglmulai,
      'tglselesai':tglselesai,
      'lokasi':lokasi
    });
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/kelaspenyelenggaraan");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return addKelasPenyelenggaraan(user, namakelas, tglmulai, tglselesai, lokasi);
    } else {
      return response;
    }
  }

  //mendapatkan semua daftar grouping di kelas
  Future<http.Response> getGroupingKelas(String user, String idkelas) async {
    var body = jsonEncode({
      'user': user,
      'idkelas': idkelas,
    });
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/kelompokkelas");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getGroupingKelas(user, idkelas);
    } else {
      return response;
    }
  }

  //menambah daftar grouping di kelas
  Future<http.Response> addGroupingKelas(
      {required String user,
      required String idkelas,
      required String namagrouping,
      required String idmatadiklat,
      required String iddiklat}) async {
    var body = jsonEncode({
      'user': user,
      'idkelas': idkelas,
      'namagrouping': namagrouping,
      'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
      'iddiklat': iddiklat
    });
    print("body $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/tambahgroupingkelas");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return addGroupingKelas(
          user: user,
          idkelas: idkelas,
          namagrouping: namagrouping,
          idmatadiklat: idmatadiklat,
          iddiklat: iddiklat);
    } else {
      return response;
    }
  }

  //mendapatkan daftar kelompok di satu kelas di grouping trtentu
  Future<http.Response> getKelompokGrouping({
    required String user,
    required String idgrouping,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idgrouping': idgrouping,
    });
    print("body $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/groupingrouping");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getKelompokGrouping(
        user: user,
        idgrouping: idgrouping,
      );
    } else {
      return response;
    }
  }

  //mendapatkan daftar kelompok di satu kelas di grouping trtentu
  Future<http.Response> getKelompokPesertaGrouping({
    required String user,
    required String idgrouping,
    required String keywordpeserta,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idgrouping': idgrouping,
      'keywordpeserta': keywordpeserta,
    });
    print("body $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/pesertaingrouping");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getKelompokPesertaGrouping(
        user: user,
        idgrouping: idgrouping,
        keywordpeserta: keywordpeserta,
      );
    } else {
      return response;
    }
  }

  //mendapatkan peserta dalam kelompok
  Future<http.Response> getPesertaInGroup({
    required String user,
    required String idgroup,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idgroup': idgroup,
    });
    print("body peserta in grup $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/kelompokpesertakelas");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getPesertaInGroup(
        user: user,
        idgroup: idgroup,
      );
    } else {
      return response;
    }
  }

  //mendapatkan peserta dalam kelompok
  Future<http.Response> getPesertaLainDiGroup({
    required String user,
    required String idgrouping,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idgrouping': idgrouping,
    });
    print("body peserta in grup $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/pesertalainingroup");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) { //response.body.contains("Token expired")
      cekValidasiJwt(jwttoken);
      return getPesertaLainDiGroup(
        user: user,
        idgrouping: idgrouping,
      );
    } else {
      return response;
    }
  }

  //mendapatkan peserta dalam kelas
  Future<http.Response> getPesertaInKelas({
    required String user,
    required String idkelas,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idkelas': idkelas,
    });
    print("body $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/pesertakelas");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getPesertaInKelas(
        user: user,
        idkelas: idkelas,
      );
    } else {
      return response;
    }
  }

  //mendapatkan peserta dalam kelas
  Future<http.Response> getPesertaInKelasNonGroup({
    required String user,
    required String idkelas,
    required String idgrouping,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idkelas': idkelas,
      'idgrouping': idgrouping,
    });
    print("body $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/pesertakelasnongroup");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getPesertaInKelasNonGroup(
        user: user,
        idkelas: idkelas,
        idgrouping: idgrouping,
      );
    } else {
      return response;
    }
  }

  //menambahkan peserta dalam kelompok
  Future<http.Response> addPesertaInGroup({
    required String user,
    required String idgruppeserta,
    required String nippeserta,
    required String namapeserta,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idgruppeserta': idgruppeserta,
      'nippeserta': nippeserta,
      'namapeserta': namapeserta,
    });
    print("tambahpeserta in grup body $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/tambahpesertaingroup");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return addPesertaInGroup(
          user: user,
          idgruppeserta: idgruppeserta,
          nippeserta: nippeserta,
          namapeserta: namapeserta);
    } else {
      return response;
    }
  }

  //menambahkan peserta dalam kelompok
  Future<http.Response> deletePesertaDariGroup({
    required String user,
    required String idgruppeserta,
    required String nippeserta,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idgruppeserta': idgruppeserta,
      'idpeserta': nippeserta,
    });
    print("hapus satu peserta dari grup body $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/hapuspesertadarigroup");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return deletePesertaDariGroup(user: user, idgruppeserta: idgruppeserta, nippeserta: nippeserta);
    } else {
      return response;
    }
  }

  //menambahkan peserta dalam kelompok
  Future<http.Response> deletePesertaInGroup({
    required String user,
    required String idgruppeserta,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idgruppeserta': idgruppeserta,
    });
    print("hapus peserta in grup body $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/hapuspesertaingroup");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return deletePesertaInGroup(user: user, idgruppeserta: idgruppeserta);
    } else {
      return response;
    }
  }

  //menambahkan peserta dalam kelompok
  Future<http.Response> deleteGroup({
    required String user,
    required String idgruppeserta,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idgruppeserta': idgruppeserta,
    });
    print("hapus peserta in grup body $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/hapusgroup");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return deleteGroup(user: user, idgruppeserta: idgruppeserta);
    } else {
      return response;
    }
  }

  //menambahkan peserta dalam kelompok
  Future<http.Response> deleteGrouping({
    required String user,
    required String idgrouping,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idgrouping': idgrouping,
    });
    //print("hapus peserta in grup body $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/hapusgrouping");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return deleteGrouping(user: user, idgrouping: idgrouping);
    } else {
      return response;
    }
  }

  //menambahkan kelompok dalam grouping
  Future<http.Response> addGrupInGrouping({
    required String user,
    required String idgrouping,
    required String namagrup,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idgrouping': idgrouping,
      'namagrup': namagrup,
    });
    print("body tambah kelompok in grouping $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/tambahklmpkingrouping");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return addGrupInGrouping(
          user: user, idgrouping: idgrouping, namagrup: namagrup);
    } else {
      return response;
    }
  }

/*****
 * API terkait assessment
 */

//mendapatkan daftar assessment available in class
  Future<http.Response> getAvailAssessmentNonClass({
    required String user,
  }) async {
    var body = jsonEncode({
      'user': user,
    });
    print("body get avail asmnt nonclass $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/nonclassactiveasmnt");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getAvailAssessmentNonClass(user: user);
    } else {
      return response;
    }
  }

  Future<http.Response> getAvailAssessmentInClass({
    required String user,
  }) async {
    var body = jsonEncode({
      'user': user,
    });
    print("body get avail asmnt9 $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/assessmentavailinclass");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getAvailAssessmentInClass(user: user);
    } else {
      return response;
    }
  }

  //mendapatkan daftar assessment available in class
  Future<http.Response> getAssessmentAddedInClass({
    required String user,
    required String idkelas,
    required String iddiklat,
    required String idmatadiklat,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idkelas': idkelas,
      'iddiklat': iddiklat,
      'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
    });
    print("body get avail asmnt10 $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/assessmentaddedinclass");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getAssessmentAddedInClass(
        user: user,
        idkelas: idkelas,
        iddiklat: iddiklat,
        idmatadiklat: idmatadiklat,
      );
    } else {
      return response;
    }
  }

  //mendapatkan daftar assessment available in class
  Future<http.Response> addAssessmentInClass({
    required String user,
    required String idtest,
    required String idkelas,
    required String iddiklat,
    required String idmatadiklat,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
      'idkelas': idkelas,
      'iddiklat': iddiklat,
      'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
    });
    print("body get avail asmnt1 $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/addassessmentinclass");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return addAssessmentInClass(
        user: user,
        idtest: idtest,
        idkelas: idkelas,
        iddiklat: iddiklat,
        idmatadiklat: idmatadiklat,
      );
    } else {
      return response;
    }
  }

  //hapus daftar assessment available in class
  Future<http.Response> deleteAssessmentInClass({
    required String user,
    required String idtest,
    required String idkelas,
    required String iddiklat,
    required String idmatadiklat,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
      'idkelas': idkelas,
      'iddiklat': iddiklat,
    'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
    });
    print("body get avail asmnt2 $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/deleteassessmentinclass");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return deleteAssessmentInClass(
        user: user,
        idtest: idtest,
        idkelas: idkelas,
        iddiklat: iddiklat,
        idmatadiklat: idmatadiklat,
      );
    } else {
      return response;
    }
  }

  //hapus daftar assessment available in class
  Future<http.Response> updateAssessmentInClass({
    required String user,
    required String idtest,
    required String idkelas,
    required String iddiklat,
    required String idmatadiklat,
    String? idgrouping,
    required String status,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
      'idkelas': idkelas,
      'iddiklat': iddiklat,
    'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
      'idgrouping': idgrouping != null ? idgrouping : "null",
      'status': status,
    });
    print("body get avail asmnt3 $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/updateassessmentinclass");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return updateAssessmentInClass(
        user: user,
        idtest: idtest,
        idkelas: idkelas,
        iddiklat: iddiklat,
        idmatadiklat: idmatadiklat,
        idgrouping: idgrouping != null ? idgrouping : "null",
        status: status,
      );
    } else {
      return response;
    }
  }

  //mendapatkan daftar assessment available in class
  Future<http.Response> getAssessmentAktifInClass({
    required String user,
    required String idkelas,
    required String iddiklat,
    required String idmatadiklat,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idkelas': idkelas,
      'iddiklat': iddiklat,
    'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
    });
    print("body get avail asmnt4 $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/assessmentaktifinclass");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getAssessmentAktifInClass(
          user: user,
          idkelas: idkelas,
          iddiklat: iddiklat,
          idmatadiklat: idmatadiklat);
    } else {
      return response;
    }
  }

  //mendapatkan daftar assessment available in class
  Future<http.Response> getSoalTest({
    required String user,
    required String idtest,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
    });
    print("body get avail asmnt5 $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/soaltest");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getSoalTest(
        user: user,
        idtest: idtest,
      );
    } else {
      return response;
    }
  }

  Future<http.Response> getSoalTestPerGrup({
    required String user,
    required String idtest,
    required String idgrup,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
      'idgrup': idgrup,
    });
    print("body get avail asmnt6 $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "http",
        host:
        "127.0.0.1", //"selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        port: int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/soaltestpergrup");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getSoalTestPerGrup(
        user: user,
        idtest: idtest,
        idgrup: idgrup
      );
    } else {
      return response;
    }
  }

  //mendapatkan daftar pilihan jawaban soal
  Future<http.Response> getPilihanJawaban({
    required String user,
    required String idpertanyaan,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idpertanyaan': idpertanyaan,
    });
    print("body get avail asmnt7 $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/pilihanjawaban");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getPilihanJawaban(
        user: user,
        idpertanyaan: idpertanyaan,
      );
    } else {
      return response;
    }
  }

  Future<http.Response> getPilihanJawaban2({
    required String user,
    required String idjenistest,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idjenistest': idjenistest,
    });
    print("body get avail asmnt7 $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/pilihanjawaban2");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getPilihanJawaban2(
        user: user,
        idjenistest: idjenistest,
      );
    } else {
      return response;
    }
  }

  //menyimpan respon peserta
  Future<http.Response> addResponPeserta({
    required String user,
    required String idtest,
    required String idkelas,
    required String idpertanyaan,
    required String respon,
    String? nilai,
    String? bobot,
    required String iddiklat,
    required String idmatadiklat,
    required String atribut1,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
      'idkelas': idkelas,
      'idpertanyaan': idpertanyaan,
      'respon': respon,
      'nilai': nilai != null ? nilai : "null",
      'bobot': bobot != null ? bobot : "null",
      'iddiklat': iddiklat,
    'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
      'atribut1': atribut1,
    });
    print("body get avail asmnt8 $body");
    developer.log(body, name: 'payload assessment');
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/simpanresponpeserta");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return addResponPeserta(
        user: user,
        idtest: idtest,
        idkelas: idkelas,
        idpertanyaan: idpertanyaan,
        respon: respon,
        nilai: nilai != null ? nilai : "null",
        bobot: bobot != null ? bobot : "null",
        iddiklat: iddiklat,
        idmatadiklat: idmatadiklat,
        atribut1: atribut1,
      );
    } else {
      return response;
    }
  }

  /*
  *
  * Belbin Test
  *
  * */

  //menyimpan respon peserta
  Future<http.Response> cekBelbin({
    required String user,
    required String idtest,
    required String idkelas,
    required String iddiklat,
    required String idmatadiklat,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
      'idkelas': idkelas,
      'iddiklat': iddiklat,
    'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
    });
    print("body cek avail belbin skor $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/cekbelbin");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return cekBelbin(
        user: user,
        idtest: idtest,
        idkelas: idkelas,
        iddiklat: iddiklat,
        idmatadiklat: idmatadiklat,
      );
    } else {
      return response;
    }
  }

  //menyimpan respon peserta
  Future<http.Response> getSkorBelbin({
    required String user,
    required String idtest,
    required String idkelas,
    required String iddiklat,
    required String idmatadiklat,
    required String nippeserta,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
      'idkelas': idkelas,
      'iddiklat': iddiklat,
    'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
      'peserta': nippeserta,
    });
    print("body get avail belbin skor $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/skorbelbin");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getSkorBelbin(
        user: user,
        idtest: idtest,
        idkelas: idkelas,
        iddiklat: iddiklat,
        idmatadiklat: idmatadiklat,
        nippeserta: nippeserta,
      );
    } else {
      return response;
    }
  }

  //menyimpan respon peserta
  Future<http.Response> getSkorBelbinAllPeserta({
    required String user,
    required String idtest,
    required String idkelas,
    required String iddiklat,
    required String idmatadiklat,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
      'idkelas': idkelas,
      'iddiklat': iddiklat,
    'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
    });
    print("body get avail belbin skor all $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/skorbelbinallpeserta");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getSkorBelbinAllPeserta(
        user: user,
        idtest: idtest,
        idkelas: idkelas,
        iddiklat: iddiklat,
        idmatadiklat: idmatadiklat,
      );
    } else {
      return response;
    }
  }

  /*
  *
  * Belbin Test
  *
  * */

  /*
  *
  * MBTI Test
  *
  * */

  Future<http.Response> cekStatusTest({
    required String user,
    required String idtest,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
    });
    print("body cek avail test skor $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/cekstatustest");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return cekStatusTest(
        user: user,
        idtest: idtest,
      );
    } else {
      return response;
    }
  }

  //menyimpan respon peserta
  // Future<http.Response> cekMBTI({
  //   required String user,
  //   required String idtest,
  //   required String idkelas,
  //   required String iddiklat,
  //   required String idmatadiklat,
  // }) async {
  //   var body = jsonEncode({
  //     'user': user,
  //     'idtest': idtest,
  //     'idkelas': idkelas,
  //     'iddiklat': iddiklat,
  //     'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
  //   });
  //   print("body cek avail mbti skor $body");
  //   String jwttoken = await getJWT();
  //
  //   var uri = new Uri(
  //       scheme: "https",
  //       host:
  //       "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
  //       //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
  //       path: "/api/cekmbti");
  //   var head = headers;
  //   head['Authorization'] = 'Bearer ' + jwttoken;
  //   //head['Content-Type']='application/json';
  //   http.Response response =
  //   //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
  //   await http.post(uri, headers: head, body: body);
  //
  //   if (response.body.contains("Token expired")) {
  //     cekValidasiJwt(jwttoken);
  //     return cekMBTI(
  //       user: user,
  //       idtest: idtest,
  //       idkelas: idkelas,
  //       iddiklat: iddiklat,
  //       idmatadiklat: idmatadiklat,
  //     );
  //   } else {
  //     return response;
  //   }
  // }

  //menyimpan respon peserta
  Future<http.Response> getSkorMBTI({
    required String user,
    required String idtest,
    required String idkelas,
    required String iddiklat,
    required String idmatadiklat,
    required String nippeserta,
    required String tglpengisian,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
      'idkelas': idkelas,
      'iddiklat': iddiklat,
      'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
      'peserta': nippeserta,
      'tglpengisian': tglpengisian
    });
    print("body get avail mbti skor $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/skormbti");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getSkorMBTI(
        user: user,
        idtest: idtest,
        idkelas: idkelas,
        iddiklat: iddiklat,
        idmatadiklat: idmatadiklat,
        nippeserta: nippeserta,
        tglpengisian: tglpengisian
      );
    } else {
      return response;
    }
  }

  //menyimpan respon peserta
  Future<http.Response> getSkorMBTI2({
    required String user,
    required String idtest,
    required String idkelas,
    required String iddiklat,
    required String idmatadiklat,
    required String nippeserta,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
      'idkelas': idkelas,
      'iddiklat': iddiklat,
      'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
      'peserta': nippeserta,
    });
    print("body get avail mbti skor $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/skormbti2");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getSkorMBTI2(
          user: user,
          idtest: idtest,
          idkelas: idkelas,
          iddiklat: iddiklat,
          idmatadiklat: idmatadiklat,
          nippeserta: nippeserta,
      );
    } else {
      return response;
    }
  }

  //menyimpan respon peserta
  Future<http.Response> getSkorMBTIAllPeserta({
    required String user,
    required String idtest,
    required String idkelas,
    required String iddiklat,
    required String idmatadiklat,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
      'idkelas': idkelas,
      'iddiklat': iddiklat,
      'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
    });
    print("body get avail mbti skor all $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/skormbtiallpeserta");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getSkorMBTIAllPeserta(
        user: user,
        idtest: idtest,
        idkelas: idkelas,
        iddiklat: iddiklat,
        idmatadiklat: idmatadiklat,
      );
    } else {
      return response;
    }
  }
  /*
  *
  * MBTI Test
  *
  * */

  /*
  *
  * B5P Test
  *
  * */

  Future<http.Response> getSkorB5P({
    required String user,
    required String idtest,
    required String idkelas,
    required String iddiklat,
    required String idmatadiklat,
    required String nippeserta,
    required String tglpengisian,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
      'idkelas': idkelas,
      'iddiklat': iddiklat,
      'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
      'peserta': nippeserta,
      'tglpengisian': tglpengisian
    });
    print("body get avail b5p skor $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/skorb5p");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getSkorB5P(
          user: user,
          idtest: idtest,
          idkelas: idkelas,
          iddiklat: iddiklat,
          idmatadiklat: idmatadiklat,
          nippeserta: nippeserta,
          tglpengisian: tglpengisian
      );
    } else {
      return response;
    }
  }

  //menyimpan respon peserta
  Future<http.Response> getSkorB5P2({
    required String user,
    required String idtest,
    required String idkelas,
    required String iddiklat,
    required String idmatadiklat,
    required String nippeserta,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
      'idkelas': idkelas,
      'iddiklat': iddiklat,
      'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
      'peserta': nippeserta,
    });
    print("body get avail b5p skor $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/skorb5p2");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getSkorB5P2(
        user: user,
        idtest: idtest,
        idkelas: idkelas,
        iddiklat: iddiklat,
        idmatadiklat: idmatadiklat,
        nippeserta: nippeserta,
      );
    } else {
      return response;
    }
  }

  //menyimpan respon peserta
  Future<http.Response> getSkorB5PAllPeserta({
    required String user,
    required String idtest,
    required String idkelas,
    required String iddiklat,
    required String idmatadiklat,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
      'idkelas': idkelas,
      'iddiklat': iddiklat,
      'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
    });
    print("body get avail b5p skor all $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/skorb5pallpeserta");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getSkorB5PAllPeserta(
        user: user,
        idtest: idtest,
        idkelas: idkelas,
        iddiklat: iddiklat,
        idmatadiklat: idmatadiklat,
      );
    } else {
      return response;
    }
  }

  /*
  *
  * B5P Test
  *
  * */


  //menyimpan respon peserta
  Future<http.Response> getSkorSosiometriFasilitator({
    required String user,
    required String idtest,
    required String idkelas,
    required String iddiklat,
    required String idmatadiklat,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
      'idkelas': idkelas,
      'iddiklat': iddiklat,
    'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
    });
    print("body get avail sosiometri skor $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/skorsosiometrifasilitator");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return getSkorSosiometriFasilitator(
        user: user,
        idtest: idtest,
        idkelas: idkelas,
        iddiklat: iddiklat,
        idmatadiklat: idmatadiklat,
      );
    } else {
      return response;
    }
  }

  //menyimpan respon peserta
  Future<http.Response> cekSosiometriPeserta({
    required String user,
    required String idtest,
    required String idkelas,
    required String iddiklat,
    required String idmatadiklat,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
      'idkelas': idkelas,
      'iddiklat': iddiklat,
    'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
    });
    print("body get avail sosiometri peserta skor $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
            "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/ceksosiometripeserta");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
        //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
        await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return cekSosiometriPeserta(
        user: user,
        idtest: idtest,
        idkelas: idkelas,
        iddiklat: iddiklat,
        idmatadiklat: idmatadiklat,
      );
    } else {
      return response;
    }
  }

  //menyimpan respon peserta
  Future<http.Response> resetResponPeserta({
    required String user,
    required String idtest,
    required String idkelas,
    required String iddiklat,
    required String idmatadiklat,
    required String nippeserta,
  }) async {
    var body = jsonEncode({
      'user': user,
      'idtest': idtest,
      'idkelas': idkelas,
      'iddiklat': iddiklat,
    'idmatadiklat': idmatadiklat=="null"?"":idmatadiklat,
      'nippeserta': nippeserta,
    });
    print("body reset sosiometri peserta $body");
    String jwttoken = await getJWT();

    var uri = new Uri(
        scheme: "https",
        host:
        "selfassessment.bpk.go.id", // "127.0.0.1", //"hqbadiklat.bpk.go.id",
        //port: port1, // int.parse("8000", radix: 10), // int.parse("7070", radix: 10),
        path: "/api/resetresponpeserta");
    var head = headers;
    head['Authorization'] = 'Bearer ' + jwttoken;
    //head['Content-Type']='application/json';
    http.Response response =
    //await http.post(Uri.https(super.authPath,'/api/userad/ValidatePostWithKeys'), headers: super.headers, body: body);
    await http.post(uri, headers: head, body: body);

    if (response.body.contains("Token expired")) {
      cekValidasiJwt(jwttoken);
      return resetResponPeserta(
        user: user,
        idtest: idtest,
        idkelas: idkelas,
        iddiklat: iddiklat,
        idmatadiklat: idmatadiklat,
        nippeserta: nippeserta,
      );
    } else {
      return response;
    }
  }
}
