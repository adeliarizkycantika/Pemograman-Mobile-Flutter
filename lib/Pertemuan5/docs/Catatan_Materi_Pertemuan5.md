# Catatan Pembelajaran Pertemuan 5 - Fluuter

## 1. Apa yang dipelajari di pertemuan ini?

Di pertemuan 5, aku belajar cara menyimpan data di aplikasi Flutter supaya datanya nggak hilang begitu saja saat aplikasi ditutup.

Ada dua materi utama yang dipelajari, yaitu SharedPreferences dan SQLite.

- **SharedPreferences** digunakan untuk menyimpan pengaturan sederhana, misalnya pilihan mode gelap.
- **SQLite** digunakan untuk menyimpan data yang lebih banyak, misalnya catatan, daftar belanja, atau pengeluaran.

Keduanya punya kegunaan yang berbeda, jadi penggunaannya perlu disesuaikan dengan jenis data yang ingin disimpan.


## 2. SharedPreferences

### Apa itu SharedPreferences?

SharedPreferences bisa dibilang sebagai tempat untuk menyimpan pengaturan kecil di aplikasi. Jadi, kalau aplikasi ditutup lalu dibuka lagi, pengaturan yang sebelumnya dipilih masih bisa diingat.

Contohnya, kita mengaktifkan mode gelap. Setelah aplikasi dibuka kembali, tampilannya tetap gelap tanpa harus mengaktifkannya lagi.

Contoh lainnya:
- Menyimpan nama pengguna.
- Menyimpan pilihan mode gelap atau terang.
- Menyimpan jumlah aplikasi dibuka.

### Cara menggunakan SharedPreferences

Pertama, tambahkan package `shared_preferences` di `pubspec.yaml`, lalu jalankan `flutter pub get`.

Setelah itu, tambahkan kode berikut di bagian atas file Dart:

```dart
import 'package:shared_preferences/shared_preferences.dart';
```

### Mengambil tempat penyimpanan

```dart
final prefs = await SharedPreferences.getInstance();
```

Kode ini digunakan sebelum kita membaca atau menyimpan pengaturan.

### Menyimpan pengaturan

Misalnya, kita ingin menyimpan pilihan mode gelap:

```dart
final prefs = await SharedPreferences.getInstance();

await prefs.setBool('modeGelap', true);
```

Artinya, pilihan mode gelap disimpan dengan nama `modeGelap` dan nilainya `true`.

### Membaca pengaturan

```dart
final prefs = await SharedPreferences.getInstance();

bool modeGelap = prefs.getBool('modeGelap') ?? false;
```

Kode ini mengambil pilihan mode gelap yang sebelumnya disimpan. Kalau belum ada pilihan, nilainya menggunakan `false`, artinya mode gelap belum aktif.

**Yang perlu diingat:** SharedPreferences lebih cocok untuk pengaturan sederhana. Kalau ingin menyimpan banyak data yang bisa ditambah, diedit, dan dihapus, SQLite lebih cocok digunakan.


## 3. SQLite

### Apa itu SQLite?

SQLite digunakan untuk menyimpan data di dalam aplikasi. Data disusun dalam bentuk tabel, mirip seperti tabel yang biasa kita lihat di Excel.

Misalnya, aplikasi pencatat pengeluaran memiliki tabel berisi nama pengeluaran, jumlah uang, kategori, dan tanggal.

Data tersebut bisa tetap tersimpan meskipun aplikasi ditutup.

### Package yang digunakan

Untuk menggunakan SQLite, tambahkan package berikut di `pubspec.yaml`:

```yaml
dependencies:
  sqflite: ^2.4.2
  path: ^1.9.1
```

Versi package bisa disesuaikan dengan yang tersedia. Setelah menambahkan package, jalankan `flutter pub get`.

Kemudian, tambahkan import berikut:

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
```

` sqflite` digunakan untuk mengelola penyimpanan data, sedangkan `path` membantu menentukan lokasi file database.

### Membuat database

Contoh kode untuk menentukan lokasi database:

```dart
final dbPath = p.join(
  await getDatabasesPath(),
  'pengeluaran.db',
);
```

Kode tersebut menentukan lokasi database yang bernama `pengeluaran.db`.

Untuk membuka atau membuat database, kita bisa menggunakan `openDatabase()`.

```dart
final db = await openDatabase(
  dbPath,
  version: 1,
  onCreate: (db, version) async {
    // Membuat tabel saat database pertama kali dibuat.
  },
);
```

Kalau database belum tersedia, aplikasi akan membuatnya. Kalau sudah ada, aplikasi akan membuka database yang sebelumnya digunakan.

### Membuat tabel pengeluaran

Contoh tabel yang digunakan dalam tugas mandiri:

```sql
CREATE TABLE pengeluaran(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nama TEXT NOT NULL,
  jumlah INTEGER NOT NULL,
  kategori TEXT NOT NULL,
  tanggal TEXT NOT NULL
)
```

Isi tabel tersebut punya kegunaan masing-masing:

- `id` sebagai nomor unik untuk setiap data.
- `nama` untuk menyimpan nama pengeluaran.
- `jumlah` untuk menyimpan nominal uang.
- `kategori` untuk menyimpan jenis pengeluaran.
- `tanggal` untuk menyimpan tanggal pengeluaran.

`AUTOINCREMENT` membuat nomor ID bertambah otomatis. Sementara itu, `NOT NULL` berarti kolom tersebut harus memiliki nilai.


## 4. CRUD untuk Mengelola Data

Saat menggunakan SQLite, ada empat kegiatan utama yang disebut CRUD.

| CRUD | Maksudnya | Contoh |
|---|---|---|
| Create | Menambahkan data | Mencatat pengeluaran baru |
| Read | Melihat data | Menampilkan daftar pengeluaran |
| Update | Mengubah data | Mengganti jumlah pengeluaran |
| Delete | Menghapus data | Menghapus catatan pengeluaran |

### A. Menambahkan data

```dart
await db.insert(
  'pengeluaran',
  data.toMap(),
);
```

Kode ini digunakan untuk memasukkan data baru ke tabel pengeluaran.

### B. Mengambil data

```dart
final rows = await db.query(
  'pengeluaran',
  orderBy: 'id DESC',
);
```

Kode ini mengambil daftar pengeluaran. `id DESC` membuat data dengan ID terbaru ditampilkan lebih dulu.

### C. Mengubah data

```dart
await db.update(
  'pengeluaran',
  data.toMap(),
  where: 'id = ?',
  whereArgs: [data.id],
);
```

Kode ini digunakan saat kita mengedit pengeluaran. Data yang diubah adalah data dengan ID yang sesuai, bukan semua data di tabel.

### D. Menghapus data

```dart
await db.delete(
  'pengeluaran',
  where: 'id = ?',
  whereArgs: [id],
);
```

Kode ini menghapus pengeluaran berdasarkan ID yang dipilih.

### Kenapa menggunakan tanda `?` dan `whereArgs`?

Tanda `?` digunakan sebagai tempat untuk nilai yang ingin dimasukkan. Nilainya diberikan melalui `whereArgs`.

Cara ini lebih aman dan membantu mencegah kesalahan saat mengolah data dibandingkan menyambungkan teks secara langsung.


## 5. Perbedaan `onCreate` dan `onUpgrade`

Keduanya digunakan saat membuat atau memperbarui database.

- **`onCreate`** dijalankan ketika database pertama kali dibuat. Biasanya digunakan untuk membuat tabel.
- **`onUpgrade`** dijalankan ketika versi database dinaikkan, misalnya saat kita menambahkan kolom baru ke tabel.

Contohnya:

```dart
openDatabase(
  dbPath,
  version: 2,
  onCreate: (db, version) async {
    // Membuat tabel.
  },
  onUpgrade: (db, oldVersion, newVersion) async {
    // Memperbarui struktur database.
  },
);
```

Hal yang perlu diingat, `onUpgrade` tidak berjalan hanya karena kita mengubah kode tabel. Versi database juga perlu dinaikkan supaya proses pembaruan dijalankan.


## 6. Menghitung Total Pengeluaran

Pada aplikasi pencatat pengeluaran, kita juga perlu mengetahui jumlah seluruh uang yang sudah dikeluarkan.

SQLite punya fungsi `SUM()` untuk menjumlahkan nilai dalam sebuah kolom.

```dart
final hasil = await db.rawQuery(
  'SELECT SUM(jumlah) AS total FROM pengeluaran',
);

final total = hasil.first['total'];

return total == null ? 0 : (total as num).toInt();
```

Dari kode tersebut, semua nilai pada kolom `jumlah` akan dijumlahkan.

Kalau belum ada pengeluaran, hasilnya bisa kosong. Karena itu, nilai total dibuat menjadi `0`.

Jadi, setiap kali ada pengeluaran baru, totalnya bisa ikut bertambah. Kalau pengeluaran diedit atau dihapus, totalnya juga perlu dihitung ulang.


## 7. Memahami `Future`, `async`, dan `await`

Saat mengambil data dari database, prosesnya membutuhkan waktu. Karena itu, Flutter menggunakan `Future`, `async`, dan `await`.

- `Future` digunakan untuk proses yang hasilnya baru tersedia setelah beberapa waktu.
- `async` menandakan bahwa sebuah fungsi menjalankan proses asynchronous.
- `await` digunakan untuk menunggu proses selesai sebelum melanjutkan ke langkah berikutnya.

Contohnya:

```dart
final data = await DbHelper.semua();
```

Artinya, aplikasi menunggu sampai proses mengambil data pengeluaran selesai.

### Menggunakan FutureBuilder

`FutureBuilder` membantu menampilkan data sesuai keadaan prosesnya.

Misalnya, ketika data masih dimuat, aplikasi menampilkan lingkaran loading. Setelah data selesai diambil, daftar pengeluaran ditampilkan.

```dart
FutureBuilder<List<Pengeluaran>>(
  future: _future,
  builder: (context, snapshot) {
    if (snapshot.connectionState ==
        ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }

    if (snapshot.hasError) {
      return const Text('Terjadi kesalahan');
    }

    final data = snapshot.data ?? [];

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Text(data[index].nama);
      },
    );
  },
)
```

Dengan begitu, aplikasi bisa menampilkan keadaan saat data sedang dimuat, terjadi kesalahan, atau sudah berhasil diambil.


## 8. Memuat Ulang Daftar Setelah Data Berubah

Misalnya, kita menambahkan pengeluaran baru lalu kembali ke halaman utama. Daftar perlu dimuat ulang supaya pengeluaran yang baru ditambahkan langsung terlihat.

Pada kode tugas mandiri, bagian ini digunakan untuk mengambil data kembali:

```dart
setState(() {
  _future = DbHelper.semua();
});
```

`DbHelper.semua()` mengambil data terbaru dari database, sedangkan `setState()` memberi tahu Flutter bahwa tampilan perlu diperbarui.

Hal yang sama dilakukan setelah data diedit atau dihapus.


## 9. Memilih Tanggal Menggunakan Kalender

Di tugas mandiri, tanggal pengeluaran bisa dipilih sendiri melalui kalender. Jadi, tanggalnya nggak harus selalu menggunakan tanggal hari ini.

Untuk membuka kalender, kita menggunakan `showDatePicker()`.

### Kode untuk membuka kalender

```dart
Future<void> _pilihTanggal() async {
  final DateTime? tanggalDipilih = await showDatePicker(
    context: context,
    initialDate: _tanggal,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (tanggalDipilih != null) {
    setState(() {
      _tanggal = tanggalDipilih;
    });
  }
}
```

Penjelasannya:

- `initialDate` menentukan tanggal yang pertama kali ditampilkan.
- `firstDate` menentukan tanggal paling awal yang boleh dipilih.
- `lastDate` menentukan tanggal paling akhir yang boleh dipilih.
- `tanggalDipilih` menyimpan tanggal yang dipilih pengguna.
- `setState()` memperbarui tampilan agar tanggal pilihan langsung terlihat.

### Membuat bagian tanggal bisa ditekan

```dart
InkWell(
  onTap: _pilihTanggal,
  child: InputDecorator(
    decoration: const InputDecoration(
      labelText: 'Tanggal',
      border: OutlineInputBorder(),
      prefixIcon: Icon(Icons.calendar_today),
    ),
    child: Text(
      _tanggal.toIso8601String().substring(0, 10),
    ),
  ),
)
```

`InkWell` membuat bagian tanggal bisa ditekan. Ketika ditekan, fungsi `_pilihTanggal()` dijalankan dan kalender akan terbuka.

Tanggal yang dipilih kemudian disimpan menggunakan kode berikut:

```dart
tanggal: _tanggal.toIso8601String().substring(0, 10),
```

Contoh hasil tanggalnya adalah `2026-10-10`.

Jadi, pengguna bisa memilih tanggal pengeluaran sesuai kebutuhan. Saat mengedit pengeluaran, tanggal sebelumnya juga tetap muncul dan bisa diubah lagi.


## 10. Tugas Mandiri: Pencatat Pengeluaran

Pada tugas mandiri, materi SharedPreferences dan SQLite diterapkan dalam aplikasi pencatat pengeluaran sehari-hari.

### Fitur yang dibuat

1. Menambahkan pengeluaran baru.
2. Mengisi nama dan jumlah pengeluaran.
3. Memilih kategori pengeluaran.
4. Memilih tanggal menggunakan kalender.
5. Menampilkan daftar pengeluaran yang sudah disimpan.
6. Mengedit pengeluaran.
7. Menghapus pengeluaran dengan konfirmasi.
8. Menghitung total seluruh pengeluaran.
9. Mengaktifkan mode gelap dan terang.
10. Menyimpan data pengeluaran menggunakan SQLite.
11. Menyimpan pilihan mode gelap menggunakan SharedPreferences.

### Kategori pengeluaran

Kategori yang tersedia di aplikasi ini adalah:

- Makanan
- Transportasi
- Belanja
- Tagihan
- Hiburan
- Lainnya

Setiap kategori juga memiliki ikon supaya daftar pengeluaran lebih mudah dibedakan.

### Cara menggunakan aplikasi

1. Buka aplikasi Pencatat Pengeluaran.
2. Tekan tombol `+` untuk menambahkan pengeluaran.
3. Isi nama dan jumlah uang yang dikeluarkan.
4. Pilih kategori yang sesuai.
5. Tekan bagian tanggal untuk membuka kalender.
6. Pilih tanggal yang diinginkan, lalu simpan pengeluaran.
7. Data akan muncul di halaman utama dan total pengeluaran akan diperbarui.
8. Gunakan tombol edit jika ingin mengubah data.
9. Gunakan tombol hapus jika ingin menghapus pengeluaran.
10. Aktifkan atau matikan mode gelap sesuai keinginan.

### Pembagian fungsi yang digunakan

| Bagian | Kegunaan |
|---|---|
| SQLite | Menyimpan data pengeluaran |
| SharedPreferences | Mengingat pilihan mode gelap |
| CRUD | Menambah, melihat, mengubah, dan menghapus data |
| `FutureBuilder` | Menampilkan data setelah proses pengambilan selesai |
| `setState()` | Memperbarui tampilan setelah ada perubahan |
| `showDatePicker()` | Membuka kalender untuk memilih tanggal |


## 11. Hal yang Perlu Diingat

Beberapa hal penting dari materi ini:

- SharedPreferences cocok untuk menyimpan pengaturan sederhana, bukan banyak catatan.
- SQLite cocok untuk data yang perlu ditambah, dilihat, diedit, dan dihapus.
- CRUD adalah proses utama untuk mengelola data.
- `onCreate` digunakan saat database pertama kali dibuat.
- `onUpgrade` digunakan ketika versi database dinaikkan.
- `Future` digunakan untuk proses yang membutuhkan waktu.
- `FutureBuilder` membantu menampilkan data ketika proses pengambilan data berlangsung.
- Setelah data berubah, daftar dan total pengeluaran perlu diperbarui.
- `showDatePicker()` digunakan untuk membuka kalender dan memilih tanggal.

## 12. Kesimpulan

Dari pertemuan ini, aku belajar cara menyimpan pengaturan dan data di aplikasi Flutter. SharedPreferences digunakan untuk mengingat pengaturan seperti mode gelap, sedangkan SQLite digunakan untuk menyimpan data pengeluaran.

Materi ini juga mengajarkan cara menambahkan, melihat, mengubah, dan menghapus data. Selain itu, aku belajar cara menampilkan data yang sedang dimuat, menghitung total pengeluaran, serta memilih tanggal menggunakan kalender.

Melalui tugas mandiri Pencatat Pengeluaran, semua materi tersebut digabungkan menjadi aplikasi sederhana yang bisa digunakan untuk mencatat dan mengelola pengeluaran sehari-hari.