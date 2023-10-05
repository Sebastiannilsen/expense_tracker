import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

// A widget representing a list of expenses
class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses, // List of expenses to display
    required this.onRemoveExpense, // Callback function for removing an expense
  });

  final List<Expense> expenses; // List of expenses to display
  final void Function(Expense expense)
      onRemoveExpense; // Callback for removing an expense

  @override
  Widget build(BuildContext context) {
    // Create a scrollable list view
    return ListView.builder(
      itemCount: expenses.length, // Number of items in the list
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index]), // Unique key for the dismissed item
        background: Container(
          color: Theme.of(context)
              .colorScheme
              .error
              .withOpacity(0.75), // Background color when swiping to delete
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),
        onDismissed: (direction) {
          // Callback when an expense is dismissed (e.g., swiped away)
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItem(
          expenses[index], // Display the expense item
        ),
      ),
    );
  }
}
