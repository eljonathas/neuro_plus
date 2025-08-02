import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';

class AppointmentsSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const AppointmentsSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Buscar por paciente, tipo ou protocolo...',
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
            borderSide: const BorderSide(color: AppColors.primarySwatch),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
