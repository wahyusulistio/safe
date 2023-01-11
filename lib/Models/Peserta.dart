import 'dart:convert';

class Peserta{

  String fullname;
  String niplama;
//  String nipbaru;

  Peserta({
    required this.fullname,
    required this.niplama,
//    required this.nipbaru,
  });


  factory Peserta.fromJSON(Map<String, dynamic> json) {
    return Peserta(
      fullname: json["namapeserta"],
      niplama: json["nippeserta"],
//      nipbaru: json["nipbaru_peserta"].toString(),
    );
  }
}
