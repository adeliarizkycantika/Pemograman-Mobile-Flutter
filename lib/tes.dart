import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// ==================================================
// APLIKASI UTAMA
// ==================================================

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
      home: const MenuPage(),
    );
  }
}

// ==================================================
// MENU PERTEMUAN 4
// ==================================================

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum 4'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Pertemuan 4',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Future, FutureBuilder, dan API',
            style: TextStyle(
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 24),

          // ==========================================
          // BAGIAN A
          // ==========================================

          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Text('A'),
              ),
              title: const Text(
                'Bagian A - FutureBuilder',
              ),
              subtitle: const Text(
                'Future tanpa internet',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const SalamPage(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // ==========================================
          // BAGIAN C - D - E
          // ==========================================

          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Text('C-E'),
              ),
              title: const Text(
                'Bagian C-E - Daftar Pengguna',
              ),
              subtitle: const Text(
                'API, daftar pengguna, dan detail',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const PenggunaPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================
// BAGIAN A
// MENGENAL FUTURE DAN FUTUREBUILDER
// ==================================================

Future<String> ambilSalam() async {
  await Future.delayed(
    const Duration(seconds: 2),
  );

  return 'Halo dari masa depan!';
}

class SalamPage extends StatefulWidget {
  const SalamPage({super.key});

  @override
  State<SalamPage> createState() => _SalamPageState();
}

class _SalamPageState extends State<SalamPage> {
  late Future<String> _future;

  @override
  void initState() {
    super.initState();

    _future = ambilSalam();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bagian A'),
      ),
      body: FutureBuilder<String>(
        future: _future,
        builder: (context, snapshot) {
          // ========================================
          // LOADING
          // ========================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ========================================
          // ERROR
          // ========================================

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
              ),
            );
          }

          // ========================================
          // DATA BERHASIL
          // ========================================

          return Center(
            child: Text(
              snapshot.data ?? '',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==================================================
// BAGIAN C
// MODEL PENGGUNA
// ==================================================

class Pengguna {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;

  Pengguna({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
  });

  factory Pengguna.fromJson(
      Map<String, dynamic> json,
      ) {
    return Pengguna(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
    );
  }
}

// ==================================================
// BAGIAN C
// FUNGSI MENGAMBIL DATA PENGGUNA
// ==================================================

Future<List<Pengguna>> ambilPengguna() async {
  final uri = Uri.parse(
    'https://jsonplaceholder.typicode.com/users',
  );

  final response = await http
      .get(uri)
      .timeout(
    const Duration(seconds: 10),
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Gagal mengambil data: ${response.statusCode}',
    );
  }

  final List<dynamic> jsonData =
  jsonDecode(response.body);

  return jsonData
      .map(
        (item) => Pengguna.fromJson(item),
  )
      .toList();
}

// ==================================================
// BAGIAN D
// HALAMAN DAFTAR PENGGUNA
// ==================================================

class PenggunaPage extends StatefulWidget {
  const PenggunaPage({super.key});

  @override
  State<PenggunaPage> createState() =>
      _PenggunaPageState();
}

class _PenggunaPageState
    extends State<PenggunaPage> {
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
        title: const Text(
          'Daftar Pengguna',
        ),
        actions: [
          IconButton(
            onPressed: _muatUlang,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Pengguna>>(
        future: _future,
        builder: (context, snapshot) {
          // ========================================
          // LOADING
          // ========================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ========================================
          // ERROR
          // ========================================

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
                      'Terjadi kesalahan: '
                          '${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton(
                      onPressed: _muatUlang,
                      child: const Text(
                        'Coba lagi',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ========================================
          // DATA BERHASIL
          // ========================================

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final p = data[index];

              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    p.name[0],
                  ),
                ),

                title: Text(
                  p.name,
                ),

                subtitle: Text(
                  p.email,
                ),

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
          );
        },
      ),
    );
  }
}

// ==================================================
// BAGIAN E
// HALAMAN DETAIL PENGGUNA
// ==================================================

class DetailPenggunaPage
    extends StatelessWidget {
  final Pengguna pengguna;

  const DetailPenggunaPage({
    super.key,
    required this.pengguna,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pengguna.name,
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(
              Icons.email,
            ),
            title: Text(
              pengguna.email,
            ),
          ),

          ListTile(
            leading: const Icon(
              Icons.phone,
            ),
            title: Text(
              pengguna.phone,
            ),
          ),

          ListTile(
            leading: const Icon(
              Icons.language,
            ),
            title: Text(
              pengguna.website,
            ),
          ),
        ],
      ),
    );
  }
}