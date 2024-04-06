import 'package:chuva_dart/common/utils.dart';
import 'package:flutter/material.dart';

class DatesTabBar extends StatelessWidget {
  final DateTime _selectedDate;
  final List<DateTime> _dates;
  final void Function(DateTime) onDateSelect;

  DatesTabBar({
    super.key,
    required DateTime selectedDate,
    required List<DateTime> dates,
    required this.onDateSelect,
  })  : _dates = dates.map(simplifiedDateTime).toSet().toList(),
        _selectedDate = simplifiedDateTime(selectedDate) {
    _dates.sort((a, b) => a.compareTo(b));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);

    final year = localizations.formatYear(_selectedDate);
    final month = localizations
        .formatShortMonthDay(_selectedDate)
        .split(" ")
        .firstWhere((date) => date.contains(RegExp(r"\D")));

    var initialIndex = _dates.indexOf(_selectedDate);
    if (initialIndex < 0) initialIndex = 0;

    return DefaultTabController(
      initialIndex: initialIndex,
      length: _dates.length,
      child: Row(
        children: [
          Container(
            color: colorScheme.primaryContainer,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text.rich(
              TextSpan(
                text: "$month\n",
                children: [
                  TextSpan(
                    text: year,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: colorScheme.onPrimaryContainer, height: 1.4),
              // height maintain consistency between Material Design Versions
            ),
          ),
          Flexible(
            child: Container(
              color: colorScheme.primary,
              child: TabBar(
                onTap: (index) => onDateSelect(_dates[index]),
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerHeight: 0,
                labelColor: colorScheme.onPrimary,
                indicatorColor: colorScheme.onPrimaryContainer,
                unselectedLabelColor: colorScheme.onPrimary.withOpacity(0.65),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: _dates.map((e) => Tab(text: "${e.day}")).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
