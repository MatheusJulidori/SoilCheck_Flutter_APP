import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/providers/navigation_provider.dart';
import 'package:soilcheck/views/checklist/checklist_list.dart';
import 'package:soilcheck/views/profile/profile_page.dart';
import 'package:soilcheck/views/template/template_list.dart';
import 'package:soilcheck/views/user/user_list.dart';

class HomeScreen extends StatelessWidget {
  final List<Widget> _pages = [
    ChecklistMain(),
    TemplatesMain(),
    ProfilePage(),
    AdminPanel(),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<NavigationProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: _pages[provider.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: provider.currentIndex,
          onTap: (index) {
            provider.currentIndex = index;
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.checklist),
              label: 'Checklists',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Templates',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              label: 'Usuários',
            ),
          ],
          backgroundColor: Color.fromARGB(255, 227, 235, 198), // Background color
          selectedItemColor: Color(0xFF258F42), // Selected item color
          unselectedItemColor: Colors.black, // Unselected item color
          type: BottomNavigationBarType
              .fixed, // Ensures that the background color fills the bar
        ),
      ),
    );
  }
}
