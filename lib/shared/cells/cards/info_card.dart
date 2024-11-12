import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/shared/cells/cards/blue_header_card.dart';

class ProfileInfoCard extends StatefulWidget {
  const ProfileInfoCard({super.key});

  @override
  ProfileInfoCardState createState() => ProfileInfoCardState();
}

class ProfileInfoCardState extends State<ProfileInfoCard> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return BlueHeaderCard(
      title: AppLocalizations.of(context)!.profileInfo,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRadioButton(context, label: AppLocalizations.of(context)!.male),
            _buildRadioButton(context, label: AppLocalizations.of(context)!.female),
            _buildRadioButton(context, label: AppLocalizations.of(context)!.nonBinary)
          ],
        ),
    );
  }

  Widget _buildRadioButton(BuildContext context, {required String label}) {
    return
      RadioListTile<String>(
        title: Text(label, style: Theme.of(context).textTheme.bodyLarge,),
        value: label,
        groupValue: selectedGender,
        onChanged: (value) {
          setState(() {
            selectedGender = value;
          });
          },
        dense: true,
        activeColor: Theme.of(context).colorScheme.primary,
        hoverColor: Theme.of(context).colorScheme.primary,
        contentPadding: EdgeInsets.zero,
      );
  }
}

