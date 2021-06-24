List<Barang> barangFromJSON(Iterable json, bool isCust) => json.map((barang) => Barang.fromJson(barang, isCust)).toList();
List<GroupBarangDetail> groupBarangFromJSON(Iterable json) => json.map((group) => GroupBarangDetail.fromJson(group)).toList();
// List<Barang> barangFromJSON(Iterable json, Map<String, Tipe> listTipe) =>
//   json.map((barang) => Barang.fromJson(barang, listTipe)).toList();

class GroupBarangDetail{
  final GroupBarang tipe;
  final List<Barang> listBarang = List<Barang>();

  GroupBarangDetail(this.tipe);

  void addBarang(Barang barang) {
    listBarang.add(barang);
  }

  void addListBarang(List<Barang> barang) {
    listBarang.addAll(barang);
  }

  factory GroupBarangDetail.fromJson(Map<String, dynamic> json) {
    return GroupBarangDetail(GroupBarang(json["tipe"], ""));
  }
}

class GroupBarang {
  final String nama;
  final String image;
  
  GroupBarang(this.nama, this.image);
}

class Barang {
  String tableid;
  String sjid;
  String tipe;
  String ukuran;
  String kode;
  String image;
  double seri;
  double jumlah;
  double jumorder;
  double harga;
  int status;
  // final List<Tipe> listTipe = List<Tipe>();

  Barang({this.tableid, this.sjid, this.tipe, this.ukuran, this.kode, this.image, this.seri, this.jumlah, this.jumorder, this.harga, this.status});

  factory Barang.fromJson(Map<String, dynamic> json, bool isCust) {
    return Barang(tableid:json["tableid"],
      sjid: json["sjid"],
      tipe: json["tipe"],
      ukuran: json["ukuran"],
      kode: json["kode"],
      image: json["image"],
      seri: (json["seri"] == null) ?  0 : double.parse(json["seri"].toString()),
      jumlah: (isCust) ? double.parse(json["jumnota"].toString()) : double.parse(json["jumlah"].toString()),
      jumorder: (isCust) ? double.parse(json["pesan"].toString()) : double.parse(json["jumorder"].toString()),
      harga: double.parse(json["harga"].toString()),
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "tableid": tableid,
      "sjid": sjid,
      "tipe": tipe,
      "ukuran": ukuran,
      "kode": kode,
      "image": image,
      "jumlah": jumlah,
      "jumorder": jumorder,
      "harga": harga,
      "status": status,
    };
  }
}

//class BarangCustomer extends Barang {
//  double pesan;
//  double jumNota;
//
//  BarangCustomer({tableid, sjid, tipe, ukuran, kode, image, seri, jumlah, jumorder, harga, status, this.pesan, this.jumNota})
//      : super(tableid: tableid, sjid: sjid, tipe: tipe, ukuran:ukuran, kode: kode, image:image, seri: seri, jumlah: jumlah, jumorder: jumorder, harga: harga, status: status);
//
//  factory BarangCustomer.fromJson() {
//
//  }
//
//  @override
//  Map<String, dynamic> toJson() {
//    Map<String, dynamic> json = super.toJson();
//    json.putIfAbsent("pesan", () => pesan);
//    json.putIfAbsent("jumnota", () => jumNota);
//    return json;
//  }
//}