import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
    final labelColor = useState(const Color(0xff666666));
    final focusNode = useFocusNode();
    final obscureText = useState(true);
    final showLabel = useState(labelWhenEmpty);

    useEffect(() {
      void updateLabelVisibility() {
        showLabel.value = focusNode.hasFocus || controller.text.isNotEmpty;
      }

      void updateLabelColor() {
        labelColor.value = focusNode.hasFocus ? const Color(0xff0D47A1) : const Color(0xff666666);
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
        hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xff9e9e9e)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff666666), width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff0D47A1), width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffB3261E), width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffB3261E), width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText.value ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            obscureText.value = !obscureText.value;
          },
        ),
      ),
    );
  }
}
