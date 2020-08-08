import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'utils/app_theme.dart';
import 'utils/app_state_notifier.dart';
import 'home_widget.dart';
import 'developer.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(ChangeNotifierProvider<AppStateNotifier>(
    create: (context) => AppStateNotifier(),
    child: App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appState, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Dupeboard',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appState.themeMode == 'System Default'
              ? ThemeMode.system
              : appState.themeMode == 'Light Theme'
                  ? ThemeMode.light
                  : ThemeMode.dark,
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/':
                return CupertinoPageRoute(
                    builder: (_) => Home(), settings: settings);
              case '/developer':
                return CupertinoPageRoute(
                    builder: (_) => DeveloperScreen(), settings: settings);
              default:
                return CupertinoPageRoute(
                    builder: (_) => Home(), settings: settings);
            }
          },
        );
      },
    );
  }
}
