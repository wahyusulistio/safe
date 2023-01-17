import 'dart:convert';

class Test{

  String idtest;
  String namatest;
  String status;
  String jenistest;
  String inclass;
  String ingroup;
  String logo;
  String nonclass;


  Test({ required this.idtest,
    required this.namatest,
    required this.status,
    required this.jenistest,
    required this.inclass,
    required this.ingroup,
    required this.logo,
    required this.nonclass,
  });

  factory Test.fromJSON(Map<String, dynamic> json) {
    return Test(
      idtest: json["idtest"],
      namatest: json["namatest"],
      status: json["status"],
      jenistest: json["jenistest"],
      inclass: json["inclass"],
      ingroup: json["ingroup"],
      logo: json["logo"]??"",
      nonclass: json["nonclass"]??"0",
    );
  }

}
