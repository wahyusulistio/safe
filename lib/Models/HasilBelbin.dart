import 'dart:convert';

class HasilBelbin{

  String teamrole;
  String skor;

  HasilBelbin({ required this.teamrole,
    required this.skor,});

  factory HasilBelbin.fromJSON(Map<String, dynamic> json) {
    return HasilBelbin(
      teamrole: json["teamrole"],
      skor: json["nilaiakhir"].toString(),
    );
  }

}
