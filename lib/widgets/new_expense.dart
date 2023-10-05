import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

// A widget representing the form for adding a new expense
class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense)
      onAddExpense; // Callback for adding a new expense

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController =
      TextEditingController(); // Controller for the title input
  final _amountController =
      TextEditingController(); // Controller for the amount input
  DateTime? _selectedDate; // Selected date for the expense
  Category _selectedCategory = Category.food; // Default selected category

  // Function to show the date picker and update the selected date
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() => _selectedDate = pickedDate);
  }

  // Function to submit the expense data
  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      // Show an alert dialog for invalid input
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date, and category were entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }
    // Call the callback function to add the expense
    widget.onAddExpense(Expense(
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    ));
    // Close the modal bottom sheet
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // Dispose of controllers when the widget is disposed
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController, // Bind controller to title input
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'), // Label for the title input
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller:
                      _amountController, // Bind controller to amount input
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    label: Text('Amount'), // Label for the amount input
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'No date selected'
                          : formatter
                              .format(_selectedDate!), // Display selected date
                    ),
                    IconButton(
                      onPressed: _presentDatePicker, // Show date picker
                      icon: const Icon(Icons.calendar_month), // Calendar icon
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 46,
          ),
          Row(
            children: [
              DropdownButton(
                  value: _selectedCategory, // Selected category
                  items: Category.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.name
                                .toUpperCase(), // Display category name
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedCategory = value; // Update selected category
                    });
                  }),
              const Spacer(), // Expand and separate items on the same row
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the modal bottom sheet
                },
                child: const Text('Cancel'), // Cancel button
              ),
              ElevatedButton(
                onPressed: _submitExpenseData, // Submit expense data
                child: const Text('Save Expense'), // Save button
              ),
            ],
          ),
        ],
      ),
    );
  }
}
