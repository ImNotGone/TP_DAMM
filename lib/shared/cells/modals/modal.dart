import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';
import 'package:ser_manos_mobile/shared/tokens/shadows.dart';
import '../../molecules/buttons/text.dart';

class Modal extends Dialog {
  Modal({
    super.key,
    required Widget child,
    required String confirmButtonText,
    required VoidCallback onConfirm,
    required BuildContext context
  }) : super(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: SerManosColors.neutral0,
        boxShadow: SerManosShadows.shadow3
      ),
      width: 280,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
          const SizedBox(height: 8.0),
          SizedBox(
            height: 44,
            child:  Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                UtilTextButton(
                  onPressed: () => GoRouter.of(context).pop(),
                  text: AppLocalizations.of(context)!.cancel,
                  minWidth: 0,
                ),
                UtilTextButton(
                  onPressed: () {
                    onConfirm();
                    GoRouter.of(context).pop();
                  },
                  text: confirmButtonText,
                  minWidth: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}