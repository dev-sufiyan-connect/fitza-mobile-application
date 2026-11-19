import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitza_mobile_application/core/error/failures.dart';
import 'package:fitza_mobile_application/core/router/route_names.dart';
import 'package:fitza_mobile_application/core/theme/app_colors.dart';
import 'package:fitza_mobile_application/core/theme/app_theme.dart';
import 'package:fitza_mobile_application/features/auth/presentation/providers/auth_providers.dart';
import 'package:fitza_mobile_application/features/auth/presentation/widgets/auth_assets.dart';
import 'package:fitza_mobile_application/features/auth/presentation/widgets/auth_hills_decoration.dart';
import 'package:fitza_mobile_application/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:fitza_mobile_application/features/auth/presentation/widgets/fitza_brand_header.dart';
import 'package:fitza_mobile_application/features/auth/presentation/widgets/gradient_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final success = await ref.read(authControllerProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;

    if (success) {
      context.goNamed(RouteNames.home);
      return;
    }

    final error = ref.read(authControllerProvider).error;
    final message = error is Failure
        ? error.message
        : 'Sign in failed. Check your credentials.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Soft green hills + sun decoration, top-right
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 240,
            child: AuthHillsDecoration(),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: FitzaBrandHeader(markSize: 52),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Welcome Back 👋',
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Sign in to continue your journey with Fitza.',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.mutedText,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthTextField(
                          controller: _emailController,
                          hint: 'Email or phone number',
                          prefixIcon: AuthAsset.mail,
                          validator: AuthValidators.identifier,
                          enabled: !isLoading,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AuthTextField(
                          controller: _passwordController,
                          hint: 'Password',
                          prefixIcon: AuthAsset.lock,
                          validator: AuthValidators.password,
                          isPassword: true,
                          enabled: !isLoading,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: isLoading ? null : () {},
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                              ),
                            ),
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        GradientButton(
                          label: 'Log In',
                          isLoading: isLoading,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const _OrContinueWithDivider(),
                  const SizedBox(height: AppSpacing.lg),
                  const Row(
                    children: [
                      Expanded(child: _SocialButton.google()),
                      SizedBox(width: AppSpacing.md),
                      Expanded(child: _SocialButton.apple()),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SignUpRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Actions
// ---------------------------------------------------------------------------

class _OrContinueWithDivider extends StatelessWidget {
  const _OrContinueWithDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE3E8E3))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'OR CONTINUE WITH',
            style: context.textTheme.labelSmall?.copyWith(
              color: AppColors.mutedText,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE3E8E3))),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton.google() : _icon = AuthAsset.google, label = 'Google';

  const _SocialButton.apple() : _icon = AuthAsset.apple, label = 'Apple';

  final String _icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: Color(0xFFE3E8E3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AuthIcon(_icon, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(label),
        ],
      ),
    );
  }
}

class _SignUpRow extends StatelessWidget {
  const _SignUpRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: AppColors.mutedText),
        ),
        const SizedBox(width: AppSpacing.xs),
        TextButton(
          onPressed: () => context.pushNamed(RouteNames.signup),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
