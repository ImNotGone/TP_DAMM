import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class CalendarInput extends HookWidget {
  final DateTime? initialDate;
  final String label;
  final TextEditingController controller;

  const CalendarInput({
    super.key,
    required this.initialDate,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = useState<Color>(const Color(0xff666666)); // Initial color
    final focusNode = useFocusNode();

    useEffect(() {
      if (controller.text.isEmpty && initialDate != null) {
        controller.text = DateFormat('dd/MM/yyyy').format(initialDate!);
      }
      focusNode.addListener(() {
        labelColor.value = focusNode.hasFocus ? const Color(0xff0D47A1) : const Color(0xff666666);
      });
      return () => focusNode.dispose();
    }, [focusNode]);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.datetime,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _DateInputFormatter(),
      ],
      // TODO: validator
      // validator: ,

      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: labelColor.value),
        hintText: 'DD/MM/YYYY',
        hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xff9e9e9e)),
        helperText: focusNode.hasFocus ? AppLocalizations.of(context)!.dayMonthYear : null,
        helperStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xff666666)),
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
          onPressed: () async {
            final DateTime? date = await showDatePicker(
                context: context,
                initialDate: initialDate ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now()
            );
            if(date != null) {
              controller.text = DateFormat('dd/MM/yyyy').format(date);
            }
          },
          icon: Icon(Icons.calendar_month_outlined,
              color: Theme.of(context).colorScheme.primary
          ),
        ),
      ),
    );
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();

    // stop writing when user reaches year max
    if(text.length == 9) {
      return oldValue;
    }

    // add / in between date and month, month and year
    for (int i = 0; i < text.length; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}