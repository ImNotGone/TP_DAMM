import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../tokens/colors.dart';

class PasswordInput extends HookWidget {
  final String? label;
  final String? hintText;
  final TextEditingController controller;
  final bool labelWhenEmpty;
  final String? Function(String?)? validator;

  const PasswordInput({
    super.key,
    this.label,
    required this.hintText,
    required this.controller,
    this.labelWhenEmpty = true,
    this.validator
  });


  @override
  Widget build(BuildContext context) {
    final labelColor = useState(SerManosColors.neutral75);
    final focusNode = useFocusNode();
    final obscureText = useState(true);
    final showLabel = useState(labelWhenEmpty);

    useEffect(() {
      void updateLabelVisibility() {
        showLabel.value = focusNode.hasFocus || controller.text.isNotEmpty;
      }

      void updateLabelColor() {
        labelColor.value = focusNode.hasFocus ? SerManosColors.secondary200 : SerManosColors.neutral75;
      }

      focusNode.addListener(updateLabelColor);
      if(!labelWhenEmpty) {
        focusNode.addListener(updateLabelVisibility);
        controller.addListener(updateLabelVisibility);
      }

      return () {
        focusNode.removeListener(updateLabelColor);
        if(!labelWhenEmpty) {
          focusNode.removeListener(updateLabelVisibility);
          controller.removeListener(updateLabelVisibility);
        }
      };
    }, [focusNode, controller]);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText.value,
      style: Theme.of(context).textTheme.titleMedium,
      validator: validator,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: showLabel.value ? label : null,
        labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: labelColor.value),
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: SerManosColors.neutral50),
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
        suffixIcon: IconButton(
          icon: Icon(
            obscureText.value ? Icons.visibility : Icons.visibility_off,
            color: SerManosColors.neutral25,
          ),
          onPressed: () {
            obscureText.value = !obscureText.value;
          },
        ),
      ),
    );
  }
}
