import 'package:bars/utilities/exports.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  static final ConfigBloc _configBlocSingleton = ConfigBloc._internal();

  factory ConfigBloc() {
    return _configBlocSingleton;
  }

  ConfigBloc._internal() : super(InConfigState());

  bool darkModeOn = true;

  get currentState => InConfigState();

  Stream<ConfigState> mapEventToState(
    ConfigEvent event,
  ) async* {
    try {
      yield UnConfigState();
      yield await event.applyAsync(currentState: currentState, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
       currentState;
    }
  }
}
