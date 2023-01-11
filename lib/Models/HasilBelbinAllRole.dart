import 'dart:convert';

class HasilBelbinAllRole{

  String nippeserta;
  String nipbaru;
  String nmpeg;
  String nmgroup;
  String CO;
  String TW;
  String RI;
  String PL;
  String ME;
  String SP;
  String SH;
  String IMP;
  String CF;

  HasilBelbinAllRole({
    required this.nippeserta,
    required this.nipbaru,
    required this.nmpeg,
    required this.nmgroup,
    required this.CO,
    required this.TW,
    required this.RI,
    required this.PL,
    required this.ME,
    required this.SP,
    required this.SH,
    required this.IMP,
    required this.CF,
  });

  factory HasilBelbinAllRole.fromJSON(Map<String, dynamic> json) {
    return HasilBelbinAllRole(
      nippeserta: json["nip_peserta"],
      nipbaru: json["nip_baru"].toString(),
      nmpeg: json["nm_peg"].toString(),
      nmgroup: json["namagroup"].toString(),
      CO: json["CO"].toString(),
      TW: json["TW"].toString(),
      RI: json["RI"].toString(),
      PL: json["PL"].toString(),
      ME: json["ME"].toString(),
      SP: json["SP"].toString(),
      SH: json["SH"].toString(),
      IMP: json["IMP"].toString(),
      CF: json["CF"].toString(),
    );
  }

}
