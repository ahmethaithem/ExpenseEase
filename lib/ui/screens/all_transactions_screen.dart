import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/transaction.dart';
import '../../providers/expense_provider.dart';
import '../../providers/user_provider.dart';

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({Key? key}) : super(key: key);

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  final List<String> _filters = ['Last 7 Days', 'Last 30 Days', 'Last 3 Months'];
  String _selectedFilter = 'Last 7 Days';
  DateTime? _customDate;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _customDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryPurple,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _customDate = picked;
        _selectedFilter = 'Custom'; // Clear preset if a custom date is picked
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final currency = userProvider.currencySymbol;

    final filteredTransactions = expenseProvider.getFilteredTransactions(
      _selectedFilter,
      _customDate,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_rounded),
            onPressed: _pickDate,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Row
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _filters.length + (_customDate != null ? 1 : 0),
                itemBuilder: (context, index) {
                  // Show Custom Date as an extra chip if selected
                  if (_customDate != null && index == 0) {
                    return _buildFilterChip(
                      label: '${_customDate!.day}/${_customDate!.month}/${_customDate!.year}',
                      isSelected: _selectedFilter == 'Custom',
                      onTap: () {}, // Already selected
                      onClear: () {
                        setState(() {
                          _customDate = null;
                          _selectedFilter = 'Last 7 Days';
                        });
                      },
                      isDark: isDark,
                    );
                  }

                  final filterIndex = _customDate != null ? index - 1 : index;
                  final filter = _filters[filterIndex];

                  return _buildFilterChip(
                    label: filter,
                    isSelected: _selectedFilter == filter && _customDate == null,
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                        _customDate = null; // Clear custom date when picking a preset
                      });
                    },
                    isDark: isDark,
                  );
                },
              ),
            ),

            // Transactions List
            Expanded(
              child: filteredTransactions.isEmpty
                  ? Center(
                      child: Text(
                        'No transactions found.',
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        return _buildTransactionItem(
                          context,
                          filteredTransactions[index],
                          isDark,
                          currency,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    VoidCallback? onClear,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: EdgeInsets.only(left: 16, right: onClear != null ? 8 : 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryPurple : (isDark ? const Color(0xFF2A2A2A) : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            if (onClear != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, TransactionModel transaction, bool isDark, String currency) {
    final isExpense = transaction.type == TransactionType.expense;
    final color = isExpense ? Colors.redAccent : AppTheme.secondaryTeal;
    final sign = isExpense ? '-' : '+';
    final icon = isExpense ? Icons.shopping_bag_outlined : Icons.account_balance_wallet_outlined;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.category,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (transaction.note.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    transaction.note,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$sign$currency${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
