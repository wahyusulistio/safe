class Pertanyaan {
/*final int id;
  final String name;
  final String imageUrl;*/
  final String idgrup;
  final String namagrup;
  final String idpertanyaan;
  final String pertanyaan;
  final String jenispertanyaan;
//final String bidkeahlian;
//final String lvl1;
//final String lvl2;

  Pertanyaan(
      {required this.idgrup,
      required this.namagrup,
      required this.idpertanyaan,
      required this.pertanyaan,
      required this.jenispertanyaan});

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return 'IndAssessment{asmntid: $asmntid, '
  //   'inclass: $inclass, '
  //       'ingroup: $ingroup, '
  //       'asmntname: $asmntname}';
  // }

  factory Pertanyaan.fromJSON(Map<String, dynamic> json) {
    return Pertanyaan(
      idgrup: json["idgrup"].toString(),
      namagrup: json["gruppertanyaan"],
      idpertanyaan: json["idpertanyaan"].toString(),
      pertanyaan: json["pertanyaan"],
      jenispertanyaan: json["jenispertanyaan"],
    );
  }
}
