import 'package:flutter/material.dart';
import '../../../core/config/theme.dart';

class SegmentControl extends StatelessWidget {
  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int> onValueChanged;

  const SegmentControl({
    Key? key,
    required this.segments,
    required this.selectedIndex,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: List.generate(segments.length, (i) {
          final bool isActive = i == selectedIndex;
          return Padding(
            padding: EdgeInsets.only(right: i == segments.length - 1 ? 0 : 8),
            child: GestureDetector(
              onTap: () => onValueChanged(i),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primarySwatch : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isActive ? Colors.transparent : AppColors.gray[200]!,
                  ),
                ),
                child: Text(
                  segments[i],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.white : AppColors.gray[600],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
