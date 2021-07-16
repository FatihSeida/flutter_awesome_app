import 'package:awesome_app/simple_bloc_observer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:shared_preferences/shared_preferences.dart';

import 'modules/photo/bloc/photo_bloc.dart';

import 'modules/photo/repositories/photo_repository.dart';
import 'modules/photo/screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  final prefs = await SharedPreferences.getInstance();
  final isListView = prefs.getBool('isListView');
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RepositoryProvider(
        create: (context) => PhotoRepository(),
        child: BlocProvider(
          create: (context) => PhotoBloc(
            RepositoryProvider.of<PhotoRepository>(context),
          ),
          child: MyHomePage(),
        ),
      ),
    );
  }
}
