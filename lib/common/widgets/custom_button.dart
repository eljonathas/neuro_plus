import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final double borderRadius;
  final EdgeInsets padding;
  final double margin;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isLoading;
  final double? width;
  final bool isDisabled;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primarySwatch,
    this.foregroundColor = Colors.white,
    this.isLoading = false,
    this.fontWeight = FontWeight.w600,
    this.fontSize = 16,
    this.elevation = 0,
    this.borderRadius = 8,
    this.padding = const EdgeInsets.all(16),
    this.margin = 0,
    this.width,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      width: width,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          disabledBackgroundColor: Colors.grey[400],
          disabledForegroundColor: Colors.white,
          padding: padding,
        ),
        child:
            isLoading
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      foregroundColor ?? Colors.white,
                    ),
                  ),
                )
                : Text(
                  text,
                  style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
                ),
      ),
    );
  }
}
