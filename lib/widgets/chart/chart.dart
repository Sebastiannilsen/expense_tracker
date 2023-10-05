import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/chart/chart_bar.dart';
import 'package:expense_tracker/models/expense.dart';

final List<String> options = ['ALL', '1 YEAR', '1 MONTH', '1 WEEK', '1 DAY'];

Option selectedOption = Option.all;

enum Option { all, year, month, week, day }

class Chart extends StatefulWidget {
  final List<Expense> expenses;

  const Chart({Key? key, required this.expenses}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChartState();
  }
}

class _ChartState extends State<Chart> {
  List<Expense> get expenses => widget.expenses;

  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategoryAndTimeFilter(
          expenses, Category.food, selectedOption),
      ExpenseBucket.forCategoryAndTimeFilter(
          expenses, Category.leisure, selectedOption),
      ExpenseBucket.forCategoryAndTimeFilter(
          expenses, Category.travel, selectedOption),
      ExpenseBucket.forCategoryAndTimeFilter(
          expenses, Category.work, selectedOption),
    ];
  }

  double get maxTotalExpense {
    double maxTotalExpense = 0;

    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }

    return maxTotalExpense;
  }

  List<bool> _selections = List.generate(5, (index) => index == 0);

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0)
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets) // alternative to map()
                  ChartBar(
                    fill: bucket.totalExpenses == 0
                        ? 0
                        : bucket.totalExpenses / maxTotalExpense,
                  )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: buckets
                .map(
                  (bucket) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        categoryIcons[bucket.category],
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 18),
          ToggleButtons(
            isSelected: _selections,
            onPressed: (int index) => {
              setState(() {
                // set all values to false
                selectedOption = Option.values[index];
                _selections = List.generate(5, (_) => false);
                _selections[index] = !_selections[index];
              }),
            },
            renderBorder: false,
            children: [
              for (final option in Option.values)
                Container(
                  // Customize the style of each button
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  child: Text(
                    option.name, // Use the text from the options list
                    //style: const TextStyle(fontSize: 10),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
