import 'dart:core';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/create_user_form.dart';
import 'screens/list_users.dart';
import 'screens/list_data_api.dart';

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

  bool _extendedNavigationRail = false;

  bool get extendedNavigationRail => _extendedNavigationRail;

  set extendedNavigationRail(bool show){
    _extendedNavigationRail = show;
    notifyListeners();
  }

  Axis _directionButtons = Axis.horizontal;

  Axis get directionButtons => _directionButtons;

  set directionButtons(Axis show){
    _directionButtons = show;
    notifyListeners();
  }

  bool _isEditing = false;

  bool get isEditing => _isEditing;

  set isEditing(bool show){
    _isEditing = show;
    notifyListeners();
  }

  Map<String, dynamic> _currentUser = {};

  Map<String, dynamic> get currentUser => _currentUser;
  set currentUser(Map<String, dynamic> user) {
    _currentUser = user;
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
      case 2:
        page = ListDataApi();
      case 3:
        page = ListDataApi();
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
                label: Text('Create', style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.view_list_outlined, color: Colors.white),
                selectedIcon: Icon(Icons.view_list_rounded, color: Colors.white),
                label: Text('Users List', style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.wifi_outlined, color: Colors.white),
                selectedIcon: Icon(Icons.signal_wifi_4_bar_outlined, color: Colors.white),
                label: Text('API List', style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.add_circle_outline, color: Colors.white),
                selectedIcon: Icon(Icons.add_circle_outlined, color: Colors.white),
                label: Text('API List', style: TextStyle(color: Colors.white)),
              ),
            ],
            selectedIndex: appState.selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                appState.selectedIndex = value;
                switch(value){
                  case 0:
                    appState.appTitle = "Create User";
                    appState.isEditing = false;
                  case 1:
                    appState.appTitle = "Users List";
                  case 2:
                    appState.appTitle = "API Data List";
                  case 3:
                    appState.appTitle = "Create on API";
                  default:
                    throw UnimplementedError('no widget for $appState.selectedIndex');
                }
              });
            },
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  onPressed: () async {
                    setState(() {
                      appState.extendedNavigationRail = !appState.extendedNavigationRail;
                    });
                    if(appState.extendedNavigationRail){
                      setState(() {
                        appState.directionButtons = Axis.vertical;
                      });
                    }else{
                      await Future.delayed(const Duration(milliseconds: 100));
                      setState(() {
                        appState.directionButtons = Axis.horizontal;
                      });
                    }
                  },
                  icon: appState.extendedNavigationRail ?
                  Icon(Icons.keyboard_arrow_left, color: Colors.white) :
                  Icon(Icons.keyboard_arrow_right, color: Colors.white),
                ),
              ),
            ),
            extended: appState.extendedNavigationRail,
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
