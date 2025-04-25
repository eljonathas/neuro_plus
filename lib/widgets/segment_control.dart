import 'package:flutter/material.dart';
import '../theme.dart';

class SegmentControl extends StatelessWidget {
  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int> onValueChanged;

  const SegmentControl({
    super.key,
    required this.segments,
    required this.selectedIndex,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(segments.length, (i) {
          final bool isActive = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onValueChanged(i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color:
                      isActive ? AppColors.primarySwatch : Colors.transparent,
                  borderRadius: BorderRadius.horizontal(
                    left: i == 0 ? const Radius.circular(8) : Radius.zero,
                    right:
                        i == segments.length - 1
                            ? const Radius.circular(8)
                            : Radius.zero,
                  ),
                ),
                alignment: Alignment.center,
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
