import 'package:flutter/material.dart';

class ErrPage extends StatelessWidget {
  const ErrPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Terjadi kendala teknis, pastikan Anda telah terhubung dengan jaringan BPK dan jalankan ulang aplikasi. Jika kendala masih terjadi, silahkan hubungi Admin Anda!"),
      )
    );
  }
}
