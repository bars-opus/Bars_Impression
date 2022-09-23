import 'package:bars/utilities/exports.dart';

class FetchingNextContent extends StatelessWidget {
  final String title;
  final bool loading;

  FetchingNextContent({
    required this.title,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 800),
        height: loading ? 45.0 : 0.0,
        width: MediaQuery.of(context).size.width,
        color: Colors.red,
        child: ListTile(
          leading: IconButton(
            icon: Icon(Icons.error_outline),
            iconSize: 25.0,
            color: loading ? Colors.white : Colors.transparent,
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
