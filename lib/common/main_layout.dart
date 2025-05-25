import 'package:flutter/material.dart';
import 'package:neuro_plus/common/widgets/bottom_nav_bar.dart';
import 'package:neuro_plus/common/widgets/custom_app_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final int navIndex;
  final bool isBackButtonVisible;

  const MainLayout({
    super.key,
    this.isBackButtonVisible = false,
    required this.child,
    required this.title,
    required this.navIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        onBack: () => Navigator.of(context).pop(),
        isBackButtonVisible: isBackButtonVisible,
      ),
      body: child,
      bottomNavigationBar: CustomBottomNavBar(currentIndex: navIndex),
    );
  }
}
