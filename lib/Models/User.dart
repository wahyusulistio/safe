import 'dart:convert';

class User{

  String username;
  String fullname;
  String niplama;
  String nipbaru;
  String unker;
  String kodeunker;

  User({ required this.username,
    required this.fullname,
    required this.niplama,
    required this.nipbaru,
    required this.unker,
    required this.kodeunker});

  factory User.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return User(
      username: json['Email'],
      fullname: json['Nama'],
      niplama: json['NIPLama'],
      nipbaru: json['NIPBaru'],
      unker: json['NamaUnitKerja'],
      kodeunker: json['KodeUnitKerja'],
    );

  }

  void printAttributes() {
    print("username: ${this.username}\n");
    print("nama: ${this.fullname}\n");
    print("niplama: ${this.niplama}\n");
    print("nipbaru: ${this.nipbaru}\n");
    print("unker: ${this.unker}\n");
    print("kodeunker: ${this.kodeunker}\n");
  }
}
