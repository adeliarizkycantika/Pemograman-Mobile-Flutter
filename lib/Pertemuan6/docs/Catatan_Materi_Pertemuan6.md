# README - Catatan Pembelajaran Pertemuan 6

## 1. Tujuan Pembelajaran

Pada Pertemuan 6, kita mempelajari cara membuat aplikasi Flutter yang lebih interaktif dan nyaman digunakan. Materi yang dipelajari meliputi:

- Mengubah tema aplikasi menjadi terang atau gelap.
- Mengubah warna utama aplikasi.
- Menyimpan pengaturan agar tidak kembali ke pengaturan awal saat aplikasi dibuka lagi.
- Berpindah halaman menggunakan named routes.
- Mengirim data dari satu halaman ke halaman lain.
- Membuat animasi pada widget.
- Menggunakan Hero untuk memberikan efek perpindahan antarhalaman.
- Membuat halaman 404 ketika halaman yang diminta tidak ditemukan.
- Menggunakan Drawer dan NavigationBar untuk berpindah menu.


## 2. Mengatur Tema Aplikasi

Tema digunakan untuk mengatur tampilan aplikasi, seperti warna utama, warna latar belakang, dan tampilan terang atau gelap.

### A. Menggunakan ThemeData

```dart
ThemeData buatTema(Color warna, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: warna,
      brightness: brightness,
    ),
  );
}
```

**Penjelasan:**

- `ThemeData` digunakan untuk mengatur tampilan aplikasi.
- `useMaterial3: true` menggunakan gaya desain Material 3.
- `ColorScheme.fromSeed()` membuat kombinasi warna berdasarkan satu warna utama.
- `seedColor` menentukan warna utama aplikasi.
- `brightness` menentukan apakah tampilan menggunakan mode terang atau gelap.

Kode ini berguna ketika kita ingin mengubah warna utama aplikasi tanpa harus mengganti warna setiap tombol atau widget satu per satu.

### B. Mengatur Tema di MaterialApp

```dart
MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: buatTema(seedColor.value, Brightness.light),
  darkTheme: buatTema(seedColor.value, Brightness.dark),
  themeMode: themeMode.value,
  home: const ShellPage(),
);
```

**Penjelasan:**

- `debugShowCheckedModeBanner: false` menghilangkan tulisan DEBUG di pojok aplikasi.
- `theme` mengatur tampilan mode terang.
- `darkTheme` mengatur tampilan mode gelap.
- `themeMode` menentukan tema yang sedang digunakan.
- `home` menentukan halaman awal aplikasi.


## 3. Menggunakan ValueNotifier

`ValueNotifier` digunakan untuk menyimpan suatu nilai yang bisa berubah dan memberi tahu widget ketika nilainya berubah.

Contohnya, untuk menyimpan mode tema dan warna utama aplikasi:

```dart
final ValueNotifier<ThemeMode> themeMode =
    ValueNotifier(ThemeMode.light);

final ValueNotifier<Color> seedColor =
    ValueNotifier(Colors.blue);
```

**Penjelasan:**

- `themeMode` menyimpan pilihan mode terang atau gelap.
- `seedColor` menyimpan warna utama aplikasi.
- `ValueNotifier` membantu memberi tahu widget ketika nilai berubah.

### Mengubah Nilai ValueNotifier

```dart
themeMode.value = ThemeMode.dark;
```

Kode tersebut mengubah tema aplikasi menjadi mode gelap.

Contoh lainnya:

```dart
seedColor.value = Colors.green;
```

Kode tersebut mengubah warna utama menjadi hijau.

### Memperbarui Tampilan dengan ListenableBuilder

```dart
ListenableBuilder(
  listenable: themeMode,
  builder: (context, child) {
    return Text(
      themeMode.value == ThemeMode.dark
          ? 'Mode Gelap'
          : 'Mode Terang',
    );
  },
);
```

Widget akan membangun ulang bagian tampilan tersebut ketika nilai `themeMode` berubah.

**Kapan digunakan?**

Gunakan `ValueNotifier` ketika ingin mengubah nilai sederhana, seperti tema atau warna, dan ingin widget terkait ikut memperbarui tampilannya.


## 4. Menyimpan Pengaturan dengan SharedPreferences

`SharedPreferences` digunakan untuk menyimpan pengaturan sederhana agar tetap tersedia ketika aplikasi dibuka kembali.

Contohnya adalah menyimpan pilihan mode gelap dan warna utama.

### A. Mengambil Akses Penyimpanan

```dart
final prefs = await SharedPreferences.getInstance();
```

Kode ini digunakan untuk mendapatkan akses ke penyimpanan lokal aplikasi.

### B. Menyimpan Data

```dart
await prefs.setBool('modeGelap', true);
await prefs.setInt('warnaTema', Colors.green.toARGB32());
```

**Penjelasan:**

- `setBool()` menyimpan data berupa `true` atau `false`.
- `setInt()` menyimpan data berupa angka.
- `'modeGelap'` dan `'warnaTema'` adalah nama kunci untuk menyimpan data.
- `await` menunggu proses penyimpanan selesai.

### C. Membaca Data

```dart
final modeGelap = prefs.getBool('modeGelap') ?? false;
final warnaTema = prefs.getInt('warnaTema');
```

Kode tersebut membaca pengaturan yang sebelumnya disimpan.

Operator `?? false` berarti jika data `modeGelap` belum tersedia atau bernilai `null`, gunakan nilai awal `false`.

### D. Menggunakan async dan await

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final modeGelap = prefs.getBool('modeGelap') ?? false;

  runApp(const MyApp());
}
```

**Penjelasan:**

- `async` menandakan bahwa fungsi menjalankan proses yang dapat menunggu.
- `await` menunggu proses tertentu selesai.
- `WidgetsFlutterBinding.ensureInitialized()` memastikan Flutter siap sebelum menjalankan proses yang membutuhkan fasilitas Flutter.
- `runApp()` menjalankan aplikasi Flutter.

Pada aplikasi sebenarnya, nilai `modeGelap` yang dibaca perlu digunakan untuk mengatur `themeMode` sebelum aplikasi ditampilkan.

**Kapan digunakan?**

SharedPreferences cocok untuk pengaturan sederhana, misalnya tema, bahasa, atau preferensi tampilan. Penyimpanan ini bukan pilihan utama untuk data yang banyak dan memiliki hubungan kompleks, seperti ratusan catatan atau transaksi.


## 5. Menggunakan setState()

`setState()` digunakan untuk memberi tahu Flutter bahwa ada perubahan data yang perlu ditampilkan kembali.

Contohnya:

```dart
bool diperbesar = false;

void ubahUkuran() {
  setState(() {
    diperbesar = !diperbesar;
  });
}
```

**Penjelasan:**

- `diperbesar` menyimpan kondisi ukuran.
- `!diperbesar` membalik nilai dari `true` menjadi `false`, atau sebaliknya.
- `setState()` meminta Flutter memperbarui tampilan widget yang terkait dengan perubahan tersebut.

**Kapan digunakan?**

Gunakan `setState()` untuk perubahan sederhana yang hanya memengaruhi tampilan pada satu bagian widget, misalnya mengubah ukuran kotak, menampilkan atau menyembunyikan teks, atau mengubah status tombol.


## 6. Animasi pada Flutter

Animasi membuat perubahan tampilan terasa lebih halus dan menarik.

### A. AnimatedContainer

`AnimatedContainer` digunakan untuk membuat perubahan ukuran, warna, jarak, atau bentuk secara otomatis dengan animasi.

```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 500),
  width: diperbesar ? 200 : 100,
  height: diperbesar ? 200 : 100,
  color: diperbesar ? Colors.green : Colors.blue,
);
```

**Penjelasan:**

- `duration` menentukan lama animasi.
- `width` mengatur lebar.
- `height` mengatur tinggi.
- `color` mengatur warna.

Ketika nilai `diperbesar` berubah dan widget dibangun ulang, ukuran dan warna akan berubah secara bertahap.

### B. AnimatedSwitcher

`AnimatedSwitcher` digunakan untuk memberikan animasi ketika widget yang ditampilkan berganti.

```dart
AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  child: Text(
    diperbesar ? 'Ukuran Besar' : 'Ukuran Kecil',
    key: ValueKey(diperbesar),
  ),
);
```

`ValueKey` membantu Flutter mengenali bahwa widget yang ditampilkan sudah berubah sehingga pergantian dapat dianimasikan.

### C. AnimatedOpacity

`AnimatedOpacity` digunakan untuk mengatur tingkat transparansi widget.

```dart
AnimatedOpacity(
  opacity: diperbesar ? 1.0 : 0.0,
  duration: const Duration(milliseconds: 500),
  child: const Text('Halo Flutter'),
);
```

**Penjelasan:**

- `opacity: 1.0` berarti widget terlihat sepenuhnya.
- `opacity: 0.0` berarti widget tidak terlihat.
- `duration` mengatur lama perubahan transparansi.

Perlu diingat, widget yang transparan belum tentu tidak bisa menerima sentuhan. Jika ingin benar-benar menonaktifkan interaksi, gunakan pengaturan tambahan yang sesuai.

### D. AnimationController

`AnimationController` digunakan ketika kita ingin mengatur jalannya animasi dengan lebih langsung, misalnya memulai, menghentikan, atau mengulang animasi.

Contoh dasar:

```dart
class _AnimasiPageState extends State<AnimasiPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
```

**Penjelasan:**

- `SingleTickerProviderStateMixin` menyediakan `vsync` untuk satu `AnimationController`.
- `initState()` menyiapkan controller saat halaman dibuat.
- `duration` menentukan lama animasi.
- `dispose()` membersihkan controller saat halaman tidak lagi digunakan.

Contoh memulai animasi:

```dart
controller.forward();
```

Contoh mengulang animasi:

```dart
controller.repeat();
```

**Catatan penting:** Contoh ini adalah kerangka dasar. Agar animasinya terlihat, controller perlu dihubungkan ke widget, misalnya menggunakan `RotationTransition` atau `AnimatedBuilder`.

### E. Perbedaan Animasi Implisit dan Eksplisit

| Jenis | Penjelasan | Contoh |
|---|---|---|
| Implisit | Perubahan dianimasikan otomatis ketika nilai widget berubah. | `AnimatedContainer`, `AnimatedOpacity` |
| Eksplisit | Jalannya animasi dikontrol secara langsung. | `AnimationController`, `RotationTransition` |


## 7. Navigasi Antarhalaman

Navigasi digunakan untuk berpindah dari satu halaman ke halaman lain.

### A. Membuka Halaman dengan Named Routes

```dart
Navigator.pushNamed(
  context,
  '/detail',
  arguments: item,
);
```

**Penjelasan:**

- `pushNamed()` membuka halaman berdasarkan nama route.
- `'/detail'` adalah nama route yang dituju.
- `arguments: item` mengirimkan data `item` ke halaman detail.

Nama route harus sesuai dengan pengaturan navigasi pada `MaterialApp`.

### B. Kembali ke Halaman Sebelumnya

```dart
Navigator.pop(context);
```

Kode tersebut menutup halaman yang sedang terbuka dan kembali ke halaman sebelumnya jika tersedia.

### C. Mengatur Route Menggunakan onGenerateRoute

```dart
onGenerateRoute: (settings) {
  if (settings.name == '/detail') {
    final argumen = settings.arguments;

    if (argumen is! Item) {
      return MaterialPageRoute(
        builder: (_) => const HalamanTidakDitemukan(),
      );
    }

    return MaterialPageRoute(
      settings: settings,
      builder: (_) => DetailPage(item: argumen),
    );
  }

  return null;
},
```

**Penjelasan:**

- `settings.name` memeriksa nama halaman yang ingin dibuka.
- `settings.arguments` mengambil data yang dikirim.
- `is! Item` memeriksa apakah data bukan objek `Item`.
- `MaterialPageRoute` membuat jalur untuk membuka halaman.
- `return null` berarti route tersebut tidak ditangani oleh bagian ini, sehingga Flutter dapat melanjutkan pencarian route, termasuk ke `onUnknownRoute`.

Pemeriksaan tipe data berguna agar halaman detail tidak menerima data yang tidak sesuai.

### D. Memberikan Animasi saat Berpindah Halaman

```dart
return PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) {
    return DetailPage(item: argumen);
  },
  transitionsBuilder: (
    context,
    animation,
    secondaryAnimation,
    child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  },
);
```

Kode ini memberikan efek memudar ketika halaman detail dibuka.

**Catatan:** Contoh tersebut digunakan di dalam kondisi route detail setelah `argumen` dipastikan merupakan objek `Item`.


## 8. Mengirim Data ke Halaman Detail

Aplikasi dapat mengirim data suatu item ketika pengguna memilihnya dari daftar.

Contoh model data:

```dart
class Item {
  final String nama;
  final String deskripsi;
  final IconData ikon;

  const Item({
    required this.nama,
    required this.deskripsi,
    required this.ikon,
  });
}
```

Model `Item` digunakan untuk mengelompokkan informasi yang dimiliki suatu item.

Contoh membuka halaman detail:

```dart
Navigator.pushNamed(
  context,
  '/detail',
  arguments: item,
);
```

Di halaman tujuan, data tersebut diterima melalui parameter:

```dart
class DetailPage extends StatelessWidget {
  final Item item;

  const DetailPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.nama),
      ),
      body: Center(
        child: Text(item.deskripsi),
      ),
    );
  }
}
```

**Kegunaannya:** Halaman detail dapat menampilkan informasi sesuai item yang dipilih pengguna, tanpa harus membuat halaman terpisah untuk setiap item.


## 9. Menggunakan Hero Animation

`Hero` digunakan untuk memberikan efek perpindahan yang menyambungkan widget pada halaman pertama dengan widget pada halaman berikutnya.

Contoh pada halaman daftar:

```dart
Hero(
  tag: 'ikon-item',
  child: Icon(
    item.ikon,
    size: 50,
  ),
);
```

Contoh pada halaman detail:

```dart
Hero(
  tag: 'ikon-item',
  child: Icon(
    item.ikon,
    size: 120,
  ),
);
```

**Penjelasan:**

- `Hero` membungkus widget yang akan dianimasikan.
- `tag` menjadi penanda untuk menghubungkan kedua widget.
- Nilai `tag` pada kedua halaman harus sama dan unik untuk pasangan widget tersebut.

Jika ukuran ikon berbeda pada kedua halaman, Flutter dapat menampilkan efek perpindahan ukuran saat navigasi berlangsung.


## 10. Membuat Halaman 404

Halaman 404 digunakan untuk memberi tahu pengguna bahwa halaman yang diminta tidak tersedia.

### A. Membuat Halaman Tidak Ditemukan

```dart
class HalamanTidakDitemukan extends StatelessWidget {
  const HalamanTidakDitemukan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Tidak Ditemukan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              '404 - Halaman tidak ditemukan',
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan:**

- `Scaffold` menjadi kerangka halaman.
- `Center` meletakkan isi di bagian tengah.
- `Icon` menampilkan ikon kesalahan.
- `FilledButton` membuat tombol untuk kembali ke beranda.
- `pushNamedAndRemoveUntil()` membuka halaman beranda sekaligus menghapus halaman sebelumnya dari riwayat navigasi.

### B. Mengatur onUnknownRoute

```dart
onUnknownRoute: (settings) {
  return MaterialPageRoute(
    builder: (_) => const HalamanTidakDitemukan(),
  );
},
```

Kode tersebut menentukan halaman yang ditampilkan ketika nama route tidak dikenali oleh sistem navigasi.

Jika menggunakan `onGenerateRoute`, route yang tidak ditangani oleh fungsi tersebut perlu mengembalikan `null` agar Flutter dapat melanjutkan ke `onUnknownRoute`.

### C. Menguji Halaman 404

```dart
FilledButton.icon(
  onPressed: () {
    Navigator.pushNamed(
      context,
      '/halaman-tidak-ada',
    );
  },
  icon: const Icon(Icons.warning_amber),
  label: const Text('Test Halaman 404'),
);
```

Kode ini dapat ditambahkan di halaman beranda sebagai tombol pengujian.

Ketika tombol ditekan, aplikasi mencoba membuka route yang tidak terdaftar. Jika konfigurasi navigasinya benar, aplikasi akan menampilkan halaman 404.


## 11. Menggunakan IndexedStack

`IndexedStack` digunakan untuk menampilkan salah satu dari beberapa widget berdasarkan indeks yang dipilih.

```dart
IndexedStack(
  index: indeksTerpilih,
  children: const [
    BerandaTab(),
    AnimasiTab(),
    PengaturanTab(),
  ],
);
```

**Penjelasan:**

- `index` menentukan halaman yang sedang terlihat.
- `children` berisi kumpulan halaman yang dapat ditampilkan.

Berbeda dengan mengganti widget secara langsung, `IndexedStack` dapat mempertahankan keadaan halaman yang tidak sedang terlihat selama widget tersebut tetap berada di dalamnya.

**Kapan digunakan?**

Cocok untuk aplikasi yang memiliki beberapa menu utama, misalnya Beranda, Animasi, dan Pengaturan.


## 12. Menggunakan Drawer dan NavigationBar

### A. Drawer

`Drawer` adalah menu samping yang biasanya berisi daftar pilihan halaman atau menu.

```dart
Drawer(
  child: ListView(
    children: [
      const DrawerHeader(
        child: Text('Menu Aplikasi'),
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text('Beranda'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ],
  ),
);
```

**Penjelasan:**

- `Drawer` membuat menu samping.
- `DrawerHeader` menampilkan bagian kepala menu.
- `ListTile` membuat satu baris menu.
- `leading` menampilkan ikon.
- `title` menampilkan tulisan menu.
- `onTap` dijalankan ketika menu ditekan.

Pada contoh ini, `Navigator.pop(context)` menutup Drawer. Jika ingin sekaligus berpindah tab, indeks tab juga perlu diubah.

### B. NavigationBar

`NavigationBar` digunakan untuk membuat menu navigasi di bagian bawah aplikasi.

```dart
NavigationBar(
  selectedIndex: indeksTerpilih,
  onDestinationSelected: (index) {
    setState(() {
      indeksTerpilih = index;
    });
  },
  destinations: const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      label: 'Beranda',
    ),
    NavigationDestination(
      icon: Icon(Icons.animation),
      label: 'Animasi',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings),
      label: 'Pengaturan',
    ),
  ],
);
```

**Penjelasan:**

- `selectedIndex` menunjukkan menu yang sedang dipilih.
- `onDestinationSelected` dijalankan ketika pengguna memilih menu.
- `setState()` memperbarui indeks agar menu yang dipilih berubah.
- `destinations` berisi daftar menu yang tersedia.


## 13. Memahami initState() dan dispose()

Kedua fungsi ini sering digunakan saat membuat halaman Flutter yang membutuhkan proses persiapan atau pengelolaan animasi.

### initState()

```dart
@override
void initState() {
  super.initState();

  // Persiapan yang dilakukan saat halaman dibuat.
}
```

`initState()` dijalankan saat objek `State` dibuat. Fungsi ini cocok untuk menyiapkan controller animasi atau memulai proses awal yang diperlukan halaman.

### dispose()

```dart
@override
void dispose() {
  controller.dispose();
  super.dispose();
}
```

`dispose()` digunakan untuk membersihkan objek atau sumber daya yang sudah tidak digunakan, seperti `AnimationController`.

Jika controller tidak dibersihkan, sumber daya yang sudah tidak diperlukan bisa tetap digunakan lebih lama dari seharusnya.


## 14. Ringkasan Kode Penting

| Kode | Fungsi |
|---|---|
| `ThemeData` | Mengatur tampilan tema aplikasi |
| `ColorScheme.fromSeed()` | Membuat kombinasi warna dari satu warna utama |
| `ValueNotifier` | Menyimpan nilai yang bisa berubah dan memberi tahu widget |
| `ListenableBuilder` | Memperbarui bagian tampilan ketika nilai yang diamati berubah |
| `SharedPreferences` | Menyimpan pengaturan sederhana di perangkat |
| `async` dan `await` | Menjalankan dan menunggu proses yang membutuhkan waktu |
| `setState()` | Meminta Flutter memperbarui tampilan setelah perubahan nilai |
| `AnimatedContainer` | Menganimasikan perubahan ukuran, warna, atau bentuk |
| `AnimatedSwitcher` | Menganimasikan pergantian widget |
| `AnimatedOpacity` | Menganimasikan perubahan transparansi |
| `AnimationController` | Mengatur jalannya animasi secara langsung |
| `Navigator.pushNamed()` | Membuka halaman berdasarkan nama route |
| `Navigator.pop()` | Kembali ke halaman sebelumnya atau menutup Drawer |
| `onGenerateRoute` | Mengatur pembuatan route secara khusus |
| `onUnknownRoute` | Menangani route yang tidak ditemukan |
| `Hero` | Menghubungkan animasi widget antarhalaman |
| `IndexedStack` | Menampilkan salah satu dari beberapa widget dan mempertahankan keadaan widget lainnya |
| `Drawer` | Membuat menu samping |
| `NavigationBar` | Membuat menu navigasi di bagian bawah |
| `initState()` | Menyiapkan kebutuhan halaman saat dibuat |
| `dispose()` | Membersihkan sumber daya yang sudah tidak digunakan |


## 15. Kesimpulan

Pada Pertemuan 6, kita belajar membuat aplikasi Flutter yang lebih interaktif dengan pengaturan tema, penyimpanan preferensi, navigasi, dan animasi.

`ValueNotifier` membantu mengelola perubahan nilai seperti tema dan warna. `SharedPreferences` menyimpan pengaturan sederhana agar tetap tersedia saat aplikasi dibuka kembali. Animasi seperti `AnimatedContainer`, `AnimatedSwitcher`, dan `AnimationController` membuat tampilan lebih menarik.

Selain itu, named routes membantu mengatur perpindahan halaman, `Hero` memberikan efek perpindahan antarhalaman, dan `onUnknownRoute` dapat digunakan untuk menampilkan halaman 404 saat route tidak ditemukan.

Materi ini menjadi dasar untuk membuat aplikasi Flutter dengan tampilan yang lebih nyaman, navigasi yang jelas, dan pengaturan yang dapat diingat oleh aplikasi.