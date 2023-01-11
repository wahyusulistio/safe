class OrgAssessment {
/*final int id;
  final String name;
  final String imageUrl;*/
  final String asmntid;
  final String asmntname;
  final String asmntlink;
  final String asmntimg;
//final String bidkeahlian;
//final String lvl1;
//final String lvl2;

  OrgAssessment(
      {required this.asmntid,
      required this.asmntname,
      required this.asmntlink,
      required this.asmntimg});

  @override
  String toString() {
    // TODO: implement toString
    return 'Expert{resid: $asmntid, '
        'resname: $asmntname, '
        'reslink: $asmntlink,'
        'imglink: $asmntimg ';
  }

  factory OrgAssessment.fromJSON(Map<String, dynamic> json) {
    return OrgAssessment(
      asmntid: json["asmntid"],
      asmntname: json["asmntname"],
      asmntlink: json["asmntlink"],
      asmntimg: json["asmntimg"]
    );
  }


}
