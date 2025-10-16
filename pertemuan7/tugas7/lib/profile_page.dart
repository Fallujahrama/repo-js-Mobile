import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Daftar mata kuliah semester 5
    final List<Map<String, dynamic>> mataKuliah = [
      {'kode': 'SIB101', 'nama': 'Pemrograman Mobile', 'sks': 4},
      {'kode': 'SIB102', 'nama': 'Kecerdasan Bisnis', 'sks': 4},
      {'kode': 'SIB103', 'nama': 'Metodologi Penelitian', 'sks': 3},
      {'kode': 'SIB104', 'nama': 'Audit Sistem Informasi', 'sks': 3},
      {'kode': 'SIB105', 'nama': 'PMPL', 'sks': 4},
      {'kode': 'SIB106', 'nama': 'Pengelolaan Sumber Daya', 'sks': 4},
      {'kode': 'SIB107', 'nama': 'Manajemen Rantai Pasok', 'sks': 3},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header profil
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.blue.shade50,
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: const AssetImage('assets/images/avatar.png'),
                  ),
                  const SizedBox(width: 20),
                  // Info profil
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Fallujah Ramadi C',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'NIM: 2341760005',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Prodi Sistem Informasi Bisnis',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Semester 5',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Detail info
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detail Informasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow('Email', 'fallujahrc@gmail.com'),
                  _buildInfoRow('No. HP', '+62 857-1804-0815'),
                  _buildInfoRow('Alamat', 'Jl. Semanggi Barat No. 20'),
                  _buildInfoRow('IPK', '3.85'),
                ],
              ),
            ),
            
            // Mata kuliah semester 5
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mata Kuliah Semester 5',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: mataKuliah.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              mataKuliah[index]['sks'].toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(mataKuliah[index]['nama']),
                          subtitle: Text('Kode: ${mataKuliah[index]['kode']}'),
                          trailing: const Icon(Icons.book, color: Colors.blue),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Tombol ke galeri
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/gallery');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Lihat Galeri'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper untuk membuat row info
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}