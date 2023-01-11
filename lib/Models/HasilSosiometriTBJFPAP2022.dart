class HasilSosiometriTBJFPAP2022{

  String nippeserta;
  String nipbaru;
  String nmpeg;
  String namakelompok;
  String jmlhpenilaikekatifan;
  String nilaimentahkeaktifan;
  String nilaiakhirkeaktifan;
  String jmlhpenilaietika;
  String nilaimentahetika;
  String nilaiakhiretika;



  HasilSosiometriTBJFPAP2022({
    required this.nippeserta,
    required this.nipbaru,
    required this.nmpeg,
    required this.namakelompok,
    required this.jmlhpenilaikekatifan,
    required this.nilaimentahkeaktifan,
    required this.nilaiakhirkeaktifan,
    required this.jmlhpenilaietika,
    required this.nilaimentahetika,
    required this.nilaiakhiretika,
  });

  factory HasilSosiometriTBJFPAP2022.fromJSON(Map<String, dynamic> json) {
    //print("datanya "+json["nilaiakhirkeaktifan"]);
    //print((json["nilaiakhirkeaktifan"] != "null" &&  json["nilaiakhirkeaktifan"] != null) ? (double.parse(json["nilaiakhirkeaktifan"])).toStringAsFixed(2) : json["nilaiakhirkeaktifan"]);
//    print(json["nilaiakhiretika"]);
  //print(double.tryParse(json["nilaimentahkeaktifan"])!=null);
    return HasilSosiometriTBJFPAP2022(
      nippeserta: json["nip_peserta"],
      nipbaru: json["nip_baru"].toString(),
      nmpeg: json["nm_peg"].toString(),
      namakelompok: json["namagroup"].toString(),
      jmlhpenilaikekatifan: json["jmlhpenilaikekatifan"].toString(),
      nilaimentahkeaktifan: json["nilaimentahkeaktifan"].toString(),
      nilaiakhirkeaktifan: json["nilaiakhirkeaktifan"].toString(),
      jmlhpenilaietika: json["jmlhpenilaietika"].toString(),
      nilaimentahetika: json["nilaimentahetika"].toString(),
      nilaiakhiretika: json["nilaiakhiretika"].toString(),
    );
  }

}

