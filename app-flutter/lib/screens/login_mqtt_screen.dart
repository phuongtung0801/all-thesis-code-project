import 'dart:math';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../state/mqtt_instance.dart';
import '../components/rounded_input_field.dart';
import '../components/rounded_button.dart';

///screen này dùng để nhập thông tin kết nối đến Broker, mặc định đã được nhập thông tin
///của tài khoản emqx nên có thể bấm connect ngay.
class LoginMQTTScreen extends StatefulWidget {
  const LoginMQTTScreen({Key? key}) : super(key: key);

  @override
  State<LoginMQTTScreen> createState() => _LoginMQTTScreenState();
}

class _LoginMQTTScreenState extends State<LoginMQTTScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _mqttInstance = Provider.of<MqttInstance>(context, listen: false);
    debugPrint('rebuild login screen tree');
    return Container(
      alignment: Alignment.center,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RoundedInputField(
                  icon: Icons.add_moderator,
                  controller: _mqttInstance.brokerController,
                  hintText: "Your Broker",
                  //onChanged: (value) => broker = value,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                RoundedInputField(
                  icon: Icons.swap_horizontal_circle,
                  controller: _mqttInstance.portController,
                  hintText: "Your Port",
                  //onChanged: (value) => port = int.tryParse(value),
                ),
                const SizedBox(height: 8.0),
                RoundedInputField(
                  icon: Icons.person,
                  controller: _mqttInstance.usernameController,
                  hintText: "Your User name",
                  //onChanged: (value) => username = value,
                ),
                const SizedBox(height: 8.0),
                RoundedInputField(
                  icon: Icons.vpn_key,
                  controller: _mqttInstance.passwdController,
                  hintText: "Your Password",
                  //onChanged: (value) => passwd = value,
                ),
                const SizedBox(height: 8.0),
                RoundedInputField(
                  icon: Icons.person_pin,
                  controller: _mqttInstance.identifierController,
                  hintText: "Your Client Identifier",
                  //onChanged: (value) => clientIdentifier = value,
                ),
                const SizedBox(height: 45.0),
                Consumer<MqttInstance>(
                  builder: (context, value, _) => RoundedButton(
                    width: size.width * 0.8,
                    fontSize: 16,
                    text: _mqttInstance.client?.connectionState ==
                            MqttConnectionState.connected
                        ? 'Disconnect'
                        : 'Connect',
                    // text: _mqttInstance.checker == true ? 'Connect' : 'Disconnect',
                    press: () {
                      //_mqttInstance.onChangeData();
                      if (_mqttInstance
                          .brokerController.value.text.isNotEmpty) {
                        _mqttInstance.broker =
                            _mqttInstance.brokerController.value.text;
                      }
                      if (_mqttInstance.portController.value.text.isNotEmpty) {
                        _mqttInstance.port =
                            int.parse(_mqttInstance.portController.value.text);
                      }

                      // if (_mqttInstance.port == null) {
                      //   _mqttInstance.port = 1883;
                      // }
                      if (_mqttInstance
                          .usernameController.value.text.isNotEmpty) {
                        _mqttInstance.username =
                            _mqttInstance.usernameController.value.text;
                      }
                      if (_mqttInstance
                          .passwdController.value.text.isNotEmpty) {
                        _mqttInstance.passwd =
                            _mqttInstance.passwdController.value.text;
                      }

                      _mqttInstance.clientIdentifier =
                          _mqttInstance.identifierController.value.text;
                      if (_mqttInstance.clientIdentifier.isEmpty) {
                        var random = Random();
                        _mqttInstance.clientIdentifier =
                            'tung_' + random.nextInt(100).toString();
                      }

                      if (_mqttInstance.client?.connectionState ==
                          MqttConnectionState.connected) {
                        _mqttInstance.disconnect();
                        // _mqttInstance.disconnect();
                      } else {
                        // disConnectTest();
                        _mqttInstance.connect();
                        // _mqttInstance.connect();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
