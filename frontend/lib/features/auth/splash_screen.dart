import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../state/app_state.dart';
import 'auth_widgets.dart';

/// Branded splash that restores a saved session, or starts the single-login
/// auth flow for guests.
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final authLoaded = context.watch<AppState>().authLoaded;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Stack(
        children: [
          const AuthGradientHeader(
            title: 'Let\'s care for your skin',
            subtitle:
                'Book consultations, manage appointments, and connect with clinic staff.',
            height: 455,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                24,
                30,
                24,
                MediaQuery.of(context).padding.bottom + 30,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'JongSart',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'A soft, simple skincare clinic booking demo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed:
                            authLoaded ? () => context.go('/login') : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandDarkGreen,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              AppColors.brandDarkGreen.withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: authLoaded
                            ? const Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            : const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
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
        ],
      ),
    );
  }
}
