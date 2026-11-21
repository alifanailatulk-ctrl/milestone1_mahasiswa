import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const DashboardPage(),
    );
  }
}

/// =====================================================
/// HALAMAN 1: DASHBOARD (StatefulWidget)
/// =====================================================
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Daftar ada di dalam State dan TIDAK const, supaya bisa ditambah.
  final List<Map<String, String>> _daftarMahasiswa = [
    {
      'nama': 'Budi Santoso',
      'nim': '2201001',
      'email': 'budi@mail.com',
      'jurusan': 'Sistem Informasi',
    },
  ];

  Future<void> _bukaFormTambah() async {
    // await: menunggu form ditutup, hasilnya dikirim lewat Navigator.pop
    final hasil = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (_) => const TambahMahasiswaPage()),
    );

    // Jika pengguna menekan Back tanpa Simpan, hasil = null
    if (hasil == null) return;
    if (!mounted) return;

    // setState: memberi tahu Flutter agar layar digambar ulang
    setState(() {
      _daftarMahasiswa.add(hasil);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${hasil['nama']} berhasil ditambahkan'),
        duration: const Duration(seconds: 8),
      ),
    );
  }

  void _bukaDetail(Map<String, String> mahasiswa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailMahasiswaPage(data: mahasiswa),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mahasiswa (${_daftarMahasiswa.length})'),
      ),
      body: _daftarMahasiswa.isEmpty
          ? const Center(child: Text('Belum ada data mahasiswa'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _daftarMahasiswa.length,
              itemBuilder: (context, index) {
                final m = _daftarMahasiswa[index];
                return KartuMahasiswa(
                  nama: m['nama']!,
                  nim: m['nim']!,
                  onTap: () => _bukaDetail(m),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaFormTambah,
        tooltip: 'Tambah Mahasiswa',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// =====================================================
/// HALAMAN 2: FORM TAMBAH MAHASISWA
/// =====================================================
class TambahMahasiswaPage extends StatefulWidget {
  const TambahMahasiswaPage({super.key});

  @override
  State<TambahMahasiswaPage> createState() => _TambahMahasiswaPageState();
}

class _TambahMahasiswaPageState extends State<TambahMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _jurusanController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _jurusanController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final dataBaru = <String, String>{
      'nama': _namaController.text.trim(),
      'nim': _nimController.text.trim(),
      'email': _emailController.text.trim(),
      'jurusan': _jurusanController.text.trim(),
    };

    // Tutup halaman form SEKALIGUS kirim dataBaru ke Dashboard
    Navigator.pop(context, dataBaru);
  }

  String? _wajibIsi(String? value, String namaKolom) {
    if (value == null || value.trim().isEmpty) {
      return '$namaKolom wajib diisi';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Mahasiswa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => _wajibIsi(v, 'Nama'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nimController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => _wajibIsi(v, 'NIM'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final salah = _wajibIsi(v, 'Email');
                  if (salah != null) return salah;
                  if (!v!.contains('@')) return 'Format email tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _jurusanController,
                decoration: const InputDecoration(
                  labelText: 'Jurusan',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => _wajibIsi(v, 'Jurusan'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpan,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =====================================================
/// HALAMAN 3: DETAIL MAHASISWA
/// =====================================================
class DetailMahasiswaPage extends StatelessWidget {
  final Map<String, String> data;

  const DetailMahasiswaPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Mahasiswa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                data['nama']![0].toUpperCase(),
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(height: 24),
            BarisInfo(
              ikon: Icons.person,
              label: 'Nama',
              nilai: data['nama']!,
            ),
            BarisInfo(
              ikon: Icons.badge,
              label: 'NIM',
              nilai: data['nim']!,
            ),
            BarisInfo(
              ikon: Icons.email,
              label: 'Email',
              nilai: data['email']!,
            ),
            BarisInfo(
              ikon: Icons.school,
              label: 'Jurusan',
              nilai: data['jurusan']!,
            ),
          ],
        ),
      ),
    );
  }
}

/// =====================================================
/// WIDGET TERPISAH 1: KartuMahasiswa
/// =====================================================
class KartuMahasiswa extends StatelessWidget {
  final String nama;
  final String nim;
  final VoidCallback onTap; // fungsi aksi dari halaman induk

  const KartuMahasiswa({
    super.key,
    required this.nama,
    required this.nim,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(nama[0].toUpperCase())),
        title: Text(nama),
        subtitle: Text('NIM: $nim'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

/// =====================================================
/// WIDGET TERPISAH 2: BarisInfo
/// =====================================================
class BarisInfo extends StatelessWidget {
  final IconData ikon;
  final String label;
  final String nilai;

  const BarisInfo({
    super.key,
    required this.ikon,
    required this.label,
    required this.nilai,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(ikon),
      title: Text(label, style: const TextStyle(fontSize: 12)),
      subtitle: Text(
        nilai,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}