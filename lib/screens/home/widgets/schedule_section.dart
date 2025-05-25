import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';

class ScheduleSection extends StatefulWidget {
  final String title;
  final int count;
  final List<Widget> children;
  final bool initiallyExpanded;

  const ScheduleSection({
    super.key,
    required this.title,
    required this.count,
    required this.children,
    this.initiallyExpanded = true,
  });

  @override
  State<ScheduleSection> createState() => _ScheduleSectionState();
}

class _ScheduleSectionState extends State<ScheduleSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.gray[200]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.blueRibbon[500],
                  ),
                ),
                Text(
                  '${widget.title}(${widget.count})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.gray[600],
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: Column(children: widget.children),
          secondChild: const SizedBox(height: 0),
          crossFadeState:
              _isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
