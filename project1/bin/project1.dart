import 'dart:io';

import 'package:project1/project1.dart' as project1;

const String nama = 'Fallujah';
void main(List<String> arguments) {
  // print('Hello world: ${project1.calculate()}!');
  // satu line comment
  /*
    multi line comment
    banyak line komen
  */

  // constanta dan final
  final nama2 = 'Ramadi';
  print("Nama saya $nama $nama2");

  // variabel
  int umur = 21;
  double tinggi = 165.5;
  bool jenis_kelamin = true; // true = laki-laki, false = perempuan
  String alamat = 'Jalan Semanggi Barat no 20';
  stdout.writeln("Umur saya $umur tahun");
  stdout.writeln("Tinggi saya $tinggi meter");
  stdout.writeln("Jenis kelamin saya ${jenis_kelamin ? 'Laki-laki' : 'Perempuan'}");
  // if (jenis_kelamin==true) {
  //   stdout.writeln("Jenis kelamin saya Laki-laki");
  // } else {
  //   stdout.writeln("Jenis kelamin saya Perempuan");
  // }
  stdout.writeln("Alamat saya $alamat");
  num nilai = 100; // bisa diisi int atau double
  stdout.writeln("Nilai saya $nilai");
  dynamic bebas = true; // bisa diisi semua tipe data
  stdout.writeln("Nilai dari dynamic adalah $bebas");

  // String angka1 = "15";
  // int angka2 = int.parse(angka1);
  // int angka3 = bebas;

  // list
  List<String> hobby = ['Tidur', 'Masak', 'Ngoding'];
  hobby.add('Main Game');
  stdout.writeln("Hobby saya: $hobby");

  // map
  Map<String, String> biodata = {
    "nama": "Gizela",
    "alamat": "Malang",
    "jenis_kelamin": "Perempuan",
  };
  biodata['pekerjaan'] = "Mahasiswi";
  biodata.addAll({"hobi": "Siwil"});

  stdout.writeln("Biodata : $biodata");
  stdout.writeln("Nama yang ada di data ${biodata['nama']}");

  try {
  // Code that might throw an exception
  int result = 10 ~/ 0; // This will throw an IntegerDivisionByZeroException
  } on IntegerDivisionByZeroException {
  // Handles the specific IntegerDivisionByZeroException
  print("Cannot divide by zero!");
  } catch (e) {
  // Handles any other type of exception and provides the exception object
  print("An unexpected error occurred: $e");
  } finally {
  // Code that always executes, regardless of whether an exception occurred 
  print("Execution complete.");
  }
}
