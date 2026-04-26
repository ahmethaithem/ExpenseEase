import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/transaction.dart';
import '../../providers/expense_provider.dart';
import '../../providers/user_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionType type;

  const AddTransactionScreen({Key? key, required this.type}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _customCategoryController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Food';

  final List<String> _expenseCategories = ['Food', 'Transport', 'Shopping', 'Bills', 'Other'];
  final List<String> _incomeCategories = ['Salary', 'Freelance', 'Gift', 'Investment', 'Other'];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.type == TransactionType.expense ? _expenseCategories[0] : _incomeCategories[0];
    _amountController.addListener(() {
      setState(() {}); // Rebuild to update button state
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    if (_amountController.text.isEmpty) return;
    
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0) return;

    // Use custom category if 'Other' is selected
    String finalCategory = _selectedCategory;
    if (_selectedCategory == 'Other' && _customCategoryController.text.trim().isNotEmpty) {
      finalCategory = _customCategoryController.text.trim();
    }

    final transaction = TransactionModel(
      id: '', // Firestore will generate this
      amount: amount,
      category: finalCategory,
      date: _selectedDate,
      note: _noteController.text,
      type: widget.type,
    );

    Provider.of<ExpenseProvider>(context, listen: false).addTransaction(transaction);
    Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currency = userProvider.currencySymbol;

    final isExpense = widget.type == TransactionType.expense;
    final color = isExpense ? Colors.redAccent : AppTheme.secondaryTeal;
    final title = isExpense ? 'Add Expense' : 'Add Income';
    final categories = isExpense ? _expenseCategories : _incomeCategories;
    
    // Consistent Padding
    const contentPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Amount Input
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '$currency ',
                  prefixStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
                  contentPadding: contentPadding,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
                decoration: InputDecoration(
                  labelText: 'Category',
                  contentPadding: contentPadding,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              
              // Dynamic Custom Category Input
              if (_selectedCategory == 'Other') ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _customCategoryController,
                  decoration: InputDecoration(
                    labelText: 'Enter Category Name',
                    contentPadding: contentPadding,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Date Picker
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(20),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date',
                    contentPadding: contentPadding,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Note Input
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Note (Optional)',
                  contentPadding: contentPadding,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              ElevatedButton(
                onPressed: _amountController.text.isNotEmpty ? _saveTransaction : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  disabledBackgroundColor: Colors.grey.shade400,
                  disabledForegroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Save Transaction',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
