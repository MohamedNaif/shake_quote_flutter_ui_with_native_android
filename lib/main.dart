import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/shake_service.dart';
import 'data/quotes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shake for Inspiration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ShakeQuotePage(),
    );
  }
}

class ShakeQuotePage extends StatefulWidget {
  const ShakeQuotePage({super.key});

  @override
  State<ShakeQuotePage> createState() => _ShakeQuotePageState();
}

class _ShakeQuotePageState extends State<ShakeQuotePage>
    with TickerProviderStateMixin {
  final ShakeService _shakeService = ShakeService();
  String _currentQuote = '';
  bool _isQuoteVisible = false;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Listen to shake events
    _shakeService.getShakeStream().listen((event) {
      if (event == 'shake_detected') {
        _showNewQuote();
      }
    });

    // Show initial instruction
    HapticFeedback.mediumImpact();
  }

  void _showNewQuote() {
    setState(() {
      _currentQuote = Quotes.getRandomQuote();
      _isQuoteVisible = true;
    });

    // Trigger animations
    _fadeController.forward(from: 0.0);
    _scaleController.forward(from: 0.0);

    // Haptic feedback
    HapticFeedback.heavyImpact();

    // Auto-hide quote after 5 seconds (optional)
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _hideQuote();
      }
    });
  }

  void _hideQuote() {
    _fadeController.reverse();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isQuoteVisible = false;
        });
      }
    });
  }

  void _showQuoteManually() {
    _showNewQuote();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade400,
              Colors.deepPurple.shade600,
              Colors.indigo.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main content
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon
                      Icon(
                        Icons.wb_incandescent,
                        size: 80,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(height: 40),

                      // Instruction text
                      Text(
                        'Shake your phone',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'to get inspired!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 60),

                      // Manual button (for testing without shaking)
                      ElevatedButton.icon(
                        onPressed: _showQuoteManually,
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('Get Quote Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Quote overlay with animation
              if (_isQuoteVisible)
                Center(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _fadeAnimation,
                      _scaleAnimation,
                    ]),
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: child,
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: _hideQuote,
                      child: Container(
                        margin: const EdgeInsets.all(24.0),
                        padding: const EdgeInsets.all(32.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Quote icon
                            Icon(
                              Icons.format_quote,
                              size: 40,
                              color: Colors.deepPurple.shade400,
                            ),
                            const SizedBox(height: 20),

                            // Quote text
                            Text(
                              _currentQuote,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade800,
                                height: 1.5,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Close hint
                            Text(
                              'Tap to close',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
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
        ),
      ),
    );
  }
}
