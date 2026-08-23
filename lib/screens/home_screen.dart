import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'reports/report_list_screen.dart';
import 'articles/article_list_screen.dart';
import 'resources/where_to_report_screen.dart';
import 'home/home_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = const [
    HomeDashboardScreen(),
    ReportListScreen(),
    ArticleListScreen(),
    WhereToReportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: IndexedStack(index: _selectedIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.ghanaGold
            : AppColors.navy,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Hub'),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Resources',
          ),
        ],
      ),
    );
  }
}

