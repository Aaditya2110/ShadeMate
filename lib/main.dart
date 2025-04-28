import 'package:flutter/material.dart';
import 'dart:math';
import 'pages/LoginPage.dart';
import 'pages/SignUpPage.dart';
import 'pages/HomePage.dart';
import 'pages/SkinToneDetectionPage.dart';
import 'pages/ProfilePage.dart';
import 'pages/ClothingRecommendationPage.dart';
import 'pages/FeedbackPage.dart';
import 'pages/SettingsPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShadeMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Color(0xFF5D4037),
          secondary: Color(0xFFD7CCC8),
          surface: Color(0xFFEFEBE9),
          background: Color(0xFFEFEBE9),
          onPrimary: Colors.white,
          onSecondary: Color(0xFF3E2723),
          onSurface: Color(0xFF3E2723),
          onBackground: Color(0xFF3E2723),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF5D4037),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          color: Color(0xFFD7CCC8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF5D4037),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF5D4037),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFF5D4037)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFF5D4037), width: 2),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/detect-skin-tone': (context) => const SkinToneDetectionPage(),
        '/recommend-clothes': (context) => const ClothingRecommendationPage(),
        '/profile': (context) => const ProfilePage(),
        '/feedback': (context) => const FeedbackPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _fadeOutAnimation;
  late Animation<Alignment> _gradientAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // Fade in animation (0-50% of timeline)
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Fade out animation (50-100% of timeline)
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // Gradient animation
    _gradientAnimation = Tween<Alignment>(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Animated gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: _gradientAnimation.value,
                    end: Alignment(-1.0, 1.0),
                    colors: [
                      Color(0xFF5D4037).withOpacity(0.2),
                      Color(0xFFD7CCC8).withOpacity(0.4),
                      Color(0xFFEFEBE9).withOpacity(0.8),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // Floating particles
              Positioned.fill(
                child: CustomPaint(
                  painter: _ParticlePainter(
                    animationValue: _controller.value,
                  ),
                ),
              ),

              // Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: _controller.value < 0.5
                          ? _fadeInAnimation.value
                          : _fadeOutAnimation.value,
                      child: Image.asset(
                        'assets/logo.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
                    SizedBox(height: 20),
                    Opacity(
                      opacity: _controller.value < 0.5
                          ? _fadeInAnimation.value
                          : _fadeOutAnimation.value,
                      child: Column(
                        children: [
                          Text(
                            'ShadeMate',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5D4037),
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Your Personal Style Guide',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF5D4037).withOpacity(0.8),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double animationValue;

  _ParticlePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF5D4037).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final particleCount = 30;
    final radius = 2.0;

    for (int i = 0; i < particleCount; i++) {
      final progress = (animationValue + i / particleCount) % 1.0;
      final x = progress * size.width;
      final y = (sin(progress * 3.14 * 2) * 50 + size.height / 2);

      canvas.drawCircle(
        Offset(x, y),
        radius * (0.5 + sin(progress * 3.14 * 4) * 0.5),
        paint..color = Color(0xFF5D4037).withOpacity(0.1 * (1 - progress)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}