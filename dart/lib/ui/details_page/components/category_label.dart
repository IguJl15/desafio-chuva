import 'package:flutter/material.dart';

import '../../../common/utils.dart';
import '../../../models/activity.dart';

class CategoryLabel extends StatelessWidget implements PreferredSizeWidget {
  const CategoryLabel({
    super.key,
    required this.activity,
  });

  final Activity activity;

  @override
  Size get preferredSize => Size.fromHeight(activity.parentActivity != null ? 64 : 20);

  Color _foregroundColorFor(
    Color backgroundColor, [
    darkColor = Colors.black,
    lightColor = Colors.white,
  ]) {
    return ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.light
        ? darkColor
        : lightColor;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final theme = Theme.of(context);

    final categoryColor = activity.category.color != null
        ? Color(colorCodeFromCss(activity.category.color!))
        : Colors.black;

    Color textColor = _foregroundColorFor(categoryColor);

    return Column(
      children: [
        Container(
          color: categoryColor,
          child: Center(
            child: Text(
              activity.category.title.value ?? "Sem categoria",
              style: theme.textTheme.bodySmall?.copyWith(color: textColor, height: 1.75),
            ),
          ),
        ),
        if (activity.parent != null)
          Container(
            color: theme.colorScheme.primary,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(Icons.calendar_month_outlined, color: theme.colorScheme.onPrimary),
                  ),
                  Flexible(
                    child: Text(
                      'Essa atividade é parte de "${activity.parentActivity!.title.value}"',
                      style:
                          theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimary),
                    ),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}
