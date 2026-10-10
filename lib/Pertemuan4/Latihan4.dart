import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum 4',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const PenggunaPage(),
    );
  }
}

// ==================================================
// BAGIAN C
// ==================================================

class Pengguna {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String city;

  Pengguna({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.city,
  });

  factory Pengguna.fromJson(Map<String, dynamic> json) {
    return Pengguna(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      city: json['address']['city'],
    );
  }
}

Future<List<Pengguna>> ambilPengguna() async {
  final uri = Uri.parse(
    'https://jsonplaceholder.typicode.com/users',
  );

  final response = await http
      .get(uri)
      .timeout(const Duration(seconds: 10));

  if (response.statusCode != 200) {
    throw Exception(
      'Gagal mengambil data: ${response.statusCode}',
    );
  }

  final List<dynamic> jsonData = jsonDecode(response.body);

  return jsonData
      .map((item) => Pengguna.fromJson(item))
      .toList();
}

// ==================================================
// BAGIAN D + LATIHAN 2, 3, DAN 4
// ==================================================

class PenggunaPage extends StatefulWidget {
  const PenggunaPage({super.key});

  @override
  State<PenggunaPage> createState() => _PenggunaPageState();
}

class _PenggunaPageState extends State<PenggunaPage> {
  late Future<List<Pengguna>> _future;

  @override
  void initState() {
    super.initState();
    _future = ambilPengguna();
  }

  void _muatUlang() {
    setState(() {
      _future = ambilPengguna();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<List<Pengguna>>(
          future: _future,
          builder: (context, snapshot) {
            // Latihan Mandiri 4:
            // Menampilkan jumlah pengguna setelah data berhasil dimuat
            if (snapshot.hasData) {
              return Text(
                'Daftar Pengguna (${snapshot.data!.length})',
              );
            }

            return const Text('Daftar Pengguna');
          },
        ),
        actions: [
          IconButton(
            onPressed: _muatUlang,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<Pengguna>>(
        future: _future,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Terjadi kesalahan: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _muatUlang,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data!;

          // Latihan Mandiri 3:
          // Jika data kosong
          if (data.isEmpty) {
            return const Center(
              child: Text('Tidak ada data'),
            );
          }

          // Latihan Mandiri 2:
          // Pull-to-refresh
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _future = ambilPengguna();
              });

              await _future;
            },
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final p = data[index];

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(p.name[0]),
                  ),
                  title: Text(p.name),
                  subtitle: Text(p.email),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPenggunaPage(
                              pengguna: p,
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ==================================================
// BAGIAN E + LATIHAN 1
// ==================================================

class DetailPenggunaPage extends StatelessWidget {
  final Pengguna pengguna;

  const DetailPenggunaPage({
    super.key,
    required this.pengguna,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pengguna.name),
      ),
      body: ListView(
        children: [
          // Latihan Mandiri 1: Username
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(pengguna.username),
          ),

          // Bagian E: Email
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(pengguna.email),
          ),

          // Bagian E: Telepon
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(pengguna.phone),
          ),

          // Bagian E: Website
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(pengguna.website),
          ),

          // Latihan Mandiri 1: Kota
          ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(pengguna.city),
          ),
        ],
      ),
    );
  }
}