import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  Future<void> onEvent(Bloc bloc, Object? event) async {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  Future<void> onError(BlocBase cubit, Object error, StackTrace stackTrace) async {
    print(error);
    super.onError(cubit, error, stackTrace);
  }
}
