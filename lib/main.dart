import 'dart:core';
import 'package:flutter/material.dart';
import 'screens/create_user_form.dart';
import 'screens/list_users.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class AppState extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  String _appTitle = "Create User";

  String get appTitle => _appTitle;

  set appTitle(String title){
    _appTitle = title;
    notifyListeners();
  }

  bool _showNavigationRail = true;

  bool get showNavigationRail => _showNavigationRail;

  set showNavigationRail(bool show){
    _showNavigationRail = show;
    notifyListeners();
  }

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    Widget page;
    switch (appState.selectedIndex) {
      case 0:
        page = CreateUserForm();
      case 1:
        page = ListUsers();
      default:
        throw UnimplementedError('no widget for $appState.selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appState.appTitle,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.reorder, color: Colors.white),
          onPressed: () {
            appState.showNavigationRail = !appState.showNavigationRail;
          },
        ),
        leadingWidth: 80,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Row(
        children: [
          appState.showNavigationRail ? NavigationRail(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.add_box_outlined, color: Colors.white),
                selectedIcon: Icon(Icons.add_box_rounded, color: Colors.white),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.view_list_outlined, color: Colors.white),
                selectedIcon: Icon(Icons.view_list_rounded, color: Colors.white),
                label: Text('Favorites'),
              ),
            ],
            selectedIndex: appState.selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                appState.selectedIndex = value;
                switch(value){
                  case 0:
                    appState.appTitle = "Create User";
                  case 1:
                    appState.appTitle = "Users List";
                  default:
                    throw UnimplementedError('no widget for $appState.selectedIndex');
                }
              });
            },
          ) : SizedBox(),
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
