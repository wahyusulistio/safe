class IndAssessment {
/*final int id;
  final String name;
  final String imageUrl;*/
  final String asmntid;
  final String asmntname;
  final String inclass;
  final String ingroup;
  final String jenistest;
//final String bidkeahlian;
//final String lvl1;
//final String lvl2;

  IndAssessment(
      {required this.asmntid,
      required this.asmntname,
        required this.inclass,
        required this.ingroup,
        required this.jenistest,
      });

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return 'IndAssessment{asmntid: $asmntid, '
  //   'inclass: $inclass, '
  //       'ingroup: $ingroup, '
  //       'asmntname: $asmntname}';
  // }

  factory IndAssessment.fromJSON(Map<String, dynamic> json) {
    return IndAssessment(
      asmntid: json["idtest"].toString(),
      asmntname: json["namatest"],
      inclass: json["inclass"].toString(),
      ingroup: json["ingroup"].toString(),
      jenistest: json["jenistest"].toString(),
    );
  }


}
