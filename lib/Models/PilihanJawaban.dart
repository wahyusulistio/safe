class PilihanJawaban {
/*final int id;
  final String name;
  final String imageUrl;*/
  final String idpilihanjawaban;
  final String pilihanjawaban;
  final String tipepilihanjawaban;
  final String idpertanyaan;
  final String statusjawaban;
  final String bobotjawaban;
  final String atribut1;
//final String bidkeahlian;
//final String lvl1;
//final String lvl2;

  PilihanJawaban(
      {required this.idpilihanjawaban,
      required this.pilihanjawaban,
      required this.tipepilihanjawaban,
      required this.idpertanyaan,
      required this.statusjawaban,
      required this.bobotjawaban,
      required this.atribut1});

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return 'IndAssessment{asmntid: $asmntid, '
  //   'inclass: $inclass, '
  //       'ingroup: $ingroup, '
  //       'asmntname: $asmntname}';
  // }

  factory PilihanJawaban.fromJSON(Map<String, dynamic> json) {
    return PilihanJawaban(
      idpilihanjawaban: json["idpilihanjawaban"].toString(),
      pilihanjawaban: json["pilihanjawaban"],
      tipepilihanjawaban: json["tipepilihanjawaban"],
      idpertanyaan: json["idpertanyaan"].toString(),
      statusjawaban: json["statusjawaban"].toString(),
      bobotjawaban: json["bobotjawaban"].toString(),
      atribut1: json["atribut1"],
    );
  }
}
