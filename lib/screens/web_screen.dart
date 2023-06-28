import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import '../main.dart';


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  final GlobalKey googleMapWebViewKey = GlobalKey();
  final TextEditingController mapController = TextEditingController();

  double prog = 0;

  InAppWebViewController? mapInAppWebViewController;
  late PullToRefreshController mapPullToRefreshController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  wikiInitRefreshController() async {
    mapPullToRefreshController = PullToRefreshController(
        options: PullToRefreshOptions(color: Colors.blue),
        onRefresh: () async {
          if (Platform.isAndroid) {
            mapInAppWebViewController?.reload();
          } else if (Platform.isIOS) {
            mapInAppWebViewController?.loadUrl(
                urlRequest: URLRequest(
                    url: await mapInAppWebViewController?.getUrl()));
          }
        });
  }

  @override
  initState() {
    super.initState();
    wikiInitRefreshController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('Map Task'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await mapInAppWebViewController!.goBack();
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.refresh,),
            onPressed: () async {
              if (Platform.isAndroid) {
                mapInAppWebViewController?.reload();
              } else if (Platform.isIOS) {
                mapInAppWebViewController?.loadUrl(
                    urlRequest: URLRequest(
                        url: await mapInAppWebViewController?.getUrl()));
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () async {
              await mapInAppWebViewController!.goForward();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: TextField(
                  controller: mapController,
                  onSubmitted: (val) async {
                    Uri uri = Uri.parse(val);
                    if (uri.scheme.isEmpty) {
                      uri = Uri.parse("https://www.google.co.in/search?q=$val");
                    }
                    await mapInAppWebViewController!
                        .loadUrl(urlRequest: URLRequest(url: uri));
                  },
                  decoration: InputDecoration(
                    hintText: "Search on web...",
                    prefixIcon: const Icon(Icons.search,color: Colors.blue,),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
          ),
          (prog < 1)
              ? LinearProgressIndicator(
            value: prog,
            color: Colors.green[700],
          )
              : Container(),
          Expanded(
            flex: 10,
            child: InAppWebView(
              key: googleMapWebViewKey,
              pullToRefreshController: mapPullToRefreshController,
              onWebViewCreated: (controller) {
                mapInAppWebViewController = controller;
              },
              initialOptions: options,
              initialUrlRequest:
              URLRequest(url: Uri.parse("https://www.google.co.in/search?q=$lat,$long")),
              onLoadStart: (controller, uri) {
                setState(() {
                  mapController.text =
                  "${uri!.scheme}://${uri.host}${uri.path}";
                });
              },
              onLoadStop: (controller, uri) {
                mapPullToRefreshController.endRefreshing();
                setState(() {
                  mapController.text =
                  "${uri!.scheme}://${uri.host}${uri.path}";
                });
              },
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT,
                );
              },
              onProgressChanged: (controller, val) {
                if (val == 100) {
                  mapPullToRefreshController.endRefreshing();
                }
                setState(() {
                  prog = val / 100;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
