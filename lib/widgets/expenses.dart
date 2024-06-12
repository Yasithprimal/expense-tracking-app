import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Materials',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  double _income = 0.0; // Variable to store the income

  // Function to calculate the total amount
  double _getTotalAmount() {
    return _registeredExpenses.fold(
        0.0, (sum, expense) => sum + expense.amount);
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });

    // Optionally, you could also save the expense to the backend here
    // final url = Uri.https('testing-flutter-ab4ed-default-rtdb.firebaseio.com',
    //     'expenses-tracking.json');
    // http.post(url,
    //     headers: {
    //       'Content-Type': 'application/json',
    //     },
    //     body: json.encode({
    //       'title': expense.title,
    //       'amount': expense.amount,
    //       'date': expense.date.toIso8601String(),
    //       'category': expense.category.toString(),
    //     }));
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  void _updateIncome(double income) {
    setState(() {
      _income = income;
    });
  }

  void _showIncomeInputDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        final TextEditingController _incomeController = TextEditingController();
        return AlertDialog(
          title: const Text('Enter Income'),
          content: TextField(
            controller: _incomeController,
            decoration: const InputDecoration(labelText: 'Income'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final enteredIncome = double.tryParse(_incomeController.text);
                if (enteredIncome != null) {
                  _updateIncome(enteredIncome);
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double totalAmount = _getTotalAmount(); // Calculate total amount

    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Ease'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: _showIncomeInputDialog,
            icon: const Icon(Icons.attach_money),
          ),
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                color: const Color.fromARGB(255, 115, 134, 147),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Income',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      Text('\$$_income',
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              Card(
                color: const Color.fromARGB(255, 115, 134, 147),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Expense',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      Text('\$$totalAmount',
                          style: const TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              ),
              Card(
                color: const Color.fromARGB(255, 115, 134, 147),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Remainder',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      Text('\$${_income - totalAmount}',
                          style: const TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}























// import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';

// import 'package:expense_tracker/widgets/new_expense.dart';
// import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
// import 'package:expense_tracker/models/expense.dart';
// import 'package:expense_tracker/widgets/chart/chart.dart';

// class Expenses extends StatefulWidget {
//   const Expenses({super.key});

//   @override
//   State<Expenses> createState() {
//     return _ExpensesState();
//   }
// }

// class _ExpensesState extends State<Expenses> {
//   final List<Expense> _registeredExpenses = [
//     Expense(
//       title: 'Materials',
//       amount: 19.99,
//       date: DateTime.now(),
//       category: Category.work,
//     ),
//     Expense(
//       title: 'Cinema',
//       amount: 15.69,
//       date: DateTime.now(),
//       category: Category.leisure,
//     ),
//   ];

//   // Function to calculate the total amount
//   double _getTotalAmount() {
//     return _registeredExpenses.fold(
//         0.0, (sum, expense) => sum + expense.amount);
//   }

//   void _openAddExpenseOverlay() {
//     showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       builder: (ctx) => NewExpense(onAddExpense: _addExpense),
//     );
//   }

//   void _addExpense(Expense expense) {
//     setState(() {
//       _registeredExpenses.add(expense);
//     });

//     // Optionally, you could also save the expense to the backend here
//     // final url = Uri.https('testing-flutter-ab4ed-default-rtdb.firebaseio.com',
//     //     'expenses-tracking.json');
//     // http.post(url,
//     //     headers: {
//     //       'Content-Type': 'application/json',
//     //     },
//     //     body: json.encode({
//     //       'title': expense.title,
//     //       'amount': expense.amount,
//     //       'date': expense.date.toIso8601String(),
//     //       'category': expense.category.toString(),
//     //     }));
//   }

//   void _removeExpense(Expense expense) {
//     final expenseIndex = _registeredExpenses.indexOf(expense);
//     setState(() {
//       _registeredExpenses.remove(expense);
//     });

//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         duration: const Duration(seconds: 3),
//         content: const Text('Expense deleted.'),
//         action: SnackBarAction(
//           label: 'Undo',
//           onPressed: () {
//             setState(() {
//               _registeredExpenses.insert(expenseIndex, expense);
//             });
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double totalAmount = _getTotalAmount(); // Calculate total amount

//     Widget mainContent = const Center(
//       child: Text('No expenses found. Start adding some!'),
//     );

//     if (_registeredExpenses.isNotEmpty) {
//       mainContent = ExpensesList(
//         expenses: _registeredExpenses,
//         onRemoveExpense: _removeExpense,
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Expense Ease'),
//         actions: [
//           IconButton(
//             onPressed: _openAddExpenseOverlay,
//             icon: const Icon(Icons.add),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Chart(expenses: _registeredExpenses),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Card(
//                 color: const Color.fromARGB(255, 115, 134, 147),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       Text(
//                         'Income',
//                         style: TextStyle(
//                             color: Color.fromARGB(255, 255, 255, 255)),
//                       ),
//                       Text('xxx', style: TextStyle(color: Colors.white))
//                     ],
//                   ),
//                 ),
//               ),
//               Card(
//                 color: const Color.fromARGB(255, 115, 134, 147),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       const Text(
//                         'Expense',
//                         style: TextStyle(
//                             color: Color.fromARGB(255, 255, 255, 255)),
//                       ),
//                       Text('\$$totalAmount',
//                           style: const TextStyle(color: Colors.white))
//                     ],
//                   ),
//                 ),
//               ),
//               Card(
//                 color: const Color.fromARGB(255, 115, 134, 147),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       Text(
//                         'Remainder',
//                         style: TextStyle(
//                             color: Color.fromARGB(255, 255, 255, 255)),
//                       ),
//                       Text('xxx', style: TextStyle(color: Colors.white))
//                     ],
//                   ),
//                 ),
//               ),
              
//             ],
//           ),
//           Expanded(
//             child: mainContent,
//           ),
//         ],
//       ),
//     );
//   }
// }






































// import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';

// import 'package:expense_tracker/widgets/new_expense.dart';
// import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
// import 'package:expense_tracker/models/expense.dart';
// import 'package:expense_tracker/widgets/chart/chart.dart';

// class Expenses extends StatefulWidget {
//   const Expenses({super.key});

//   @override
//   State<Expenses> createState() {
//     return _ExpensesState();
//   }
// }

// class _ExpensesState extends State<Expenses> {
//   final List<Expense> _registeredExpenses = [
//     Expense(
//       title: 'Materials',
//       amount: 19.99,
//       date: DateTime.now(),
//       category: Category.work,
//     ),
//     Expense(
//       title: 'Cinema',
//       amount: 15.69,
//       date: DateTime.now(),
//       category: Category.leisure,
//     ),
//   ];

//   void _openAddExpenseOverlay() {
//     showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       builder: (ctx) => NewExpense(onAddExpense: _addExpense),
//     );
//   }

//   void getTotalAMount(){
//     List<double> totalAmountList =_registeredExpenses.map((expense) => expense.amount).toList();
//     double totalAmount= totalAmountList.fold(0, (previousValue, element) => previousValue + element);
//   }

//   void _addExpense(Expense expense) {
//     setState(() {
//       _registeredExpenses.add(expense);
//       getTotalAMount();
//     });

//     // final url = Uri.https('testing-flutter-ab4ed-default-rtdb.firebaseio.com',
//     //     'expenses-tracking.json');
//     // http.post(url,
//     //     headers: {
//     //       'Content-Type': 'application/json',
//     //     },
//     //     body: json.encode({
//     //       'expense': expense,
//     //     }));
//   }

//   void _removeExpense(Expense expense) {
//     final expenseIndex = _registeredExpenses.indexOf(expense);
//     setState(() {
//       _registeredExpenses.remove(expense);
//     });
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         duration: const Duration(seconds: 3),
//         content: const Text('Expense deleted.'),
//         action: SnackBarAction(
//           label: 'Undo',
//           onPressed: () {
//             setState(() {
//               _registeredExpenses.insert(expenseIndex, expense);
//             });
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget mainContent = const Center(
//       child: Text('No expenses found. Start adding some!'),
//     );

//     if (_registeredExpenses.isNotEmpty) {
//       mainContent = ExpensesList(
//         expenses: _registeredExpenses,
//         onRemoveExpense: _removeExpense,
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Expense Ease'),
//         actions: [
//           IconButton(
//             onPressed: _openAddExpenseOverlay,
//             icon: const Icon(Icons.add),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Chart(expenses: _registeredExpenses),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Card(
//                 color:const Color.fromARGB(255, 115, 134, 147),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       Text(
//                         'income',
//                         style: TextStyle(
//                             color: Color.fromARGB(255, 255, 255, 255)),
//                       ),
//                       Text('xxx', style: TextStyle(color: Colors.white))
//                     ],
//                   ),
//                 ),
//               ),
//               Card(
//                 color:const Color.fromARGB(255, 115, 134, 147),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       Text(
//                         'Expense',
//                         style: TextStyle(
//                             color: Color.fromARGB(255, 255, 255, 255)),
//                       ),
//                       Text('$totalAmount', style: TextStyle(color: Colors.white))
//                     ],
//                   ),
//                 ),
//               ),
//               Card(
//                 color:const Color.fromARGB(255, 115, 134, 147),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       Text(
//                         'Remainder',
//                         style: TextStyle(
//                             color: Color.fromARGB(255, 255, 255, 255)),
//                       ),
//                       Text('xxx', style: TextStyle(color: Colors.white))
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: mainContent,
//           ),
//         ],
//       ),
//     );
//   }
// }
