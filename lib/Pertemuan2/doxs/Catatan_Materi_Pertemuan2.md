# Catatan Pembelajaran Pertemuan 2 – Flutter Fundamental

## 1. Tujuan Pembelajaran

Pada Pertemuan 2, saya mempelajari cara membuat tampilan aplikasi Flutter yang lebih rapi dan terstruktur. Selain membuat tampilan, saya juga belajar menyimpan data dalam bentuk daftar, menampilkan banyak data, membuat halaman detail, dan berpindah dari satu halaman ke halaman lainnya.

Materi yang dipelajari meliputi:

* Membuat **Profile Card**.
* Menyusun tampilan menggunakan `Row` dan `Column`.
* Membuat data menggunakan `class`.
* Menampilkan data menggunakan `ListView.builder`.
* Membuat tampilan menggunakan `Card` dan `ListTile`.
* Membuat halaman detail.
* Mengirim data dari halaman daftar ke halaman detail.
* Menambahkan deskripsi dan format harga.
* Membuat aplikasi **Daftar Kontak**.


# 2. Bagian A – Profile Card

Pada bagian pertama, saya belajar membuat tampilan profil sederhana yang berisi foto, nama, NIM, dan jurusan.

### Sintaks yang dipelajari

| Sintaks              | Fungsi                                             |
| -------------------- | -------------------------------------------------- |
| `Row`                | Menyusun beberapa bagian secara menyamping.        |
| `CircleAvatar`       | Membuat gambar atau avatar berbentuk lingkaran.    |
| `SizedBox`           | Memberikan jarak antar bagian.                     |
| `Expanded`           | Memberikan ruang yang tersedia untuk suatu bagian. |
| `Column`             | Menyusun beberapa bagian dari atas ke bawah.       |
| `Container`          | Membuat bagian tertentu menjadi sebuah kotak.      |
| `Padding`            | Memberikan jarak di dalam suatu bagian.            |
| `BoxDecoration`      | Mengatur tampilan dari `Container`.                |
| `borderRadius`       | Membuat sudut kotak menjadi melengkung.            |
| `crossAxisAlignment` | Mengatur posisi bagian di dalam `Column`.          |

### Hasil

Profile Card menampilkan avatar di sebelah kiri dan informasi pengguna di sebelah kanan. Dengan susunan tersebut, tampilan menjadi lebih rapi dan mudah dibaca.


# 3. Bagian B & C – Data Makanan dan Halaman Detail

Setelah membuat Profile Card, saya belajar membuat data makanan dan menampilkannya dalam bentuk daftar. Data makanan dibuat menggunakan sebuah `class`.

Contohnya, setiap makanan memiliki **nama dan harga**. Data tersebut kemudian disimpan dalam sebuah daftar.

### Sintaks yang dipelajari

| Sintaks              | Fungsi                                                         |
| -------------------- | -------------------------------------------------------------- |
| `class Makanan`      | Membuat tempat untuk menyimpan data makanan.                   |
| `final`              | Menentukan data yang nilainya tidak diubah setelah dibuat.     |
| `const Makanan(...)` | Membuat data makanan dengan nilai yang sudah ditentukan.       |
| `ListView.builder`   | Menampilkan banyak data dalam bentuk daftar yang bisa digeser. |
| `itemCount`          | Menentukan jumlah data yang akan ditampilkan.                  |
| `itemBuilder`        | Mengatur tampilan setiap data dalam daftar.                    |
| `Card`               | Membuat tampilan menu seperti sebuah kartu.                    |
| `ListTile`           | Membantu menyusun informasi menu agar lebih rapi.              |
| `onTap`              | Menjalankan perintah ketika suatu menu ditekan.                |
| `Navigator.push`     | Membuka halaman baru.                                          |
| `MaterialPageRoute`  | Menentukan halaman yang akan dibuka.                           |
| `required`           | Menentukan data yang wajib diberikan.                          |
| `Navigator.pop`      | Kembali ke halaman sebelumnya.                                 |

### Cara kerja halaman detail

Ketika salah satu makanan ditekan, aplikasi membuka halaman detail. Data makanan yang dipilih dikirim ke halaman tersebut sehingga halaman detail dapat menampilkan informasi makanan yang sesuai.

Contohnya:

```dart
DetailPage(makanan: item)
```

Artinya, data makanan yang dipilih diberikan ke halaman detail.

### Hasil

Aplikasi dapat menampilkan beberapa makanan dalam bentuk daftar. Ketika salah satu makanan dipilih, pengguna dapat melihat informasi yang lebih lengkap pada halaman detail dan kembali ke halaman daftar.


# 4. Latihan

Pada bagian latihan, aplikasi yang sudah dibuat sebelumnya dikembangkan lagi agar memiliki informasi dan tampilan yang lebih lengkap.

### Perubahan yang dilakukan

1. **Menambahkan menu makanan**

    * Menambahkan tiga makanan baru ke dalam daftar.
    * Jumlah data makanan menjadi lebih banyak dan tetap dapat digeser.

2. **Menambahkan deskripsi**

    * Data makanan tidak hanya memiliki nama dan harga.
    * Ditambahkan juga `deskripsi` untuk menjelaskan makanan tersebut.

3. **Mengubah tampilan menu**

    * `Card` diganti dengan `Container`.
    * Ditambahkan tampilan latar dan sudut yang melengkung agar menu terlihat lebih menarik.

4. **Membuat format harga**

    * Dibuat fungsi `formatRupiah()` untuk mengubah angka menjadi format yang lebih mudah dibaca.
    * Contohnya:

      ```text
      15000 → Rp 15.000
      ```

### Sintaks baru pada latihan

| Sintaks             | Fungsi                                       |
| ------------------- | -------------------------------------------- |
| `deskripsi`         | Menambahkan penjelasan mengenai makanan.     |
| `makanan.deskripsi` | Mengambil dan menampilkan deskripsi makanan. |
| `formatRupiah()`    | Mengubah angka harga menjadi format Rupiah.  |

### Hasil

Menu makanan menjadi lebih lengkap karena memiliki nama, harga, dan deskripsi. Harga juga ditampilkan dengan format yang lebih mudah dipahami.


# 5. Tugas Mandiri – Daftar Kontak

Pada tugas mandiri, konsep yang sudah dipelajari digunakan untuk membuat aplikasi **Daftar Kontak**.

Aplikasi ini memiliki minimal enam kontak. Setiap kontak memiliki:

* Nama
* Nomor telepon
* Email

Data kontak disimpan menggunakan `class Kontak`.

### Sintaks baru yang digunakan

| Sintaks                | Fungsi                                               |
| ---------------------- | ---------------------------------------------------- |
| `class Kontak`         | Membuat tempat untuk menyimpan data kontak.          |
| `kontak.nama[0]`       | Mengambil huruf pertama dari nama kontak.            |
| `required this.kontak` | Mengirim data kontak yang dipilih ke halaman detail. |

### Tampilan Daftar Kontak

Pada halaman utama, semua kontak ditampilkan dalam bentuk daftar. Setiap kontak memiliki avatar yang berisi huruf pertama dari namanya.

Contohnya:

```text
A   Adelia Rizky Cantika
    081234567890
```

Ketika kontak ditekan, aplikasi membuka halaman detail yang menampilkan:

```text
Adelia Rizky Cantika
081234567890
adelia@gmail.com
```

Tersedia juga tombol untuk kembali ke halaman daftar kontak.


# 6. Navigasi Antarhalaman

Salah satu pembelajaran penting pada pertemuan ini adalah **navigasi**.

Alurnya:

```text
Halaman Daftar
      ↓
Pilih makanan/kontak
      ↓
Halaman Detail
      ↓
Tombol kembali
      ↓
Halaman Daftar
```

`Navigator.push` digunakan untuk membuka halaman detail, sedangkan `Navigator.pop` digunakan untuk kembali ke halaman sebelumnya.

# 7. Cara Kerja Data

Pada praktikum ini, data tidak langsung ditulis satu per satu pada tampilan. Data terlebih dahulu dibuat dan disimpan dalam daftar.

Contohnya:

```text
Data makanan
      ↓
Disimpan dalam daftar
      ↓
Ditampilkan dengan ListView
      ↓
Data dipilih
      ↓
Dikirim ke halaman detail
      ↓
Informasi ditampilkan
```

Dengan cara ini, beberapa data dapat ditampilkan menggunakan pola yang sama tanpa harus membuat tampilan satu per satu.


# 8. Pertanyaan Refleksi

### 1. Apa perbedaan `ListView` biasa dengan `ListView.builder`?

`ListView` biasa cocok untuk jumlah data yang sedikit, sedangkan `ListView.builder` lebih cocok untuk daftar data yang banyak karena data ditampilkan sesuai kebutuhan.

### 2. Mengapa `Row` yang berisi teks panjang dapat menyebabkan overflow?

Karena ruang yang tersedia terbatas, sedangkan teks membutuhkan ruang yang lebih panjang. `Expanded` membantu dengan memberikan ruang yang tersedia kepada teks agar dapat menyesuaikan dengan ukuran layar.

### 3. Bagaimana data dikirim dari halaman daftar ke halaman detail?

Data dikirim ketika pengguna memilih salah satu data. `Navigator.push` digunakan untuk membuka halaman detail, kemudian data yang dipilih diberikan kepada halaman tersebut.


# 9. Kesimpulan Pembelajaran

Pada Pertemuan 2, saya mempelajari cara membuat aplikasi Flutter yang tidak hanya menampilkan satu tampilan, tetapi sudah dapat **menampilkan banyak data dan berpindah antarhalaman**.

Saya memahami penggunaan `Row`, `Column`, `Container`, dan `CircleAvatar` untuk membuat tampilan. Saya juga mempelajari cara membuat data menggunakan `class`, menampilkannya dengan `ListView.builder`, serta membuat halaman detail menggunakan navigasi.

Melalui latihan dan tugas mandiri, saya menjadi lebih memahami bagaimana data seperti **makanan dan kontak** dapat disimpan, ditampilkan dalam daftar, dipilih, kemudian ditampilkan kembali secara lengkap pada halaman detail.
