import "package:expense_tracker/widgets/chart/chart.dart";
import "package:flutter/material.dart";
import "package:uuid/uuid.dart";
import 'package:intl/intl.dart';

// Define a date formatter
final formatter = DateFormat.yMd();

// Generate unique IDs for expenses
const uuid = Uuid();

// Enum representing expense categories
enum Category { food, travel, leisure, work }

// Icons corresponding to each category
const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

// Class representing an expense
class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id; // Unique ID for the expense
  final String title; // Title of the expense
  final double amount; // Amount of money spent
  final DateTime date; // Date of the expense
  final Category category; // Category of the expense

  // Formatted date for display
  String get formattedDate {
    return formatter.format(date);
  }
}

// Class representing a bucket of expenses for a specific category
class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  // Factory constructor to create a bucket with filtered expenses
  factory ExpenseBucket.forCategoryAndTimeFilter(
      List<Expense> allExpenses, Category category, Option selectedOption) {
    List<Expense> filteredExpenses =
        filterExpenses(allExpenses, category, selectedOption);
    return ExpenseBucket(category: category, expenses: filteredExpenses);
  }

  final Category category; // Category for which expenses are grouped
  final List<Expense> expenses; // List of expenses in the bucket

  // Calculate the total sum of expenses in the bucket
  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}

// Function to filter expenses based on category and time period
List<Expense> filterExpenses(
    List<Expense> allExpenses, Category category, Option selectedOption) {
  DateTime currentDate = DateTime.now();
  DateTime startDate;

  switch (selectedOption) {
    case Option.year:
      startDate = currentDate.subtract(const Duration(days: 365));
      break;
    case Option.month:
      startDate = currentDate.subtract(const Duration(days: 30));
      break;
    case Option.week:
      startDate = currentDate.subtract(const Duration(days: 7));
      break;
    case Option.day:
      startDate = currentDate.subtract(const Duration(days: 1));
      break;
    case Option.all:
    default:
      startDate = DateTime(0); // Filter all expenses.
      break;
  }

  // Filter expenses based on startDate and category
  return allExpenses
      .where((expense) =>
          expense.category == category && expense.date.isAfter(startDate))
      .toList();
}
