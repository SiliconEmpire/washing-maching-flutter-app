import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:washing_machine_app_v2/providers/ble_provider.dart';
import 'package:washing_machine_app_v2/providers/config_provider.dart';
import 'package:washing_machine_app_v2/sharedPreferences/shared_references.dart';

import 'pages/home_page.dart';

Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return BleProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return ConfigurationProvider();
          },
        ),
      ],
      // await DataSharedPreferences.init();
      child: const MyApp(),
    ),
  );
  await DataSharedPreferences.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    Provider.of<BleProvider>(context, listen: false).initBle();

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Polystar washing Machine App',
      home: HomePage(),
    );
  }
}
