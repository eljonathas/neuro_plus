import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBack;
  final bool? isBackButtonVisible;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onBack,
    this.isBackButtonVisible,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56); // Altura ajustada a fit-content (48 de conteúdo + 16 padding top/bottom)

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(40)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isBackButtonVisible ?? true)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: onBack,
                ),
              )
            else
              const SizedBox(width: 48),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            // Espaço vazio para manter o título centralizado
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}
