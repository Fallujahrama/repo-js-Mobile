import 'dart:io';
 
 void main () {
   stdout.writeln("TUGAS PRAKTIKUM 4");
   stdout.writeln("=======================\n");

   // program menyimpan daftar nama mahasiswa
  //  stdout.writeln("Tugas 1 : Menyimpan daftar nama mahasiswa\n");
   var daftarMahasiswa = <String>["Ani", "Budi", "Cici"];
   stdout.writeln("Daftar Nama Mahasiswa :");
   stdout.writeln(daftarMahasiswa);
   stdout.writeln("Dengan total : ${daftarMahasiswa.length} mahasiswa\n");

  //  // program menghitung union dan intersection dua set
   stdout.writeln("Tugas 2 : Menghitung union dan intersection dua set\n");
   var setA = <String>{};
   var setB = <String>{};
   
   stdout.write("Masukkan jumlah elemen set A: ");
   String? jumlahA = stdin.readLineSync();
   int jumlahA1 = int.tryParse(jumlahA ?? '') ?? 0;
   for (int i = 0; i < jumlahA1; i++) {
    stdout.write("Masukkan nilai ke-${i + 1} = ");

    String? nilaiA = stdin.readLineSync();
    String nilaiA1 = nilaiA ?? '';
    setA.add(nilaiA1);
   }

    stdout.write("\nMasukkan jumlah elemen set B: ");
    String? jumlahB = stdin.readLineSync();
    int jumlahB1 = int.tryParse(jumlahB ?? '') ?? 0;
    for (int i = 0; i < jumlahB1; i++) {
      stdout.write("Masukkan nilai ke-${i + 1} = ");

      String? nilaiB = stdin.readLineSync();
      String nilaiB1 = nilaiB ?? '';
      setB.add(nilaiB1);
    }

    var setUnion = setA.union(setB);
    var setIntersection = setA.intersection(setB);
    
    print("\nSet A : $setA");
    print("Set B : $setB");
    print("\nSet Union : $setUnion");
    print("Set Intersection : $setIntersection");

    // program menyimpan data barang
    stdout.writeln("\nTugas 3 : Menyimpan data barang\n");
    var barang = {
      'kode' : ['B001', 'B002', 'B003'],
      'nama' : ['Pensil', 'Buku', 'Penghapus'],
      'harga' : [2000, 5000, 3000],
    };
    stdout.writeln("Data barang : ");
    stdout.writeln(barang['kode']);
    stdout.writeln(barang['nama']);
    stdout.writeln(barang['harga']);

    // function closure diskon bertingkat
    stdout.writeln("\nTugas 4 : Function closure diskon bertingkat");
    Function buatDiskonBertingkat() {
      double diskon = 0;
      return () {
        diskon += 0.05;
        return diskon;
      };
    }

    var hitungDiskon = buatDiskonBertingkat();
    stdout.writeln("\nDiskon ke-1: ${(hitungDiskon()*100).toStringAsFixed(0)}%");
    stdout.writeln("Diskon ke-2: ${(hitungDiskon()*100).toStringAsFixed(0)}%");
    stdout.writeln("Diskon ke-3: ${(hitungDiskon()*100).toStringAsFixed(0)}%");
 }