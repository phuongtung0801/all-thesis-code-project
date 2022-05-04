import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/rounded_input_field.dart';
import '../components/topics_list.dart';
import '../components/rounded_button.dart';
import '../state/mqtt_instance.dart';

///screen này dùng để subscribe/unsubscribe vào các topic khác nhau
class TopicScreen extends StatefulWidget {
  const TopicScreen({Key? key}) : super(key: key);

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint('rebuild topic screen tree');
    final _mqttInstance = Provider.of<MqttInstance>(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*SizedBox(
              width: 200.0,
              child: TextField(
                controller: topicController,
                decoration: InputDecoration(hintText: 'Please enter a topic'),
              ),
            ),*/
              RoundedInputField(
                controller: _mqttInstance.topicController,
                hintText: "Please enter a topic",
                icon: Icons.ac_unit_outlined,
                //onChanged: (value) => passwd = value,
              ),
              //SizedBox(width: 8.0),
              RoundedButton(
                width: size.width * 0.8,
                text: 'ADD TOPIC',
                fontSize: 16,
                press: () {
                  _mqttInstance.subscribeToTopic(
                      _mqttInstance.topicController.value.text);
                  //_subscribeToTopic(topicController.value.text);
                },
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          TopicsList(
              topics: _mqttInstance.topics,
              unSubscribeTopic: _mqttInstance.unsubscribeFromTopic)
        ],
      ),
    );
  }
}
