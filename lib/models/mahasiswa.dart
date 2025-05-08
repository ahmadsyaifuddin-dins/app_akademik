class Mahasiswa {
  final int? id;
  final String nama;
  final String npm;
  final String email;
  final String tempatLahir;
  final String tanggalLahir;
  final String sex;
  final String alamat;
  final String telp;
  final String? photo;

  Mahasiswa({
    this.id,
    required this.nama,
    required this.npm,
    required this.email,
    this.tempatLahir = '',
    this.tanggalLahir = '',
    this.sex = '',
    this.alamat = '',
    this.telp = '',
    this.photo,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      id: json['id'],
      nama: json['nama'] ?? '',
      npm: json['npm'] ?? '',
      email: json['email'] ?? '',
      tempatLahir: json['tempat_lahir'] ?? '',
      tanggalLahir: json['tanggal_lahir'] ?? '',
      sex: json['sex'] ?? '',
      alamat: json['alamat'] ?? '',
      telp: json['telp'] ?? '',
      photo: json['photo'],
    );
  }

  Map<String, String?> toJson() {
    return {
      if (id != null) 'id': id.toString(),
      'nama': nama,
      'npm': npm,
      'email': email,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir,
      'sex': sex,
      'alamat': alamat,
      'telp': telp,
      if (photo != null) 'photo': photo,
    };
  }
}
