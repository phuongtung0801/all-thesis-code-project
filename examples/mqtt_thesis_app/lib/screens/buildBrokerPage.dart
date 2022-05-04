import 'package:flutter/material.dart';
import '../components/rounded_input_field.dart';
import '../components/rounded_button.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:math';

class BuildBrokerPage extends StatelessWidget {
  //const buildBrokerPage({ Key? key }) : super(key: key);
  TextEditingController brokerController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwdController = TextEditingController();
  TextEditingController identifierController = TextEditingController();
  TextEditingController topicController = TextEditingController();
  Size size;
  MqttServerClient client;
  MqttConnectionState connectionState;
  String broker;
  int port;
  String username;
  String passwd;
  String clientIdentifier;
  Function disconnect;
  Function connect;
  BuildBrokerPage(
      {this.connect,
      this.broker,
      this.brokerController,
      this.client,
      this.clientIdentifier,
      this.connectionState,
      this.disconnect,
      this.identifierController,
      this.passwd,
      this.passwdController,
      this.port,
      this.portController,
      this.size,
      this.topicController,
      this.username,
      this.usernameController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
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
                  controller: brokerController,
                  hintText: "Your Broker",
                  //onChanged: (value) => broker = value,
                ),
                SizedBox(
                  height: 8.0,
                ),
                RoundedInputField(
                  icon: Icons.swap_horizontal_circle,
                  controller: portController,
                  hintText: "Your Port",
                  //onChanged: (value) => port = int.tryParse(value),
                ),
                SizedBox(height: 8.0),
                RoundedInputField(
                  icon: Icons.person,
                  controller: usernameController,
                  hintText: "Your User name",
                  //onChanged: (value) => username = value,
                ),
                SizedBox(height: 8.0),
                RoundedInputField(
                  icon: Icons.vpn_key,
                  controller: passwdController,
                  hintText: "Your Password",
                  //onChanged: (value) => passwd = value,
                ),
                SizedBox(height: 8.0),
                RoundedInputField(
                  icon: Icons.person_pin,
                  controller: identifierController,
                  hintText: "Your Client Identifier",
                  //onChanged: (value) => clientIdentifier = value,
                ),
                SizedBox(height: 45.0),
                RoundedButton(
                  width: size.width * 0.8,
                  fontSize: 16,
                  text: client?.connectionState == MqttConnectionState.connected
                      ? 'Disconnect'
                      : 'Connect',
                  press: () {
                    if (brokerController.value.text.isNotEmpty) {
                      broker = brokerController.value.text;
                    }

                    port = int.tryParse(portController.value.text);
                    if (port == null) {
                      port = 1883;
                    }
                    if (usernameController.value.text.isNotEmpty) {
                      username = usernameController.value.text;
                    }
                    if (passwdController.value.text.isNotEmpty) {
                      passwd = passwdController.value.text;
                    }

                    clientIdentifier = identifierController.value.text;
                    if (clientIdentifier.isEmpty) {
                      var random = new Random();
                      clientIdentifier =
                          'tung_' + random.nextInt(100).toString();
                    }

                    if (client?.connectionState ==
                        MqttConnectionState.connected) {
                      disconnect();
                    } else {
                      connect();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
