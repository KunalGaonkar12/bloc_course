import 'dart:async';
import 'package:bloctest_project/dialogs/loading_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoadingScreen {

  //Singleton pattern
  LoadingScreen._sharedInstance();

  static late final LoadingScreen _shared = LoadingScreen._sharedInstance();

  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? _controller;

  void show({required String text,required BuildContext context}) {
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = _showOverLay(text: text,context:context);
    }
  }

  void hide(){
    _controller?.close();
    _controller=null;
  }

  LoadingScreenController _showOverLay({
    required String text,
    required BuildContext  context,
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);
    final rendBox =
    context.findRenderObject() as RenderBox;
    final size = rendBox.size;

    final overlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: size.width * 0.8,
              maxWidth: size.width * 0.8,
              minWidth: size.width * 0.5,
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(4)),
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 10,
                      ),
                      StreamBuilder(
                          stream: _text.stream,
                          builder: (context, snapShot) {
                            if (snapShot.hasData) {
                              return Text(
                                snapShot.data!,
                                textAlign: TextAlign.center,
                              );
                            } else {
                              return Container();
                            }
                          })
                    ],
                  ),
                )),
          ),
        ),
      );
    });
    state.insert(overlay);
    return LoadingScreenController(close: () {
      _text.close();
      overlay.remove();
      return true;
    }, update: (text) {
      _text.add(text);
      return true;
    });
  }
}
