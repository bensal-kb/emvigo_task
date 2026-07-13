import 'package:emvigo_test/core/base/base_bloc/base_bloc.dart';

class MyBlocObserver extends BlocObserver {
  const MyBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logger.d('${bloc.runtimeType}: $change');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.d('${bloc.runtimeType}: $event');
  }
}
