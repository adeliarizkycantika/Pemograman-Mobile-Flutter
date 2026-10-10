
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// =====================================================
// PENGATURAN TEMA DAN FAVORIT
// =====================================================

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.indigo);
final daftarFavorit = ValueNotifier<Set<String>>({});

SharedPreferences? penyimpanan;

const pilihanWarna = [
  Colors.indigo,
  Colors.teal,
  Colors.deepOrange,
  Colors.pink,
];

ThemeData buatTema(Color warna, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: warna,
    brightness: brightness,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
    cardTheme: const CardThemeData(
      elevation: 1,
      margin: EdgeInsets.zero,
    ),
  );
}

Future<void> muatPengaturan() async {
  penyimpanan = await SharedPreferences.getInstance();

  final modeGelap =
      penyimpanan!.getBool('modeGelap') ?? false;
  final warnaTersimpan =
  penyimpanan!.getInt('warnaTema');

  themeMode.value =
  modeGelap ? ThemeMode.dark : ThemeMode.light;

  seedColor.value = Color(
    warnaTersimpan ?? Colors.indigo.toARGB32(),
  );
}

Future<void> simpanModeTema(ThemeMode mode) async {
  await penyimpanan?.setBool(
    'modeGelap',
    mode == ThemeMode.dark,
  );
}

Future<void> simpanWarnaTema(Color warna) async {
  await penyimpanan?.setInt(
    'warnaTema',
    warna.toARGB32(),
  );
}

void ubahFavorit(String nama) {
  final favoritBaru = Set<String>.from(daftarFavorit.value);

  if (favoritBaru.contains(nama)) {
    favoritBaru.remove(nama);
  } else {
    favoritBaru.add(nama);
  }

  daftarFavorit.value = favoritBaru;
}

// =====================================================
// MODEL WISATA
// =====================================================

class Wisata {
  final String nama;
  final String lokasi;
  final String deskripsi;
  final IconData ikon;
  final String gambar;

  const Wisata({
    required this.nama,
    required this.lokasi,
    required this.deskripsi,
    required this.ikon,
    required this.gambar,
  });
}

// =====================================================
// DATA 15 DESTINASI WISATA INDONESIA
// =====================================================

const daftarWisata = [
  Wisata(
    nama: 'Candi Borobudur',
    lokasi: 'Magelang, Jawa Tengah',
    deskripsi:
    'Candi Borobudur merupakan peninggalan bersejarah '
        'yang terkenal dengan relief dan stupa Buddha. '
        'Tempat ini cocok untuk menikmati sejarah dan '
        'keindahan arsitektur Indonesia.',
    ikon: Icons.temple_buddhist,
    gambar:
    'https://images.unsplash.com/photo-1596402184320-417e7178b2cd?auto=format&fit=crop&w=800&q=80',
  ),
  Wisata(
    nama: 'Danau Toba',
    lokasi: 'Sumatera Utara',
    deskripsi:
    'Danau Toba merupakan danau vulkanik yang luas '
        'dengan pemandangan alam yang indah. Pengunjung '
        'dapat menikmati suasana dan budaya lokal.',
    ikon: Icons.landscape,
    gambar:
    'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=800&q=80',
  ),
  Wisata(
    nama: 'Raja Ampat',
    lokasi: 'Papua Barat Daya',
    deskripsi:
    'Raja Ampat terkenal dengan gugusan pulau, air '
        'laut yang jernih, serta keanekaragaman hayati laut.',
    ikon: Icons.scuba_diving,
    gambar:
    'https://images.unsplash.com/photo-1510414842594-a61c69b5ae57?auto=format&fit=crop&w=800&q=80',
  ),
  Wisata(
    nama: 'Gunung Bromo',
    lokasi: 'Jawa Timur',
    deskripsi:
    'Gunung Bromo menawarkan pemandangan pegunungan, '
        'lautan pasir, dan matahari terbit yang indah.',
    ikon: Icons.terrain,
    gambar:
    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=80',
  ),
  Wisata(
    nama: 'Pantai Kuta',
    lokasi: 'Bali',
    deskripsi:
    'Pantai Kuta terkenal dengan garis pantainya yang '
        'panjang dan pemandangan matahari terbenam.',
    ikon: Icons.beach_access,
    gambar:
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80',
  ),
  Wisata(
    nama: 'Kota Tua',
    lokasi: 'Jakarta',
    deskripsi:
    'Kawasan Kota Tua menyimpan bangunan bersejarah '
        'dan suasana kota lama yang menarik untuk dijelajahi.',
    ikon: Icons.location_city,
    gambar:
    'https://images.unsplash.com/photo-1518005020951-eccb494ad742?auto=format&fit=crop&w=800&q=80',
  ),
  Wisata(
    nama: 'Taman Nasional Komodo',
    lokasi: 'Nusa Tenggara Timur',
    deskripsi:
    'Kawasan konservasi yang menjadi habitat komodo '
        'serta memiliki panorama pulau dan laut yang indah.',
    ikon: Icons.pets,
    gambar:
    'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=800&q=80',
  ),
  Wisata(
    nama: 'Kawah Ijen',
    lokasi: 'Banyuwangi, Jawa Timur',
    deskripsi:
    'Kawah Ijen terkenal dengan danau kawah berwarna '
        'biru kehijauan dan fenomena api biru.',
    ikon: Icons.landscape,
    gambar:
    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=80',
  ),
  Wisata(
    nama: 'Nusa Penida',
    lokasi: 'Bali',
    deskripsi:
    'Pulau dengan tebing dramatis, pantai yang indah, '
        'dan panorama laut yang menawan.',
    ikon: Icons.waves,
    gambar:
    'https://images.unsplash.com/photo-1510414842594-a61c69b5ae57?auto=format&fit=crop&w=800&q=80',
  ),
  Wisata(
    nama: 'Tana Toraja',
    lokasi: 'Sulawesi Selatan',
    deskripsi:
    'Daerah yang dikenal dengan rumah adat Tongkonan, '
        'tradisi budaya, dan pemandangan perbukitan.',
    ikon: Icons.house,
    gambar:
    'https://images.unsplash.com/photo-1518005020951-eccb494ad742?auto=format&fit=crop&w=800&q=80',
  ),
  Wisata(
    nama: 'Lawang Sewu',
    lokasi: 'Semarang, Jawa Tengah',
    deskripsi:
    'Bangunan bersejarah dengan arsitektur kolonial '
        'yang menjadi salah satu ikon Kota Semarang.',
    ikon: Icons.account_balance,
    gambar:
    'https://images.unsplash.com/photo-1518005020951-eccb494ad742?auto=format&fit=crop&w=800&q=80',
  ),
  Wisata(
    nama: 'Pantai Pink',
    lokasi: 'Pulau Komodo, Nusa Tenggara Timur',
    deskripsi:
    'Pantai unik dengan pasir bernuansa merah muda '
        'dan pemandangan laut yang jernih.',
    ikon: Icons.beach_access,
    gambar:
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80',
  ),
  Wisata(
    nama: 'Taman Mini Indonesia Indah',
    lokasi: 'Jakarta Timur',
    deskripsi:
    'Tempat wisata budaya yang memperkenalkan '
        'keragaman rumah adat dan budaya Indonesia.',
    ikon: Icons.park,
    gambar:
    'https://images.unsplash.com/photo-1518005020951-eccb494ad742?auto=format&fit=crop&w=800&q=80',
  ),
  Wisata(
    nama: 'Dieng Plateau',
    lokasi: 'Wonosobo, Jawa Tengah',
    deskripsi:
    'Dataran tinggi dengan udara sejuk, telaga warna, '
        'kawah, dan kompleks candi kuno.',
    ikon: Icons.terrain,
    gambar:
    'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=800&q=80',
  ),
  Wisata(
    nama: 'Malioboro',
    lokasi: 'Yogyakarta',
    deskripsi:
    'Jalan ikonik dengan pusat belanja, kuliner khas, '
        'dan suasana budaya Yogyakarta.',
    ikon: Icons.storefront,
    gambar:
    'https://images.unsplash.com/photo-1518005020951-eccb494ad742?auto=format&fit=crop&w=800&q=80',
  ),
];

// =====================================================
// MAIN
// =====================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await muatPengaturan();
  runApp(const MyApp());
}

// =====================================================
// APLIKASI UTAMA
// =====================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        themeMode,
        seedColor,
      ]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Jelajah Wisata Indonesia',
          debugShowCheckedModeBanner: false,
          theme: buatTema(
            seedColor.value,
            Brightness.light,
          ),
          darkTheme: buatTema(
            seedColor.value,
            Brightness.dark,
          ),
          themeMode: themeMode.value,
          initialRoute: '/',
          routes: {
            '/': (_) => const ShellPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final argumen = settings.arguments;

              if (argumen is! Wisata) {
                return MaterialPageRoute(
                  builder: (_) =>
                  const HalamanTidakDitemukan(),
                );
              }

              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    ) {
                  return DetailWisataPage(
                    wisata: argumen,
                  );
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
                transitionDuration:
                const Duration(milliseconds: 400),
              );
            }

            return null;
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (_) =>
              const HalamanTidakDitemukan(),
            );
          },
        );
      },
    );
  }
}

// =====================================================
// SHELL PAGE DAN NAVIGASI
// =====================================================

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  static const _judul = [
    'Jelajah Wisata',
    'Wisata Favorit',
    'Pengaturan',
  ];

  static const _halaman = [
    BerandaTab(),
    FavoritTab(),
    PengaturanTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_judul[_index]),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: tema.colorScheme.primaryContainer,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.travel_explore,
                        size: 48,
                        color:
                        tema.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Jelajah Indonesia',
                        style: tema.textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Beranda'),
                selected: _index == 0,
                onTap: () {
                  setState(() => _index = 0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite_outline),
                title: const Text('Favorit'),
                selected: _index == 1,
                onTap: () {
                  setState(() => _index = 1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Pengaturan'),
                selected: _index == 2,
                onTap: () {
                  setState(() => _index = 2);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _index,
        children: _halaman,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) {
          setState(() => _index = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

// =====================================================
// TAB BERANDA
// =====================================================

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Jelajahi Keindahan Indonesia',
          style: tema.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Temukan 15 destinasi menarik untuk perjalananmu.',
          style: tema.textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: daftarWisata.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            return KartuWisata(
              wisata: daftarWisata[index],
            );
          },
        ),
      ],
    );
  }
}

// =====================================================
// KARTU WISATA DENGAN FOTO DAN ANIMASI IMPLISIT
// =====================================================

class KartuWisata extends StatelessWidget {
  final Wisata wisata;

  const KartuWisata({
    super.key,
    required this.wisata,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return ListenableBuilder(
      listenable: daftarFavorit,
      builder: (context, _) {
        final favorit =
        daftarFavorit.value.contains(wisata.nama);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: favorit
                ? warna.secondaryContainer
                : warna.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: favorit
                  ? warna.secondary
                  : warna.outlineVariant,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: wisata,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Hero(
                        tag: 'wisata-${wisata.nama}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            wisata.gambar,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (
                                context,
                                error,
                                stackTrace,
                                ) {
                              return Container(
                                color: warna.surfaceContainerHighest,
                                child: Center(
                                  child: Icon(
                                    wisata.ikon,
                                    size: 56,
                                    color: warna.primary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    wisata.nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tema.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    wisata.lokasi,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: tema.textTheme.bodySmall,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      tooltip: favorit
                          ? 'Hapus dari favorit'
                          : 'Tambahkan ke favorit',
                      onPressed: () {
                        ubahFavorit(wisata.nama);
                      },
                      icon: Icon(
                        favorit
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: favorit
                            ? warna.primary
                            : warna.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// =====================================================
// TAB FAVORIT
// =====================================================

class FavoritTab extends StatelessWidget {
  const FavoritTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListenableBuilder(
      listenable: daftarFavorit,
      builder: (context, _) {
        final favorit = daftarWisata
            .where(
              (wisata) =>
              daftarFavorit.value.contains(wisata.nama),
        )
            .toList();

        if (favorit.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: tema.colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Belum ada wisata favorit',
                    style: tema.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tekan ikon hati pada kartu wisata '
                        'untuk menambahkannya.',
                    textAlign: TextAlign.center,
                    style: tema.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: favorit.length,
          separatorBuilder: (context, index) =>
          const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final wisata = favorit[index];

            return Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    wisata.gambar,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return Icon(
                        wisata.ikon,
                        size: 36,
                        color: tema.colorScheme.primary,
                      );
                    },
                  ),
                ),
                title: Text(wisata.nama),
                subtitle: Text(wisata.lokasi),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite),
                  color: tema.colorScheme.primary,
                  onPressed: () {
                    ubahFavorit(wisata.nama);
                  },
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: wisata,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

// =====================================================
// DETAIL WISATA: HERO DAN ANIMASI EKSPLISIT
// =====================================================

class DetailWisataPage extends StatefulWidget {
  final Wisata wisata;

  const DetailWisataPage({
    super.key,
    required this.wisata,
  });

  @override
  State<DetailWisataPage> createState() =>
      _DetailWisataPageState();
}

class _DetailWisataPageState
    extends State<DetailWisataPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;
    final wisata = widget.wisata;

    return Scaffold(
      appBar: AppBar(
        title: Text(wisata.nama),
        actions: [
          ListenableBuilder(
            listenable: daftarFavorit,
            builder: (context, _) {
              final favorit =
              daftarFavorit.value.contains(wisata.nama);

              return IconButton(
                tooltip: favorit
                    ? 'Hapus dari favorit'
                    : 'Tambahkan ke favorit',
                onPressed: () {
                  ubahFavorit(wisata.nama);
                },
                icon: Icon(
                  favorit
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SizedBox(
            height: 240,
            width: double.infinity,
            child: Hero(
              tag: 'wisata-${wisata.nama}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  wisata.gambar,
                  fit: BoxFit.cover,
                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Container(
                      color: warna.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          wisata.ikon,
                          size: 80,
                          color: warna.primary,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            wisata.nama,
            style: tema.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: warna.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  wisata.lokasi,
                  style: tema.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Tentang Destinasi',
            style: tema.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            wisata.deskripsi,
            style: tema.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Card(
            color: warna.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  RotationTransition(
                    turns: _controller,
                    child: Icon(
                      Icons.explore,
                      size: 40,
                      color: warna.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Ayo jelajahi keindahan Indonesia!',
                      style: tema.textTheme.titleMedium?.copyWith(
                        color: warna.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// TAB PENGATURAN
// =====================================================

class PengaturanTab extends StatelessWidget {
  const PengaturanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Tampilan Aplikasi',
          style: tema.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Atur tema sesuai kenyamananmu.',
          style: tema.textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        Card(
          child: ListenableBuilder(
            listenable: themeMode,
            builder: (context, _) {
              return SwitchListTile(
                secondary: Icon(
                  themeMode.value == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: warna.primary,
                ),
                title: const Text('Mode gelap'),
                subtitle: Text(
                  themeMode.value == ThemeMode.dark
                      ? 'Mode gelap aktif'
                      : 'Mode terang aktif',
                ),
                value: themeMode.value == ThemeMode.dark,
                onChanged: (aktif) {
                  final mode = aktif
                      ? ThemeMode.dark
                      : ThemeMode.light;

                  themeMode.value = mode;
                  simpanModeTema(mode);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Warna Tema',
          style: tema.textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Pilih warna untuk mengubah tampilan aplikasi.',
          style: tema.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        ListenableBuilder(
          listenable: seedColor,
          builder: (context, _) {
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final c in pilihanWarna)
                  GestureDetector(
                    onTap: () {
                      seedColor.value = c;
                      simpanWarnaTema(c);
                    },
                    child: CircleAvatar(
                      radius: 27,
                      backgroundColor: c,
                      child: seedColor.value == c
                          ? const Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                          : null,
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        Card(
          child: ListTile(
            leading: Icon(
              Icons.info_outline,
              color: warna.primary,
            ),
            title: const Text('Tentang Aplikasi'),
            subtitle: const Text(
              'Jelajah Wisata Indonesia',
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================
// HALAMAN 404
// =====================================================

class HalamanTidakDitemukan extends StatelessWidget {
  const HalamanTidakDitemukan({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman tidak ditemukan'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 72,
                color: tema.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                '404 - Halaman tidak ditemukan',
                style: tema.textTheme.titleLarge,
                textAlign: TextAlign.center,
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
      ),
    );
  }
}
