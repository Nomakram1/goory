import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:foodie/constants/app_text_styles.dart';

class WebView extends StatefulWidget {
  WebView({
    Key key,
    @required this.url,
  }) : super(key: key);

  final String url;
  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  //webpage loading state
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onStateChanged.listen(
      (WebViewStateChanged event) {
        if (event.type == WebViewState.startLoad) {
          setState(() {
            isLoading = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Payment",
          style: AppTextStyle.h3TitleTextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          //progress bar
          isLoading ? LinearProgressIndicator() : SizedBox.shrink(),
          //webvieew
          Expanded(
            child: WebviewScaffold(
              url: widget.url,
            ),
          ),
        ],
      ),
    );
  }
}
