import "package:expense_tracker/widgets/chart/chart.dart";
import "package:flutter/material.dart";
import "package:uuid/uuid.dart";
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  factory ExpenseBucket.forCategoryAndTimeFilter(
      List<Expense> allExpenses, Category category, Option selectedOption) {
    List<Expense> filteredExpenses =
        filterExpenses(allExpenses, category, selectedOption);
    return ExpenseBucket(category: category, expenses: filteredExpenses);
  }

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}

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
