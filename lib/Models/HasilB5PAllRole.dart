import 'dart:convert';

class HasilB5PAllRole{

  String nippeserta;
  String nipbaru;
  String nmpeg;
  String nmgroup;
  String N;
  String E;
  String O;
  String A;
  String C;

  HasilB5PAllRole({
    required this.nippeserta,
    required this.nipbaru,
    required this.nmpeg,
    required this.nmgroup,
    required this.N,
    required this.E,
    required this.O,
    required this.A,
    required this.C,
  });

  factory HasilB5PAllRole.fromJSON(Map<String, dynamic> json) {
    return HasilB5PAllRole(
      nippeserta: json["nip_peserta"],
      nipbaru: json["nip_baru"].toString(),
      nmpeg: json["nm_peg"].toString(),
      nmgroup: json["namagroup"].toString(),
      N: json["N"].toString(),
      E: json["E"].toString(),
      O: json["O"].toString(),
      A: json["A"].toString(),
      C: json["C"].toString(),
    );
  }

}
