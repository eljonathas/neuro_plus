import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neuro_plus/common/config/theme.dart';

enum TagsFieldVariant { filled, outlined }

class CustomTagsField extends FormField<List<String>> {
  CustomTagsField({
    super.key,
    List<String> initialTags = const [],
    this.hintText,
    this.variant = TagsFieldVariant.outlined,
    this.onChanged,
    super.validator,
    AutovalidateMode super.autovalidateMode = AutovalidateMode.disabled,
  })  : _initialTags = initialTags,
        super(
          initialValue: List.from(initialTags),
          builder: (field) {
            final state = field as _CustomTagsFieldState;
            final tags = List<String>.from(state.value!);
            final focus = state._focusNode;
            final controller = state._controller;
            final borderColor = field.hasError
                ? Colors.red
                : (focus.hasFocus ? AppColors.primarySwatch : AppColors.gray[300]!);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => FocusScope.of(field.context).requestFocus(focus),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: state.widget.variant == TagsFieldVariant.filled
                          ? AppColors.gray[100]
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...tags.map((tag) => TagWidget(
                          key: ValueKey(tag),
                          tag: tag,
                          onRemove: () => state._removeTag(tag),
                        )),
                        IntrinsicWidth(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 100),
                            child: KeyboardListener(
                              focusNode: FocusNode(),
                              onKeyEvent: (event) {
                                if (event is KeyDownEvent &&
                                    event.logicalKey == LogicalKeyboardKey.backspace &&
                                    controller.text.isEmpty &&
                                    tags.isNotEmpty) {
                                  state._removeLastTagToInput();
                                }
                              },
                              child: TextField(
                                controller: controller,
                                focusNode: focus,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (value) {
                                  state._addTag(value);
                                  controller.clear();
                                },
                                onChanged: (value) {
                                  if (value.endsWith(',')) {
                                    final tagText = value.substring(0, value.length - 1);
                                    state._addTag(tagText);
                                    controller.clear();
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: tags.isEmpty
                                      ? state.widget.hintText ?? 'Adicione tags (pressione a vírgula)'
                                      : null,
                                  hintStyle: TextStyle(color: AppColors.gray[400]),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 12),
                    child: Text(
                      field.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        );

  final List<String> _initialTags;
  final String? hintText;
  final TagsFieldVariant variant;
  final ValueChanged<List<String>>? onChanged;

  @override
  FormFieldState<List<String>> createState() => _CustomTagsFieldState();
}

class _CustomTagsFieldState extends FormFieldState<List<String>> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(() => setState(() {}));
    _controller = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant CustomTagsField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget._initialTags, widget._initialTags)) {
      setValue(List.from(widget._initialTags));
    }
  }

  void _addTag(String raw) {
    final tag = raw.trim();
    if (tag.isEmpty || value!.contains(tag)) return;
    final updated = [...value!, tag];
    didChange(updated);
    widget.onChanged?.call(updated);
  }

  void _removeTag(String tag) {
    final updated = value!..remove(tag);
    didChange(updated);
    widget.onChanged?.call(updated);
  }

  void _removeLastTagToInput() {
    final tags = List<String>.from(value!);
    if (tags.isNotEmpty) {
      final lastTag = tags.last;
      final updated = [...value!]..remove(lastTag);
      didChange(updated);
      widget.onChanged?.call(updated);
      _controller.text = lastTag;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  CustomTagsField get widget => super.widget as CustomTagsField;
}

class TagWidget extends StatelessWidget {
  final String tag;
  final VoidCallback onRemove;

  const TagWidget({
    required this.tag,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primarySwatch.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primarySwatch.withAlpha(30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: TextStyle(
              color: AppColors.primarySwatch,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 14, color: AppColors.primarySwatch),
          ),
        ],
      ),
    );
  }
}