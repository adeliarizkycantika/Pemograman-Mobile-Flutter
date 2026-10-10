# Catatan Pembelajaran Materi  – Pertemuan 4

## 1. Materi yang Dipelajari

Pada pertemuan 4 ini, kita belajar cara mengambil data dari internet dan menampilkannya di aplikasi Flutter.

Sebelumnya, data yang ditampilkan biasanya ditulis langsung di dalam aplikasi. Nah, sekarang kita belajar mengambil data dari API, jadi data bisa berasal dari server.

Materi yang dipelajari meliputi:
- Mengenal `Future` dan `FutureBuilder`.
- Mengambil data dari API menggunakan package HTTP.
- Mengubah JSON menjadi class model.
- Menampilkan daftar data dan halaman detail.
- Menangani loading dan error.
- Membuat aplikasi Daftar Postingan.

## 2. Mengenal Future dan FutureBuilder

### Apa itu Future?

`Future` digunakan untuk proses yang hasilnya tidak langsung tersedia. Contohnya, mengambil data dari internet yang membutuhkan waktu beberapa detik.

Pada praktikum, kita menggunakan fungsi `ambilSalam()` untuk mencoba proses yang membutuhkan waktu 2 detik.

```dart
Future<String> ambilSalam() async {
  await Future.delayed(const Duration(seconds: 2));
  return 'Halo dari masa depan!';
}
```

Penjelasan:
- `Future<String>` berarti fungsi akan menghasilkan data berupa teks.
- `async` digunakan untuk fungsi yang menjalankan proses asynchronous.
- `await` digunakan untuk menunggu proses selesai.
- `Future.delayed()` memberikan jeda selama waktu yang ditentukan.
- `return` digunakan untuk mengembalikan hasilnya.

Jadi, selama 2 detik aplikasi menampilkan loading, kemudian teks "Halo dari masa depan!" muncul.

### Apa itu FutureBuilder?

`FutureBuilder` digunakan untuk menampilkan tampilan berdasarkan hasil suatu proses `Future`.

Contohnya:
- Saat data masih dimuat, tampilkan loading.
- Saat terjadi kesalahan, tampilkan pesan error.
- Saat data berhasil didapatkan, tampilkan hasilnya.

Contoh loading:

```dart
if (snapshot.connectionState == ConnectionState.waiting) {
  return const CircularProgressIndicator();
}
```

Contoh saat terjadi error:

```dart
if (snapshot.hasError) {
  return Text('Error: ${snapshot.error}');
}
```

**Catatan penting:** `Future` sebaiknya dibuat di `initState()`, bukan langsung di `build()`. Kalau dibuat di `build()`, proses pengambilan data bisa diulang setiap kali tampilan diperbarui.

Contohnya:

```dart
late Future<String> _future;

@override
void initState() {
  super.initState();
  _future = ambilSalam();
}
```

`initState()` dijalankan saat halaman pertama kali dibuat. Jadi, proses pengambilan data bisa disiapkan dari awal tanpa terus-menerus dibuat ulang setiap kali `build()` berjalan.

## 3. Menyiapkan Package HTTP

Untuk mengambil data dari API, kita membutuhkan package `http`.

Jalankan perintah berikut di terminal pada folder proyek Flutter:

```bash
flutter pub add http
```

Setelah itu, tambahkan import berikut di bagian atas file `main.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
```

Kegunaannya:
- `dart:convert` digunakan untuk mengolah data JSON.
- `package:http/http.dart` digunakan untuk mengambil data dari API.

### Izin internet

Untuk aplikasi Android versi release, tambahkan izin berikut di `android/app/src/main/AndroidManifest.xml`, tepat sebelum tag pembuka `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Izin ini dibutuhkan agar aplikasi dapat mengakses internet.

## 4. Mengambil Data dari API

API yang digunakan dalam praktikum ini adalah JSONPlaceholder, yaitu layanan API untuk latihan.

Alamat API daftar pengguna:

`https://jsonplaceholder.typicode.com/users`

Untuk mengambil data, kita bisa menggunakan `http.get()`.

```dart
final uri = Uri.parse(
  'https://jsonplaceholder.typicode.com/users',
);

final response = await http.get(uri);
```

Penjelasan:
- `Uri.parse()` digunakan untuk menyiapkan alamat API.
- `http.get()` digunakan untuk meminta data ke server.
- `response` menyimpan jawaban dari server.

### Mengecek hasil permintaan

```dart
if (response.statusCode != 200) {
  throw Exception(
    'Gagal memuat data (kode ${response.statusCode})',
  );
}
```

Kode `200` biasanya menandakan permintaan berhasil. Kalau server memberikan status lain, aplikasi bisa menampilkan pesan kesalahan.

Dalam modul, pengambilan data juga diberi batas waktu 10 detik:

```dart
final response = await http
    .get(uri)
    .timeout(const Duration(seconds: 10));
```

Tujuannya supaya aplikasi tidak menunggu proses pengambilan data tanpa batas waktu.

## 5. Mengubah JSON Menjadi Class Model

Data dari API diterima dalam bentuk JSON. Supaya lebih mudah digunakan, data tersebut diubah menjadi class model.

Pada praktikum, kita membuat class `Pengguna` yang berisi:
- `id`
- `name`
- `email`
- `phone`
- `website`

Contoh sederhananya:

```dart
class Pengguna {
  final int id;
  final String name;
  final String email;

  const Pengguna({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Pengguna.fromJson(Map<String, dynamic> json) {
    return Pengguna(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}
```

Kode di atas hanya contoh singkat. Pada praktikum, model `Pengguna` juga memiliki `phone` dan `website`.

### Apa fungsi fromJson()?

`fromJson()` digunakan untuk mengubah data JSON menjadi objek yang sesuai dengan class model.

Dengan begitu, data bisa dipanggil dengan lebih mudah, misalnya `pengguna.name` untuk mengambil nama pengguna.

### Mengubah daftar JSON

```dart
final List<dynamic> data = jsonDecode(response.body);

return data
    .map((e) => Pengguna.fromJson(e as Map<String, dynamic>))
    .toList();
```

Kode tersebut mengubah JSON menjadi daftar objek `Pengguna`, sehingga setiap pengguna bisa ditampilkan di aplikasi.

## 6. Menampilkan Daftar Pengguna

Setelah data berhasil diambil, kita menggunakan `FutureBuilder` untuk menampilkan daftar pengguna.

Pada halaman utama, setiap pengguna ditampilkan menggunakan `ListTile`.

Contohnya:

```dart
ListTile(
  title: Text(p.name),
  subtitle: Text(p.email),
  trailing: const Icon(Icons.chevron_right),
)
```

Penjelasan:
- `title` menampilkan nama pengguna.
- `subtitle` menampilkan email pengguna.
- `trailing` menampilkan ikon di sebelah kanan.

Untuk menampilkan banyak data, kita menggunakan `ListView.builder()`.

```dart
ListView.builder(
  itemCount: data.length,
  itemBuilder: (context, i) {
    final p = data[i];

    return ListTile(
      title: Text(p.name),
      subtitle: Text(p.email),
    );
  },
)
```

`ListView.builder()` digunakan untuk membuat daftar berdasarkan jumlah data yang tersedia.

Dalam checkpoint praktikum, seharusnya muncul 10 pengguna setelah loading selesai.

## 7. Menampilkan Halaman Detail Pengguna

Ketika salah satu pengguna ditekan, aplikasi akan membuka halaman detail yang berisi email, nomor telepon, dan website.

Perpindahan halaman dilakukan menggunakan `Navigator.push()`.

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => DetailPenggunaPage(pengguna: p),
  ),
);
```

Data pengguna yang dipilih dikirim ke halaman detail melalui parameter `pengguna`.

Contoh menampilkan datanya:

```dart
ListTile(
  leading: const Icon(Icons.email),
  title: Text(pengguna.email),
)
```

Dengan cara ini, halaman detail menampilkan data sesuai pengguna yang dipilih, bukan mengambil data pengguna lain.

## 8. Menangani Loading dan Error

Saat mengambil data dari internet, ada tiga kondisi utama yang perlu ditangani.

### Loading

Loading muncul ketika aplikasi masih menunggu data.

```dart
const CircularProgressIndicator()
```

### Error

Error muncul saat proses pengambilan data mengalami masalah.

```dart
if (snapshot.hasError) {
  return const Text('Terjadi kesalahan');
}
```

Contohnya, koneksi internet terputus atau server mengirimkan status yang tidak sesuai harapan.

### Data berhasil dimuat

Jika proses berhasil, aplikasi menampilkan data dari API.

Ketiga kondisi ini penting agar pengguna tahu apa yang sedang terjadi dan tidak mengira aplikasi macet ketika data belum muncul.

### Tombol Coba Lagi

Ketika terjadi error, pengguna bisa mencoba mengambil data kembali.

```dart
void _muatUlang() {
  setState(() {
    _future = ambilPengguna();
  });
}
```

`setState()` digunakan agar perubahan pada `_future` diperbarui di tampilan.

Fungsi `_muatUlang()` juga bisa dipakai pada tombol refresh di AppBar dan tombol "Coba lagi" di halaman error.

## 9. Percobaan Penanganan Error

Pada Bagian F, ada dua percobaan yang perlu dilakukan.

### Percobaan 1: Mengubah alamat API

Ubah alamat `/users` menjadi `/userz`.

Alamat yang salah tersebut akan menghasilkan status `404` karena halaman yang diminta tidak ditemukan.

Yang perlu diamati:
- Pesan error yang muncul.
- Kode status yang ditampilkan.
- Apakah tombol "Coba lagi" bisa digunakan setelah alamat API diperbaiki.

### Percobaan 2: Mematikan internet

Matikan koneksi internet perangkat atau emulator, kemudian tekan tombol refresh.

Yang perlu diamati:
- Pesan error jaringan yang muncul.
- Apakah data gagal dimuat.
- Apakah aplikasi bisa mengambil data kembali setelah internet dinyalakan.

**Kesimpulan:** error bisa terjadi karena alamat API salah maupun karena masalah koneksi. Keduanya perlu ditangani agar aplikasi tetap mudah digunakan.

## 10. Latihan Mandiri

Pada latihan mandiri, ada beberapa hal yang perlu ditambahkan.

### 1. Menambahkan username dan kota

Tambahkan data `username` dan `city` ke class `Pengguna`.

Untuk kota, datanya berasal dari bagian `address` di JSON:

```dart
json['address']['city']
```

Karena kota berada di dalam data alamat, kita perlu mengambilnya dari bagian `address`, bukan langsung dari bagian utama JSON.

### 2. Menambahkan RefreshIndicator

`RefreshIndicator` digunakan agar pengguna bisa menarik daftar ke bawah untuk memuat ulang data.

Fitur ini membuat aplikasi terasa lebih praktis karena pengguna tidak harus selalu menekan tombol refresh.

### 3. Menangani daftar kosong

Jika data yang diterima kosong, tampilkan pesan:

```dart
const Text('Tidak ada data')
```

Dengan begitu, halaman tetap memberikan informasi walaupun tidak ada data yang bisa ditampilkan.

### 4. Menampilkan jumlah pengguna

Setelah data berhasil dimuat, tampilkan jumlah pengguna di AppBar.

Jumlahnya bisa diambil menggunakan:

```dart
data.length
```

Misalnya, jika ada 10 pengguna, AppBar bisa menampilkan tulisan "Daftar Pengguna (10)".

## 11. Tugas: Membuat Aplikasi Daftar Postingan

Pada tugas ini, kita menggunakan konsep yang sudah dipelajari untuk membuat aplikasi Daftar Postingan.

API yang digunakan:

- Daftar postingan: `https://jsonplaceholder.typicode.com/posts`
- Komentar postingan: `https://jsonplaceholder.typicode.com/posts/1/comments`

Angka `1` adalah contoh ID postingan dan bisa diganti sesuai postingan yang dipilih.

### Fitur yang harus dibuat

1. Halaman utama menampilkan daftar postingan, termasuk judul dan potongan isi.
2. Setiap postingan bisa ditekan untuk membuka halaman detail.
3. Halaman detail menampilkan isi postingan secara lengkap.
4. Komentar diambil dari API terpisah dan ditampilkan di halaman detail.
5. Model `Post` dan `Komentar` dibuat menggunakan `fromJson()`.
6. Kode pengambilan data dipisahkan dari kode tampilan.
7. Halaman daftar dan detail memiliki status loading dan error.
8. Sediakan tombol "Coba lagi" ketika terjadi error.

### Hal yang perlu dikumpulkan

- Screenshot halaman daftar postingan.
- Screenshot halaman detail beserta komentar.
- Screenshot tampilan error.
- File `main.dart` atau tautan repositori.

## 12. Perbedaan snapshot.hasError dan response.statusCode

Keduanya digunakan untuk menangani masalah, tetapi fungsinya berbeda.

- `snapshot.hasError` digunakan untuk mengetahui apakah proses pengambilan data mengalami kesalahan.
- `response.statusCode` digunakan untuk mengetahui status jawaban dari server.

Contohnya, koneksi internet terputus bisa menyebabkan proses pengambilan data gagal. Sementara itu, status `404` menunjukkan bahwa alamat atau halaman yang diminta tidak ditemukan.

Keduanya diperlukan supaya aplikasi bisa mengetahui masalah yang terjadi dan menampilkan pesan yang sesuai.

## 13. Pertanyaan Refleksi

### 1. Apa yang terjadi bila Future dibuat di dalam build() dan bukan di initState()? Mengapa?

Data bisa dimuat berulang kali setiap halaman diperbarui. Makanya, `Future` lebih baik dibuat di `initState()` supaya data tidak terus-menerus dimuat ulang.

### 2. Apa perbedaan snapshot.hasError dengan memeriksa response.statusCode? Mengapa keduanya diperlukan?

`snapshot.hasError` mengecek apakah proses pengambilan data mengalami kesalahan, sedangkan `response.statusCode` mengecek status jawaban dari server. Keduanya membantu mengetahui penyebab data gagal dimuat.

### 3. Mengapa data JSON sebaiknya diubah menjadi class model, bukan dipakai langsung sebagai Map?

Supaya data lebih rapi dan mudah dipahami. Dengan class model, kita juga lebih mudah mengambil data yang dibutuhkan dan mengurangi kesalahan saat menulis kode.

### 4. Mengapa UI wajib menyediakan status loading dan error, bukan hanya status data?

Supaya pengguna tahu kalau data sedang dimuat atau sedang terjadi masalah. Jadi, pengguna tidak bingung saat data belum muncul atau gagal ditampilkan.

## 14. Ringkasan Kode Penting

| Kode | Kegunaan |
|---|---|
| `Future` | Menjalankan proses yang hasilnya tidak langsung tersedia |
| `async` dan `await` | Menjalankan dan menunggu proses asynchronous |
| `FutureBuilder` | Menampilkan tampilan berdasarkan hasil proses `Future` |
| `http.get()` | Mengambil data dari API |
| `jsonDecode()` | Mengubah JSON menjadi data Dart |
| `fromJson()` | Mengubah data JSON menjadi objek model |
| `response.statusCode` | Mengecek status jawaban server |
| `snapshot.hasError` | Mengecek apakah proses mengalami error |
| `initState()` | Menyiapkan proses awal saat halaman dibuat |
| `setState()` | Memperbarui tampilan setelah ada perubahan |
| `ListView.builder()` | Menampilkan daftar data |
| `Navigator.push()` | Membuka halaman baru |
| `RefreshIndicator` | Memuat ulang data dengan menarik layar ke bawah |
| `data.length` | Menghitung jumlah data |

## 15. Kesimpulan

Dari pertemuan 4 ini, kita belajar mengambil data dari API, mengolah JSON menjadi class model, dan menampilkan hasilnya menggunakan `FutureBuilder`.

Kita juga belajar membuat halaman detail, memuat ulang data, serta menangani loading dan error.

Semua konsep ini bisa digunakan untuk membuat aplikasi yang membutuhkan data dari internet, seperti daftar pengguna, daftar postingan, komentar, dan berbagai informasi lainnya.

**Intinya:** aplikasi bukan hanya perlu menampilkan data, tetapi juga harus memberi tahu pengguna ketika data sedang dimuat atau ketika terjadi masalah.