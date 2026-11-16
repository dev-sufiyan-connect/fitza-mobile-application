import 'package:flutter/material.dart';

import 'package:fitza_mobile_application/core/theme/app_colors.dart';
import 'package:fitza_mobile_application/core/theme/app_theme.dart';
import 'package:fitza_mobile_application/features/auth/presentation/widgets/auth_assets.dart';

/// Pill-shaped input used across auth screens (soft gray-green fill,
/// leading icon, optional visibility toggle for passwords).
class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    required this.validator,
    this.isPassword = false,
    this.enabled = true,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final String prefixIcon;
  final String? Function(String?) validator;
  final bool isPassword;
  final bool enabled;
  final TextInputType? keyboardType;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.isPassword && _obscure,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      style: const TextStyle(
        color: AppColors.textDark,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(color: AppColors.mutedText),
        filled: true,
        fillColor: const Color(0xFFF1F4F1),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: 16),
        prefixIcon: Padding(
          padding:
              const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.sm),
          child: AuthIcon(widget.prefixIcon, color: AppColors.textDark),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: widget.isPassword
            ? IconButton(
                splashRadius: 20,
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: AuthIcon(
                  _obscure ? AuthAsset.eyeOff : AuthAsset.eye,
                  color: AppColors.mutedText,
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// Validators shared by auth screens.
abstract final class AuthValidators {
  static String? identifier(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email or phone number is required.';
    final email = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
    final phone = RegExp(r'^\+?\d{7,15}$');
    if (!email.hasMatch(v) && !phone.hasMatch(v)) {
      return 'Enter a valid email or phone number.';
    }
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required.';
    if (v.length < 6) return 'Password must be at least 6 characters.';
    return null;
  }

  static String? fullName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Full name is required.';
    if (v.length < 2) return 'Enter your full name.';
    return null;
  }
}
