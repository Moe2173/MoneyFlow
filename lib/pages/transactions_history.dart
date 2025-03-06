import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  List<Map<String, dynamic>> transactions = [];
  String searchQuery = '';
  bool _showDeleteButton = false;

  @override
  void initState() {
    super.initState();
    _initializeTransactions();
  }

  // Initialize transactions: load from SharedPreferences or use sample data
  Future<void> _initializeTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getString('transactions');

    if (transactionsJson == null) {
      // No stored transactions, use sample data and save it
      transactions = [
        {"title": "Grocery Shopping", "date": "03/01/2025", "amount": 50.25, "type": "payment"},
        {"title": "Salary", "date": "03/01/2025", "amount": 1500.00, "type": "income"},
        {"title": "Restaurant", "date": "03/03/2025", "amount": 75.00, "type": "payment"},
      ];
      await _saveTransactions();
    } else {
      // Load saved transactions
      final List<dynamic> decodedTransactions = jsonDecode(transactionsJson);
      setState(() {
        transactions = decodedTransactions.cast<Map<String, dynamic>>();
      });
    }
  }

  // Save transactions to SharedPreferences
  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = jsonEncode(transactions);
    await prefs.setString('transactions', transactionsJson);
  }

  // Add a new transaction
  Future<void> _addTransaction(String title, String date, double amount, String type) async {
    setState(() {
      transactions.add({"title": title, "date": date, "amount": amount, "type": type});
    });
    await _saveTransactions();
  }

  // Remove a transaction
  Future<void> _removeTransaction(int index) async {
    setState(() {
      transactions.removeAt(index);
    });
    await _saveTransactions();
  }

  List<Map<String, dynamic>> get filteredTransactions {
    return transactions
        .where((transaction) =>
        transaction["title"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  void _showAddTransactionDialog() {
    String title = '';
    String date = '';
    double amount = 0.0;
    String type = 'payment';
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Transaction"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Name of transaction'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(hintText: 'MM/DD/YYYY'),
                onChanged: (value) {
                  date = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  amount = double.tryParse(value) ?? 0.0;
                },
              ),
              DropdownButton<String>(
                value: type,
                items: const [
                  DropdownMenuItem(value: 'payment', child: Text('Payment')),
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                ],
                onChanged: (value) {
                  setState(() {
                    type = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (title.isNotEmpty &&
                    date.isNotEmpty &&
                    amount > 0 &&
                    _isValidDate(date)) {
                  await _addTransaction(title, date, amount, type);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid date format. Please use MM/DD/YYYY.'),
                    ),
                  );
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  bool _isValidDate(String date) {
    try {
      DateFormat('MM/dd/yyyy').parseStrict(date);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.blueGrey,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Transaction History",
            style: TextStyle(color: Colors.black, fontSize: 26, fontFamily: 'Quicksand'),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: const Icon(Icons.add_circle, size: 35, color: Colors.black),
                onPressed: _showAddTransactionDialog,
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showDeleteButton = !_showDeleteButton;
                  });
                },
                child: Text(_showDeleteButton ? 'Disable Delete' : 'Enable Delete'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by transaction',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (query) {
                  setState(() {
                    searchQuery = query;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                "Transaction History",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = filteredTransactions[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: transaction["type"] == "income"
                          ? Colors.green[100]
                          : Colors.red[100],
                      child: Icon(
                        Icons.receipt,
                        color: transaction["type"] == "income" ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(transaction["title"],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(transaction["date"]),
                    trailing: _showDeleteButton
                        ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _removeTransaction(index);
                      },
                    )
                        : Text(
                      "\$${transaction["amount"].toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: transaction["type"] == "income" ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
