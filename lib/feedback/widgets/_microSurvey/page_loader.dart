import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import './../../../constants/index.dart';

class PageLoader extends StatefulWidget {
  final double top;
  final double bottom;
  PageLoader({Key key, this.top = 0, this.bottom = 0}) : super(key: key);
  @override
  _PageLoaderState createState() => _PageLoaderState();
}

class _PageLoaderState extends State<PageLoader> {
  final riveFileName = PAGE_LOADER;
  Artboard _artboard;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile.import(bytes);

    // Select an animation by its name
    setState(() => _artboard = file.mainArtboard
      ..addController(
        SimpleAnimation('idle'),
      ));

    // Select an animation by its name
    setState(() => _artboard = file.mainArtboard
      ..addController(
        SimpleAnimation('loading'),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Container(
          height: 64,
          width: 64,
          margin: EdgeInsets.only(top: widget.top, bottom: widget.bottom),
          child: _artboard != null
              ? Rive(
                  useArtboardSize: true,
                  artboard: _artboard,
                  // fit: BoxFit.cover,
                )
              : Center(),
        )));
  }
}
