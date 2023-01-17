import 'dart:convert';

class AssessmentHistoryTest{

  String tglisi;
  String iddiklat;
  String idmatadiklat;
  String idtest;
  String nip_peserta;
  String NM_PEG;
  String idkelas;
  String namakelas;
  String lokasi;
  String namatest;
//  String nipbaru;

  AssessmentHistoryTest({
    required this.tglisi,
    required this.iddiklat,
    required this.idmatadiklat,
    required this.idtest,
    required this.nip_peserta,
    required this.NM_PEG,
    required this.idkelas,
    required this.namakelas,
    required this.lokasi,
    required this.namatest,
//    required this.nipbaru,
  });


  factory AssessmentHistoryTest.fromJSON(Map<String, dynamic> json) {
    return AssessmentHistoryTest(
      tglisi: json["tglisi"],
      iddiklat: json["id_diklat"],
      idmatadiklat: json["id_matadiklat"],
      idtest: json["idtest"],
      nip_peserta: json["nip_peserta"],
      NM_PEG: json["NM_PEG"],
      idkelas: json["id_kelas"],
      namakelas: json["nama_kelas"],
      lokasi: json["lokasi"]??"",
      namatest: json["namatest"],
//      nipbaru: json["nipbaru_peserta"].toString(),
    );
  }
}
