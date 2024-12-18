import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';

import '../../../translations/locale_keys.g.dart';
import '../../tokens/text_style.dart';

class ChangeProfilePictureCard extends StatelessWidget {
  final void Function() onUploadPicture;
  final String? profilePictureUrl;
  final File? pickedImage;

  const ChangeProfilePictureCard({
    super.key,
    required this.onUploadPicture,
    this.profilePictureUrl,
    this.pickedImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        color: SerManosColors.secondary25,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 19, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.profilePicture.tr(),
                      style: SerManosTextStyle.subtitle01(),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                        height: 36,
                        child: ElevatedButton(
                            onPressed: onUploadPicture,
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0)),
                                backgroundColor:
                                    SerManosColors.primary100,
                                foregroundColor:
                                    SerManosColors.neutral0),
                            child: Text(
                                LocaleKeys.changePicture.tr()))),
                  ],
                ),
              ),
              ClipOval(
                child: profilePictureUrl != null ?
                Image.network(
                  profilePictureUrl!,
                  width: 84,
                  height: 84,
                  fit: BoxFit.cover,
                )
                : Image.file(
                  pickedImage!,
                  width: 84,
                  height: 84,
                  fit: BoxFit.cover,
                )
              ),
            ],
          ),
        ),
      );
  }
}
