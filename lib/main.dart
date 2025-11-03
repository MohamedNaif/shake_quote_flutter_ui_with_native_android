import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/shake_service.dart';
import 'data/quotes.dart';

// Constants for configuration
class AppConstants {
  static const Duration quoteDisplayDuration = Duration(seconds: 6);
  static const Duration fadeAnimationDuration = Duration(milliseconds: 600);
  static const Duration scaleAnimationDuration = Duration(milliseconds: 400);
  static const Duration hideAnimationDuration = Duration(milliseconds: 300);

  static const double quoteCardPadding = 32.0;
  static const double quoteCardMargin = 24.0;
  static const double quoteCardRadius = 24.0;
  static const double quoteIconSize = 40.0;
  static const double mainIconSize = 80.0;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait (optional)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
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
  int _quoteCount = 0;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _shakeIconController;
  late AnimationController _slideController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeIconAnimation;
  late Animation<Offset> _slideAnimation;

  // Stream subscription for cleanup
  Stream<String>? _shakeStream;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeShakeListener();
    _triggerWelcomeHaptic();
  }

  void _initializeAnimations() {
    // Fade animation for quote appearance
    _fadeController = AnimationController(
      vsync: this,
      duration: AppConstants.fadeAnimationDuration,
    );

    // Scale animation for quote bounce effect
    _scaleController = AnimationController(
      vsync: this,
      duration: AppConstants.scaleAnimationDuration,
    );

    // Shake icon animation (subtle pulse)
    _shakeIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Slide animation for quote entrance
    _slideController = AnimationController(
      vsync: this,
      duration: AppConstants.fadeAnimationDuration,
    );

    // Setup animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _shakeIconAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _shakeIconController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
  }

  void _initializeShakeListener() {
    try {
      _shakeStream = _shakeService.getShakeStream();
      _shakeStream!.listen(
        (event) {
          if (!_isDisposed && event == 'shake_detected') {
            _showNewQuote();
          }
        },
        onError: (error) {
          // Handle stream errors gracefully
          if (!_isDisposed) {
            debugPrint('Error in shake stream: $error');
          }
        },
        cancelOnError: false,
      );
    } catch (e) {
      debugPrint('Error initializing shake listener: $e');
    }
  }

  void _triggerWelcomeHaptic() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        HapticFeedback.mediumImpact();
      }
    });
  }

  void _showNewQuote() {
    if (_isDisposed) return;

    // Cancel any pending auto-hide
    _cancelAutoHide();

    setState(() {
      _currentQuote = Quotes.getRandomQuote();
      _isQuoteVisible = true;
      _quoteCount++;
    });

    // Trigger all animations
    _fadeController.forward(from: 0.0);
    _scaleController.forward(from: 0.0);
    _slideController.forward(from: 0.0);

    // Haptic feedback
    HapticFeedback.heavyImpact();

    // Auto-hide quote after duration
    _scheduleAutoHide();
  }

  void _hideQuote() {
    if (_isDisposed) return;

    _cancelAutoHide();
    _fadeController.reverse();
    _scaleController.reverse();
    _slideController.reverse();

    Future.delayed(AppConstants.hideAnimationDuration, () {
      if (mounted && !_isDisposed) {
        setState(() {
          _isQuoteVisible = false;
        });
      }
    });
  }

  void _scheduleAutoHide() {
    Future.delayed(AppConstants.quoteDisplayDuration, () {
      if (mounted && !_isDisposed && _isQuoteVisible) {
        _hideQuote();
      }
    });
  }

  void _cancelAutoHide() {
    // Implementation note: In a production app, you'd store the Future
    // and cancel it, but for simplicity we check mounted state
  }

  void _showQuoteManually() {
    _showNewQuote();
  }

  Future<void> _shareQuote() async {
    if (_currentQuote.isEmpty) return;

    try {
      await Clipboard.setData(ClipboardData(text: _currentQuote));
      if (mounted && !_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quote copied to clipboard!'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      debugPrint('Error sharing quote: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _fadeController.dispose();
    _scaleController.dispose();
    _shakeIconController.dispose();
    _slideController.dispose();
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
              _buildMainContent(),

              // Quote overlay with enhanced animations
              if (_isQuoteVisible) _buildQuoteOverlay(),

              // Statistics badge (top right)
              _buildStatsBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated shake icon
            AnimatedBuilder(
              animation: _shakeIconAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _shakeIconAnimation.value,
                  child: Icon(
                    Icons.wb_incandescent,
                    size: AppConstants.mainIconSize,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),

            // Instruction text with better typography
            Text(
              'Shake your phone',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'to get inspired!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white.withValues(alpha: 0.9),
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 60),

            // Enhanced manual button
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton.icon(
      onPressed: _showQuoteManually,
      icon: const Icon(Icons.auto_awesome),
      label: const Text('Get Quote Now'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildQuoteOverlay() {
    return Center(
      child: GestureDetector(
        onTap: _hideQuote,
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 500) {
            _hideQuote();
          }
        },
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _fadeAnimation,
            _scaleAnimation,
            _slideAnimation,
          ]),
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: SlideTransition(position: _slideAnimation, child: child),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(AppConstants.quoteCardMargin),
            padding: const EdgeInsets.all(AppConstants.quoteCardPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.quoteCardRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Quote icon with color
                Icon(
                  Icons.format_quote,
                  size: AppConstants.quoteIconSize,
                  color: Colors.deepPurple.shade400,
                ),
                const SizedBox(height: 20),

                // Quote text with better styling
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

                // Action buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Share button
                    IconButton(
                      onPressed: _shareQuote,
                      icon: const Icon(Icons.share),
                      color: Colors.deepPurple.shade400,
                      tooltip: 'Copy quote',
                    ),
                    const SizedBox(width: 20),

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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsBadge() {
    if (_quoteCount == 0) return const SizedBox.shrink();

    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              size: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 6),
            Text(
              '$_quoteCount',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
