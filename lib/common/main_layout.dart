import 'package:flutter/material.dart';
import 'package:neuro_plus/core/navigation/app_bar.dart';
import 'package:neuro_plus/core/navigation/bottom_nav_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final int navIndex;
  final bool isBackButtonVisible;
  final bool hideTitle;

  const MainLayout({
    super.key,
    this.isBackButtonVisible = false,
    required this.child,
    required this.title,
    required this.navIndex,
    this.hideTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        onBack: () => Navigator.of(context).pop(),
        isBackButtonVisible: isBackButtonVisible,
        hideTitle: hideTitle,
      ),
      body: child,
      bottomNavigationBar: CustomBottomNavBar(currentIndex: navIndex),
    );
  }
}
