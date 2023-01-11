class Group {
/*final int id;
  final String name;
  final String imageUrl;*/
  final String groupid;
  final String groupname;
  final String groupingid;
//final String bidkeahlian;
//final String lvl1;
//final String lvl2;

  Group(
      {required this.groupid,
      required this.groupname,
        required this.groupingid,
      });

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return 'IndAssessment{asmntid: $asmntid, '
  //   'inclass: $inclass, '
  //       'ingroup: $ingroup, '
  //       'asmntname: $asmntname}';
  // }

  factory Group.fromJSON(Map<String, dynamic> json) {
    return Group(
      groupid: json["id_gruppeserta"].toString(),
      groupname: json["namagroup"],
      groupingid: json["id_grouping"].toString(),
    );
  }


}
