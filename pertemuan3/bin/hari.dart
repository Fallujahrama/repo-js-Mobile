import 'dart:io';

void main () {
  // print('coba');
  print("Masukan angka hari =");
  String? hari = stdin.readLineSync();
  int nilai = int.tryParse(hari ?? '') ?? 0;
  switch (nilai) {
    case 1 :
      print ("Hari Senin");
      break;
    case 2 :
      print ("Hari Selasa");
      break;
    case 3 :
      print ("Hari Rabu");
      break;
    default :
      print ("Maaf inputan salah");
  }
} 