// import 'package:bars/utilities/exports.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class MyWebView extends StatefulWidget {
//   final String url;
//   final String title;

//   MyWebView({required this.url, required this.title});
//   static final id = 'MyWebView';
//   @override
//   _MyWebViewState createState() => _MyWebViewState();
// }

// class _MyWebViewState extends State<MyWebView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColorLight,
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Theme.of(context).secondaryHeaderColor,
//         ),
//         automaticallyImplyLeading: true,
//         title: Text(
//           widget.title,
//           style: Theme.of(context).textTheme.bodyLarge,
//         ),
//         backgroundColor: Theme.of(context).primaryColorLight,
//       ),
//       body: WebView(
//         initialUrl: widget.url,
//         javascriptMode: JavascriptMode.unrestricted,
//       ),
//     );
//   }
// }

// class WebViewArguments {
//   final String? url;
//   WebViewArguments({this.url});
// }
