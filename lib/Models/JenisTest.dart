import 'dart:convert';

class JenisTest{

  String idjenistest;
  String namajenistest;
  String keterangan;
  String minjedawaktu;

  JenisTest({ required this.idjenistest,
    required this.namajenistest,
    required this.keterangan,
    required this.minjedawaktu,
  });

  factory JenisTest.fromJSON(Map<String, dynamic> json) {
    return JenisTest(
      idjenistest: json["idjenistest"],
      namajenistest: json["namajenistest"],
      keterangan: json["keterangan"],
      minjedawaktu: json["minjedawaktu"]??"0",
    );
  }

}
