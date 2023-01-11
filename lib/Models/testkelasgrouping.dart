class TestKelasGrouping {
/*final int id;
  final String name;
  final String imageUrl;*/
final String idtest;
  final String idkelas;
  final String iddiklat;
  final String idmatadiklat;
  final String idgrouping;
  final String status;
  final String namates;
  final String inclass;
  final String ingroup;
  final String jenistes;
//final String bidkeahlian;
//final String lvl1;
//final String lvl2;

  TestKelasGrouping(
      {required this.idtest,
        required this.idkelas,
        required this.iddiklat,
        required this.idmatadiklat,
        required this.idgrouping,
        required this.status,
        required this.namates,
        required this.inclass,
        required this.ingroup,
        required this.jenistes,
      });


  factory TestKelasGrouping.fromJSON(Map<String, dynamic> json) {
    return TestKelasGrouping(
      idtest: json["idtest"].toString(),
      idkelas: json["id_kelas"],
      iddiklat: json["id_diklat"].toString(),
      idmatadiklat: json["id_matadiklat"].toString(),
      idgrouping: json["id_grouping"].toString(),
      status: json["status"].toString(),
      namates: json["namatest"].toString(),
      inclass: json["inclass"].toString(),
      ingroup: json["ingroup"].toString(),
      jenistes: json["jenistest"].toString(),
    );
  }


}
