import 'dart:io';

import 'package:pertemuan4/pertemuan4.dart' as pertemuan4;

void main(List<String> arguments) {
  // print('Hello world: ${pertemuan4.calculate()}!');

  // array fix length
  var fixList = List<int>.filled(4, 13);
  fixList[0] = 1;
  fixList[1] = 2;
  fixList[2] = 3;
  fixList[3] = 4;
  // fixList[4] = 5;

  // print isi list
  // print(fixList);
  stdout.writeln(fixList);
  // stdout.writeln(fixList[1]);

  var fl = List<String>.filled(3, '');
  fl[0] = "satu";
  fl[1] = "dua";
  fl[2] = "tiga";
  stdout.writeln(fl);

  var growList = [3, 4, 5];
  growList.add(1);
  growList.add(2);
  growList.add(3);
  growList.remove(2);

  stdout.writeln(growList);

}
