import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitza_mobile_application/core/di/core_providers.dart';
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

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final success = await ref.read(authControllerProvider.notifier).signUp(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;

    if (success) {
      // Email confirmation is enabled on the project, so sign-up usually
      // returns a user without a session until the link is clicked.
      final hasSession =
          ref.read(supabaseClientProvider).auth.currentSession != null;
      if (hasSession) {
        context.goNamed(RouteNames.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Account created. Check your email to confirm, then log in.',
            ),
            duration: Duration(seconds: 4),
          ),
        );
        context.goNamed(RouteNames.login);
      }
      return;
    }

    final error = ref.read(authControllerProvider).error;
    final message = error is Failure
        ? error.message
        : 'Sign up failed. Please try again.';

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
            height: 260,
            child: AuthHillsDecoration(),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton.filledTonal(
                      onPressed: () => context.pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.textDark,
                      ),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: FitzaBrandHeader(markSize: 52),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text.rich(
                    TextSpan(
                      text: 'Create ',
                      children: [
                        TextSpan(
                          text: 'Account',
                          style: TextStyle(color: context.colorScheme.primary),
                        ),
                      ],
                    ),
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Start your health and productivity journey with Fitza.',
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
                          controller: _fullNameController,
                          hint: 'Full name',
                          prefixIcon: AuthAsset.user,
                          validator: AuthValidators.fullName,
                          enabled: !isLoading,
                        ),
                        const SizedBox(height: AppSpacing.md),
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
                        const SizedBox(height: AppSpacing.md),
                        AuthTextField(
                          controller: _confirmPasswordController,
                          hint: 'Confirm password',
                          prefixIcon: AuthAsset.lock,
                          isPassword: true,
                          enabled: !isLoading,
                          validator: (value) {
                            if ((value ?? '').isEmpty) {
                              return 'Please confirm your password.';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        GradientButton(
                          label: 'Sign Up',
                          isLoading: isLoading,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: AppColors.mutedText),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      TextButton(
                        onPressed:
                            isLoading ? null : () => context.pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs),
                        ),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
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
