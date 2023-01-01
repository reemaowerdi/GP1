//references
//https://www.youtube.com/watch?v=1ukSR1GRtMU&list=PL4cUxeGkcC9jLYyp2Aoh6hcWuxFDX6PBJ
//https://www.youtube.com/watch?v=ok6se5sOthw
//https://www.youtube.com/watch?v=dkkuMdCkQFo&t=315s

import 'package:flutter/material.dart';
import 'package:read_me_a_story/books_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:read_me_a_story/firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //wist
    options: DefaultFirebaseOptions.currentPlatform, //wist
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Read me a book',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "SourceSansPro",
      ),
      home: const BooksSplash(), //wist
    );
  }
}
