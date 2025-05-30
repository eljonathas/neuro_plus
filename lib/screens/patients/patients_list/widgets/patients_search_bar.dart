import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';

class PatientsSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const PatientsSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Buscar por nome, responsável ou telefone...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.gray[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.gray[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primarySwatch),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
