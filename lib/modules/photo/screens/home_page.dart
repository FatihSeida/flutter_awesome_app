import 'package:awesome_app/enums/layout_mode.dart';
import 'package:awesome_app/modules/photo/bloc/photo_bloc.dart';
import 'package:awesome_app/modules/photo/models/album.dart';
import 'package:awesome_app/modules/photo/screens/widgets/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PhotoBloc photoBloc;
  final scrollController = ScrollController();
  List<Photo> photoCached = [];

  @override
  void initState() {
    scrollController.addListener(_onScroll);
    photoBloc = context.read<PhotoBloc>();
    photoBloc.add(FetchPhoto());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          photoBloc.add(FetchPhoto());
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.red,
              expandedHeight: 200,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'assets/images/appbar.png',
                  fit: BoxFit.cover,
                ),
                title: Text('Awesome App'),
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
            BlocConsumer<PhotoBloc, PhotoState>(
              listener: (context, state) {
                if (state.photoStatus == PhotoStatus.noConnection) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(state.connectionResultMessage),
                      ],
                    ),
                  ));
                }
              },
              builder: (context, state) {
                switch (state.photoStatus) {
                  case PhotoStatus.loading:
                    return SliverToBoxAdapter(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                          CircularProgressIndicator()
                        ],
                      ),
                    );
                  case PhotoStatus.loaded:
                    final photos = state.photos;
                    return ListItem(state, photos);
                  case PhotoStatus.noConnection:
                    return SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 1,
                        ),
                      ),
                    );
                  //   SharedPreferences.getInstance().then((prefValue) => {
                  //         setState(() {
                  //           photoCached = json.decode(
                  //               prefValue.getString('albumData').toString());
                  //         })
                  //       });
                  //   return ListItem(state, photoCached);
                  default:
                    return SliverToBoxAdapter(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                          Text('Error'),
                        ],
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}