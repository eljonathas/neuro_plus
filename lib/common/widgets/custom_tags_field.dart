import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';

enum TagsFieldVariant { filled, outlined }

/// A tag input field that allows adding and removing tags separated by comma.
/// Returns the list of tags via onChanged and in validator.
class CustomTagsField extends FormField<List<String>> {
  CustomTagsField({
    Key? key,
    List<String> initialTags = const [],
    this.hintText,
    this.variant = TagsFieldVariant.outlined,
    this.onChanged,
    FormFieldValidator<List<String>>? validator,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  }) : super(
         key: key,
         initialValue: List.from(initialTags),
         validator: validator,
         autovalidateMode: autovalidateMode,
         builder: (state) {
           final tags = state.value!;
           final focus = FocusNode();
           final controller = TextEditingController();

           void addTag(String raw) {
             final tag = raw.trim();
             if (tag.isEmpty || tags.contains(tag)) return;
             tags.add(tag);
             state.didChange(tags);
             onChanged?.call(tags);
             controller.clear();
           }

           void removeTag(String tag) {
             tags.remove(tag);
             state.didChange(tags);
             onChanged?.call(tags);
           }

           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               InkWell(
                 onTap: () => FocusScope.of(state.context).requestFocus(focus),
                 child: Container(
                   decoration: BoxDecoration(
                     color:
                         variant == TagsFieldVariant.filled
                             ? AppColors.gray[100]
                             : Colors.white,
                     borderRadius: BorderRadius.circular(8),
                     border: Border.all(
                       color:
                           state.hasError
                               ? Colors.red
                               : focus.hasFocus
                               ? AppColors.primarySwatch
                               : AppColors.gray[300]!,
                     ),
                   ),
                   padding: const EdgeInsets.symmetric(
                     horizontal: 12,
                     vertical: 8,
                   ),
                   child: Wrap(
                     spacing: 4,
                     runSpacing: 4,
                     children: [
                       ...tags.map(
                         (tag) => InputChip(
                           label: Text(tag),
                           onDeleted: () => removeTag(tag),
                           materialTapTargetSize:
                               MaterialTapTargetSize.shrinkWrap,
                         ),
                       ),
                       SizedBox(
                         width: 100,
                         child: TextField(
                           controller: controller,
                           focusNode: focus,
                           onSubmitted: addTag,
                           onChanged: (value) {
                             if (value.endsWith(','))
                               addTag(value.substring(0, value.length - 1));
                           },
                           decoration: InputDecoration(
                             hintText:
                                 tags.isEmpty
                                     ? hintText ?? 'Add tag (press comma)'
                                     : null,
                             border: InputBorder.none,
                             isDense: true,
                             contentPadding: EdgeInsets.zero,
                           ),
                           textInputAction: TextInputAction.done,
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
               if (state.hasError)
                 Padding(
                   padding: const EdgeInsets.only(top: 4, left: 12),
                   child: Text(
                     state.errorText!,
                     style: const TextStyle(color: Colors.red, fontSize: 12),
                   ),
                 ),
             ],
           );
         },
       );

  final String? hintText;
  final TagsFieldVariant variant;
  final ValueChanged<List<String>>? onChanged;
}
