class Grouping {
/*final int id;
  final String name;
  final String imageUrl;*/
  final String groupingid;
  final String groupingname;
  final String kelasid;
  final String matadiklatid;
  final String diklatid;
//final String bidkeahlian;
//final String lvl1;
//final String lvl2;

  Grouping(
      {required this.groupingid,
      required this.groupingname,
        required this.kelasid,
        required this.matadiklatid,
        required this.diklatid,
      });

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return 'IndAssessment{asmntid: $asmntid, '
  //   'inclass: $inclass, '
  //       'ingroup: $ingroup, '
  //       'asmntname: $asmntname}';
  // }

  factory Grouping.fromJSON(Map<String, dynamic> json) {
    print("masuk fromjson grouping");
    return Grouping(
      groupingid: json["id_grouping"].toString(),
      groupingname: json["nama_grouping"],
      kelasid: json["id_kelas"],
      matadiklatid: json["id_matadiklat"].toString(),
      diklatid: json["id_diklat"].toString(),
    );
  }


}
