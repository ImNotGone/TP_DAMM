import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/shared/tokens/shadows.dart';

import '../../tokens/colors.dart';
import '../../tokens/text_style.dart';


class UtilSearchBar extends HookWidget {
  final VoidCallback onIconPressed;
  final ValueChanged<String> onSearchChanged;
  final IconData icon;

  const UtilSearchBar({
    super.key,
    required this.onIconPressed,
    required this.icon,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final focusNode = useFocusNode();

    useEffect(() {
      void listener() => onSearchChanged(searchController.text);
      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    return Container(
      height: 48,
      padding: const EdgeInsets.only(left: 16.0, right: 8),
      decoration: BoxDecoration(
        color: SerManosColors.neutral0,
        borderRadius: BorderRadius.circular(2),
        boxShadow: SerManosShadows.shadow1
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: SerManosColors.neutral75),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: searchController,
              focusNode: focusNode,
              style: SerManosTextStyle.subtitle01(),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.search,
                border: InputBorder.none,
                hintStyle: SerManosTextStyle.subtitle01().copyWith(color: SerManosColors.neutral75),
              ),
              onChanged: onSearchChanged,
            ),
          ),
          if(searchController.text.isNotEmpty)
            IconButton(
              iconSize: 24,
              icon: const Icon(Icons.close, color: SerManosColors.neutral75),
              onPressed: () {
                searchController.clear();
                onSearchChanged('');
              },
            )
          else
            IconButton(
                icon: Icon(icon, color: SerManosColors.primary100),
                onPressed: onIconPressed
            ),
        ],
      ),
    );
  }
}