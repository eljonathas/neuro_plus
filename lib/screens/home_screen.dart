import 'package:flutter/material.dart';
import '../widgets/segment_control.dart';
import '../widgets/stats_card.dart';
import '../widgets/recent_item.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedSegment = 0;
  int _navIndex = 0;

  final _ranges = ['Últimos 7 dias', 'Últimos 30 dias', 'Últimos 90 dias'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text('Tela inicial'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Visão geral',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SegmentControl(
              segments: _ranges,
              selectedIndex: _selectedSegment,
              onValueChanged: (i) => setState(() => _selectedSegment = i),
            ),
            const SizedBox(height: 16),
            Wrap(
              direction: Axis.horizontal,
              runSpacing: 16,
              children: [
                StatsCard(
                  icon: Icons.sticky_note_2_outlined,
                  label: 'Consultas realizadas',
                  count: '10',
                ),
                StatsCard(
                  icon: Icons.person_add_outlined,
                  label: 'Pacientes cadastrados',
                  count: '5',
                ),
                StatsCard(
                  icon: Icons.assignment_outlined,
                  label: 'Protocolos criados',
                  count: '3',
                ),
              ],
            ),
            const SizedBox(height: 24),
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
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: const [
                  RecentItem(
                    title: 'João Pedro Almeida',
                    subtitle: '987.654.321-00',
                  ),
                  RecentItem(title: 'Maria Silva', subtitle: '123.456.789-00'),
                  RecentItem(title: 'Ana Costa', subtitle: '321.654.987-00'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}
