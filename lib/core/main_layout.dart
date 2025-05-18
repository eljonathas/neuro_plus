import 'package:flutter/material.dart';
import 'package:neuro_plus/core/widgets/bottom_nav_bar.dart';
import 'package:neuro_plus/core/widgets/custom_app_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final int navIndex;
  final ValueChanged<int> onNavTap;
  final bool isBackButtonVisible;
  final EdgeInsets padding;

  const MainLayout({
    super.key,
    this.isBackButtonVisible = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    required this.child,
    required this.title,
    required this.navIndex,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        onBack: () => Navigator.of(context).pop(),
        isBackButtonVisible: isBackButtonVisible,
      ),
      body: SingleChildScrollView(padding: padding, child: child),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: navIndex,
        onTap: onNavTap,
      ),
    );
  }
}
