import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'ui/navigation/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}
//--
class MyApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.amber),
      ),
      initialRoute: mainNavigation.initialRoute,
      routes: mainNavigation.routes,
      onGenerateRoute: mainNavigation.onGenerateRoutes,
    );
  }
}
