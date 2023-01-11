import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:safe/Pages/root_page.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:safe/Utilities/navigator_key.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return OverlaySupport(
      child: GetMaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Halo Expert',
        theme: ThemeData(
            fontFamily: "OpenSans",
            //primarySwatch: white,
            primaryColor: Color(0xFF075E54),
        ),
        home: RootPage(),
      ),
    );
  }
}




