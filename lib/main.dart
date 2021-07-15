import 'package:animations/animations.dart';
import 'package:awesome_app/enums/layout_mode.dart';
import 'package:awesome_app/modules/cache/photo_cache.dart';

import 'package:awesome_app/modules/photo/screens/widgets/grid_view_item.dart';
import 'package:awesome_app/modules/photo/screens/widgets/list_view_item.dart';

import 'package:awesome_app/modules/photo/screens/widgets/photo_open_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'modules/photo/bloc/photo_bloc.dart';
import 'modules/photo/repositories/photo_repository.dart';
import 'modules/photo/screens/widgets/bottom_loader.dart';
import 'package:connectivity/connectivity.dart';

void main() {
  runApp(MyApp());
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
        create: (context) => PhotoRepository(PhotoCache()),
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
  final scrollController = ScrollController();
  var subscription;
  var connectionStatus;

  @override
  void initState() {
    scrollController.addListener(_onScroll);
    photoBloc = context.read<PhotoBloc>();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {         
      setState(() => connectionStatus = result );
    });
    checkInternetConnectivity();
    checkLoginStatus();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    photoBloc.add(FetchPhoto());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    subscription.cancel();
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      photoBloc.add((LoadMorePhoto()));
    }
  }

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  checkInternetConnectivity() {
    if (connectionStatus == ConnectivityResult.none) {
      return Fluttertoast.showToast(
          msg: "Check your internet connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.red,
            expandedHeight: 200,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://source.unsplash.com/random?monochromatic+dark',
                fit: BoxFit.cover,
              ),
              title: Text('Flexible Title'),
              centerTitle: true,
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    context
                        .read<PhotoBloc>()
                        .add(ToggleLayoutMode(LayoutMode.listview));
                  },
                  icon: Icon(Icons.list)),
              SizedBox(width: 12),
              IconButton(
                  onPressed: () {
                    context
                        .read<PhotoBloc>()
                        .add(ToggleLayoutMode(LayoutMode.gridview));
                  },
                  icon: Icon(Icons.grid_view)),
              SizedBox(width: 12),
            ],
          ),
          BlocBuilder<PhotoBloc, PhotoState>(
            builder: (context, state) {
              switch (state.photoStatus) {
                case PhotoStatus.loading:
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                case PhotoStatus.loaded:
                  final photos = state.photos;
                  return state.layoutMode == LayoutMode.listview
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return index >= state.photos.length
                                  ? BottomLoader()
                                  : OpenContainer<bool>(
                                      closedBuilder: (context, openContainer) =>
                                          ListViewItem(
                                              photo: photos[index],
                                              openContainer: openContainer),
                                      openBuilder: (context, openContainer) =>
                                          PhotoOpenBuilder(
                                              photo: photos[index]));
                            },
                            childCount: state.hasReachedMax
                                ? photos.length
                                : photos.length + 1,
                          ),
                        )
                      : SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 2.0,
                            crossAxisSpacing: 2.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return index >= state.photos.length
                                  ? BottomLoader()
                                  : OpenContainer<bool>(
                                      closedBuilder: (context, openContainer) =>
                                          GridViewItem(
                                              photo: photos[index],
                                              openContainer: openContainer),
                                      openBuilder: (context, openContainer) =>
                                          PhotoOpenBuilder(
                                              photo: photos[index]),
                                    );
                            },
                            childCount: state.hasReachedMax
                                ? photos.length
                                : photos.length + 1,
                          ),
                        );
                default:
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text('Error'),
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
