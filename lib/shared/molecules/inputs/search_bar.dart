import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../tokens/colors.dart';


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
      // TODO: ver si puedo hacer que el icono sea 24x24 y se mantenga al centro
      padding: const EdgeInsets.only(left: 16.0, right: 8),
      decoration: BoxDecoration(
        color: SerManosColors.neutral0,
        borderRadius: BorderRadius.circular(0.0),
        border: Border.all(color: SerManosColors.neutral25),
        boxShadow: [
          // TODO: revisar color / shadows
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: SerManosColors.neutral75),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: searchController,
              focusNode: focusNode,
              style: Theme.of(context).textTheme.titleMedium,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.search,
                border: InputBorder.none,
                hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: SerManosColors.neutral75),
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
          // TODO: focus is kinda weird, for now it remains like this
          // if(!focusNode.hasFocus && searchController.text.isEmpty)
          IconButton(
                icon: Icon(icon, color: SerManosColors.primary100),
                onPressed: onIconPressed
            ),
        ],
      ),
    );
  }
}