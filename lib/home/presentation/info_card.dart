import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileInfoCard extends StatefulWidget {
  const ProfileInfoCard({super.key});

  @override
  ProfileInfoCardState createState() => ProfileInfoCardState();
}

class ProfileInfoCardState extends State<ProfileInfoCard> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
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



class CustomCard extends StatelessWidget {
  final String title;
  final Widget child;

  const CustomCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header azul
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryFixed,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4)
              )
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

