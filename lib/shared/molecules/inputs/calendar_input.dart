import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/date_validation.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/required_validation.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/validator.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';

import '../../../translations/locale_keys.g.dart';
import '../../tokens/text_style.dart';

class CalendarInput extends HookWidget {
  final DateTime? initialDate;
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String?) onFieldSubmitted;

  const CalendarInput({
    super.key,
    required this.initialDate,
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.onFieldSubmitted
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = useState<Color>(SerManosColors.neutral75); // Initial color

    useEffect(() {
      if (controller.text.isEmpty && initialDate != null) {
        controller.text = DateFormat(LocaleKeys.dateFormat.tr()).format(initialDate!);
      }
      focusNode.addListener(() {
        labelColor.value = focusNode.hasFocus ? SerManosColors.secondary200 : SerManosColors.neutral75;
      });
      return () => {};
    }, [focusNode]);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.datetime,
      style: SerManosTextStyle.subtitle01(),
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _DateInputFormatter(),
      ],
      validator: Validator.apply(context, [
        const DateValidation(),
        const RequiredValidation(),
      ]),

      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: label,
        labelStyle: SerManosTextStyle.body02().copyWith(color: labelColor.value),
        hintText: LocaleKeys.dateFormat.tr().toUpperCase(),
        hintStyle: SerManosTextStyle.subtitle01().copyWith(color: SerManosColors.neutral50),
        helperText: focusNode.hasFocus ? LocaleKeys.dayMonthYear.tr() : null,
        helperStyle: SerManosTextStyle.body02().copyWith(color: SerManosColors.neutral75),
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
          onPressed: () async {
            final DateTime? date = await showDatePicker(
                context: context,
                initialDate: initialDate ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now()
            );
            if(date != null) {
              controller.text = DateFormat(LocaleKeys.dateFormat.tr()).format(date);
            }
          },
          icon: const Icon(
              Icons.calendar_month_outlined,
              color: SerManosColors.primary100
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