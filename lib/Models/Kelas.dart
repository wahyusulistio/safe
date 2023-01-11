class Kelas {
  /*final int id;
  final String name;
  final String imageUrl;*/
  final String id_kelas;
  final String namakelas;
  final String id_diklat;
  final String namadiklat;
  final String id_matadiklat;
  final String namamatadiklat;
  final String lokasi;
  final String tglmulai;
  final String tglselesai;
  //final String bidkeahlian;
  //final String lvl1;
  //final String lvl2;

  Kelas({
    required this.id_kelas,
    required this.namakelas,
    required this.id_diklat,
    required this.namadiklat,
    required this.id_matadiklat,
    required this.namamatadiklat,
    required this.lokasi,
    required this.tglmulai,
    required this.tglselesai,
  });

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return 'Kelas{namakelas: $namakelas, '
  //       'namadiklat: $namadiklat, '
  //       'namamatadiklat: $namamatadiklat, '
  //       'lokasi: $lokasi, '
  //       'tglmulai: $tglmulai,'
  //       'tglselesai: $tglselesai,}';
  //}

  factory Kelas.fromJSON(Map<String, dynamic> json) {
    return Kelas(
      id_kelas: json["id_kelas"],
      namakelas: json["nama_kelas"],
      id_diklat: json["id_diklat"].toString(),
      namadiklat: json["nama_diklat"]??"",
      id_matadiklat: json["id_matadiklat"].toString()??"",
      namamatadiklat: json["nama_matadiklat"]??"",
      lokasi: json["lokasi"],
      tglmulai: json["tgl_mulai"],
      tglselesai: json["tgl_selesai"],
    );
  }
}
