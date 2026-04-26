import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Info
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primaryPurple,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userProvider.userName.isNotEmpty ? userProvider.userName : 'User',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Appearance Settings
              Text(
                'Appearance',
                style: TextStyle(
                  color: AppTheme.secondaryTeal,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SwitchListTile(
                  title: const Text('Dark Mode'),
                  secondary: Icon(isDark ? Icons.nights_stay : Icons.wb_sunny, color: AppTheme.primaryPurple),
                  value: themeProvider.isDarkMode,
                  activeColor: AppTheme.primaryPurple,
                  onChanged: (val) {
                    themeProvider.toggleTheme();
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Currency Settings
              Text(
                'Currency Settings',
                style: TextStyle(
                  color: AppTheme.secondaryTeal,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('US Dollar (\$)'),
                      value: '\$',
                      groupValue: userProvider.currencySymbol,
                      onChanged: (val) {
                        if (val != null) userProvider.updateCurrency(val);
                      },
                      activeColor: AppTheme.primaryPurple,
                    ),
                    const Divider(height: 1),
                    RadioListTile<String>(
                      title: const Text('Euro (€)'),
                      value: '€',
                      groupValue: userProvider.currencySymbol,
                      onChanged: (val) {
                        if (val != null) userProvider.updateCurrency(val);
                      },
                      activeColor: AppTheme.primaryPurple,
                    ),
                    const Divider(height: 1),
                    RadioListTile<String>(
                      title: const Text('Turkish Lira (₺)'),
                      value: '₺',
                      groupValue: userProvider.currencySymbol,
                      onChanged: (val) {
                        if (val != null) userProvider.updateCurrency(val);
                      },
                      activeColor: AppTheme.primaryPurple,
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Logout Button
              ElevatedButton.icon(
                onPressed: () {
                  userProvider.signOut();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
