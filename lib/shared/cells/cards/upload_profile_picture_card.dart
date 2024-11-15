import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UploadProfilePictureCard extends StatelessWidget {

  final void Function() onUploadPicture;

  const UploadProfilePictureCard({
    super.key,
    required this.onUploadPicture,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryFixed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: SizedBox(
          height: 36,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.profilePicture,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                  height: 36,
                  child: ElevatedButton(
                      onPressed: onUploadPicture,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)
                          ),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary
                      ),
                      child: Text(AppLocalizations.of(context)!.uploadPicture)
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}