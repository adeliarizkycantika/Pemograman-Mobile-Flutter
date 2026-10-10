import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.indigo);

const List<Color> pilihanWarna = [
  Colors.indigo,
  Colors.teal,
  Colors.deepOrange,
  Colors.pink,
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final gelap = prefs.getBool('modeGelap') ?? false;
  final warnaIndex = prefs.getInt('warnaTema') ?? 0;

  themeMode.value = gelap ? ThemeMode.dark : ThemeMode.light;
  seedColor.value = pilihanWarna[
  warnaIndex >= 0 && warnaIndex < pilihanWarna.length
      ? warnaIndex
      : 0
  ];

  runApp(const MyApp());
}

ThemeData buatTema(Color seed, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: brightness,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Praktikum 6',
          debugShowCheckedModeBanner: false,
          theme: buatTema(seedColor.value, Brightness.light),
          darkTheme: buatTema(seedColor.value, Brightness.dark),
          themeMode: themeMode.value,
          initialRoute: '/',
          routes: {
            '/': (_) => const ShellPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final item = settings.arguments;

              if (item is Item) {
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return DetailPage(item: item);
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                );
              }
            }

            return null;
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const NotFoundPage(),
            );
          },
        );
      },
    );
  }
}

class Item {
  final String nama;
  final IconData ikon;
  final Color warna;

  const Item(this.nama, this.ikon, this.warna);
}

const daftarItem = [
  Item('Flutter', Icons.flutter_dash, Colors.blue),
  Item('Musik', Icons.music_note, Colors.pink),
  Item('Kamera', Icons.camera_alt, Colors.orange),
  Item('Peta', Icons.map, Colors.green),
];

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: daftarItem.length,
      itemBuilder: (context, i) {
        final item = daftarItem[i];

        return ListTile(
          leading: Hero(
            tag: 'ikon-${item.nama}',
            child: CircleAvatar(
              backgroundColor: item.warna,
              child: Icon(item.ikon, color: Colors.white),
            ),
          ),
          title: Text(
            item.nama,
            style: tema.textTheme.titleMedium,
          ),
          subtitle: const Text('Ketuk untuk melihat detail'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/detail',
              arguments: item,
            );
          },
        );
      },
    );
  }
}

class DetailPage extends StatelessWidget {
  final Item item;

  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(item.nama)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'ikon-${item.nama}',
              child: CircleAvatar(
                radius: 64,
                backgroundColor: item.warna,
                child: Icon(
                  item.ikon,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.nama,
              style: tema.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Detail untuk ${item.nama}',
              style: tema.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimasiTab extends StatefulWidget {
  const AnimasiTab({super.key});

  @override
  State<AnimasiTab> createState() => _AnimasiTabState();
}

class _AnimasiTabState extends State<AnimasiTab>
    with SingleTickerProviderStateMixin {
  bool _besar = false;
  bool _tampil = true;
  int _hitung = 0;
  late final AnimationController _putar;

  @override
  void initState() {
    super.initState();

    _putar = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _putar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '1. AnimatedContainer',
          style: tema.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: _besar ? 200 : 100,
            height: 100,
            decoration: BoxDecoration(
              color: _besar ? warna.primary : warna.tertiary,
              borderRadius: BorderRadius.circular(_besar ? 50 : 8),
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _besar = !_besar),
          child: const Text('Ubah bentuk'),
        ),
        const Divider(height: 32),
        Text(
          '2. AnimatedSwitcher',
          style: tema.textTheme.titleMedium,
        ),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animasi) {
              return ScaleTransition(
                scale: animasi,
                child: child,
              );
            },
            child: Text(
              '$_hitung',
              key: ValueKey(_hitung),
              style: tema.textTheme.displayMedium,
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _hitung++),
          child: const Text('Tambah'),
        ),
        const Divider(height: 32),
        Text(
          '3. AnimationController',
          style: tema.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Center(
          child: RotationTransition(
            turns: _putar,
            child: Icon(
              Icons.settings,
              size: 64,
              color: warna.primary,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              if (_putar.isAnimating) {
                _putar.stop();
              } else {
                _putar.repeat();
              }
            });
          },
          child: Text(
            _putar.isAnimating ? 'Berhenti' : 'Putar',
          ),
        ),
        const Divider(height: 32),
        Text(
          '4. AnimatedOpacity',
          style: tema.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Center(
          child: AnimatedOpacity(
            opacity: _tampil ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: Card(
              child: SizedBox(
                width: 200,
                height: 100,
                child: Center(
                  child: Text(
                    'Kartu Animasi',
                    style: tema.textTheme.titleMedium,
                  ),
                ),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _tampil = !_tampil),
          child: Text(_tampil ? 'Sembunyikan' : 'Tampilkan'),
        ),
      ],
    );
  }
}

class PengaturanTab extends StatelessWidget {
  const PengaturanTab({super.key});

  Future<void> _simpanMode(bool gelap) async {
    themeMode.value = gelap ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modeGelap', gelap);
  }

  Future<void> _simpanWarna(Color warna) async {
    seedColor.value = warna;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('warnaTema', pilihanWarna.indexOf(warna));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        final tema = Theme.of(context);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Pengaturan Tampilan',
              style: tema.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Mode gelap'),
              value: themeMode.value == ThemeMode.dark,
              onChanged: _simpanMode,
            ),
            const SizedBox(height: 16),
            Text(
              'Warna tema',
              style: tema.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                for (final warna in pilihanWarna)
                  GestureDetector(
                    onTap: () => _simpanWarna(warna),
                    child: CircleAvatar(
                      backgroundColor: warna,
                      child: seedColor.value == warna
                          ? const Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                          : null,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Pengaturan tema akan tetap tersimpan '
                  'setelah aplikasi ditutup.',
              style: tema.textTheme.bodyMedium,
            ),
          ],
        );
      },
    );
  }
}

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  static const _halaman = [
    BerandaTab(),
    AnimasiTab(),
    PengaturanTab(),
  ];

  static const _judul = [
    'Beranda',
    'Animasi',
    'Pengaturan',
  ];

  void _pindahTab(int index) {
    setState(() => _index = index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_judul[_index])),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Text(
                    'Praktikum 6',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Beranda'),
                selected: _index == 0,
                onTap: () => _pindahTab(0),
              ),
              ListTile(
                leading: const Icon(Icons.animation),
                title: const Text('Animasi'),
                selected: _index == 1,
                onTap: () => _pindahTab(1),
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Pengaturan'),
                selected: _index == 2,
                onTap: () => _pindahTab(2),
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
            icon: Icon(Icons.animation),
            label: 'Animasi',
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

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Tidak Ditemukan')),
      body: Center(
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
            ElevatedButton(
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