import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

// ============================================================
// MODEL
// ============================================================

class Catatan {
  final int? id;
  final String judul;
  final String isi;
  final String dibuat;

  const Catatan({
    this.id,
    required this.judul,
    required this.isi,
    required this.dibuat,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'dibuat': dibuat,
    };
  }

  factory Catatan.fromMap(Map<String, Object?> m) {
    return Catatan(
      id: m['id'] as int,
      judul: m['judul'] as String,
      isi: m['isi'] as String,
      dibuat: (m['dibuat'] as String?) ?? '',
    );
  }
}

// ============================================================
// DATABASE HELPER
// ============================================================

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    final path = p.join(
      await getDatabasesPath(),
      'catatan.db',
    );

    _db = await openDatabase(
      path,
      version: 2,

      // Membuat database baru
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE catatan('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'judul TEXT NOT NULL, '
              'isi TEXT NOT NULL, '
              'dibuat TEXT NOT NULL'
              ')',
        );
      },

      // Upgrade database dari versi sebelumnya
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE catatan ADD COLUMN dibuat TEXT',
          );

          // Memberikan tanggal pada data lama
          await db.update(
            'catatan',
            {
              'dibuat': DateTime.now().toIso8601String(),
            },
            where: 'dibuat IS NULL',
          );
        }
      },
    );

    return _db!;
  }

  // CREATE
  static Future<int> tambah(Catatan c) async {
    final db = await database;

    return db.insert(
      'catatan',
      c.toMap(),
    );
  }

  // READ
  static Future<List<Catatan>> semua({
    String orderBy = 'id DESC',
  }) async {
    final db = await database;

    final rows = await db.query(
      'catatan',
      orderBy: orderBy,
    );

    return rows.map(Catatan.fromMap).toList();
  }

  // SEARCH
  static Future<List<Catatan>> cari(
      String kata, {
        String orderBy = 'id DESC',
      }) async {
    final db = await database;

    final rows = await db.query(
      'catatan',
      where: 'judul LIKE ?',
      whereArgs: ['%$kata%'],
      orderBy: orderBy,
    );

    return rows.map(Catatan.fromMap).toList();
  }

  // UPDATE
  static Future<int> ubah(Catatan c) async {
    final db = await database;

    return db.update(
      'catatan',
      c.toMap(),
      where: 'id = ?',
      whereArgs: [c.id],
    );
  }

  // DELETE
  static Future<int> hapus(int id) async {
    final db = await database;

    return db.delete(
      'catatan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

// ============================================================
// MY APP
// ============================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catatan SQLite',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const CatatanPage(),
    );
  }
}

// ============================================================
// HALAMAN DAFTAR CATATAN
// ============================================================

class CatatanPage extends StatefulWidget {
  const CatatanPage({super.key});

  @override
  State<CatatanPage> createState() => _CatatanPageState();
}

class _CatatanPageState extends State<CatatanPage> {
  late Future<List<Catatan>> _future;

  final TextEditingController _searchController =
  TextEditingController();

  // Menyimpan pilihan urutan
  String _urutan = 'terbaru';

  @override
  void initState() {
    super.initState();

    _future = DbHelper.semua();

    _searchController.addListener(_cari);

    // Membaca pilihan urutan yang tersimpan
    _ambilUrutan();
  }

  @override
  void dispose() {
    _searchController.removeListener(_cari);
    _searchController.dispose();
    super.dispose();
  }

  // ==========================================================
  // MENGAMBIL PILIHAN URUTAN DARI SHARED PREFERENCES
  // ==========================================================

  Future<void> _ambilUrutan() async {
    final prefs = await SharedPreferences.getInstance();

    final tersimpan = prefs.getString('urutan') ?? 'terbaru';

    setState(() {
      _urutan = tersimpan;
    });

    _muat();
  }

  // ==========================================================
  // MENYIMPAN PILIHAN URUTAN
  // ==========================================================

  Future<void> _simpanUrutan(String nilai) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'urutan',
      nilai,
    );

    setState(() {
      _urutan = nilai;
    });

    _muat();
  }

  // ==========================================================
  // MENENTUKAN ORDER BY
  // ==========================================================

  String get _orderBy {
    if (_urutan == 'terlama') {
      return 'id ASC';
    }

    return 'id DESC';
  }

  // ==========================================================
  // LOAD DATA
  // ==========================================================

  void _muat() {
    final kata = _searchController.text.trim();

    setState(() {
      if (kata.isEmpty) {
        _future = DbHelper.semua(
          orderBy: _orderBy,
        );
      } else {
        _future = DbHelper.cari(
          kata,
          orderBy: _orderBy,
        );
      }
    });
  }

  // ==========================================================
  // SEARCH
  // ==========================================================

  void _cari() {
    final kata = _searchController.text.trim();

    setState(() {
      if (kata.isEmpty) {
        _future = DbHelper.semua(
          orderBy: _orderBy,
        );
      } else {
        _future = DbHelper.cari(
          kata,
          orderBy: _orderBy,
        );
      }
    });
  }

  // ==========================================================
  // KONFIRMASI HAPUS
  // ==========================================================

  Future<void> _konfirmasiHapus(Catatan catatan) async {
    final hasil = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text(
            'Hapus catatan ini?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (hasil == true) {
      await DbHelper.hapus(catatan.id!);
      _muat();
    }
  }

  // ==========================================================
  // BUKA FORM
  // ==========================================================

  Future<void> _buka([Catatan? catatan]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormCatatanPage(
          catatan: catatan,
        ),
      ),
    );

    _muat();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Catatan'),

        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),

            initialValue: _urutan,

            onSelected: (value) {
              _simpanUrutan(value);
            },

            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'terbaru',
                child: Text('Terbaru'),
              ),
              PopupMenuItem(
                value: 'terlama',
                child: Text('Terlama'),
              ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          // ==================================================
          // SEARCH
          // ==================================================

          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari catatan',
                hintText: 'Masukkan judul catatan',
                prefixIcon: const Icon(Icons.search),

                suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
                    : null,

                border: const OutlineInputBorder(),
              ),
            ),
          ),

          // ==================================================
          // INFORMASI URUTAN
          // ==================================================

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Urutan: ${_urutan == 'terbaru' ? 'Terbaru' : 'Terlama'}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ==================================================
          // LIST CATATAN
          // ==================================================

          Expanded(
            child: FutureBuilder<List<Catatan>>(
              future: _future,

              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Terjadi kesalahan: ${snapshot.error}',
                    ),
                  );
                }

                final data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada catatan',
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: data.length,

                  itemBuilder: (context, index) {
                    final c = data[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),

                      child: ListTile(
                        title: Text(
                          c.judul,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),

                            Text(
                              c.isi,
                              maxLines: 2,
                              overflow:
                              TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 6),

                            Text(
                              'Dibuat: ${c.dibuat}',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        onTap: () {
                          _buka(c);
                        },

                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),

                          onPressed: () {
                            _konfirmasiHapus(c);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // ======================================================
      // TAMBAH CATATAN
      // ======================================================

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _buka();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ============================================================
// FORM CATATAN
// ============================================================

class FormCatatanPage extends StatefulWidget {
  final Catatan? catatan;

  const FormCatatanPage({
    super.key,
    this.catatan,
  });

  @override
  State<FormCatatanPage> createState() =>
      _FormCatatanPageState();
}

class _FormCatatanPageState
    extends State<FormCatatanPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _judul;
  late final TextEditingController _isi;

  @override
  void initState() {
    super.initState();

    _judul = TextEditingController(
      text: widget.catatan?.judul ?? '',
    );

    _isi = TextEditingController(
      text: widget.catatan?.isi ?? '',
    );
  }

  @override
  void dispose() {
    _judul.dispose();
    _isi.dispose();
    super.dispose();
  }

  // ==========================================================
  // SIMPAN
  // ==========================================================

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final sekarang =
    DateTime.now().toIso8601String();

    final c = Catatan(
      id: widget.catatan?.id,
      judul: _judul.text.trim(),
      isi: _isi.text.trim(),

      // Jika edit, tanggal dibuat tetap menggunakan
      // tanggal lama.
      dibuat:
      widget.catatan?.dibuat ?? sekarang,
    );

    // Tambah data baru
    if (widget.catatan == null) {
      await DbHelper.tambah(c);
    }

    // Update data lama
    else {
      await DbHelper.ubah(c);
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final baru = widget.catatan == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          baru ? 'Catatan Baru' : 'Ubah Catatan',
        ),
      ),

      body: Form(
        key: _formKey,

        child: ListView(
          padding: const EdgeInsets.all(16),

          children: [
            // =================================================
            // JUDUL
            // =================================================

            TextFormField(
              controller: _judul,

              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),

              validator: (v) {
                if (v == null ||
                    v.trim().isEmpty) {
                  return 'Judul wajib diisi';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            // =================================================
            // ISI
            // =================================================

            TextFormField(
              controller: _isi,

              maxLines: 6,

              decoration: const InputDecoration(
                labelText: 'Isi catatan',
                border: OutlineInputBorder(),
              ),

              validator: (v) {
                if (v == null ||
                    v.trim().isEmpty) {
                  return 'Isi wajib diisi';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // =================================================
            // TOMBOL SIMPAN
            // =================================================

            ElevatedButton(
              onPressed: _simpan,

              child: const Text(
                'Simpan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}