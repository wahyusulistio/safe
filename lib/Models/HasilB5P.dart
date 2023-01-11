import 'dart:convert';

class HasilB5P{

  String dimensi;
  String skor;

  HasilB5P({ required this.dimensi,
    required this.skor,});

  factory HasilB5P.fromJSON(Map<String, dynamic> json) {
    return HasilB5P(
      dimensi: json["atribut1"],
      skor: json["totalskormentah"].toString(),
    );
  }

}
