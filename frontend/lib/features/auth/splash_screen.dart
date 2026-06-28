import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../state/app_state.dart';

/// Branded splash that waits for the local auth session to load, then routes
/// the user to the right place: customer home, staff dashboard, or the
/// role selection screen for guests.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeRoute());
  }

  Future<void> _maybeRoute() async {
    // Small branded pause so the splash is visible on fast devices.
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;

    final state = context.read<AppState>();

    // Wait until the persisted auth session finished loading.
    while (!state.authLoaded) {
      await Future<void>.delayed(const Duration(milliseconds: 60));
      if (!mounted) return;
    }

    if (_navigated) return;
    _navigated = true;

    if (state.isLoggedIn && state.isStaff) {
      context.go('/clinic-staff');
    } else if (state.isLoggedIn && state.isCustomer) {
      context.go('/');
    } else {
      context.go('/role-selection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFBFEFE4), Color(0xFF0F766E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.75)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.spa,
                    color: AppColors.brandDarkGreen, size: 48),
              ),
              const SizedBox(height: 22),
              const Text(
                'JongSart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Soft skincare clinic care',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              const SizedBox(height: 34),
              const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
