///Copyright Trần Phương Tùng, ĐH Bách Khoa, 2022
///Contact: phuongtung0801@gmail.com
///App được dùng để giao tiếp thông qua giao thức MQTT. Có các chức năng gửi, nhận
///msg MQTT, hiển thị data lên Monitor Screen, dùng API Alan Voice để ra lệnh bằng giọng nói.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/home.dart';
import './state/mqtt_instance.dart';
import './constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///Sử dụng Provider để quản lý state, dùng một object để kết nối MQTT và share
    ///giữa các screen.
    debugPrint("main.dart rebuild");
    return ChangeNotifierProvider(
        create: (ctx) => MqttInstance(),
        child: MaterialApp(
          title: 'Monitor MQTT App ',
          home: const HomeTabs(),
          theme: ThemeData(
              appBarTheme: const AppBarTheme(backgroundColor: kPrimaryColor),
              primaryColor: kPrimaryColor,
              // primarySwatch: ,
              scaffoldBackgroundColor: backgroundColor,
              canvasColor: kPrimaryLightColor,
              bottomAppBarTheme: const BottomAppBarTheme(color: kPrimaryColor)
              //accentColor: Colors.white10),
              ),
        ));
  }
}
