import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
//import 'package:gesture_zoom_box/gesture_zoom_box.dart';

///dùng để stream camera từ server trên aws, which is nhận stream từ camera ESP32CAM
class CameraStreamScreen extends StatefulWidget {
  const CameraStreamScreen({Key? key}) : super(key: key);
  @override
  _CameraStreamScreenState createState() => _CameraStreamScreenState();
}

class _CameraStreamScreenState extends State<CameraStreamScreen> {
  final double videoWidth = 640;
  final double videoHeight = 480;
  final WebSocketChannel channel =
      IOWebSocketChannel.connect('ws://13.228.247.159:8888');
  double newVideoSizeWidth = 640;
  double newVideoSizeHeight = 480;

  bool isLandscape = false;
  String _timeString = 'null';

  final _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    isLandscape = false;
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void dispose() {
    ///khi remove widget khỏi tree thì cần close cái nùi này để khỏi bị lỗi
    channel.sink.close();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      timer.cancel();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('rebuild camera screen tree');
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        var screenWidth = MediaQuery.of(context).size.width;
        var screenHeight = MediaQuery.of(context).size.height;

        if (orientation == Orientation.portrait) {
          //screenWidth < screenHeight

          isLandscape = false;
          newVideoSizeWidth =
              screenWidth > videoWidth ? videoWidth : screenWidth;
          newVideoSizeHeight = videoHeight * newVideoSizeWidth / videoWidth;
        } else {
          isLandscape = true;
          newVideoSizeHeight =
              screenHeight > videoHeight ? videoHeight : screenHeight;
          newVideoSizeWidth = videoWidth * newVideoSizeHeight / videoHeight;
        }

        return Container(
          color: Colors.black,
          child: StreamBuilder(
            stream: channel.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  // child: Text(
                  //   'Fuck you',
                  //   style: TextStyle(color: Colors.amber),
                  // ),
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: isLandscape ? 0 : 30,
                        ),
                        Stack(
                          children: <Widget>[
                            RepaintBoundary(
                              key: _globalKey,
                              child: Image.memory(
                                snapshot.data as Uint8List,
                                gaplessPlayback: true,
                                width: newVideoSizeWidth,
                                height: newVideoSizeHeight,
                              ),
                            ),
                            Positioned.fill(
                                child: Align(
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  const Text(
                                    'ESP32\'s cam',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'Live | $_timeString',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                              alignment: Alignment.topCenter,
                            ))
                          ],
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.black,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(
                                      Icons.photo_camera,
                                      size: 24,
                                    ),
                                    onPressed: takeScreenShot,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        );
      }),
      floatingActionButton: _getFab(),
    );
  }

  takeScreenShot() async {
    // RenderRepaintBoundary boundary =
    //     _globalKey.currentContext.findRenderObject();
    // var image = await boundary.toImage();
    // var byteData = await image.toByteData(format: ImageByteFormat.png);
    // var pngBytes = byteData.buffer.asUint8List();
    // final res = await _imageSaver.saveImage(imageBytes: pngBytes);

    // Fluttertoast.showToast(
    //     msg: res ? "ScreenShot Saved" : "ScreenShot Failure!",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIos: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd hh:mm:ss aaa').format(dateTime);
  }

  void _getTime() {
    final DateTime now = DateTime.now();

    ///kiểm tra xem widget có còn trong tree không, nếu không thì không được
    ///gọi hàm setState()
    if (!mounted) return;
    setState(() {
      _timeString = _formatDateTime(now);
    });
  }

  Widget _getFab() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 22),
      visible: isLandscape,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.photo_camera),
          onTap: takeScreenShot,
        ),
        SpeedDialChild(child: const Icon(Icons.videocam), onTap: () {})
      ],
    );
  }
}
