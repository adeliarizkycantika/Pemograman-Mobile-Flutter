import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// ==================================================
// APLIKASI
// ==================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Postingan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const PostPage(),
    );
  }
}

// ==================================================
// MODEL POST
// ==================================================

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

// ==================================================
// MODEL KOMENTAR
// ==================================================

class Komentar {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  Komentar({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory Komentar.fromJson(Map<String, dynamic> json) {
    return Komentar(
      postId: json['postId'],
      id: json['id'],
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }
}

// ==================================================
// FUNGSI MENGAMBIL DATA POSTINGAN
// ==================================================

Future<List<Post>> ambilPostingan() async {
  final uri = Uri.parse(
    'https://jsonplaceholder.typicode.com/posts',
  );

  final response = await http
      .get(uri)
      .timeout(const Duration(seconds: 10));

  if (response.statusCode != 200) {
    throw Exception(
      'Gagal mengambil postingan: ${response.statusCode}',
    );
  }

  final List<dynamic> jsonData = jsonDecode(response.body);

  return jsonData
      .map((item) => Post.fromJson(item))
      .toList();
}

// ==================================================
// FUNGSI MENGAMBIL KOMENTAR
// ==================================================

Future<List<Komentar>> ambilKomentar(int postId) async {
  final uri = Uri.parse(
    'https://jsonplaceholder.typicode.com/posts/$postId/comments',
  );

  final response = await http
      .get(uri)
      .timeout(const Duration(seconds: 10));

  if (response.statusCode != 200) {
    throw Exception(
      'Gagal mengambil komentar: ${response.statusCode}',
    );
  }

  final List<dynamic> jsonData = jsonDecode(response.body);

  return jsonData
      .map((item) => Komentar.fromJson(item))
      .toList();
}

// ==================================================
// HALAMAN DAFTAR POSTINGAN
// ==================================================

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late Future<List<Post>> _future;

  @override
  void initState() {
    super.initState();
    _future = ambilPostingan();
  }

  void _muatUlang() {
    setState(() {
      _future = ambilPostingan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Postingan'),
        actions: [
          IconButton(
            onPressed: _muatUlang,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _future,
        builder: (context, snapshot) {
          // LOADING
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ERROR
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Terjadi kesalahan:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _muatUlang,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          // DATA
          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(
              child: Text('Tidak ada data'),
            );
          }

          // DAFTAR POSTINGAN
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final post = data[index];

              return ListTile(
                leading: CircleAvatar(
                  child: Text('${post.id}'),
                ),
                title: Text(
                  post.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  post.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailPostPage(post: post),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// ==================================================
// HALAMAN DETAIL POSTINGAN
// ==================================================

class DetailPostPage extends StatefulWidget {
  final Post post;

  const DetailPostPage({
    super.key,
    required this.post,
  });

  @override
  State<DetailPostPage> createState() =>
      _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  late Future<List<Komentar>> _futureKomentar;

  @override
  void initState() {
    super.initState();

    _futureKomentar =
        ambilKomentar(widget.post.id);
  }

  void _muatUlangKomentar() {
    setState(() {
      _futureKomentar =
          ambilKomentar(widget.post.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Postingan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // JUDUL POSTINGAN
          Text(
            widget.post.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // ISI LENGKAP POSTINGAN
          Text(
            widget.post.body,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          const Divider(),

          const SizedBox(height: 12),

          // JUDUL KOMENTAR
          const Text(
            'Komentar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // FUTUREBUILDER KOMENTAR
          FutureBuilder<List<Komentar>>(
            future: _futureKomentar,
            builder: (context, snapshot) {
              // LOADING KOMENTAR
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // ERROR KOMENTAR
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 45,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gagal memuat komentar:\n'
                            '${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _muatUlangKomentar,
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                );
              }

              // DATA KOMENTAR
              final komentar =
                  snapshot.data ?? [];

              if (komentar.isEmpty) {
                return const Center(
                  child: Text('Tidak ada komentar'),
                );
              }

              // DAFTAR KOMENTAR
              return Column(
                children: komentar.map((item) {
                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.email,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(item.body),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}