import 'package:flutter/material.dart';
import 'screens/create_user_form.dart';
import 'screens/list_users.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = CreateUserForm();
      case 1:
        page = ListUsers();
      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.view_list_outlined),
                selectedIcon: Icon(Icons.view_list_rounded),
                label: Text('Favorites'),
              ),
            ],
            selectedIndex: _selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
          ),
          Expanded(
            child: Container(
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}
