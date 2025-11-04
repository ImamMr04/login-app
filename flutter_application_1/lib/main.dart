import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

void main() {
  runApp(const LokaEksploreApp());
}

class LokaEksploreApp extends StatelessWidget {
  const LokaEksploreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOKA EKSPLORE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white54),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.cyan),
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/register': (_) => const RegisterPage(),
        '/main': (_) => const MainPage(),
      },
    );
  }
}

// ================== LOGIN PAGE ==================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // 🔹 Inisialisasi video background
    _videoController = VideoPlayerController.asset('images/sea.mp4');
    _initializeVideoPlayerFuture = _videoController.initialize().then((_) {
      _videoController.setLooping(true);
      _videoController.setVolume(0.0);
      _videoController.play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background video laut
          Positioned.fill(
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController.value.size.width,
                      height: _videoController.value.size.height,
                      child: VideoPlayer(_videoController),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),

          // 🔹 Lapisan gelap agar form tetap jelas
          Container(color: Colors.black.withOpacity(0.55)),

          // 🔹 Form login di tengah
          Center(
            child: Container(
              width: 380,
              padding: const EdgeInsets.all(30),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Start your journey with LokaEksplore',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email, color: Colors.white70),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Masukkan email';
                        if (!v.contains('@')) return 'Email tidak valid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock, color: Colors.white70),
                      ),
                      validator: (v) =>
                          v!.isEmpty ? 'Masukkan password' : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'MASUK',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Lupa password?',
                        style: TextStyle(color: Colors.cyan),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                      child: const Text(
                        'Belum punya akun? Daftar di sini',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================== REGISTER PAGE ==================
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(
      'images/sea.mp4', // ← video lokal kamu
    )
      ..initialize().then((_) {
        _videoController.setLooping(true);
        _videoController.setVolume(0);
        _videoController.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pendaftaran berhasil! Silakan login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          if (_videoController.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),
          Container(color: Colors.black.withOpacity(0.55)),
          Center(
            child: Container(
              width: 380,
              padding: const EdgeInsets.all(30),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'DAFTAR',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Bergabunglah dengan LokaEksplore',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Nama Lengkap',
                          prefixIcon: Icon(Icons.person, color: Colors.white70),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? 'Masukkan nama lengkap' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: Colors.white70),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Masukkan email';
                          if (!v.contains('@')) return 'Email tidak valid';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock, color: Colors.white70),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Masukkan password';
                          }
                          if (v.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Konfirmasi Password',
                          prefixIcon:
                              Icon(Icons.lock_outline, color: Colors.white70),
                        ),
                        validator: (v) {
                          if (v != _passwordController.text) {
                            return 'Password tidak cocok';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'DAFTAR',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Sudah punya akun? Login',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// ================== TRANSPORT MODAL DIALOG ==================
class TransportModalDialog extends StatefulWidget {
  final String destination;
  final List<Map<String, dynamic>> transports;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const TransportModalDialog({
    super.key,
    required this.destination,
    required this.transports,
    required this.scaffoldKey,
  });

  @override
  State<TransportModalDialog> createState() => _TransportModalDialogState();
}

class _TransportModalDialogState extends State<TransportModalDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openBookingForm() {
    Navigator.pop(context);
    showDialog(
      context: widget.scaffoldKey.currentContext ?? context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (ctx) => BookingFormDialog(
        destination: widget.destination,
        image: 'images/${widget.destination.toLowerCase().replaceAll(' ', '_')}.jpg',
        onSubmit: (data) {
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Booking transport ke ${widget.destination} berhasil!'),
              backgroundColor: Colors.cyan,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(30),
        child: Container(
          width: 500,
          height: 400,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'images/${widget.destination.toLowerCase().replaceAll(' ', '_')}.jpg',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey,
                          child: const Icon(Icons.image, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transport ke ${widget.destination}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Pilih opsi & harga 2025',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              // List Transport
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView.builder(
                    itemCount: widget.transports.length,
                    itemBuilder: (ctx, i) {
                      final t = widget.transports[i];
                      return Card(
                        color: Colors.white.withOpacity(0.1),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Text(
                            t['type'],
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          trailing: Text(
                            'Rp ${NumberFormat.compact().format(t['price'])}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          onTap: _openBookingForm,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Footer Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: _openBookingForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan.shade600,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'BOOK TRANSPORT',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== MAIN PAGE ==================
class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _selectedDestination = 'Bali';
  int _selectedNav = 0;
  int _selectedFilter = 0;
  final List<String> _filterItems = ['LOCATION', 'TYPE', 'DESTINATION'];
  final List<String> _navItems = ['HOME', 'ABOUT', 'PROMO', 'RATE US', 'LOGOUT'];

  final List<Map<String, String>> _allDestinations = [
    {
      'title': 'Gunung Bromo',
      'location': 'Jawa Timur',
      'type': 'Adventure',
      'image': 'images/bromo.jpg',
      'destination': 'Gunung',
    },
    {
      'title': 'Bali',
      'location': 'Bali',
      'type': 'Premium',
      'image': 'images/bali.jpg',
      'destination': 'Pulau',
    },
    {
      'title': 'Raja Ampat',
      'location': 'Papua Barat',
      'type': 'Premium',
      'image': 'images/raja_ampat.jpg',
      'destination': 'Kepulauan',
    },
    {
      'title': 'Tana Toraja',
      'location': 'Sulawesi Selatan',
      'type': 'Culture',
      'image': 'images/toraja.jpeg',
      'destination': 'Budaya',
    },
  ];

  final Map<String, List<Map<String, dynamic>>> transportOptions = {
    'Gunung Bromo': [
      {'type': 'Mobil/Jep 4WD', 'price': 450000},
      {'type': 'Bus Shuttle', 'price': 335000},
    ],
    'Bali': [
      {'type': 'Pesawat', 'price': 1550000},
      {'type': 'Bus AKAP', 'price': 525000},
    ],
    'Raja Ampat': [
      {'type': 'Pesawat ke Waisai', 'price': 3100000},
      {'type': 'Kapal Cepat', 'price': 315000},
    ],
    'Tana Toraja': [
      {'type': 'Bus Ekonomi', 'price': 125000},
      {'type': 'Bus Eksekutif', 'price': 250000},
    ],
  };

List<Map<String, String>> get _filteredDestinations {
  final list = List<Map<String, String>>.from(_allDestinations);
  switch (_selectedFilter) {
    case 0: // LOCATION
      list.sort((a, b) => a['location']!.compareTo(b['location']!));
      break;
    case 1: // TYPE
      list.sort((a, b) => a['type']!.compareTo(b['type']!));
      break;
    case 2: // DESTINATION
      list.sort((a, b) => a['destination']!.compareTo(b['destination']!));
      break;
  }
  return list;
}
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _cardsKey = GlobalKey();
  final GlobalKey _natureKey = GlobalKey();
  final GlobalKey _footerKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 800), curve: Curves.easeInOutCubic);
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar dari Akun', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin keluar?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal', style: TextStyle(color: Colors.white70))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _showTransportModal(String destination) {
    final transports = transportOptions[destination] ?? [];
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (_) => TransportModalDialog(
        destination: destination,
        transports: transports,
        scaffoldKey: _scaffoldKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // HERO SECTION (pakai kode yang udah diperbaiki)
Container(
  key: _heroKey,
  height: size.height,
  width: double.infinity,
  child: Stack(
    children: [
      Row(
        children: [
          Expanded(
            child: Image.asset(
              'images/hero.jpg',
              fit: BoxFit.cover,
              height: size.height,
              width: double.infinity,
            ),
          ),
          Expanded(
            child: Image.asset(
              'images/hero2.jpg',
              fit: BoxFit.cover,
              height: size.height,
              width: double.infinity,
            ),
          ),
          Expanded(
            child: Image.asset(
              'images/hero3.jpg',
              fit: BoxFit.cover,
              height: size.height,
              width: double.infinity,
            ),
          ),
        ],
      ),
      Container(
        height: size.height,
        width: double.infinity,
        color: Colors.black.withOpacity(0.4),
      ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'LOKA EKSPLORE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          actions: List.generate(_navItems.length, (i) {
            return ClickableNavItem(
              text: _navItems[i],
              isSelected: _selectedNav == i,
              onTap: () {
                setState(() => _selectedNav = i);
                if (i == 4) {
                  _showLogoutDialog();
                } else if (i == 2) {
                  showDialog(
                    context: context,
                    barrierColor: Colors.black.withOpacity(0.9),
                    builder: (_) => PromoModalDialog(scaffoldKey: _scaffoldKey),
                  );
                } else {
                  if (i == 0) _scrollTo(_heroKey);
                  if (i == 1) _scrollTo(_cardsKey);
                  if (i == 3) _scrollTo(_footerKey);
                }
              },
            );
          }),
        ),
      ),
      Positioned(
        top: size.height * 0.28,
        left: 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('WONDERFUL',
                style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Text('INDONESIA',
                style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 20),
            SizedBox(
                width: 500,
                child: Text('Celebrate the grace and strength of every woman, where beauty meets confidence in every story',
                    style: TextStyle(color: Colors.white70, fontSize: 16))),
            SizedBox(height: 15),
            SizedBox(
                width: 500,
                child: Text('From timeless elegance to modern spirit — discover, express, and shine your true self.',
                    style: TextStyle(color: Colors.white70, fontSize: 16))),
          ],
        ),
      ),
      const Positioned(
          right: 50,
          top: 220,
          child: Column(children: [
            NumberIndicator('01'),
            NumberIndicator('02'),
            NumberIndicator('03'),
            NumberIndicator('04'),
            NumberIndicator('05')
          ])),
    ],
  ),
),

                // CAROUSEL (FIXED!)
                Container(
                  key: _cardsKey,
                  padding: const EdgeInsets.symmetric(vertical: 80),
                  color: Colors.black,
                  child: Column(
                    children: [
                      const Text('POPULAR DESTINATIONS', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 40),
                      SizedBox(
                        height: 350,
                        child: DestinationCarousel(
                          filterType: _filterItems[_selectedFilter],
                          filteredDestinations: _filteredDestinations,
                          onDestinationTap: (dest) => _showTransportModal(dest),
                        ),
                      ),
                    ],
                  ),
                ),

                // NATURE SECTION
                Container(
                  key: _natureKey,
                  height: 650,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('images/nature.jpg'), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken)),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 100,
                        left: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('TRAVEL AND', style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text('ENJOY THE', style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text('BEAUTY OF', style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text('NATURE', style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white)),
                            SizedBox(height: 30),
                            SizedBox(width: 520, child: Text('Bali is an Indonesian island...', style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.6))),
                          ],
                        ),
                      ),
                      const Positioned(right: 120, top: 220, child: VideoPlayButton(videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', thumbnail: 'images/video1_thumb.jpeg')),
                      const Positioned(right: 120, top: 430, child: VideoPlayButton(videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', thumbnail: 'images/video2_thumb.jpg')),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // FOOTER
                Container(
                  key: _footerKey,
                  padding: const EdgeInsets.all(25),
                  color: Colors.black,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Contact: 0895679077688', style: TextStyle(color: Colors.white70)),
                      Text('by nabiles.', style: TextStyle(color: Colors.white70)),
                      Text('Special Collaboration', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================== PROMO MODAL DIALOG ==================
class PromoModalDialog extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const PromoModalDialog({super.key, required this.scaffoldKey});

  @override
  State<PromoModalDialog> createState() => _PromoModalDialogState();
}

class _PromoModalDialogState extends State<PromoModalDialog> with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  late TabController _tabController;
  late ScrollController _scrollController;

  final List<String> _tabs = ['Semua', 'Budget', 'Premium', 'Adventure'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _scrollController = ScrollController();
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() => _selectedTab = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'budget': return Colors.green.shade600;
      case 'premium': return Colors.purple.shade600;
      case 'adventure': return Colors.orange.shade600;
      default: return Colors.cyan.shade600;
    }
  }

  List<Widget> _filterDestinations() {
    final destinations = [

      {
        'title': 'Gunung Bromo, Jawa Tengah',
        'image': 'images/bromo.jpg',
        'rating': 4.8,
        'review': '“Sunrise paling indah di Jawa!” — TripAdvisor',
        'prices': ['1 Hari: Rp 300.000 - Rp 500.000/orang'],
        'type': 'Budget',
        'popular': true,
      },
      {
        'title': 'Bali, Indonesia',
        'image': 'images/bali.jpg',
        'rating': 4.9,
        'review': '“Surga tropis terbaik dunia!” — #2 TripAdvisor 2025',
        'prices': ['3 Hari: Rp 1.500.000 - Rp 2.500.000/orang'],
        'type': 'Premium',
        'popular': true,
      },
      {
        'title': 'Gunung Rinjani, Lombok',
        'image': 'images/rinjani.jpg',
        'rating': 4.7,
        'review': '“Trek menantang, view luar biasa!” — TripAdvisor',
        'prices': ['2 Hari: Rp 2.250.000 - Rp 2.550.000/orang'],
        'type': 'Adventure',
      },
      {
        'title': 'Raja Ampat, Papua Barat',
        'image': 'images/raja_ampat.jpg',
        'rating': 5.0,
        'review': '“The Last Paradise on Earth!” — UNESCO',
        'prices': ['4 Hari: Rp 8.500.000 - Rp 12.000.000/orang'],
        'type': 'Premium',
        'popular': true,
      },
      {
        'title': 'Pulau Komodo, NTT',
        'image': 'images/komodo.jpeg',
        'rating': 4.9,
        'review': '“Bertemu naga hidup!” — TripAdvisor',
        'prices': ['1 Hari: Rp 1.200.000 - Rp 1.800.000/orang'],
        'type': 'Adventure',
      },
      {
        'title': 'Tana Toraja, Sulawesi Selatan',
        'image': 'images/toraja.jpeg',
        'rating': 4.8,
        'review': '“Budaya paling unik di Indonesia!” — NatGeo',
        'prices': ['3 Hari: Rp 2.500.000 - Rp 3.500.000/orang'],
        'type': 'Premium',
      },  
    ];

    final Map<String, List<Widget>> categories = {'semua': [], 'budget': [], 'premium': [], 'adventure': []};
    for (var d in destinations) {
      final item = _buildPromoItem(
        title: d['title'] as String,
        image: d['image'] as String,
        rating: d['rating'] as double,
        review: d['review'] as String,
        prices: d['prices'] as List<String>,
        type: d['type'] as String,
        isPopular: d['popular'] as bool? ?? false,
      );
      categories['semua']!.add(item);
      categories[(d['type'] as String).toLowerCase()]!.add(item);
    }

    final selected = _tabs[_selectedTab].toLowerCase();
    final result = categories[selected] ?? categories['semua']!;

    if (result.isNotEmpty && _selectedTab != 0) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: _getCategoryColor(selected), borderRadius: BorderRadius.circular(20)),
                child: Text('${_tabs[_selectedTab].toUpperCase()} PACKAGES', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              const SizedBox(width: 12),
              Text('${result.length} Paket Tersedia', style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        ...result,
      ];
    }
    return result;
  }

  Widget _buildPromoItem({required String title, required String image, required double rating, required String review, required List<String> prices, required String type, bool isPopular = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: AnimatedPromoCard(
        title: title,
        image: image,
        rating: rating,
        review: review,
        prices: prices,
        type: type,
        isPopular: isPopular,
        scaffoldKey: widget.scaffoldKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12), child: Container(color: Colors.black.withOpacity(0.85)))),
          Center(
            child: Container(
              width: 1000,
              height: 720,
              margin: const EdgeInsets.all(30),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF16213E)]), boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 30, offset: const Offset(0, 15))]),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Row(children: [const Text('PROMO 2025', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)), const Spacer(), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white, size: 28))]),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(30)),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(color: Colors.cyan.shade600, borderRadius: BorderRadius.circular(30)),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      tabs: _tabs.map((t) => Tab(text: t)).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Stack(
                      children: [
                        NotificationListener<ScrollNotification>(
                          onNotification: (_) { setState(() {}); return false; },
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(children: _filterDestinations()),
                          ),
                        ),
                        if (_scrollController.hasClients)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 4,
                              margin: const EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                              child: LayoutBuilder(builder: (_, c) {
                                final progress = _scrollController.position.maxScrollExtent > 0 ? (_scrollController.offset / _scrollController.position.maxScrollExtent).clamp(0.0, 1.0) : 0.0;
                                return FractionallySizedBox(heightFactor: (c.maxHeight * 0.3 * (1 - progress)).clamp(0.1, 0.3), child: Container(color: Colors.cyan.shade600));
                              }),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan.shade600, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), padding: const EdgeInsets.symmetric(vertical: 18)),
                      child: const Text('TUTUP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
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

// ... (AnimatedPromoCard, BookingFormDialog, VideoPlayButton, ClickableNavItem, dll tetap sama)


// ================== ANIMATED PROMO CARD (FIX BOOK NOW!) ==================
class AnimatedPromoCard extends StatefulWidget {
  final String title, image, review, type;
  final double rating;
  final List<String> prices;
  final bool isPopular;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AnimatedPromoCard({
    super.key,
    required this.title,
    required this.image,
    required this.rating,
    required this.review,
    required this.prices,
    required this.type,
    this.isPopular = false,
    required this.scaffoldKey,
  });

  @override
  State<AnimatedPromoCard> createState() => _AnimatedPromoCardState();
}

class _AnimatedPromoCardState extends State<AnimatedPromoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openBookingForm() {
    showDialog(
      context: widget.scaffoldKey.currentContext ?? context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (ctx) => BookingFormDialog(
        destination: widget.title,
        image: widget.image,
        onSubmit: (data) {
          Navigator.pop(ctx); // Tutup dialog booking
          ScaffoldMessenger.of(
            widget.scaffoldKey.currentContext ?? ctx,
          ).showSnackBar(
            SnackBar(
              content: Text('Booking ${widget.title} berhasil!'),
              backgroundColor: Colors.cyan,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  widget.image,
                  width: 180,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 180,
                    height: 140,
                    color: Colors.grey,
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.white54,
                      size: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (widget.isPopular)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'POPULAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 18,
                            ),
                            Text(
                              ' ${widget.rating}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.review,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...widget.prices
                        .take(2)
                        .map(
                          (p) => Text(
                            '• $p',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.cyan.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.type,
                            style: const TextStyle(
                              color: Colors.cyan,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _openBookingForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'BOOK NOW',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== BOOKING FORM (FIX ERROR!) ==================
class BookingFormDialog extends StatefulWidget {
  final String destination, image;
  final Function(Map<String, String>) onSubmit;
  const BookingFormDialog({
    super.key,
    required this.destination,
    required this.image,
    required this.onSubmit,
  });

  @override
  State<BookingFormDialog> createState() => _BookingFormDialogState();
}

class _BookingFormDialogState extends State<BookingFormDialog>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _peopleController = TextEditingController();
  DateTime? _selectedDate;
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final data = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'people': _peopleController.text,
        'date':
            '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
      };

      // Kirim data ke callback, lalu tutup dialog
      widget.onSubmit(data);
      Navigator.pop(context);

      // Tampilkan notifikasi singkat (opsional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking ${widget.destination} berhasil!'),
          backgroundColor: Colors.cyan.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih tanggal!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Material(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            width: 500,
            height: 680,
            child: Column(
              children: [
                // Header Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: Stack(
                    children: [
                      Image.asset(
                        widget.image,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey,
                          height: 180,
                          child: const Icon(
                            Icons.image,
                            size: 60,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                      Container(height: 180, color: Colors.black54),
                      const Positioned(
                        bottom: 16,
                        left: 20,
                        child: Text(
                          'BOOKING',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Form
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nama',
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (v) =>
                                  v!.isEmpty ? 'Nama wajib diisi' : null,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email),
                              ),
                              validator: (v) => v != null && v.contains('@')
                                  ? null
                                  : 'Email tidak valid',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'No HP',
                                prefixIcon: Icon(Icons.phone),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (v) => v != null && v.length >= 10
                                  ? null
                                  : 'Nomor tidak valid',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _peopleController,
                              decoration: const InputDecoration(
                                labelText: 'Jumlah Orang',
                                prefixIcon: Icon(Icons.group),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) => v != null && v.isNotEmpty
                                  ? null
                                  : 'Isi jumlah orang',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: _selectDate,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white54),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white70,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _selectedDate == null
                                          ? 'Pilih Tanggal'
                                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white24,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                    child: const Text('BATAL'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.cyan.shade600,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                    child: const Text('SUBMIT'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================== DESTINATION CAROUSEL (FINAL - NO ERROR!) ==================
class DestinationCarousel extends StatefulWidget {
  final String filterType;
  final List<Map<String, String>> filteredDestinations;
  final void Function(String)? onDestinationTap;

  const DestinationCarousel({
    super.key,
    required this.filterType,
    required this.filteredDestinations,
    this.onDestinationTap,
  });

  @override
  State<DestinationCarousel> createState() => _DestinationCarouselState();
}

class _DestinationCarouselState extends State<DestinationCarousel> {
  late PageController _controller;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.45, initialPage: 0);
  }

  @override
  void didUpdateWidget(DestinationCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filterType != widget.filterType ||
        oldWidget.filteredDestinations.length != widget.filteredDestinations.length) {
      _controller.jumpToPage(0);
      setState(() => _current = 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filteredDestinations.isEmpty) {
      return const SizedBox(
        height: 320,
        child: Center(
          child: Text('Tidak ada destinasi', style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    return SizedBox(
      height: 340,
      child: Stack(
        children: [
          // PAGE VIEW
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: widget.filteredDestinations.length,
            itemBuilder: (context, i) {
              final dest = widget.filteredDestinations[i];
              final scale = i == _current ? 1.0 : 0.9;
              final opacity = i == _current ? 1.0 : 0.6;

              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween(begin: 0.9, end: scale),
                curve: Curves.easeOutCubic,
                builder: (_, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: opacity,
                      child: GestureDetector(
                        onTap: () => widget.onDestinationTap?.call(dest['title']!),
                        child: DestinationCard(
                          imagePath: dest['image']!,
                          title: dest['title']!,
                          isActive: i == _current,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // ARROW KIRI
          Positioned(
            left: 10,
            top: 110,
            child: GestureDetector(
              onTap: () {
                _controller.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              ),
            ),
          ),

          // ARROW KANAN
          Positioned(
            right: 10,
            top: 110,
            child: GestureDetector(
              onTap: () {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
              ),
            ),
          ),

          // DOTS
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.filteredDestinations.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _current ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _current ? Colors.cyan : Colors.white54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// PASTE INI DI BAWAH DestinationCarousel (HARUS ADA!)
class DestinationCard extends StatelessWidget {
  final String imagePath, title;
  final bool isActive;

  const DestinationCard({
    super.key,
    required this.imagePath,
    required this.title,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 340,
          height: 210,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: isActive
                ? [BoxShadow(color: Colors.cyan.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 8))]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                if (isActive)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.cyan : Colors.white,
            fontSize: 16,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(width: 80, height: 1, color: isActive ? Colors.cyan : Colors.white54),
      ],
    );
  }
}
class ClickableNavItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  const ClickableNavItem({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => AnimatedScaleButton(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.cyan : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}

class ClickableFilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  const ClickableFilterButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedScaleButton(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class AnimatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const AnimatedButton({super.key, required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) => AnimatedScaleButton(
    onTap: onTap,
    child: ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.cyan.shade600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}

class AnimatedScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const AnimatedScaleButton({
    super.key,
    required this.child,
    required this.onTap,
  });
  @override
  State<AnimatedScaleButton> createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _s;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _s = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _c.forward(),
      onTapUp: (_) {
        _c.reverse();
        widget.onTap();
      },
      onTapCancel: () => _c.reverse(),
      child: ScaleTransition(scale: _s, child: widget.child),
    );
  }
}

class NumberIndicator extends StatelessWidget {
  final String number;
  const NumberIndicator(this.number, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(
      number,
      style: const TextStyle(color: Colors.white54, fontSize: 18),
    ),
  );
}

// ================== VIDEO PLAY BUTTON ==================
class VideoPlayButton extends StatelessWidget {
  final String videoUrl;
  final String thumbnail;

  const VideoPlayButton({
    super.key,
    required this.videoUrl,
    required this.thumbnail,
  });

  void _openVideoPlayer(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => VideoPlayerDialog(videoUrl: videoUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openVideoPlayer(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              thumbnail,
              width: 320,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(Icons.play_arrow, size: 40, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

// ================== VIDEO PLAYER DIALOG ==================
class VideoPlayerDialog extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerDialog({super.key, required this.videoUrl});

  @override
  State<VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: true,
          looping: false,
        );
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      insetPadding: const EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
      ),
    );
  }
}

// ================== TRANSPORT LIST ==================
class TransportList extends StatelessWidget {
  final String destination;
  final List<Map<String, dynamic>> transports;

  const TransportList({
    super.key,
    required this.destination,
    required this.transports,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 60),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transportasi ke $destination',
            style: const TextStyle(
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...transports.map((t) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      t['type'],
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      'Rp ${t['price'].toString()}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}