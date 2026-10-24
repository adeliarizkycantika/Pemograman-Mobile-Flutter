# 📘 TabungKu — Catatan Pembelajaran Mini Proyek Flutter

> Catatan ringkas dari modul praktikum Flutter Pertemuan 7. Dibuat supaya mudah dipahami saat belajar ulang.

---

## 🧩 Apa Itu TabungKu?

**TabungKu** adalah aplikasi pencatat kegiatan harian yang sekaligus mencatat uang keluar-masuk dari setiap kegiatan. Tujuannya sederhana: **melatih kebiasaan menabung** dengan cara mencatat semua pengeluaran kecil yang sering terlewat.

Bayangkan kamu kuliah, kerja kelompok, nongkrong, atau kerja paruh waktu — semuanya hampir selalu berhubungan dengan uang. TabungKu membantu kamu melihat ke mana uangmu pergi setiap hari.

---

## 🎯 Tujuan Pembelajaran

Setelah menyelesaikan proyek ini, kamu diharapkan bisa:

1. Menerjemahkan kebutuhan sederhana menjadi aturan aplikasi, rancangan data, dan daftar halaman.
2. Menggabungkan semua materi Pertemuan 1–6 dalam satu aplikasi utuh.
3. Menulis perintah pengambilan data (query) untuk membuat laporan seperti **jumlah**, **total**, dan **pengelompokan**.
4. Menyusun kode ke dalam folder yang rapi.
5. Menguji aplikasi dengan skenario nyata, lalu mendokumentasikannya.

---

## 💡 Cara Kerja Aplikasi

### Kegiatan yang dicatat punya:
- **Nama** kegiatan
- **Tanggal**
- **Status** selesai atau belum
- **Jenis keuangan**, pilih salah satu:
    - `Tidak melibatkan uang`
    - `Pemasukan` (dengan nominal)
    - `Pengeluaran` (dengan nominal **dan** kategori)

### Aturan penting:
| Aturan | Penjelasan |
|---|---|
| **Tabungan harian** | Total pemasukan − total pengeluaran pada tanggal itu |
| **Nominal** | Wajib lebih dari 0 jika jenisnya pemasukan atau pengeluaran |
| **Kategori pengeluaran** | Makan, Transport, Belajar, Hiburan, Lainnya |
| **Target tabungan** | Bawaan Rp 20.000, bisa diubah dan tetap tersimpan walau aplikasi ditutup |
| **Peringatan** | Jika tabungan negatif → muncul peringatan. Jika mencapai target → muncul apresiasi 🎉 |

---

## 📊 Contoh Satu Hari

| Kegiatan | Jenis | Nominal | Kategori | Selesai |
|---|---|---|---|---|
| Kuliah pagi dan makan siang | Pengeluaran | Rp 15.000 | Makan | Ya |
| Pulang naik angkot | Pengeluaran | Rp 10.000 | Transport | Ya |
| Kerja freelance desain poster | Pemasukan | Rp 50.000 | – | Belum |
| Belajar Flutter di perpustakaan | Tidak | – | – | Belum |

**Hasil laporan hari itu:**
- Jumlah kegiatan: **2 dari 4 selesai**
- Total pemasukan: **Rp 50.000**
- Total pengeluaran: **Rp 25.000** (Makan Rp 15.000 + Transport Rp 10.000)
- Tabungan hari itu: **Rp 25.000** → melebihi target Rp 20.000, jadi **target tercapai** ✅

---

## ✨ Fitur Wajib

| Kode | Fitur |
|---|---|
| **F1** | Daftar kegiatan hari ini — bisa dicentang selesai, diubah, dan dihapus (dengan konfirmasi) |
| **F2** | Form tambah/ubah kegiatan — nama, tanggal (date picker), jenis keuangan, nominal, kategori, semuanya tervalidasi |
| **F3** | Data tersimpan di SQLite, tidak hilang saat aplikasi ditutup |
| **F4** | Ringkasan hari ini — jumlah kegiatan, pemasukan, pengeluaran, tabungan |
| **F5** | Halaman Laporan — pilih tanggal, ringkasan, pengeluaran per kategori, dan 7 hari terakhir |
| **F6** | Target tabungan harian + indikator kemajuan beranimasi |
| **F7** | Pengaturan — mode gelap, warna tema, target (semua tersimpan) |
| **F8** | Navigasi 3 tab (NavigationBar) + halaman form lewat named route |

---

## 📁 Struktur Folder

```
lib/
├── main.dart                     → tema + named routes
├── models/
│   └── kegiatan.dart             → Kegiatan, Tipe, Ringkasan
├── data/
│   └── db_helper.dart            → SQLite (CRUD + query laporan)
├── state/
│   └── pengaturan.dart           → tema, warna, target (shared_preferences)
├── utils/
│   └── format.dart               → format tanggal dan rupiah
├── widgets/
│   ├── ringkasan_card.dart       → kartu ringkasan + progress target
│   └── kegiatan_title.dart       → satu baris kegiatan
└── pages/
    ├── shell_page.dart           → NavigationBar 3 tab
    ├── beranda_page.dart         → kegiatan hari ini
    ├── form_kegiatan_page.dart   → tambah/ubah kegiatan
    ├── laporan_page.dart         → laporan
    └── pengaturan_page.dart      → pengaturan
```

---

## 🗄️ Rancangan Tabel `kegiatan`

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | INTEGER, PK | Kunci utama, auto increment |
| `judul` | TEXT | Nama kegiatan |
| `tanggal` | TEXT | Format `yyyy-MM-dd` — supaya mudah dibandingkan dan diurutkan |
| `selesai` | INTEGER (0/1) | SQLite tidak punya tipe boolean, jadi pakai angka |
| `tipe` | TEXT | `tanpa`, `pemasukan`, atau `pengeluaran` |
| `nominal` | INTEGER | Rupiah bulat (tanpa desimal), isi 0 kalau tanpa uang |
| `kategori` | TEXT | Hanya untuk pengeluaran; selain itu diisi `'-'` |

> 💡 **Kenapa tanggal pakai format `yyyy-MM-dd`?** Karena dengan format ini, urutan teks = urutan tanggal. Jadi mudah untuk dibandingkan, diurutkan, dan difilter tanpa perlu mengubah tipe data.

---

## 🔄 Alur Data dan Halaman

| Halaman | Isi Utama | Sumber Data |
|---|---|---|
| **Hari Ini** | Kartu ringkasan + daftar kegiatan hari ini + tombol tambah | `DbHelper.pada()`, `DbHelper.ringkasan()` |
| **Form Kegiatan** | Nama, tanggal, jenis keuangan, nominal, kategori | Ditulis lewat `DbHelper.tambah()` / `ubah()` |
| **Laporan** | Pilih tanggal, ringkasan, per kategori, 7 hari terakhir | `ringkasan()`, `pengeluaranPerKategori()` |
| **Pengaturan** | Slider target, saklar mode gelap, pilihan warna | `shared_preferences` |

---

## 🔁 Sinkronisasi Antar Tab — Trik `versiData`

Ada tiga tab yang menampilkan data yang sama. Kalau kamu menambah kegiatan di satu tab, tab lain harus ikut berubah tanpa perlu restart. Solusinya sederhana:

1. Di `db_helper.dart` ada variabel `ValueNotifier<int> versiData`.
2. Setiap kali ada **tambah / ubah / hapus**, nilai `versiData` dinaikkan.
3. Setiap halaman yang menampilkan data **mendengarkan** perubahan itu (`addListener`) dan memuat ulang datanya.
4. Jangan lupa **`removeListener`** di `dispose()` supaya tidak bocor memori.

Pola ini disebut **observer sederhana** — satu-satunya konsep baru di proyek ini.

---

## 🛠️ Panduan Pengerjaan (Bertahap)

| Tahap | Kegiatan | Checkpoint | Estimasi |
|---|---|---|---|
| **1** | Analisis & rancangan: sketsa 3 layar, tetapkan tabel dan aturan. Buat proyek & pasang paket. | Sketsa & skema diperiksa | 30 menit |
| **2** | Model (`Kegiatan`, `Ringkasan`), utilitas format, `DbHelper` (CRUD). | Data uji tersimpan & terbaca | 40 menit |
| **3** | Halaman Hari Ini: daftar kegiatan, centang selesai, hapus dengan konfirmasi. | Data dari SQLite tampil dan bertahan setelah restart | 40 menit |
| **4** | Form kegiatan dengan validasi; jenis keuangan menampilkan/menyembunyikan nominal & kategori. | Tambah/ubah berhasil; input salah ditolak | 40 menit |

---

## 🧠 Tiga Potongan Kode Kunci

### 1️⃣ Model ↔ Map (untuk disimpan/dibaca SQLite)

Perhatikan: `selesai` disimpan sebagai **0 atau 1** (karena SQLite tidak punya boolean), dan `tipe` disimpan sebagai **teks**.

```dart
class Kegiatan {
  // ... properti dan constructor ...

  Map<String, Object?> toMap() => {
    'id': id,
    'judul': judul,
    'tanggal': tanggal,
    'selesai': selesai ? 1 : 0,
    'tipe': tipe.name,
    'nominal': nominal,
    'kategori': kategori,
  };

  factory Kegiatan.fromMap(Map<String, Object?> m) => Kegiatan(
    id: m['id'] as int,
    judul: m['judul'] as String,
    tanggal: m['tanggal'] as String,
    selesai: (m['selesai'] as int) == 1,
    tipe: Tipe.values.byName(m['tipe'] as String),
    nominal: m['nominal'] as int,
    kategori: m['kategori'] as String,
  );
}
```

### 2️⃣ Query Laporan Harian

Satu query bisa menghasilkan seluruh angka ringkasan sekaligus. `CASE WHEN` memilah pemasukan dan pengeluaran. `COALESCE` mengganti nilai kosong (NULL) dengan 0 agar tidak error saat data belum ada.

```dart
static Future<Ringkasan> ringkasan(String tanggal) async {
  final db = await _database;
  final hasil = await db.rawQuery('''
    SELECT COUNT(*) AS jumlah,
           COALESCE(SUM(selesai), 0) AS selesai,
           COALESCE(SUM(CASE WHEN tipe = 'pemasukan' THEN nominal END), 0) AS masuk,
           COALESCE(SUM(CASE WHEN tipe = 'pengeluaran' THEN nominal END), 0) AS keluar
    FROM kegiatan
    WHERE tanggal = ?
  ''', [tanggal]);

  final baris = hasil.first;
  return Ringkasan(
    jumlahKegiatan: baris['jumlah'] as int,
    selesai: baris['selesai'] as int,
    pemasukan: baris['masuk'] as int,
    pengeluaran: baris['keluar'] as int,
  );
}
```

> 💡 **Kenapa hitung di database, bukan di Dart?** Karena database jauh lebih cepat dan ringan untuk menjumlahkan ribuan baris. Menjumlahkan di Dart baru masuk akal kalau datanya sedikit atau sudah ada di memori untuk keperluan tampilan kecil.

### 3️⃣ Memuat Ulang Saat Data Berubah

```dart
class _BerandaPageState extends State<BerandaPage> {
  late Future<DataHari> _future;

  @override
  void initState() {
    super.initState();
    _future = _ambil();
    _versiData.addListener(_muat);   // mulai mendengarkan
  }

  @override
  void dispose() {
    _versiData.removeListener(_muat); // berhenti mendengarkan
    super.dispose();
  }

  void _muat() {
    setState(() {
      _future = _ambil(); // Future baru → FutureBuilder memuat ulang
    });
  }
}
```

---

## ✅ Skenario Uji

Isi kolom hasil saat laporan dibuat. Semua skenario harus lulus sebelum demo.

| No | Langkah | Hasil yang Diharapkan |
|---|---|---|
| 1 | Tambah kegiatan "Belajar" jenis **Tidak** | Muncul di daftar; jumlah naik; pemasukan/pengeluaran tidak berubah |
| 2 | Tambah jenis **Pemasukan** Rp 50.000 | Pemasukan Rp 50.000; tabungan naik Rp 50.000; nominal hijau bertanda `+` |
| 3 | Tambah jenis **Pengeluaran** Rp 15.000 kategori Makan | Pengeluaran naik; tabungan turun; kategori Makan muncul di Laporan |
| 4 | Simpan dengan nama kosong / nominal kosong / nominal 0 | Pesan kesalahan tampil, data tidak tersimpan |
| 5 | Centang selesai dua kegiatan | Kartu ringkasan menunjukkan selesai/total benar; judul tercoret |
| 6 | Ubah nominal kegiatan yang sudah ada | Ringkasan dan laporan ikut berubah tanpa restart |
| 7 | Hapus kegiatan (pilih Batal, lalu Hapus) | Batal tidak menghapus; Hapus benar-benar menghapus |
| 8 | Tambah kegiatan bertanggal kemarin | Tidak muncul di Hari Ini; muncul di Laporan tanggal itu & daftar 7 hari |
| 9 | Ubah target & warna, aktifkan mode gelap, tutup lalu buka aplikasi | Semua pengaturan dan data tetap |
| 10 | Buat pengeluaran lebih besar dari pemasukan | Tabungan negatif berwarna merah + pesan peringatan |

---

## 🚀 Pengembangan Lanjutan (Pilih Minimal 2)

- 📊 **Rencana vs realisasi** — laporan hanya menghitung kegiatan yang selesai
- 📅 **Laporan bulanan** — ringkasan per bulan + grafik batang sederhana
- 🔍 **Pencarian & filter** — berdasarkan nama, jenis, atau kategori
- 🏷️ **Kategori kustom** — tambah tabel kategori baru (naikkan versi database + `onUpgrade`)
- 💬 **Kutipan motivasi** — ambil dari API publik lewat `http` + `FutureBuilder`
- 🔁 **Kegiatan berulang** — misal uang saku mingguan sebagai pemasukan tetap
- 📋 **Ekspor laporan** — salin teks laporan ke clipboard

---

## 📤 Ketentuan Pengumpulan

- [ ] Folder proyek (tanpa `build/`) yang bisa dijalankan dengan `flutter run`
- [ ] **README** berisi deskripsi, daftar fitur, cara menjalankan, struktur folder, dan fitur pengembangan yang dipilih
- [ ] Tabel hasil skenario uji (lulus/tidak, disertai catatan bila gagal)
- [ ] Minimal **6 tangkapan layar**: Hari Ini, Form (dengan pesan error), Laporan, Pengaturan, mode gelap, dan tabungan negatif
- [ ] **Demo 5 menit**: alur menambah pemasukan dan pengeluaran, lalu tunjukkan laporan berubah

---

## 🏆 Rubrik Penilaian

| Komponen | Kriteria | Bobot |
|---|---|---|
| **Fungsionalitas** | Fitur F1–F8 berfungsi; perhitungan laporan benar; skenario uji lulus | 35% |
| **Penerapan konsep** | Tepat memakai SQLite, form validasi, state/refresh, tema, named routes, animasi | 20% |
| **Antarmuka & UX** | Tampilan konsisten, pesan jelas, kondisi kosong/galat ditangani | 15% |
| **Kualitas kode** | Struktur folder, penamaan, tidak ada duplikasi berlebihan, controller di-dispose | 10% |
| **Pengujian & dokumentasi** | README, tabel uji, tangkapan layar | 10% |
| **Demo & pengembangan lanjutan** | Demo lancar, minimal 2 fitur lanjutan berfungsi | 10% |

---

## 🤔 Pertanyaan Refleksi (untuk Dipikirkan)

1. Mengapa tanggal disimpan sebagai teks `yyyy-MM-dd` dan **bukan** `dd/MM/yyyy`?
   > Karena urutan teks `yyyy-MM-dd` sama dengan urutan tanggal yang sebenarnya, jadi mudah diurutkan dan dibandingkan.

2. Mengapa laporan dihitung lewat **query SUM di database**, bukan dijumlahkan di Dart?
   > Database jauh lebih cepat & hemat memori untuk data banyak. Menjumlahkan di Dart lebih tepat kalau datanya sedikit atau sudah di memori.

3. Bagaimana tiga tab bisa selalu sinkron? Apa risikonya kalau `removeListener` lupa dipanggil?
   > Lewat pola `versiData` (observer). Kalau lupa `removeListener`, halaman yang sudah dihapus masih ikut mendengarkan perubahan → **memori bocor** dan bisa error.

4. Apa dampak keputusan "semua kegiatan dihitung, bukan hanya yang selesai"?
   > Pengguna melihat gambaran tabungan yang lebih realistis (uang yang sudah keluar/masuk benar-benar dihitung), tapi bisa jadi terasa "berat" saat banyak kegiatan belum selesai.

5. Bagian mana yang paling sulit? Apa yang akan kamu ubah kalau mengerjakan ulang?
   > (Jawab sendiri — ini bahan refleksi pribadi.)

---

## 🧯 Troubleshooting

| Masalah | Solusi |
|---|---|
| Ringkasan tidak berubah setelah tambah/ubah | Pastikan `versiData` dinaikkan & halaman mendengarkannya |
| Error `type 'Null' is not a subtype of 'int'` | Hasil SUM bisa NULL bila tidak ada baris → bungkus dengan `COALESCE(..., 0)` |
| `no such table` / `no such column` | Skema berubah tapi versi database tidak dinaikkan → hapus data aplikasi lalu jalankan ulang |
| Nominal masih terlihat setelah pilih "Tidak" | Sembunyikan field nominal bila jenis = tanpa, simpan 0 |
| `MissingPluginException` | Hentikan aplikasi sepenuhnya & jalankan ulang setelah menambah paket |
| Layar tertutup keyboard di form | Pakai `ListView` sebagai induk form |
| `flutter test` gagal | `test/widget_test.dart` bawaan menguji aplikasi counter — hapus atau ganti |

---

## 📚 Referensi

- Dokumentasi Flutter: [docs.flutter.dev](https://docs.flutter.dev)
- Paket `sqflite`: [pub.dev/packages/sqflite](https://pub.dev/packages/sqflite)
- Paket `shared_preferences`: [pub.dev/packages/shared_preferences](https://pub.dev/packages/shared_preferences)
- Modul Pertemuan 1–6 praktikum ini

---

## 💭 Ringkasan Satu Paragraf

**TabungKu** adalah mini proyek yang menggabungkan semua materi Flutter dari Pertemuan 1–6. Kamu akan membangun aplikasi to-do list yang **setiap kegiatannya bisa dicatat keuangannya**, lalu diringkas jadi laporan harian untuk melatih kebiasaan menabung. Konsep baru yang akan kamu pelajari hanyalah **`versiData`** (pola observer sederhana untuk sinkronisasi antar halaman) dan **query agregasi** (`COUNT`, `SUM`, `CASE WHEN`, `COALESCE`). Sisanya bisa kamu bangun dengan mengacu pada modul-modul sebelumnya.

> 📌 *Simpan catatan ini sebagai panduan saat mengerjakan. Selamat berkarya!* 🚀