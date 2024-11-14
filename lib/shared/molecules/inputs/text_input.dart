import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TextInput extends HookWidget {
  final String? label;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const TextInput({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = useState<Color>(const Color(0xff666666));
    final focusNode = useFocusNode();

    useEffect(() {
      void updateLabelColor() {
        labelColor.value = focusNode.hasFocus ? const Color(0xff0D47A1) : const Color(0xff666666);
      }

      focusNode.addListener(updateLabelColor);

      return () => focusNode.removeListener(updateLabelColor);
    }, [focusNode]);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      // TODO: general formatter?
      //inputFormatters: [
      //],
      // TODO: validator
      // validator: ,

      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: label,
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
        suffixIcon: IconButton(
          onPressed: () {
            controller.text = '';
          },
          icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.primary
          ),
        ),
      ),
    );
  }
}