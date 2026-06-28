import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../state/app_state.dart';
import 'auth_widgets.dart';

/// Staff-only login against the mock staff account. There is intentionally
/// no public staff registration.
class StaffLoginScreen extends StatefulWidget {
  const StaffLoginScreen({super.key});

  @override
  State<StaffLoginScreen> createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends State<StaffLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _busy = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _busy = true);
    final state = context.read<AppState>();
    final error = await state.loginStaff(
      username: _usernameController.text,
      password: _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _busy = false);

    if (error != null) {
      showAuthSnackBar(context, error, isError: true);
      return;
    }
    showAuthSnackBar(context, 'Signed in as Clinic Staff.');
    context.go('/clinic-staff');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/role-selection'),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF007D68)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthHeader(
                  icon: Icons.badge_outlined,
                  title: 'Staff Login',
                  subtitle:
                      'Clinic staff only. Sign in to manage appointment requests.',
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryMintLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: AppColors.primaryMint, size: 18),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Demo staff account:\nstaff@jongsart.com / staff123',
                          style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 12,
                              height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AuthTextField(
                  controller: _usernameController,
                  label: 'Staff Email or Username',
                  hint: 'staff@jongsart.com',
                  icon: Icons.account_circle_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your staff email or username.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  icon: Icons.lock_outline,
                  obscure: _obscure,
                  textInputAction: TextInputAction.done,
                  suffix: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textGrey,
                      size: 20,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AuthPrimaryButton(
                  label: 'Log In as Staff',
                  busy: _busy,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
