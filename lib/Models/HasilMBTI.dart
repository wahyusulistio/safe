import 'dart:convert';

class HasilMBTI{

  String dimensi;
  String skor;

  HasilMBTI({ required this.dimensi,
    required this.skor,});

  factory HasilMBTI.fromJSON(Map<String, dynamic> json) {
    return HasilMBTI(
      dimensi: json["atribut1"],
      skor: double.parse(json["totalskormentah"]).toStringAsFixed(2),
    );
  }

}
