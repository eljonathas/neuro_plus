import 'package:flutter/material.dart';
import 'package:neuro_plus/core/main_layout.dart';
import 'package:neuro_plus/core/widgets/custom_calendar.dart';

import 'widgets/recent_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navIndex = 0;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Tela inicial",
      navIndex: navIndex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calendário',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          CustomCalendar(
            selectedDate: selectedDate,
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Consultas recentes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextButton(onPressed: () {}, child: const Text('Ver todos')),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: const [
              RecentItem(
                title: 'João Pedro Almeida',
                subtitle: '987.654.321-00',
              ),
              RecentItem(title: 'Maria Silva', subtitle: '123.456.789-00'),
              RecentItem(title: 'Ana Costa', subtitle: '321.654.987-00'),
            ],
          ),
        ],
      ),

      onNavTap: (index) {
        setState(() {
          navIndex = index;
        });
      },
    );
  }
}
