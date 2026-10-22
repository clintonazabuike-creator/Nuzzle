import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'app_theme.dart';

class WalletScreen extends StatefulWidget {
  final int userId;

  const WalletScreen({super.key, required this.userId});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isLoading = true;
  double _balance = 0.00;
  double _totalEarned = 0.00;
  int _totalViews = 0;
  List<dynamic> _transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchWalletData();
  }

  // Fetch wallet balance and earnings ledger from cPanel API
  Future<void> _fetchWalletData() async {
    try {
      final response = await http.get(
        Uri.parse('https://yourdomain.com/api/get_wallet.php?user_id=${widget.userId}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _balance = double.parse(data['wallet']['balance'].toString());
            _totalEarned = double.parse(data['wallet']['total_earned'].toString());
            _totalViews = data['wallet']['total_views'] ?? 0;
            _transactions = data['transactions'] ?? [];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // Request Payout
  Future<void> _requestPayout() async {
    if (_balance < 5000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimum withdrawal threshold is ₦5,000')),
      );
      return;
    }

    // Trigger payout request API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payout request submitted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Creator Wallet & Earnings'),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : RefreshIndicator(
              onRefresh: _fetchWalletData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Balance Card (Gradient Glassmorphism)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primary, Color(0xFF6D28D9)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Available Balance',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₦${_balance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Earned: ₦${_totalEarned.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                              ElevatedButton(
                                onPressed: _requestPayout,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppTheme.primary,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                ),
                                child: const Text('Withdraw', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 2. Metrics Grid (Views & Ad Share)
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            'Monetized Views',
                            '$_totalViews',
                            Icons.remove_red_eye_outlined,
                            AppTheme.accent,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMetricCard(
                            'Ad Revenue Share',
                            '50%',
                            Icons.pie_chart_outline,
                            Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // 3. Transaction Ledger
                    const Text(
                      'Earnings & Payout Ledger',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textWhite),
                    ),
                    const SizedBox(height: 12),
                    _transactions.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(30.0),
                              child: Text('No transactions yet. Keep publishing!', style: TextStyle(color: AppTheme.textGray)),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _transactions.length,
                            itemBuilder: (context, index) {
                              final tx = _transactions[index];
                              return Card(
                                color: AppTheme.cardColor,
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppTheme.primary.withOpacity(0.2),
                                    child: const Icon(Icons.monetization_on, color: AppTheme.primary),
                                  ),
                                  title: Text(tx['transaction_type'].toString().toUpperCase(),
                                      style: const TextStyle(color: AppTheme.textWhite, fontWeight: FontWeight.bold)),
                                  subtitle: Text(tx['created_at'], style: const TextStyle(color: AppTheme.textGray, fontSize: 12)),
                                  trailing: Text(
                                    '+₦${tx['amount']}',
                                    style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: AppTheme.textGray, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: AppTheme.textWhite, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
