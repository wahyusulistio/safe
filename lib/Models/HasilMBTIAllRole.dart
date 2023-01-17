import 'dart:convert';

class HasilMBTIAllRole{

  String nippeserta;
  String nipbaru;
  String nmpeg;
  String nmgroup;
  String I;
  String E;
  String S;
  String N;
  String T;
  String F;
  String J;
  String P;

  HasilMBTIAllRole({
    required this.nippeserta,
    required this.nipbaru,
    required this.nmpeg,
    required this.nmgroup,
    required this.I,
    required this.E,
    required this.S,
    required this.N,
    required this.T,
    required this.F,
    required this.J,
    required this.P,
  });

  factory HasilMBTIAllRole.fromJSON(Map<String, dynamic> json) {
    return HasilMBTIAllRole(
      nippeserta: json["nip_peserta"],
      nipbaru: json["nip_baru"].toString(),
      nmpeg: json["nm_peg"].toString(),
      nmgroup: json["namagroup"].toString(),
      I: double.parse(json["I"]).toString(),
      E: double.parse(json["E"]).toString(),
      S: double.parse(json["S"]).toString(),
      N: double.parse(json["N"]).toString(),
      T: double.parse(json["T"]).toString(),
      F: double.parse(json["F"]).toString(),
      J: double.parse(json["J"]).toString(),
      P: double.parse(json["P"]).toString(),
    );
  }

}
