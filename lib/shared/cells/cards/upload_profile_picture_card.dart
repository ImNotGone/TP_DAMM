import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../translations/locale_keys.g.dart';
import '../../tokens/colors.dart';
import '../../tokens/text_style.dart';

class UploadProfilePictureCard extends StatelessWidget {

  final void Function() onUploadPicture;

  const UploadProfilePictureCard({
    super.key,
    required this.onUploadPicture,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: SerManosColors.secondary25,
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
                LocaleKeys.profilePicture.tr(),
                style: SerManosTextStyle.subtitle01(),
              ),
              SizedBox(
                  height: 36,
                  child: ElevatedButton(
                      onPressed: onUploadPicture,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)
                          ),
                          backgroundColor: SerManosColors.primary100,
                          foregroundColor: SerManosColors.neutral0
                      ),
                      child: Text(LocaleKeys.uploadPicture.tr())
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}