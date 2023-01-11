class ExtRes {
/*final int id;
  final String name;
  final String imageUrl;*/
  final String resid;
  final String resname;
  final String reslink;
  final String imglink;
//final String bidkeahlian;
//final String lvl1;
//final String lvl2;

  ExtRes(
      {required this.resid,
        required this.resname,
        required this.reslink,
        required this.imglink});

  @override
  String toString() {
    // TODO: implement toString
    return 'Expert{resid: $resid, '
        'resname: $resname, '
        'reslink: $reslink,'
        'imglink: $imglink ';
  }

  factory ExtRes.fromJSON(Map<String, dynamic> json) {
    return ExtRes(
        resid: json["resid"],
        resname: json["resname"],
        reslink: json["reslink"],
        imglink: json["imglink"]
    );
  }


}
