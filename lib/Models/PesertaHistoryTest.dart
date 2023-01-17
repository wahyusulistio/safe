import 'dart:convert';

class PesertaHistoryTest{

  String tglisi;
  String iddiklat;
  String idmatadiklat;
  String idtest;
  String idkelas;
  String namakelas;
  String lokasi;
  String namatest;
//  String nipbaru;

  PesertaHistoryTest({
    required this.tglisi,
    required this.iddiklat,
    required this.idmatadiklat,
    required this.idtest,
    required this.idkelas,
    required this.namakelas,
    required this.lokasi,
    required this.namatest,
//    required this.nipbaru,
  });


  factory PesertaHistoryTest.fromJSON(Map<String, dynamic> json) {
    return PesertaHistoryTest(
      tglisi: json["tglisi"],
      iddiklat: json["id_diklat"],
      idmatadiklat: json["id_matadiklat"],
      idtest: json["idtest"],
      idkelas: json["id_kelas"],
      namakelas: json["nama_kelas"],
      lokasi: json["lokasi"]??"",
      namatest: json["namatest"],
//      nipbaru: json["nipbaru_peserta"].toString(),
    );
  }
}
