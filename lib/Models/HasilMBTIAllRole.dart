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
      I: json["I"].toString(),
      E: json["E"].toString(),
      S: json["S"].toString(),
      N: json["N"].toString(),
      T: json["T"].toString(),
      F: json["F"].toString(),
      J: json["J"].toString(),
      P: json["P"].toString(),
    );
  }

}
