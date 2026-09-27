import 'package:flutter/material.dart';

void main() {
  runApp(const SmartCampusApp());
}

// Global Value Notifier untuk memanipulasi Dark Mode dari halaman mana saja
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class SmartCampusApp extends StatelessWidget {
  const SmartCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SmartCampus Premium',
          themeMode: currentMode,
          // Tema Terang
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.indigo,
            brightness: Brightness.light,
          ),
          // Tema Gelap
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.indigo,
            brightness: Brightness.dark,
          ),
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginPage(),
            '/': (context) => const MainNavigation(),
            '/jadwal': (context) => const JadwalPage(),
            '/nilai': (context) => const NilaiPage(),
            '/presensi': (context) => const PresensiPage(),
            '/perpus': (context) => const PerpusPage(),
          },
        );
      },
    );
  }
}

// ==========================================
// 1. FORM LOGIN MODERN
// ==========================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _passController = TextEditingController();

  void _prosesLogin() {
    if (_formKey.currentState!.validate()) {
      if (_nimController.text == '12345' && _passController.text == 'ihwal') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Autentikasi Berhasil! Selamat Datang.'),
            backgroundColor: Colors.indigo.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushReplacementNamed(context, '/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('NIM atau Password Salah!'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade900, Colors.indigo.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.blur_on_rounded, size: 70, color: Colors.indigo),
                        const SizedBox(height: 10),
                        const Text("SMARTCAMPUS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.indigo, letterSpacing: 1.5)),
                        const Text("Enterprise Portal Mobile", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _nimController,
                          decoration: InputDecoration(
                            labelText: 'NIM Mahasiswa',
                            prefixIcon: const Icon(Icons.badge_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          validator: (value) => value!.isEmpty ? 'NIM tidak boleh kosong' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password Secure',
                            prefixIcon: const Icon(Icons.lock_open_rounded),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          validator: (value) => value!.isEmpty ? 'Password tidak boleh kosong' : null,
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _prosesLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text("SIGN IN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. BOTTOM NAVIGATION HUB WITH NOTIFICATION LIST
// ==========================================
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // FITUR: Simulasi Daftar Notifikasi Aktif Pengingat Tugas
  final List<Map<String, String>> _notifikasiList = [
    {"judul": "Batas Pengumpulan Tugas 2 Mobile", "waktu": "Hari ini, 23:59 WITA", "tipe": "Penting"},
    {"judul": "Pengumuman KRS Susulan Semester Genap", "waktu": "Esok Hari, 08:00 WITA", "tipe": "Info"},
    {"judul": "Praktikum Metode Numerik di Lab STI Diundur", "waktu": "22 Juni 2026", "tipe": "Pengumuman"},
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const DashboardPage(),
      // FITUR: Tampilan halaman notifikasi yang interaktif, tidak kosongan/statis lagi
      Scaffold(
        appBar: AppBar(title: const Text("Notifikasi & Pengingat")),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _notifikasiList.length,
          itemBuilder: (context, index) {
            final item = _notifikasiList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: item['tipe'] == 'Penting' ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                  child: Icon(Icons.notifications_active, color: item['tipe'] == 'Penting' ? Colors.red : Colors.blue),
                ),
                title: Text(item['judul']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(item['waktu']!),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: item['tipe'] == 'Penting' ? Colors.red : Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(item['tipe']!, style: const TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ),
            );
          },
        ),
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.indigo,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_max_rounded), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active_outlined), label: 'Notifikasi'),
        ],
      ),
    );
  }
}

// ==========================================
// 3. DASHBOARD PAGE WITH DARK MODE SWITCH
// ==========================================
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menus = [
      {'title': 'Jadwal', 'icon': Icons.class_outlined, 'badge': true, 'color': Colors.blue.shade700, 'route': '/jadwal'},
      {'title': 'Nilai', 'icon': Icons.analytics_outlined, 'badge': false, 'color': Colors.amber.shade800, 'route': '/nilai'},
      {'title': 'Presensi', 'icon': Icons.fingerprint_rounded, 'badge': false, 'color': Colors.green.shade700, 'route': '/presensi'},
      {'title': 'Perpustakaan', 'icon': Icons.local_library_outlined, 'badge': true, 'color': Colors.purple.shade700, 'route': '/perpus'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("SmartCampus", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.indigo)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Ihwal Irlandika", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              accountEmail: Text("irlandikaiwal@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 45, color: Colors.indigo),
              ),
              decoration: BoxDecoration(color: Colors.indigo),
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: const Text('Mode Gelap Application'),
              trailing: Switch(
                value: themeNotifier.value == ThemeMode.dark,
                onChanged: (bool value) {
                  themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ),
            const Divider(),
            ListTile(leading: const Icon(Icons.settings), title: const Text('Pengaturan Aplikasi'), onTap: () {}),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.indigo.shade800, Colors.indigo.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -30,
                      bottom: -30,
                      child: Icon(Icons.school, size: 200, color: Colors.white.withOpacity(0.1)),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("KTM DIGITAL", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
                          SizedBox(height: 15),
                          Text("Ihwal Irlandika", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          Text("NIM: 123456", style: TextStyle(color: Colors.white, fontSize: 14)),
                          SizedBox(height: 15),
                          Text("S1 Sistem dan Teknologi Informasi", style: TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Text("Layanan Akademik", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: menus.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => Navigator.pushNamed(context, menus[index]['route']),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: menus[index]['color'].withOpacity(0.1), shape: BoxShape.circle),
                                  child: Icon(menus[index]['icon'], size: 36, color: menus[index]['color']),
                                ),
                                const SizedBox(height: 10),
                                Text(menus[index]['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (menus[index]['badge'])
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                              ),
                            )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 4. JADWAL PAGE (HALAMAN 3) - DATA GLOBAL (TIDAK TERESET)
// ==========================================

final List<Map<String, dynamic>> _globalDataJadwal = [
  {"hari": "Senin", "jam": "10:00 - 11:30", "matkul": "Kemuhamadiyahan", "ruang": "3.13", "dosen": "Bpk Muhibrahman, M.Pd"},
  {"hari": "Senin", "jam": "13:30 - 15:00", "matkul": "Kecerdasan Buatan", "ruang": "3.13", "dosen": "Nani Sulistianingsih, S.Kom,M.Eng"},
  {"hari": "Selasa", "jam": "13:30 - 15:00", "matkul": "Pemrograman Mobile", "ruang": "Lab STI(Lantai 6 FIK)", "dosen": "Nani Sulistianingsih, S.Kom,M.Eng"},
  {"hari": "Selasa", "jam": "16:00 - 17:30", "matkul": "Multimedia", "ruang": "Lab STI(Lantai 6 FIK)", "dosen": "Arif Rahman S.Kom,M.Kom"},
  {"hari": "Jumat", "jam": "16:00 - 17:30", "matkul": "OOP", "ruang": "Lab STI(Lantai 6 FIK)", "dosen": "Arif Rahman S.Kom,M.Kom"},
];

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  // Fungsi Tampilkan Dialog Detail Mata Kuliah (READ Detail)
  void _tampilkanDetailDialog(Map<String, dynamic> jadwal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.menu_book, color: Colors.indigo),
            SizedBox(width: 10),
            Text("Detail Kelas"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Mata Kuliah: ${jadwal['matkul']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(),
            Text("Dosen: ${jadwal['dosen'] ?? 'Dosen STI'}"),
            Text("Waktu: ${jadwal['hari']}, ${jadwal['jam']}"),
            Text("Lokasi Ruangan: ${jadwal['ruang']}"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("TUTUP")),
        ],
      ),
    );
  }

  // Fungsi Form Pengisian Tambah & Edit (CREATE & UPDATE Form)
  void _tampilkanFormJadwal({int? index}) {
    final matkulController = TextEditingController(text: index != null ? _globalDataJadwal[index]['matkul'] : '');
    final hariController = TextEditingController(text: index != null ? _globalDataJadwal[index]['hari'] : 'Senin');
    final jamController = TextEditingController(text: index != null ? _globalDataJadwal[index]['jam'] : '08:00 - 09:30');
    final ruangController = TextEditingController(text: index != null ? _globalDataJadwal[index]['ruang'] : 'Ruang 3.13');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(index == null ? "Tambah Jadwal Baru" : "Edit Mata Kuliah", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(controller: matkulController, decoration: const InputDecoration(labelText: 'Nama Mata Kuliah', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: hariController, decoration: const InputDecoration(labelText: 'Hari', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: jamController, decoration: const InputDecoration(labelText: 'Jam (cth: 08:00 - 09:30)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: ruangController, decoration: const InputDecoration(labelText: 'Ruangan', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                if (matkulController.text.isNotEmpty) {
                  setState(() {
                    if (index == null) {
                      // Operasi Tambah Data ke Global List
                      _globalDataJadwal.add({
                        "hari": hariController.text,
                        "jam": jamController.text,
                        "matkul": matkulController.text,
                        "ruang": ruangController.text,
                      });
                    } else {
                      // Operasi Perbarui Data di Global List
                      _globalDataJadwal[index]['matkul'] = matkulController.text;
                      _globalDataJadwal[index]['hari'] = hariController.text;
                      _globalDataJadwal[index]['jam'] = jamController.text;
                      _globalDataJadwal[index]['ruang'] = ruangController.text;
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(index == null ? "SIMPAN JADWAL" : "PERBARUI JADWAL"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Fungsi Hapus Jadwal (DELETE)
  void _hapusJadwal(int index) {
    setState(() {
      _globalDataJadwal.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Jadwal perkuliahan berhasil dihapus!'), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jadwal Kuliah")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () => _tampilkanFormJadwal(),
        child: const Icon(Icons.add),
      ),
      body: _globalDataJadwal.isEmpty
          ? const Center(child: Text("Tidak ada jadwal kuliah tersedia. Silakan tambah."))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _globalDataJadwal.length,
              itemBuilder: (context, index) {
                final item = _globalDataJadwal[index];
                Color borderWarna = Colors.blue;
                if (item['hari'] == 'Selasa') borderWarna = Colors.orange;
                if (item['hari'] == 'Jumat') borderWarna = Colors.red;

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _tampilkanDetailDialog(item),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(border: Border(left: BorderSide(color: borderWarna, width: 6))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item['hari'], style: TextStyle(fontWeight: FontWeight.bold, color: borderWarna, fontSize: 16)),
                              Row(
                                children: [
                                  IconButton(icon: const Icon(Icons.edit, size: 18, color: Colors.grey), onPressed: () => _tampilkanFormJadwal(index: index)),
                                  IconButton(icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent), onPressed: () => _hapusJadwal(index)),
                                ],
                              )
                            ],
                          ),
                          Text(item['jam'], style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
                          const SizedBox(height: 8),
                          Text(item['matkul'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey), 
                              const SizedBox(width: 5), Text(item['ruang'], style: 
                              const TextStyle(color: Colors.grey))
                            ]
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ==========================================
// 5. NILAI PAGE (HALAMAN 4)
// ==========================================
class NilaiPage extends StatelessWidget {
  const NilaiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nilai")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildNilaiCard("Pemrograman Mobile", "3 SKS", "-", Colors.green),
          _buildNilaiCard("Pemrograman Berorientasi Objek", "3 SKS", "B+", Colors.green),
          _buildNilaiCard("Kecerdasan Buatan", "3 SKS", "-", Colors.grey),
          _buildNilaiCard("Multimedia", "3 SKS", "A", Colors.blue),
        ],
      ),
    );
  }

  Widget _buildNilaiCard(String matkul, String sks, String grade, Color warna) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(matkul, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(sks),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: warna.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Text(grade, style: TextStyle(color: warna, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }
}

// ==========================================
// 6. PRESENSI PAGE (HALAMAN 5)
// ==========================================
class PresensiPage extends StatefulWidget {
  const PresensiPage({super.key});

  @override
  State<PresensiPage> createState() => _PresensiPageState();
}

class _PresensiPageState extends State<PresensiPage> {
  int _hadirCount = 12;

  @override
  Widget build(BuildContext context) {
    double persentase = (_hadirCount / 14) * 100;
    return Scaffold(
      appBar: AppBar(title: const Text("Presensi")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text("Persentase Kehadiran Kelas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 110,
                          height: 110,
                          child: CircularProgressIndicator(value: persentase / 100, strokeWidth: 10, color: Colors.green, backgroundColor: Colors.grey.shade200),
                        ),
                        Text("${persentase.toStringAsFixed(1)}%", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text("Total Hadir: $_hadirCount dari 14 Pertemuan", style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {
                if (_hadirCount < 14) {
                  setState(() => _hadirCount++);
                }
              },
              icon: const Icon(Icons.fingerprint),
              label: const Text("LAKUKAN ABSENSI SEKARANG"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, 
              foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 7. PERPUSTAKAAN PAGE (HALAMAN 6) - WITH SEARCH BAR FILTERING
// ==========================================
class PerpusPage extends StatefulWidget {
  const PerpusPage({super.key});

  @override
  State<PerpusPage> createState() => _PerpusPageState();
}

class _PerpusPageState extends State<PerpusPage> {
  final List<Map<String, dynamic>> _katalogBuku = [
    {"judul": "Pemrograman Mobile", "status": "Batas Pengembalian: 14 Juni 2026", "pinjam": true},
    {"judul": "Multimedia", "status": "Batas Pengembalian: 12 Juni 2026", "pinjam": true},
    {"judul": "Kecerdasan Buatan", "status": "Sudah Dikembalikan", "pinjam": false},
    {"judul": "Pemrograman Berorientasi Objek (OOP)", "status": "Tersedia di Rak B1", "pinjam": false},
  ];

  List<Map<String, dynamic>> _bukuTerfilter = [];
  String _queryPencarian = "";

  @override
  void initState() {
    super.initState();
    _bukuTerfilter = _katalogBuku;
  }

  void _filterBuku(String query) {
    setState(() {
      _queryPencarian = query;
      _bukuTerfilter = _katalogBuku
          .where((buku) => buku['judul'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Perpustakaan Digital")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => _filterBuku(value),
              decoration: InputDecoration(
                labelText: 'Cari Buku Akademik...',
                hintText: 'Ketik judul buku di sini',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _queryPencarian.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear), onPressed: () => _filterBuku(""))
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          Expanded(
            child: _bukuTerfilter.isEmpty
                ? const Center(child: Text("Buku yang Anda cari tidak ditemukan."))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _bukuTerfilter.length,
                    itemBuilder: (context, index) {
                      final item = _bukuTerfilter[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Icon(Icons.book_rounded, color: item['pinjam'] ? Colors.purple : Colors.grey),
                          title: Text(item['judul'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(item['status'], style: TextStyle(color: item['pinjam'] ?
                           Colors.redAccent : Colors.green)),
                        ),
                      );
                      
                    },
                  ),
          ),
        ],
      ),
    );
  }
}