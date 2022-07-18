import 'package:bars/utilities/exports.dart';

@immutable
abstract class ConfigEvent {
  Future<ConfigState> applyAsync({ConfigState currentState, ConfigBloc bloc});
}

class DarkModeEvent extends ConfigEvent {
  final bool darkOn;
  DarkModeEvent(this.darkOn);
  @override
  String toString() => 'DarkModeEvent';

  @override
  Future<ConfigState> applyAsync(
      {ConfigState? currentState, ConfigBloc? bloc}) async {
    try {
      bloc!.darkModeOn = darkOn;
      await Bars.prefs!.setBool(Bars.darkModePref, darkOn);
      return InConfigState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorConfigState(_.toString());
    }
  }
}

class LoadConfigEvent extends ConfigEvent {
  @override
  String toString() => 'LoadConfigEvent';

  @override
  Future<ConfigState> applyAsync(
      {ConfigState? currentState, ConfigBloc? bloc}) async {
    try {
      await Future.delayed(new Duration(seconds: 2));

      return new InConfigState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorConfigState(_.toString());
    }
  }
}
