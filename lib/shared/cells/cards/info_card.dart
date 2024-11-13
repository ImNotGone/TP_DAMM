import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/shared/cells/cards/blue_header_card.dart';

class ProfileInfoCard extends StatefulWidget {
  final void Function(String) onGenderSelected;
  const ProfileInfoCard({super.key, required this.onGenderSelected});

  @override
  ProfileInfoCardState createState() => ProfileInfoCardState();
}

class ProfileInfoCardState extends State<ProfileInfoCard> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return BlueHeaderCard(
      title: AppLocalizations.of(context)!.profileInfo,
        child:
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRadioButton(context, label: AppLocalizations.of(context)!.male, value: 'male'),
              _buildRadioButton(context, label: AppLocalizations.of(context)!.female, value: 'female'),
              _buildRadioButton(context, label: AppLocalizations.of(context)!.nonBinary, value: 'nonBinary')
            ],
          ),
        ),
    );
  }

  Widget _buildRadioButton(BuildContext context, {required String label, required String value}) {
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
                // TODO: make it green when unselected
                child: Radio(
                  value: value,
                  groupValue: selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue;
                    });
                    widget.onGenderSelected(newValue!);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(label, style: Theme.of(context).textTheme.bodyLarge)
            ],
          ),
        )
    );
  }
}

