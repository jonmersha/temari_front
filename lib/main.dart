import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:temari/features/home/home.dart';
import 'package:temari/features/menu/bottom_nav.dart';
import 'package:temari/features/service_provider/provider_home.dart';
import 'package:temari/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    //const adds = BannerAdds();

    return MaterialApp(
      //title: 'Pdf Reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
      //home: ServiceProviderHome(email: 'jonmersha@gmail.com',),
      //home:BottomNavigationWidget(),
    );
  }
}

