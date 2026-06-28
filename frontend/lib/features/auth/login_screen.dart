import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../state/app_state.dart';
import 'auth_widgets.dart';

/// Customer login with phone-or-email + password. Customers who have not
/// registered yet can jump to the sign up screen.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _busy = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _busy = true);
    final state = context.read<AppState>();
    final error = await state.loginCustomer(
      identifier: _identifierController.text,
      password: _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _busy = false);

    if (error != null) {
      showAuthSnackBar(context, error, isError: true);
      return;
    }
    showAuthSnackBar(context, 'Welcome back, ${state.userName}!');
    context.go('/');
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
                  icon: Icons.person_outline,
                  title: 'Customer Login',
                  subtitle: 'Sign in to book and manage your treatments.',
                ),
                const SizedBox(height: 28),
                AuthTextField(
                  controller: _identifierController,
                  label: 'Phone or Email',
                  hint: 'e.g. 012345678 or you@email.com',
                  icon: Icons.account_circle_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your phone or email.';
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
                  label: 'Log In',
                  busy: _busy,
                  onPressed: _submit,
                ),
                const SizedBox(height: 18),
                Center(
                  child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'New to JongSart? ',
                      style:
                          TextStyle(color: AppColors.textGrey, fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/signup'),
                      child: const Text(
                        'Create an account',
                        style: TextStyle(
                          color: AppColors.primaryMint,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
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
