import 'package:flutter/material.dart';
import 'package:soilcheck/widgets/grid_item.dart';

class DashboardMain extends StatelessWidget {
  const DashboardMain({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> gridItems = [
      {
        'icon': Icons.co_present_rounded,
        'label': 'Clientes',
        'route': '/cliente',
        'color': const Color(0xFF27C236)
      },
      {
        'icon': Icons.warehouse_outlined,
        'label': 'Fazendas',
        'route': '/fazenda',
        'color': const Color(0xFF27C236)
      },
      {
        'icon': Icons.water_drop,
        'label': 'Pivos',
        'route': '/pivo',
        'color': const Color(0xFF27C236)
      },
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 5 / 5,
          ),
          itemCount: gridItems.length,
          itemBuilder: (context, index) {
            final item = gridItems[index];
            return GridItem(
              icon: item['icon'],
              label: item['label'],
              iconColor: item['color'],
              onTap: () {
                Navigator.of(context).pushNamed(item['route']);
              },
            );
          },
        ),
      ),
    );
  }
}
