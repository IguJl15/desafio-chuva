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
  Size get preferredSize => const Size.fromHeight(20);

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

    return Container(
      color: categoryColor,
      child: Center(
        child: Text(
          activity.category.title.value ?? "Sem categoria",
          style: theme.textTheme.bodySmall?.copyWith(color: textColor, height: 1.75),
        ),
      ),
    );
  }
}
