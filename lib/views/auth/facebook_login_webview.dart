import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class FacebookLoginWebView extends StatefulWidget {
  final String selectedUrl;

  FacebookLoginWebView({this.selectedUrl});

  @override
  _FacebookLoginWebViewState createState() => _FacebookLoginWebViewState();
}

class _FacebookLoginWebViewState extends State<FacebookLoginWebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  //webpage loading state
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.cleanCookies();
    flutterWebviewPlugin.onUrlChanged.listen(
      (String url) {
        if (url.contains("#access_token")) {
          succeed(url);
        }

        if (url.contains(
            "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
          denied();
        }
      },
    );

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

  denied() {
    Navigator.pop(context);
  }

  succeed(String url) {
    var params = url.split("access_token=");
    var endparam = params[1].split("&");
    Navigator.pop(context, endparam[0]);
  }

  checkRequestStatus(String url) {
    if (url.contains("#access_token")) {
      succeed(url);
    }

    if (url.contains(
        "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
      denied();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(66, 103, 178, 1),
        title: new Text("Facebook login"),
      ),
      body: Column(
        children: <Widget>[
          //progress bar
          isLoading ? LinearProgressIndicator() : SizedBox.shrink(),
          //webvieew
          Expanded(
            child: WebviewScaffold(
              url: widget.selectedUrl,
            ),
          ),
        ],
      ),
    );
  }
}
