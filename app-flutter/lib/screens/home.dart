import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';

import 'login_mqtt_screen.dart';
import 'messages_screen.dart';
import './monitor_screen.dart';
import 'topics_screen.dart';
import '../state/mqtt_instance.dart';
import '../screens/send_messages_screen.dart';
import '../screens/camera_stream_screen.dart';

class HomeTabs extends StatefulWidget {
  const HomeTabs({Key? key}) : super(key: key);

  @override
  State<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
  List<Map<String, Object>> _pages = [];

  ///initState được gọi đầu tiên khi HomeTabs được gọi (trước khi build context)
  @override
  void initState() {
    _pages = [
      {'page': const LoginMQTTScreen(), 'title': 'Login MQTT Screen'},
      {'page': const TopicScreen(), 'title': 'Topic Screen'},
      {'page': const MessageScreen(), 'title': 'Message Screen'},
      {'page': const MonitorScreen(), 'title': 'Monitor Screen'},
      {'page': const CameraStreamScreen(), 'title': 'Camera Screen'},
    ];
    super.initState();
  }

  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("home.dart rebuild");
    IconData connectionStateIcon;

    ///gọi instance của MQTT Object được quản lý bằng Provider
    ///chú ý là mỗi screen đều gọi instance này ra để dùng, nhưng bản chất chỉ
    ///có một object mqtt_instance duy nhất được khởi tạo ở file main.dart, tất cả
    ///các widget con của main.dart chỉ là gọi ra để dùng chứ không tạo object mới.
    final _mqttInstance = Provider.of<MqttInstance>(context);

    ///icon hiển thị trạng thái kết nối trên Appbar
    switch (_mqttInstance.client?.connectionState) {
      case MqttConnectionState.connected:
        connectionStateIcon = Icons.cloud_done;
        break;
      case MqttConnectionState.disconnected:
        connectionStateIcon = Icons.cloud_off;
        break;
      case MqttConnectionState.connecting:
        connectionStateIcon = Icons.cloud_upload;
        break;
      case MqttConnectionState.disconnecting:
        connectionStateIcon = Icons.cloud_download;
        break;
      case MqttConnectionState.faulted:
        connectionStateIcon = Icons.error;
        break;
      default:
        connectionStateIcon = Icons.cloud_off;
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_pages[_selectedPageIndex]['title'] as String),
            const SizedBox(
              width: 8.0,
            ),
            Icon(connectionStateIcon)
          ],
        ),
        centerTitle: true,
      ),
      drawer: null,

      ///tất cả 4 subpage trong BottomNavigation là con của HomeTabs, vì vậy chúng cũng
      ///sử dụng được Provider của mqtt_instance.dart
      body: _pages[_selectedPageIndex]['page'] as Widget,
      floatingActionButton: _selectedPageIndex == 2

          ///nếu index page là 2 (page thứ 3) thì hiện nút để gọi screen gửi message qua MQTT
          ? Builder(builder: (BuildContext context) {
              return FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<String>(
                        ///pass instance của provider vào screen vừa được push
                        builder: (BuildContext context) =>
                            SendMessageDialog(client: _mqttInstance.client),
                        fullscreenDialog: true,
                      ));
                },
                child: const Icon(Icons.add),
              );
            })
          : null,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Theme.of(context).canvasColor,
        selectedItemColor: Theme.of(context).canvasColor,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.login),
              label: 'Login MQTT',
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: const Icon(Icons.playlist_add_outlined),
              label: 'Topics',
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: const Icon(Icons.message_sharp),
              label: 'Messages',
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: const Icon(Icons.smart_display_rounded),
              label: 'Monitor',
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: const Icon(Icons.camera_outlined),
              label: 'Camera Stream',
              backgroundColor: Theme.of(context).primaryColor),
        ],
      ),
    );
  }
}
