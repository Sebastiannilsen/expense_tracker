import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

// A widget representing an individual expense item
class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense; // The expense to display

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title, // Display the expense title
              style: Theme.of(context)
                  .textTheme
                  .titleLarge, // Apply a specific text style
            ),
            const SizedBox(height: 4), // Add a small vertical gap
            Row(
              children: [
                Text(
                    '\$${expense.amount.toStringAsFixed(2)}'), // Display the expense amount
                const Spacer(), // Expand and separate items on the same row
                Row(
                  children: [
                    Icon(categoryIcons[
                        expense.category]), // Display the expense category icon
                    const SizedBox(width: 8), // Add a small horizontal gap
                    Text(expense
                        .formattedDate), // Display the formatted expense date
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
