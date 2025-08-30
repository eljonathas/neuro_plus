import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';

class TriStateSelector extends StatefulWidget {
  final TextEditingController? controller;
  final EdgeInsetsGeometry? padding;
  final String? defaultValue; // 'true', 'false' ou ''
  final bool treatEmptyAsUnselected;
  final ValueChanged<String>? onChanged;

  const TriStateSelector({
    super.key,
    this.controller,
    this.padding,
    this.defaultValue,
    this.treatEmptyAsUnselected = false,
    this.onChanged,
  });

  @override
  State<TriStateSelector> createState() => _TriStateSelectorState();
}

class _TriStateSelectorState extends State<TriStateSelector> {
  String? _uncontrolledValue;

  bool get _isControlled => widget.controller != null;

  @override
  void initState() {
    super.initState();
    if (_isControlled) {
      widget.controller!.addListener(_onExternalChange);
    } else {
      _uncontrolledValue = widget.defaultValue;
    }
  }

  @override
  void didUpdateWidget(covariant TriStateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onExternalChange);
      widget.controller?.addListener(_onExternalChange);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onExternalChange);
    super.dispose();
  }

  void _onExternalChange() {
    if (mounted) setState(() {});
  }

  String _currentTextValue() {
    if (_isControlled) {
      return widget.controller!.text;
    }
    return _uncontrolledValue ?? '';
  }

  String? _selectedLabelFor(String textValue) {
    if (textValue == 'true') return 'Sim';
    if (textValue == 'false') return 'Não';
    if (textValue.isEmpty || textValue == 'not_observed') {
      return widget.treatEmptyAsUnselected ? null : 'Não observado';
    }
    return null;
  }

  void _setValue(String newTextValue) {
    if (_isControlled) {
      widget.controller!.text = newTextValue;
    } else {
      setState(() {
        _uncontrolledValue = newTextValue;
      });
    }
    if (widget.onChanged != null) widget.onChanged!(newTextValue);
  }

  @override
  Widget build(BuildContext context) {
    final String textValue = _currentTextValue();
    final String? groupLabel = _selectedLabelFor(textValue);

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          _buildRadio(
            label: 'Sim',
            groupValue: groupLabel,
            onChanged: () => _setValue('true'),
          ),
          _buildRadio(
            label: 'Não',
            groupValue: groupLabel,
            onChanged: () => _setValue('false'),
          ),
          _buildRadio(
            label: 'Não observado',
            groupValue: groupLabel,
            onChanged: () => _setValue('not_observed'),
          ),
        ],
      ),
    );
  }

  Widget _buildRadio({
    required String label,
    required String? groupValue,
    required VoidCallback onChanged,
  }) {
    final bool isSelected = groupValue == label;
    return GestureDetector(
      onTap: onChanged,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: label,
            groupValue: groupValue,
            activeColor: AppColors.primarySwatch,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (_) => onChanged(),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? AppColors.primarySwatch : Colors.black87,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
