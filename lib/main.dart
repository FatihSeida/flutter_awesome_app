import 'package:awesome_app/modules/photo/models/album.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'modules/photo/bloc/photo_bloc.dart';
import 'modules/photo/repositories/photo_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PhotoBloc photoBloc;

  @override
  void initState() {
    photoBloc = context.read<PhotoBloc>();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    photoBloc.add(FetchPhoto());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }
}
