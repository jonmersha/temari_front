import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:temari/features/downloader/save_pdf.dart';
import 'package:temari/features/file_loader.dart';
import 'package:temari/features/home/chaild/student_text_list.dart';
import 'package:temari/features/home/home.dart';
import 'package:temari/features/home_page.dart';
import 'package:temari/features/network_stand_alon.dart';
import 'package:temari/features/par_with_progress.dart';
import 'package:temari/features/parl.dart';
import 'package:temari/features/home/partition_with_overal.dart';
import 'package:temari/features/pdf_network.dart';
import 'package:temari/firebase_options.dart';
//import 'package:temari/features/home/home_screen.dart';
//import 'package:temari/features/home_page.dart';


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
    return MaterialApp(
      title: 'Pdf Reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

