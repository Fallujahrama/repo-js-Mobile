import 'dart:io';

import 'package:pertemuan4/pertemuan4.dart' as pertemuan4;

void main(List<String> arguments) {
  // // print('Hello world: ${pertemuan4.calculate()}!');

  // // array fix length
  // var fixList = List<int>.filled(4, 13);
  // fixList[0] = 1;
  // fixList[1] = 2;
  // fixList[2] = 3;
  // fixList[3] = 4;
  // // fixList[4] = 5;

  // // print isi list
  // // print(fixList);
  // stdout.writeln(fixList);
  // // stdout.writeln(fixList[1]);

  // var fl = List<String>.filled(3, '');
  // fl[0] = "satu";
  // fl[1] = "dua";
  // fl[2] = "tiga";
  // stdout.writeln(fl);

  // var growList = [3, 4, 5];
  // growList.add(1);
  // growList.add(2);
  // growList.add(3);
  // growList.remove(2);

  // stdout.writeln(growList);

  var setNilai1 = <int>{1, 2, 3, 4};
  var setNilai2 = <int>{1, 1, 2, 2, 5};
  
  // // print(setNilai1);
  // print(setNilai2);
  // // gabungan 2 set
  // print(setNilai1.union(setNilai2));
  // // // irisan 2 set
  // print(setNilai1.intersection(setNilai2));

  // var setNilai3 = <int>{};

  // stdout.write("Jumlah data setNilai3 = ");
  // String? input = stdin.readLineSync();
  // int jumlah1 = int.tryParse(input ?? '') ?? 0;
  // for (int i = 0; i < jumlah1; i++) {
  //   stdout.write("Masukkan nilai ke-${i + 1} = ");
  //   String? nilaiInput = stdin.readLineSync();
  //   int nilai = int.tryParse(nilaiInput ?? '') ?? 0;
  //   setNilai3.add(nilai);
  // }
  // print(setNilai3);

  // var setNilai3 = <String>{};

  // stdout.write("Jumlah data setNilai3 = ");
  // String? input = stdin.readLineSync();
  // int jumlah1 = int.tryParse(input ?? '') ?? 0;
  // for (int i = 0; i < jumlah1; i++) {
  //   stdout.write("Masukkan nilai ke-${i + 1} = ");
  //   String? nilaiInput = stdin.readLineSync();
  //   String nilai = nilaiInput ?? '';
  //   setNilai3.add(nilai);
  // }
  // print(setNilai3);
  // // merubah set ke list
  // var nilaiList = setNilai3.toList();
  // print(nilaiList[2]);
  // print(nilaiList.elementAt(1));

  // map
  var mapBio = {
    'nim': '1501',
    'nama': 'Fallujah',
    'umur': 21,
  };
  print(mapBio);
  print(mapBio['nama']);

  var sudah = {
    'nim' : ['1501', '1502'],
    'nama' : ['Fallujah', 'Ramadi'],
    'umur' : [21, 22],
  };
  print(sudah);
  print(sudah['nama']?[1]);
  print(sudah['nama']![0]);
}
