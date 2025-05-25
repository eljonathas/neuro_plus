import 'package:flutter/material.dart';
import '../../../common/config/theme.dart';

class RecentItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const RecentItem({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: AppColors.gray[600]),
              ),
            ],
          ),
          Icon(Icons.remove_red_eye, color: AppColors.gray[600]),
        ],
      ),
    );
  }
}
