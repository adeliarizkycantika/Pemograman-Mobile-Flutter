
# LAPORAN PRAKTIKUM PEMROGRAMAN MOBILE

## Pertemuan 1 – Flutter Fundamental

### Pengenalan Flutter, Instalasi, dan Aplikasi Pertama


## A. Instalasi dan Verifikasi

Pada tahap pertama dilakukan pengecekan instalasi Flutter dan komponen pendukungnya. Pengecekan dilakukan melalui Terminal menggunakan perintah:

```bash
flutter doctor
````

Perintah tersebut digunakan untuk melihat apakah Flutter dan komponen yang diperlukan sudah siap digunakan.

Selanjutnya dilakukan pengecekan lisensi Android SDK dengan perintah:

```bash
flutter doctor --android-licenses
```

Setelah proses selesai, lisensi Android SDK disetujui agar dapat digunakan untuk menjalankan aplikasi Flutter pada Android.


## B. Membuat Project Flutter

Project Flutter dibuat menggunakan Terminal dengan beberapa perintah berikut:

```bash
flutter create praktikum_1
cd praktikum_1
flutter run
```

`flutter create` digunakan untuk membuat project Flutter baru.

`cd praktikum_1` digunakan untuk masuk ke folder project.

`flutter run` digunakan untuk menjalankan aplikasi Flutter pada emulator atau perangkat yang terhubung.

Setelah berhasil dijalankan, muncul aplikasi bawaan Flutter berupa aplikasi Counter.


## C. Struktur Project Flutter

Setelah project dibuat, terdapat beberapa file dan folder penting di dalam project.

| File/Folder     | Keterangan                                                   |
| --------------- | ------------------------------------------------------------ |
| `lib/main.dart` | File utama untuk menulis kode aplikasi Flutter.              |
| `pubspec.yaml`  | Digunakan untuk mengatur dependency dan konfigurasi project. |
| `android/`      | Berisi bagian project untuk platform Android.                |
| `ios/`          | Berisi bagian project untuk platform iOS.                    |
| `test/`         | Digunakan untuk menyimpan file pengujian aplikasi.           |


## D. Aplikasi Hello Flutter

Pada tahap ini dibuat aplikasi sederhana yang menampilkan tulisan pada bagian tengah halaman.

Kode yang digunakan:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 1',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hello Flutter'),
        ),
        body: const Center(
          child: Text(
            'Halo, nama saya [NAMA]!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
```

Pada tahap ini dipelajari penggunaan `MaterialApp`, `Scaffold`, `AppBar`, `Center`, dan `Text`.

Nama `[NAMA]` kemudian diganti dengan nama masing-masing.

### Hasil

Aplikasi menampilkan tulisan:

**Halo, nama saya [NAMA]!**

di bagian tengah halaman.


## E. Widget Layout Dasar

Pada tahap ini tampilan aplikasi dikembangkan dengan menambahkan icon, nama, dan NIM.

Bagian `body` diubah menjadi:

```dart
body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Icon(
        Icons.flutter_dash,
        size: 80,
        color: Colors.blue,
      ),
      SizedBox(height: 16),
      Text(
        'Halo, nama saya [NAMA]!',
        style: TextStyle(fontSize: 24),
      ),
      Text('NIM: [NIM]'),
    ],
  ),
),
```

### Widget yang digunakan

* `Column` digunakan untuk menyusun widget secara vertikal.
* `mainAxisAlignment: MainAxisAlignment.center` digunakan untuk menempatkan isi di bagian tengah.
* `Icon` digunakan untuk menampilkan icon Flutter.
* `SizedBox` digunakan untuk memberikan jarak.
* `Text` digunakan untuk menampilkan nama dan NIM.

### Hasil

Tampilan aplikasi menampilkan icon Flutter, nama, dan NIM secara vertikal di tengah halaman.


## F. Widget Interaktif

Pada tahap ini dibuat aplikasi Counter menggunakan `StatefulWidget`.

Kode yang digunakan:

```dart
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Saya'),
      ),
      body: Center(
        child: Text(
          '$_count',
          style: const TextStyle(fontSize: 48),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _count++),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

Variabel `_count` digunakan untuk menyimpan nilai angka pada Counter.

Ketika tombol tambah ditekan, nilai `_count` akan bertambah satu.

### `setState()`

`setState()` digunakan untuk memberi tahu Flutter bahwa terdapat perubahan nilai sehingga tampilan aplikasi dapat diperbarui.


# Latihan Mandiri

Pada latihan mandiri, aplikasi Counter yang sudah dibuat sebelumnya dikembangkan kembali.

## 1. Mengubah Warna AppBar dan Teks

Warna `AppBar` dan teks diubah sesuai keinginan menggunakan:

```dart
backgroundColor: Colors.deepPurple,
```

dan:

```dart
color: Colors.white,
```

`backgroundColor` digunakan untuk mengatur warna latar belakang, sedangkan `color` digunakan untuk mengatur warna teks atau icon.


## 2. Menambahkan Tombol Kurang

Ditambahkan tombol dengan icon:

```dart
Icons.remove
```

Tombol tersebut digunakan untuk mengurangi nilai Counter.

Perintah yang digunakan:

```dart
_count--;
```

Perintah tersebut mengurangi nilai `_count` sebanyak satu.


## 3. Menambahkan Tombol Reset

Ditambahkan tombol reset menggunakan:

```dart
Icons.refresh
```

Ketika tombol reset ditekan, nilai Counter dikembalikan menjadi:

```dart
_count = 0;
```


## 4. Mencegah Angka Menjadi Negatif

Agar nilai Counter tidak menjadi negatif, digunakan kondisi:

```dart
if (_count > 0)
```

Contohnya:

```dart
void _kurang() {
  if (_count > 0) {
    setState(() {
      _count--;
    });
  }
}
```

Jika nilai Counter sudah mencapai 0, tombol kurang tidak akan mengurangi angka lagi.


## Sintaks Penting pada Latihan

| Sintaks           | Fungsi                                  |
| ----------------- | --------------------------------------- |
| `backgroundColor` | Mengatur warna latar belakang AppBar.   |
| `color`           | Mengatur warna teks atau icon.          |
| `Icons.remove`    | Menampilkan icon kurang.                |
| `Icons.refresh`   | Menampilkan icon reset.                 |
| `_count++`        | Menambah nilai Counter sebanyak 1.      |
| `_count--`        | Mengurangi nilai Counter sebanyak 1.    |
| `_count = 0`      | Mengembalikan nilai Counter menjadi 0.  |
| `if (_count > 0)` | Mencegah nilai Counter menjadi negatif. |


# Tugas – Kartu Perkenalan

Pada tugas ini dibuat aplikasi **Kartu Perkenalan** yang menampilkan informasi diri.

Informasi yang ditampilkan terdiri dari:

* Foto atau icon
* Nama
* NIM
* Jurusan
* Hobi

Contoh kode:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kartu Perkenalan',
      home: const IntroductionCard(),
    );
  }
}

class IntroductionCard extends StatelessWidget {
  const IntroductionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kartu Perkenalan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_circle,
              size: 120,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 20),
            const Text(
              'Adelia Rizky Cantika',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'NIM: [NIM]',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Jurusan: Sistem Informasi',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hobi: Membaca dan Mendengarkan Musik',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Catatan:** bagian `[NIM]` diganti dengan NIM masing-masing.

### Sintaks Baru pada Tugas

```dart
Icons.account_circle
```

Digunakan untuk menampilkan icon akun atau profil sebagai pengganti foto.

```dart
fontWeight: FontWeight.bold
```

Digunakan untuk membuat tulisan menjadi tebal.


# Refleksi

## 1. Apa perbedaan StatelessWidget dan StatefulWidget?

`StatelessWidget` tampilannya tidak berubah, sedangkan `StatefulWidget` dapat berubah ketika datanya berubah.

## 2. Mengapa perubahan variabel `_count` perlu dibungkus `setState()`?

Karena `setState()` memberi tahu Flutter bahwa ada perubahan data sehingga tampilan ikut diperbarui.

## 3. Apa keuntungan Hot Reload dibanding rebuild penuh?

Hot Reload lebih cepat karena perubahan kode bisa langsung terlihat tanpa menjalankan ulang aplikasi dari awal.


# Hasil Praktikum

Dari praktikum Pertemuan 1, beberapa aplikasi dan latihan yang berhasil dibuat adalah:

1. Aplikasi Hello Flutter.
2. Tampilan layout dengan icon, nama, dan NIM.
3. Aplikasi Counter menggunakan `StatefulWidget`.
4. Counter dengan tombol tambah, kurang, dan reset.
5. Counter yang tidak dapat menghasilkan angka negatif.
6. Kartu Perkenalan yang berisi informasi diri.


# Kesimpulan

Pada Pertemuan 1, saya mempelajari dasar-dasar Flutter mulai dari instalasi dan pengecekan Flutter, membuat project baru, mengenal struktur project, sampai membuat aplikasi sederhana.

Saya juga mempelajari penggunaan beberapa widget dasar seperti `Text`, `Icon`, `Column`, `SizedBox`, `Scaffold`, dan `AppBar`. Selain itu, saya memahami perbedaan `StatelessWidget` dan `StatefulWidget`, penggunaan `setState()`, serta manfaat Hot Reload.

Melalui latihan Counter dan tugas Kartu Perkenalan, saya dapat memahami cara membuat tampilan sederhana dan menambahkan fungsi interaksi pada aplikasi Flutter.


Versi ini aku susun mengikuti **urutan dan materi yang ada di modul Pertemuan 1**, bukan menambahkan materi Flutter lain di luar tugas. :contentReference[oaicite:0]{index=0} :contentReference[oaicite:1]{index=1} :contentReference[oaicite:2]{index=2}

**Yang perlu kamu ubah sebelum disimpan:** semua bagian `[NIM]` dan `[NAMA]` kalau masih ada.
```
