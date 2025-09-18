import 'dart:io';
 
 void main () {


  // Daftar nama mahasiswa
  List<String> daftarNama = ['a', 'b', 'c', 'd', 'e'];
  Map<String, int> nilaiMahasiswa = {};

  // Input nilai untuk 5 mahasiswa menggunakan for
  for (int i = 0; i < daftarNama.length; i++) {
    String nama = daftarNama[i];
    stdout.write('Masukkan nilai ujian mahasiswa $nama = ');
    String? input = stdin.readLineSync();
    int? nilai = int.tryParse(input ?? '');
    if (nilai != null) {
      nilaiMahasiswa[nama] = nilai;
    } else {
      print('Input tidak valid, ulangi.');
      i--; // ulangi input untuk mahasiswa yang sama
    }
  }

  // Menentukan kategori kelulusan dan menampilkan hasil
  print('\nDaftar Mahasiswa dan Kategori Kelulusan:');
  for (int i = 0; i < daftarNama.length; i++) {
    String nama = daftarNama[i];
    int nilai = nilaiMahasiswa[nama] ?? 0;
    String kategori;
    if ((nilai >= 80) && (nilai <= 100)) {
      kategori = 'A';
    } else if ((nilai >= 60) && (nilai <= 79)) {
      kategori = 'B';
    } else if ((nilai >= 0) && (nilai <= 59)) {
      kategori = 'C';
    } else {
      kategori = 'Nilai tidak valid';
    }
    print("Mahasiswa $nama dengan kategori : $kategori");
  }
 }