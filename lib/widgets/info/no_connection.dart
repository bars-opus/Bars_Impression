import 'package:bars/utilities/exports.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NoConnection extends StatefulWidget {
  @override
  _NoConnectionState createState() => _NoConnectionState();
}

class _NoConnectionState extends State<NoConnection> {
   ConnectivityResult? oldResult;
  bool _networkConnection = false;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  initState() {
    super.initState();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        if (mounted) {
          setState(() {
            _networkConnection = true;
          });
        }
      } else if (oldResult == ConnectivityResult.none) {
        if (mounted) {
          setState(() {
            _networkConnection = false;
          });
        }
      }
      oldResult = result;
    });
  }

  @override
  dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return AnimatedContainer(
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 800),
        height: _networkConnection ? 45.0 : 0.0,
        width: width,
        color: Colors.red,
        child: ListTile(
          leading: IconButton(
            icon: Icon(Icons.error_outline),
            iconSize: 25.0,
            color: _networkConnection ? Colors.white : Colors.transparent,
            onPressed: () => () {},
          ),
          title: Text('No internet connection',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.white,
              )),
          onTap: () => () {},
        ));
  }
}
