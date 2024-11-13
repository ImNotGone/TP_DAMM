import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeProfilePictureCard extends StatelessWidget {

  final Future<void> Function() onUploadPicture;
  final String profilePictureUrl;

  const ChangeProfilePictureCard({
    super.key,
    required this.onUploadPicture,
    required this.profilePictureUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryFixed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 19, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.profilePicture,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    // TODO: replace this button
                    SizedBox(
                      height: 36,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          onUploadPicture();
                        },
                        label: Text(AppLocalizations.of(context)!.changePicture),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ClipOval(
                child: Image.network(
                  profilePictureUrl,
                  width: 84,
                  height: 84,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
    );
  }
}