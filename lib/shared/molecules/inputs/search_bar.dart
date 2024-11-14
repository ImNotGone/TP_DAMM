import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(0.0),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        boxShadow: [
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
          Icon(Icons.search, color: Theme.of(context).iconTheme.color),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: searchController,
              focusNode: focusNode,
              style: Theme.of(context).textTheme.titleMedium,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.search,
                border: InputBorder.none,
                hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xff666666)),
              ),
              onChanged: onSearchChanged,
            ),
          ),
          if(searchController.text.isNotEmpty)
            IconButton(
              iconSize: 24,
              icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color,),
              onPressed: () {
                searchController.clear();
                onSearchChanged('');
              },
            )
          else
          // TODO: focus is kinda weird, for now it remains like this
          // if(!focusNode.hasFocus && searchController.text.isEmpty)
          IconButton(
                icon: Icon(icon, color: Theme.of(context).colorScheme.primary),
                onPressed: onIconPressed
            ),
        ],
      ),
    );
  }
}