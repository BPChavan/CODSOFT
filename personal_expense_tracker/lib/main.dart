import 'package:flutter/material.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExpenseTrackerHomePage(),
    );
  }
}

class ExpenseTrackerHomePage extends StatefulWidget {
  const ExpenseTrackerHomePage({Key? key});

  @override
  _ExpenseTrackerHomePageState createState() => _ExpenseTrackerHomePageState();
}

class _ExpenseTrackerHomePageState extends State<ExpenseTrackerHomePage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final budgetController = TextEditingController(); // Controller for the budget input field

  final List<Transaction> _transactions = [];

  String _selectedCategory = 'All'; // Default category filter
  double _monthlyBudget = 0; // Variable to store the monthly budget value

  void _addTransaction() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    setState(() {
      _transactions.add(Transaction(
        title: enteredTitle,
        amount: enteredAmount,
        date: DateTime.now(),
        category: _selectedCategory,
      ));
    });

    titleController.clear();
    amountController.clear();
  }

  void _setCategory(String? category) {
    if (category != null) {
      setState(() {
        _selectedCategory = category;
      });
    }
  }

  void _showAllTransactions() {
    setState(() {
      _selectedCategory = 'All';
    });
  }

  void _setMonthlyBudget(double newBudget) {
    if (newBudget > 0) {
      setState(() {
        _monthlyBudget = newBudget;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Monthly budget set to \$${newBudget.toStringAsFixed(2)}'),
      ));
    }
    budgetController.clear();
  }

  double getTotalExpenses() {
    // Calculate and return the total expenses based on transactions
    return _transactions.fold(0, (sum, tx) => sum + tx.amount);
  }

  double getRemainingBudget() {
    // Calculate and return the remaining budget based on monthly budget and total expenses
    return _monthlyBudget - getTotalExpenses();
  }

  List<Transaction> get _filteredTransactions {
    if (_selectedCategory == 'All') {
      return _transactions;
    } else {
      return _transactions
          .where((tx) => tx.category == _selectedCategory)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: amountController,
                      decoration: const InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => _addTransaction(),
                    ),
                    DropdownButton<String>(
                      value: _selectedCategory,
                      onChanged: _setCategory,
                      items: <String>[
                        'All',
                        'Food',
                        'Shopping',
                        'Entertainment'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: _showAllTransactions,
                          child: const Text('Show All Transactions'),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: _addTransaction,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.purple,
                      ),
                      child: const Text('Add Transaction'),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: _filteredTransactions.map((tx) {
                return Card(
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.purple,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          '\$${tx.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            tx.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            formatDate(tx.date),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            // Text field for setting the monthly budget
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: budgetController,
                      decoration: const InputDecoration(labelText: 'Set Monthly Budget'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      double newBudget = double.parse(budgetController.text);
                      _setMonthlyBudget(newBudget);
                    },
                    child: const Text('Set'),
                  ),
                ],
              ),
            ),
            // Display expense summaries and monthly budgets
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Monthly Budget: \u20B9${_monthlyBudget.toStringAsFixed(2)}'),
                    Text('Total Expenses: \u20B9${getTotalExpenses().toStringAsFixed(2)}'),
                    Text('Remaining Budget: \u20B9${getRemainingBudget().toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Transaction {
  final String title;
  final double amount;
  final DateTime date;
  final String category;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
}

String formatDate(DateTime date) {
  return '${_months[date.month - 1]} ${date.day}, ${date.year}';
}

final List<String> _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];
