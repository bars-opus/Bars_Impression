import 'package:bars/utilities/exports.dart';

class StringListWidget extends StatefulWidget {
  final List<String> stringValues;

  StringListWidget({required this.stringValues});

  @override
  _StringListWidgetState createState() => _StringListWidgetState();
}

class _StringListWidgetState extends State<StringListWidget> {
  _removePortfolio(String value) {
    setState(() {
      widget.stringValues.remove(value);
    });
  }

  _buildTilePost(
    BuildContext context,
    double width,
    String stringValue,
  ) {
    return Padding(
      padding: EdgeInsets.all(1),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(5)),
        width: width,
        child: Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: ListTile(
            title: Text(
              stringValue.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () => _removePortfolio(stringValue),
              icon: Icon(
                Icons.remove,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildDisplayPortfolioList(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    List<Widget> forumViews = [];
    widget.stringValues.forEach((portfolio) {
      forumViews.add(_buildTilePost(
        context,
        width,
        portfolio,
      ));
    });
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(children: forumViews),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.stringValues.sort((a, b) => a.compareTo(b));

    return _buildDisplayPortfolioList(context);
  }
}
