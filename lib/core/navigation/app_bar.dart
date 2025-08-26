import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBack;
  final bool? isBackButtonVisible;
  final bool hideTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onBack,
    this.isBackButtonVisible,
    this.hideTitle = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(kIsWeb ? 80 : 56);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(40)),
      ),
      child: SafeArea(
        bottom: false,
        top: !kIsWeb,
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
            if (!hideTitle)
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
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}
