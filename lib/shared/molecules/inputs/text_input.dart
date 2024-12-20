import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../tokens/colors.dart';
import '../../tokens/text_style.dart';

class UtilTextInput extends HookWidget {
  final String? label;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool labelWhenEmpty;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final void Function(String?) onFieldSubmitted;

  const UtilTextInput({
    super.key,
    this.label,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    required this.focusNode,
    required this.onFieldSubmitted,
    this.labelWhenEmpty = true,
    this.validator,
    this.textInputAction = TextInputAction.done,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = useState(SerManosColors.neutral75);

    final showLabel = useState(labelWhenEmpty);
    final showCloseIcon = useState(false);

    useEffect(() {
      void updateLabelVisibility() {
        showLabel.value = focusNode.hasFocus || controller.text.isNotEmpty;
      }

      void updateLabelColor() {
        labelColor.value = focusNode.hasFocus ? SerManosColors.secondary200 : SerManosColors.neutral75;
      }

      void updateCloseIconVisibility() {
        showCloseIcon.value = focusNode.hasFocus && controller.text.isNotEmpty;
      }

      focusNode.addListener(updateLabelColor);
      if(!labelWhenEmpty) {
        focusNode.addListener(updateLabelVisibility);
        controller.addListener(updateLabelVisibility);
      }
      focusNode.addListener(updateCloseIconVisibility);
      controller.addListener(updateCloseIconVisibility);

      return () {
        focusNode.removeListener(updateLabelColor);
        if(!labelWhenEmpty) {
          focusNode.removeListener(updateLabelVisibility);
          controller.removeListener(updateLabelVisibility);
        }
        focusNode.removeListener(updateCloseIconVisibility);
        controller.removeListener(updateCloseIconVisibility);
      };
    }, [focusNode, controller]);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      style: SerManosTextStyle.subtitle01(),
      validator: validator,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: showLabel.value ? label : null,
        labelStyle: SerManosTextStyle.body02().copyWith(color: labelColor.value),
        hintText: hintText,
        hintStyle: SerManosTextStyle.subtitle01().copyWith(color: SerManosColors.neutral50),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: SerManosColors.neutral75, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: SerManosColors.secondary200, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: SerManosColors.error100, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: SerManosColors.error100, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        suffixIcon: showCloseIcon.value
          ? IconButton(
              onPressed: () {
                controller.text = '';
              },
              icon: const Icon(
                  Icons.close,
                  color: SerManosColors.neutral75
              )
          )
          : null,
        ),
      );
  }
}