import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/cells/cards/blue_header_card.dart';

import '../../../auth/domain/app_user.dart';
import '../../../translations/locale_keys.g.dart';
import '../../tokens/text_style.dart';

class InputCard extends StatefulWidget {
  final void Function(Gender) onGenderSelected;
  final Gender? previousGender;
  const InputCard({super.key, required this.onGenderSelected, this.previousGender});

  @override
  InputCardState createState() => InputCardState();
}

class InputCardState extends State<InputCard> {
  Gender? selectedGender;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.previousGender;
  }

  @override
  Widget build(BuildContext context) {
    return BlueHeaderCard(
      title: LocaleKeys.profileInfo.tr(),
        child:
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRadioButton(context, label: Gender.male.localizedName(context), value: Gender.male),
              _buildRadioButton(context, label: Gender.female.localizedName(context), value: Gender.female),
              _buildRadioButton(context, label: Gender.nonBinary.localizedName(context), value: Gender.nonBinary),
            ],
          ),
        ),
    );
  }

  Widget _buildRadioButton(BuildContext context, {required String label, required Gender value}) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedGender = value;
        });
        widget.onGenderSelected(value);
      },
      child: Container (
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Radio(
                  value: value,
                  groupValue: selectedGender,
                  onChanged: (Gender? newValue) {
                    setState(() {
                      selectedGender = newValue;
                    });
                    widget.onGenderSelected(newValue!);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(label, style: SerManosTextStyle.body01())
            ],
          ),
        )
    );
  }
}

