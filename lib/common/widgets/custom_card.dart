import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';

class CustomCard extends Card {
  CustomCard({super.key, super.child}) : super(
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: AppColors.gray[300]!),
    ),
  );
}