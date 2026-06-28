import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Shared, softly styled text field used across the auth screens so the
/// customer and staff forms keep the same JongSart look and feel.
class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType keyboardType;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.validator,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13),
            prefixIcon: Icon(icon, color: AppColors.primaryMint, size: 20),
            suffixIcon: suffix,
            filled: true,
            fillColor: const Color(0xFFF6FAF9),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE6F0ED)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: AppColors.brandDarkGreen, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFD4465D)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: Color(0xFFD4465D), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

/// Full-width primary action button used by the auth forms.
class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final bool busy;
  final VoidCallback onPressed;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: busy ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F766E),
          foregroundColor: Colors.white,
          elevation: 0,
          disabledBackgroundColor: const Color(0xFF0F766E),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: busy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                label,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
      ),
    );
  }
}

/// Rounded header used at the top of each auth screen.
class AuthHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEFFFFB), Color(0xFFB5F0E6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFD6EEE8)),
          ),
          child: Icon(icon, color: AppColors.brandDarkGreen, size: 28),
        ),
        const SizedBox(height: 18),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
              color: AppColors.textGrey, fontSize: 13, height: 1.4),
        ),
      ],
    );
  }
}

/// Shows a soft, friendly snackbar (success or error).
void showAuthSnackBar(BuildContext context, String message,
    {bool isError = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor:
            isError ? const Color(0xFFD4465D) : const Color(0xFF0F766E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
}

class AuthBrandMark extends StatelessWidget {
  final double size;
  final bool light;

  const AuthBrandMark({
    super.key,
    this.size = 58,
    this.light = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: light ? Colors.white : null,
        gradient: light
            ? null
            : const LinearGradient(
                colors: [Color(0xFFEFFFFB), Color(0xFFB5F0E6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(size * 0.3),
        border: Border.all(
          color: light
              ? Colors.white.withValues(alpha: 0.7)
              : const Color(0xFFD6EEE8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: light ? 0.12 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(
        Icons.spa,
        color: AppColors.brandDarkGreen,
        size: size * 0.48,
      ),
    );
  }
}

class AuthGradientHeader extends StatelessWidget {
  static const String backgroundAsset = 'assets/images/image.png';

  final String title;
  final String subtitle;
  final double height;
  final bool showBack;

  const AuthGradientHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.height = 330,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: AppColors.brandDarkGreen,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              backgroundAsset,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0F766E).withValues(alpha: 0.84),
                    const Color(0xFF3B9B82).withValues(alpha: 0.68),
                    Colors.black.withValues(alpha: 0.30),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned(
            right: -38,
            top: MediaQuery.of(context).padding.top + 18,
            child: const _DecorCircle(size: 142, opacity: 0.14),
          ),
          const Positioned(
            left: -42,
            top: 124,
            child: _DecorCircle(size: 110, opacity: 0.10),
          ),
          Positioned(
            right: 34,
            bottom: 58,
            child: Icon(
              Icons.eco_outlined,
              size: 54,
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              MediaQuery.of(context).padding.top + 18,
              24,
              42,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showBack)
                  IconButton.filledTonal(
                    onPressed: () => Navigator.of(context).maybePop(),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.18),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.arrow_back),
                  )
                else
                  const AuthBrandMark(light: true),
                const Spacer(),
                if (showBack) const AuthBrandMark(light: true, size: 52),
                if (showBack) const SizedBox(height: 18),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    height: 1.45,
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

class _DecorCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _DecorCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: opacity),
          width: 20,
        ),
      ),
    );
  }
}
