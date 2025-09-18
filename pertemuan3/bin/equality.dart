import 'dart:io';

void main () {
  int a = 10;
  int b = 10;
  print(a == b);
  print(identical(a, b)); 

  String a1 = "DaRt";
  String b1 = "DaRt";
  print(a1 == b1);
}