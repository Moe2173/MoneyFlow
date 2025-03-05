import 'package:flutter/material.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  // Empty list of transactions
  List<Map<String, dynamic>> transactions = [];

  // Variable to hold the search query
  String searchQuery = '';

  // To toggle the visibility of delete button
  bool _showDeleteButton = false;

  // Function to filter transactions based on search
  List<Map<String, dynamic>> get filteredTransactions {
    return transactions
        .where((transaction) =>
        transaction["title"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  // Function to add a transaction to the list
  void _addTransaction(String title, String date, double amount, String type) {
    setState(() {
      transactions.add({"title": title, "date": date, "amount": amount, "type": type});
    });
  }

  // Function to remove a transaction
  void _removeTransaction(int index) {
    setState(() {
      transactions.removeAt(index);
    });
  }

  // Function to show the add transaction dialog
  void _showAddTransactionDialog() {
    String title = '';
    String date = '';
    double amount = 0.0;
    String type = 'payment'; // Default to payment

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
                decoration: const InputDecoration(hintText: 'Date of transaction'),
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
                items: [
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
              onPressed: () {
                if (title.isNotEmpty && date.isNotEmpty && amount > 0) {
                  _addTransaction(title, date, amount, type);
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Transaction History",
          style: const TextStyle(color: Colors.black, fontSize: 26, fontFamily: 'Quicksand'),
        ),
        actions: [
          // Add Transaction Button in top-right corner
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(Icons.add_circle, size: 35, color: Colors.black),
              onPressed: _showAddTransactionDialog, // Show popup dialog
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Special Button to toggle delete visibility
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showDeleteButton = !_showDeleteButton; // Toggle delete button visibility
                });
              },
              child: Text(_showDeleteButton ? 'Disable Delete' : 'Enable Delete'),
            ),
          ),
          // Search Bar under "Transaction History"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by transaction',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ),
          // History Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Transaction History",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // Transaction List
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
                  title: Text(transaction["title"], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(transaction["date"]),
                  trailing: _showDeleteButton
                      ? IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _removeTransaction(index); // Remove the transaction
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
    );
  }
}
