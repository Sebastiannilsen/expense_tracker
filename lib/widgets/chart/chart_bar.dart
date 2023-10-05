import 'package:flutter/material.dart';

// A widget representing a single bar in a chart
class ChartBar extends StatelessWidget {
  const ChartBar({
    super.key, // A unique key for identifying this widget
    required this.fill, // The fill level (height) of the bar
  });

  final double fill; // The fill level (height) of the bar

  @override
  Widget build(BuildContext context) {
    // Determine if the app is running in dark mode
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Create an expanded container to take up available space
    return Expanded(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 4), // Horizontal padding
        child: FractionallySizedBox(
          heightFactor: fill, // Set the height of the bar
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle, // Bar shape
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8)), // Rounded corners at the top
              color: isDarkMode // Bar color based on dark mode
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.65),
            ),
          ),
        ),
      ),
    );
  }
}
