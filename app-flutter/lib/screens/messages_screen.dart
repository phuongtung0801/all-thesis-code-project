import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/rounded_button.dart';
import '../state/mqtt_instance.dart';
import '../constants.dart';
import '../model/message.dart';

///screen này dùng để hiển thị các msg nhận được thông qua giao thức MQTT
class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint('rebuild message screen tree');
    Size size = MediaQuery.of(context).size;
    final _mqttInstance = Provider.of<MqttInstance>(context, listen: true);
    return Column(
      children: <Widget>[
        Expanded(
            child: ListView(
                controller: _mqttInstance.messageController,
                children: _mqttInstance.messages
                    .map((Message message) => Card(
                          color: backgroundColor,
                          child: ListTile(
                            trailing: CircleAvatar(
                                radius: 14.0,
                                backgroundColor: Theme.of(context).accentColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Text(
                                      'QoS',
                                      style: TextStyle(fontSize: 8.0),
                                    ),
                                    /*Text(
                  message.qos.index.toString(),
                  style: TextStyle(fontSize: 8.0),
                ),*/
                                  ],
                                )),
                            title: Text(message.topic),
                            subtitle: Text(
                              message.message,
                              style: const TextStyle(color: kPrimaryColor),
                            ),
                            dense: true,
                          ),
                        ))
                    .toList()
                    .reversed
                    .toList())),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RoundedButton(
            text: 'CLEAR',
            fontSize: 16,
            width: size.width * 0.5,
            press: () {
              setState(() {
                _mqttInstance.messages.clear();
              });
            },
          ),
        ),
      ],
    );
  }
}
