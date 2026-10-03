# CATATAN BELAJAR PEMROGRAMAN MOBILE

## Pertemuan 3 – Form, Validasi, dan Provider

### A. Gambaran Umum

Pada Pertemuan 3, saya belajar membuat aplikasi yang dapat menerima **data dari pengguna**, memeriksa apakah data yang dimasukkan sudah benar, dan mengatur data tersebut agar dapat digunakan di beberapa halaman.

Materi utama yang dipelajari adalah:

1. Input data
2. Penggunaan `TextEditingController`
3. Penggunaan `setState()`
4. Form dan validasi
5. Checkbox dan pilihan data
6. Perpindahan halaman
7. Pengelolaan data dengan Provider
8. Menambah, mengubah, dan menghapus data
9. Menampilkan pesan kepada pengguna
10. Membuat aplikasi Daftar Tugas
11. Membuat aplikasi Daftar Belanja

# 1. Input Data

Input data digunakan ketika aplikasi membutuhkan pengguna untuk memasukkan sesuatu, misalnya:

* Nama
* Email
* Jurusan
* Nama tugas
* Nama barang
* Jumlah barang

Untuk membuat tempat memasukkan tulisan, digunakan **TextField**.

Contohnya:

```dart
TextField(
  controller: _controller,
  decoration: const InputDecoration(
    labelText: 'Nama',
  ),
)
```

### TextEditingController

`TextEditingController` digunakan untuk mengambil isi yang ditulis pengguna pada kolom input.

Contoh:

```dart
final _controller = TextEditingController();
```

Kemudian controller tersebut dipasang pada kolom input:

```dart
TextField(
  controller: _controller,
)
```

Untuk mengambil tulisan yang dimasukkan:

```dart
_controller.text
```

Misalnya pengguna mengetik:

> Adelia

Maka:

```dart
_controller.text
```

akan berisi:

> Adelia

### dispose()

Jika controller sudah tidak digunakan, controller perlu dihentikan penggunaannya.

Contoh:

```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

Sederhananya, `dispose()` digunakan supaya sesuatu yang sudah tidak digunakan tidak terus berada di memori.


# 2. setState()

`setState()` digunakan ketika ada perubahan data yang ingin langsung ditampilkan pada layar.

Contohnya, pengguna mengetik sebuah nama dan menekan tombol **Sapa**. Setelah tombol ditekan, tulisan pada layar berubah menjadi:

> Halo, Adelia!

Contohnya:

```dart
setState(() {
  _hasil = 'Halo, ${_controller.text}!';
});
```

### Cara mudah mengingat

**Ada perubahan data → gunakan `setState()` agar tampilan ikut berubah.**

Contoh penggunaan:

* Mengubah tulisan.
* Mengubah pilihan.
* Mengubah tanda centang.
* Mengubah nilai yang ditampilkan.


# 3. onChanged

`onChanged` digunakan ketika kita ingin melakukan sesuatu saat isi input berubah.

Contoh:

```dart
TextField(
  onChanged: (value) {
    print(value);
  },
)
```

Artinya, setiap pengguna mengetik atau mengubah tulisan, perubahan tersebut dapat diketahui oleh aplikasi.


# 4. Form

Setelah memahami input sederhana, materi dilanjutkan dengan membuat **Form**.

Form digunakan untuk mengumpulkan beberapa data sekaligus.

Misalnya form pendaftaran memiliki:

* Nama
* Email
* Jurusan
* Persetujuan

Contohnya:

```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      // input
    ],
  ),
)
```

Form membantu agar semua input dapat diperiksa sebelum data disimpan.


# 5. Validasi

Validasi digunakan untuk memastikan data yang dimasukkan pengguna sudah benar.

Misalnya:

> Nama wajib diisi.

Jika pengguna tidak mengisi nama, aplikasi akan memberikan pesan kesalahan.

Contoh:

```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Nama wajib diisi';
  }

  return null;
},
```

Jika data salah, akan muncul pesan.

Jika data sudah benar, `validator` mengembalikan:

```dart
return null;
```

Artinya data tersebut tidak memiliki masalah.


# 6. TextFormField

`TextFormField` hampir sama seperti `TextField`, tetapi digunakan bersama `Form` dan dapat memiliki pemeriksaan data.

Contoh:

```dart
TextFormField(
  controller: _namaController,
  decoration: const InputDecoration(
    labelText: 'Nama',
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Nama wajib diisi';
    }

    return null;
  },
)
```

Jadi, jika input membutuhkan pemeriksaan, `TextFormField` lebih sesuai digunakan.


# 7. GlobalKey<FormState>

Untuk memeriksa seluruh isi Form, digunakan sebuah kunci khusus.

Contoh:

```dart
final _formKey = GlobalKey<FormState>();
```

Kemudian dipasang pada Form:

```dart
Form(
  key: _formKey,
)
```

Saat tombol Simpan ditekan, form dapat diperiksa dengan:

```dart
if (_formKey.currentState!.validate()) {
  // data boleh disimpan
}
```

Artinya:

> Periksa semua input. Kalau semuanya benar, lanjutkan proses penyimpanan.


# 8. Dropdown

Dropdown digunakan jika pengguna harus memilih salah satu pilihan yang sudah disediakan.

Contohnya pada data jurusan:

* Sistem Informasi
* Informatika
* Teknik Komputer

Atau pada daftar belanja:

* Makanan
* Minuman
* Kebutuhan Rumah
* Kebutuhan Pribadi

Contoh:

```dart
DropdownButtonFormField<String>(
  value: _kategori,
  decoration: const InputDecoration(
    labelText: 'Kategori',
  ),
  items: _kategoriList.map((kategori) {
    return DropdownMenuItem(
      value: kategori,
      child: Text(kategori),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      _kategori = value;
    });
  },
)
```

Dengan dropdown, pengguna tidak perlu mengetik pilihan sendiri.


# 9. Checkbox

Checkbox digunakan untuk pilihan yang dapat dicentang atau tidak dicentang.

Contohnya:

> Saya menyetujui data yang diberikan.

Atau dalam aplikasi daftar belanja:

> Barang sudah dibeli.

Contoh:

```dart
Checkbox(
  value: _setuju,
  onChanged: (value) {
    setState(() {
      _setuju = value ?? false;
    });
  },
)
```

Jika dicentang, nilainya menjadi `true`.

Jika tidak dicentang, nilainya menjadi `false`.


# 10. Perpindahan Halaman

Dalam aplikasi, kita sering membutuhkan lebih dari satu halaman.

Contohnya pada Daftar Tugas:

**Halaman Daftar Tugas → Halaman Tambah Tugas**

Ketika pengguna menekan tombol tambah, aplikasi berpindah ke halaman berikutnya.

Contoh:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const TambahPage(),
  ),
);
```

Setelah selesai menambahkan data, pengguna dapat kembali ke halaman sebelumnya.

Contoh:

```dart
Navigator.pop(context);
```

# 11. Masalah Ketika Data Digunakan di Banyak Halaman

Misalnya kita memiliki aplikasi Daftar Tugas.

Ada dua halaman:

### Halaman pertama

Menampilkan:

> Daftar Tugas

### Halaman kedua

Digunakan untuk:

> Tambah Tugas

Ketika tugas ditambahkan di halaman kedua, halaman pertama juga harus mengetahui bahwa ada tugas baru.

Kalau data hanya disimpan di satu halaman, pengaturannya bisa menjadi lebih sulit.

Karena itu, pada Pertemuan 3 dipelajari **Provider**.


# 12. Provider

Provider digunakan untuk membantu mengatur data aplikasi.

Dengan Provider, data dapat digunakan oleh beberapa bagian aplikasi tanpa harus selalu dikirim secara manual dari satu halaman ke halaman lainnya.

Sederhananya:

> Provider adalah tempat untuk menyimpan dan mengatur data yang digunakan oleh aplikasi.

Contohnya kita mempunyai data:

```text
Daftar Tugas
- Mengerjakan laporan
- Belajar Flutter
- Membuat tugas
```

Data tersebut dapat dikelola oleh Provider dan digunakan oleh halaman daftar maupun halaman tambah.


# 13. ChangeNotifier

`ChangeNotifier` digunakan sebagai tempat untuk mengatur data yang dapat berubah.

Contoh:

```dart
class TugasModel extends ChangeNotifier {
  final List<Tugas> _items = [];
}
```

Di dalamnya kita dapat membuat kegiatan seperti:

* Menambah tugas.
* Mengubah tugas.
* Menghapus tugas.
* Menghitung tugas yang selesai.

# 14. notifyListeners()

Setelah data berubah, aplikasi perlu diberi tahu bahwa datanya sudah berubah.

Untuk itu digunakan:

```dart
notifyListeners();
```

Contohnya:

```dart
void tambah(String judul) {
  _items.add(Tugas(judul));
  notifyListeners();
}
```

Urutannya:

**Data berubah → beri tahu aplikasi → tampilan ikut diperbarui.**

Kalau `notifyListeners()` tidak dipanggil, datanya mungkin sudah berubah, tetapi tampilan belum langsung mengikuti perubahan tersebut.


# 15. context.watch()

`context.watch()` digunakan ketika halaman ingin **mengikuti perubahan data**.

Contoh:

```dart
final model = context.watch<TugasModel>();
```

Jika jumlah tugas berubah, halaman yang menggunakan `watch()` akan ikut diperbarui.

Contohnya jumlah tugas selesai ditampilkan di bagian atas:

```dart
title: Text(
  'Daftar Tugas (${model.jumlahSelesai})',
),
```

Ketika tugas selesai bertambah, angka tersebut ikut berubah.

# 16. context.read()

`context.read()` digunakan ketika kita hanya ingin **melakukan suatu tindakan terhadap data**.

Contohnya ketika tombol hapus ditekan:

```dart
context.read<TugasModel>().hapus(index);
```

Atau ketika ingin menambahkan tugas:

```dart
context.read<TugasModel>().tambah(judul);
```

### Perbedaan mudah

| Yang digunakan | Kegunaan                                |
| -------------- | --------------------------------------- |
| `watch()`      | Mengikuti perubahan data                |
| `read()`       | Mengambil data untuk melakukan tindakan |

Contoh gampang:

> **watch** → "Saya mau melihat perubahan."

> **read** → "Saya mau melakukan sesuatu."


# 17. List Data

Dalam aplikasi Daftar Tugas, beberapa tugas disimpan dalam satu daftar.

Contohnya:

```text
1. Belajar Flutter
2. Mengerjakan laporan
3. Membuat tugas
```

Data tersebut disimpan dalam sebuah daftar.

Aplikasi kemudian menampilkan data tersebut satu per satu.

# 18. Menambah Data

Ketika pengguna menekan tombol tambah, aplikasi membuka halaman untuk mengisi data.

Setelah tombol **Simpan** ditekan:

1. Judul tugas diperiksa.
2. Jika benar, tugas ditambahkan.
3. Data disimpan.
4. Pengguna kembali ke halaman daftar.
5. Daftar tugas diperbarui.

Contoh:

```dart
context.read<TugasModel>().tambah(judul);
Navigator.pop(context);
```


# 19. Mengubah Status Tugas

Pada Daftar Tugas terdapat checkbox.

Jika tugas belum selesai:

☐ Belajar Flutter

Ketika dicentang:

☑ Belajar Flutter

Tugas juga dapat diberi garis pada tulisannya sebagai tanda bahwa tugas sudah selesai.

Contohnya:

```dart
decoration: barang.sudahDibeli
    ? TextDecoration.lineThrough
    : null,
```

Tujuannya supaya pengguna lebih mudah membedakan tugas yang sudah dan belum selesai.


# 20. Menghapus Data

Data yang tidak diperlukan dapat dihapus.

Contohnya:

```dart
void hapus(int index) {
  _items.removeAt(index);
  notifyListeners();
}
```

Artinya data pada posisi tertentu dihapus dari daftar.

Setelah itu `notifyListeners()` dipanggil supaya tampilan ikut diperbarui.

# 21. removeWhere()

Pada latihan, dibuat fitur untuk menghapus semua tugas yang sudah selesai.

Contohnya:

```dart
void hapusSelesai() {
  _items.removeWhere((t) => t.selesai);
  notifyListeners();
}
```

Artinya:

> Cari semua tugas yang sudah selesai, kemudian hapus dari daftar.

Jadi pengguna tidak perlu menghapus tugas satu per satu.


# 22. SnackBar

`SnackBar` digunakan untuk memberikan pemberitahuan singkat kepada pengguna.

Contohnya setelah tugas berhasil ditambahkan:

> **Tugas ditambahkan**

Pesan tersebut muncul sebentar di bagian bawah layar.

Contoh:

```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('Tugas ditambahkan'),
  ),
);
```

Tujuannya agar pengguna tahu bahwa tindakan yang dilakukan sudah berhasil.


# 23. async dan await

Pada latihan, setelah pengguna selesai menambahkan tugas, halaman sebelumnya perlu menunggu hasil dari halaman tambah.

Contohnya:

```dart
final hasil = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const TambahPage(),
  ),
);
```

`await` berarti proses berikutnya menunggu sampai halaman yang dibuka selesai memberikan hasil.

Kemudian halaman tambah dapat mengirim hasil:

```dart
Navigator.pop(context, true);
```

Nilai `true` tersebut dapat diterima oleh halaman sebelumnya.


# 24. Tugas Mandiri – Daftar Belanja

Setelah mempelajari Daftar Tugas, materi diterapkan pada tugas mandiri berupa aplikasi **Daftar Belanja**.

Aplikasi ini digunakan untuk mencatat barang yang ingin dibeli.

Contohnya:

```text
Daftar Belanja (2)

☐ Beras
  2 - Makanan

☑ Sabun
  3 - Kebutuhan Rumah
```

Angka **2** pada bagian atas menunjukkan jumlah barang yang belum dibeli.


# 25. Data Barang

Setiap barang memiliki beberapa informasi:

* Nama barang
* Jumlah
* Kategori
* Status sudah dibeli atau belum

Contohnya:

```text
Nama       : Beras
Jumlah     : 2
Kategori   : Makanan
Status     : Belum dibeli
```


# 26. Validasi Nama Barang

Nama barang wajib diisi.

Jika pengguna langsung menekan Simpan tanpa memasukkan nama, muncul:

> **Nama barang wajib diisi**

Contoh pemeriksaan:

```dart
if (value == null || value.trim().isEmpty) {
  return 'Nama barang wajib diisi';
}
```


# 27. Validasi Jumlah

Jumlah barang juga wajib diisi.

Selain itu, jumlah harus berupa angka dan lebih dari 0.

Contoh:

```text
Kosong     → Jumlah wajib diisi
abc        → Jumlah harus berupa angka
0          → Jumlah harus lebih dari 0
2          → Benar
```

Untuk memeriksa angka digunakan:

```dart
final jumlah = int.tryParse(value.trim());
```

Dengan cara ini, aplikasi dapat memeriksa apakah tulisan yang dimasukkan dapat dianggap sebagai angka.


# 28. Validasi Kategori

Kategori juga wajib dipilih.

Jika pengguna belum memilih kategori dan menekan Simpan, akan muncul:

> **Kategori wajib dipilih**

Dengan begitu, data barang yang disimpan sudah memiliki informasi yang lengkap.


# 29. Menampilkan Barang

Setelah barang berhasil disimpan, barang tersebut akan muncul di halaman Daftar Belanja.

Contoh:

```text
Daftar Belanja (1)

☐ Beras
  2 - Makanan
```

Jika pengguna menambahkan barang lain:

```text
Daftar Belanja (2)

☐ Beras
  2 - Makanan

☐ Air Mineral
  1 - Minuman
```


# 30. Menandai Barang Sudah Dibeli

Ketika barang sudah dibeli, pengguna dapat mencentang checkbox.

Sebelum dibeli:

```text
☐ Beras
```

Setelah dibeli:

```text
☑ Beras
```

Jumlah barang yang belum dibeli juga akan berkurang.

Misalnya awalnya:

> Daftar Belanja (2)

Setelah satu barang dibeli:

> Daftar Belanja (1)


# 31. Menghapus Barang

Jika barang tidak lagi diperlukan, pengguna dapat menekan tombol hapus.

Barang tersebut akan dihapus dari daftar.

Contohnya:

```text
☐ Beras       🗑
☐ Minyak      🗑
☐ Telur       🗑
```

Jika Beras dihapus:

```text
☐ Minyak      🗑
☐ Telur       🗑
```


# 32. Perbedaan setState dan Provider

Ini salah satu bagian penting yang perlu dipahami.

### setState()

Digunakan untuk perubahan sederhana pada satu halaman.

Contohnya:

* Mengubah pilihan dropdown.
* Mengubah checkbox.
* Mengubah tulisan yang ditampilkan.

### Provider

Digunakan ketika data perlu dikelola dan digunakan pada beberapa bagian atau halaman aplikasi.

Contohnya:

* Halaman daftar membutuhkan data tugas.
* Halaman tambah memasukkan tugas.
* Setelah tugas ditambahkan, halaman daftar harus ikut berubah.

### Cara mudah mengingat

> **setState = perubahan sederhana pada halaman.**

> **Provider = mengatur data yang digunakan bersama.**


# 33. Alur Aplikasi Daftar Belanja

Secara sederhana, alurnya adalah:

```text
Halaman Daftar Belanja
          ↓
     Tekan tombol +
          ↓
   Halaman Tambah Barang
          ↓
      Isi data barang
          ↓
        Validasi
          ↓
   Data sudah benar?
       ↙       ↘
     Tidak      Ya
       ↓         ↓
  Tampilkan    Simpan
    error        ↓
                 ↓
        Kembali ke daftar
                 ↓
        Barang ditampilkan
```


# 34. Hal yang Saya Pahami dari Pertemuan 3

Setelah mempelajari materi ini, saya memahami bahwa membuat aplikasi bukan hanya tentang menampilkan tampilan. Aplikasi juga harus dapat menerima data, memeriksa data, menyimpan data, dan memperbarui tampilan ketika data berubah.

Saya juga memahami bahwa:

* `TextField` digunakan untuk memasukkan tulisan.
* `TextEditingController` digunakan untuk mengambil isi input.
* `setState()` digunakan ketika ada perubahan yang perlu ditampilkan.
* `Form` digunakan untuk mengatur beberapa input.
* Validasi digunakan untuk memastikan data benar.
* Dropdown digunakan untuk memilih data yang tersedia.
* Checkbox digunakan untuk pilihan yang dapat dicentang.
* Provider digunakan untuk mengatur data yang digunakan bersama.
* `notifyListeners()` memberi tahu bahwa data telah berubah.
* `watch()` digunakan untuk mengikuti perubahan data.
* `read()` digunakan untuk melakukan tindakan terhadap data.
* `Navigator` digunakan untuk berpindah halaman.
* `SnackBar` digunakan untuk memberikan pemberitahuan singkat.

# 35. Kesimpulan

Pertemuan 3 memberikan pemahaman tentang bagaimana membuat aplikasi yang dapat **menerima dan mengelola data dari pengguna**. Materi dimulai dari input sederhana, kemudian berkembang menjadi form dengan validasi dan akhirnya menggunakan Provider untuk mengatur data.

Melalui latihan **Daftar Tugas** dan tugas mandiri **Daftar Belanja**, saya dapat menerapkan materi tersebut secara langsung. Saya juga belajar bahwa data yang berubah harus dapat ditampilkan kembali dengan benar sehingga pengguna dapat melihat hasil tindakannya secara langsung.
