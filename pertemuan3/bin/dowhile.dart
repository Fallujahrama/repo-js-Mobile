import 'dart:io';

void main () {
  print("Masukan nilai awal =");
  String? input = stdin.readLineSync();
  int i = int.tryParse(input ?? '') ?? 0;
  while (i <= 10) {
    print("Iterasi ke-$i");
    i++;
  }

  int a = int.tryParse(input ?? '') ?? 0;
  do {
    print("Perulangan ke $a");
    a++;
  } while (a <= 10);
}