class CustomFunction{

  static String getNamaBulan(int bulan){
    List<String> listbulan=<String>['Januari', 'Februari', 'Maret',
    'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September',
    'Oktober', 'November', 'Desember'];
    return listbulan[bulan];
  }
  static String getBahasaJadwal(String harijam){
    String tgl=harijam.substring(8,10);
    String bulan=getNamaBulan(int.parse(harijam.substring(5,7))-1);
    String tahun=harijam.substring(0,4);
    return "tanggal "+tgl+" "+bulan+" "+tahun+" pukul "+harijam.substring(11,16);
  }
  static String BahasaDateFormat(String harijam){
    String tgl=harijam.substring(8,10);
    String bulan=getNamaBulan(int.parse(harijam.substring(5,7))-1);
    String tahun=harijam.substring(0,4);
    return tgl+" "+bulan+" "+tahun+" pukul "+harijam.substring(11,16);
  }
  static String BahasaTanggal(String tanggal){
    String tgl=tanggal.substring(8,10);
    String bulan=getNamaBulan(int.parse(tanggal.substring(5,7))-1);
    String tahun=tanggal.substring(0,4);
    return tgl+" "+bulan+" "+tahun;
  }

}