import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neuro_plus/common/config/theme.dart';

enum InputVariant { filled, outlined, link, ghost, icon }

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? labelText;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final InputVariant variant;
  final int minLines;
  final int maxLines;
  final bool expands;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  const CustomFormField({
    super.key,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.labelText,
    this.hintText,
    this.hintStyle,
    this.inputType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.variant = InputVariant.filled,
    this.minLines = 1,
    this.maxLines = 1,
    this.expands = false,
    this.textInputAction,
    this.inputFormatters,
  });

  bool get isTextArea => maxLines > 1 || expands;

  OutlineInputBorder _outlineBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: color),
  );

  OutlineInputBorder _noneBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
  );

  InputDecoration _buildDecoration() {
    switch (variant) {
      case InputVariant.outlined:
        return InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.gray[400]).merge(hintStyle),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
          border: _outlineBorder(AppColors.gray[300]!),
          enabledBorder: _outlineBorder(AppColors.gray[300]!),
          focusedBorder: _outlineBorder(AppColors.primarySwatch),
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        );

      case InputVariant.filled:
        return InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.gray[400]).merge(hintStyle),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
          border: _noneBorder(),
          enabledBorder: _noneBorder(),
          focusedBorder: _noneBorder(),
          fillColor: AppColors.gray[100]!,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        );

      case InputVariant.link:
        return InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: (hintStyle ?? const TextStyle()).copyWith(
            color: AppColors.primarySwatch,
            decoration: TextDecoration.underline,
          ),
          contentPadding: EdgeInsets.zero,
        );

      case InputVariant.ghost:
        return InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.gray[400]).merge(hintStyle),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
          border: _noneBorder(),
          enabledBorder: _noneBorder(),
          focusedBorder: _noneBorder(),
          filled: false,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        );

      case InputVariant.icon:
        return InputDecoration(
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
          border: _noneBorder(),
          enabledBorder: _noneBorder(),
          focusedBorder: _noneBorder(),
          isDense: true,
          contentPadding: EdgeInsets.zero,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      textInputAction: textInputAction,
      validator: validator,
      obscureText: obscureText,
      minLines: isTextArea ? minLines : 1,
      maxLines: isTextArea ? maxLines : 1,
      expands: expands,
      inputFormatters: inputFormatters,
      decoration: _buildDecoration().copyWith(
        errorStyle: const TextStyle(color: Colors.red),
        errorBorder: _outlineBorder(Colors.red),
        focusedErrorBorder: _outlineBorder(Colors.red),
      ),
    );
  }
}
