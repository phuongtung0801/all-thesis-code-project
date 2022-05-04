import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../model/message.dart';

class MqttInstance with ChangeNotifier {
  double temperature = 30, humidity = 40, light = 50;
  bool checker = true;
  String titleBar = 'MQTT App';
  String broker = 'phuongtung08081.tk';
  int port = 1883;
  String username = 'tungtran256';
  String passwd = 'nguyenthiminhthy2304';
  String clientIdentifier = 'tung';
  MqttServerClient? client;
  MqttConnectionState? connectionState;
  StreamSubscription? subscription;
  Set<String> topics = Set<String>();
  List<Message> messages = <Message>[];
  // List<Message> get publicMessage {
  //   //notifyListeners();
  //   return [...messages];
  // }

  ScrollController messageController = ScrollController();
  //text controller
  TextEditingController brokerController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwdController = TextEditingController();
  TextEditingController identifierController = TextEditingController();
  TextEditingController topicController = TextEditingController();

  void onChangeData() {
    checker = !checker;
    notifyListeners();
  }

  void subscribeToTopic(String topic) {
    if (connectionState == MqttConnectionState.connected) {
      if (topics.add(topic.trim())) {
        debugPrint('Subscribing to ${topic.trim()}');
        client?.subscribe(topic, MqttQos.exactlyOnce);
      }
    }
    notifyListeners();
  }

  void unsubscribeFromTopic(String topic) {
    if (connectionState == MqttConnectionState.connected) {
      if (topics.remove(topic.trim())) {
        debugPrint('Unsubscribing from ${topic.trim()}');
        client?.unsubscribe(topic);
      }
    }
    notifyListeners();
  }

  ///Connect Functions
  void connect() async {
    /// First create a client, the client is constructed with a broker name, client identifier
    /// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
    /// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
    /// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
    /// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
    /// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
    /// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
    /// of 1883 is used.
    /// If you want to use websockets rather than TCP see below.
    ///
    client = MqttServerClient(broker, '');
    client?.port = port;

    /// A websocket URL must start with ws:// or wss:// or Dart will throw an exception, consult your websocket MQTT broker
    /// for details.
    /// To use websockets add the following lines -:
    /// client.useWebSocket = true;
    /// client.port = 80;  ( or whatever your WS port is)
    /// Note do not set the secure flag if you are using wss, the secure flags is for TCP sockets only.

    /// Set logging on if needed, defaults to off
    client?.logging(on: true);

    /// If you intend to use a keep alive value in your connect message that is not the default(60s)
    /// you must set it here
    client?.keepAlivePeriod = 30;

    /// Add the unsolicited disconnection callback
    client?.onDisconnected = _onDisconnected;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password, the default keepalive interval(60s)
    /// and clean session, an example of a specific one below.
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        // Must agree with the keep alive set above or not set
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
        // If you set this you must set a will message
        .withWillTopic('test/test')
        .withWillMessage('tung message test')
        .withWillQos(MqttQos.atMostOnce);
    debugPrint('MQTT client connecting....');
    client?.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.

    try {
      await client?.connect(username, passwd);
    } catch (e) {
      debugPrint("something went wrong in mqtt_instance:118");
      disconnect();
    }

    /// Check if we are connected
    if (client?.connectionState == MqttConnectionState.connected) {
      debugPrint('MQTT client connected');
      connectionState = client?.connectionState;
    } else {
      debugPrint('ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client?.connectionState}');
      disconnect();
    }

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    subscription = client?.updates?.listen(_onMessage);
    notifyListeners();
  }

  void disconnect() {
    client?.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    topics.clear();
    connectionState = client?.connectionState;
    client = null;
    subscription?.cancel();
    subscription = null;

    debugPrint('MQTT client disconnected');
    notifyListeners();
  }

  void _onMessage(List<MqttReceivedMessage> event) {
    //debugPrint("do dai cua event: ${event.length}");
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
    String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    /// The above may seem a little convoluted for users only interested in the
    /// payload,some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    debugPrint('MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- ${message} -->');
    print(client?.connectionState);

    ///nếu data gửi đến là dạng json (data từ sensor), thì sẽ extract nó để hiển
    ///thị lên monitor screen, không thì catch error và thực hiện lên kế tiếp
    try {
      final userMap = jsonDecode(message);
      light = double.tryParse(userMap['light']) as double;
      print("hello json");
      print(light);
    } catch (e) {
      debugPrint('json light is fuck off');
    }
    try {
      final userMap = jsonDecode(message);
      humidity = double.tryParse(userMap['humidity']) as double;
      print("hello json");
      print(light);
    } catch (e) {
      debugPrint('json humidity is fuck off');
    }
    try {
      final userMap = jsonDecode(message);
      temperature = double.tryParse(userMap['temperature']) as double;
      print("hello json");
      print(light);
    } catch (e) {
      debugPrint('json temperature is fuck off');
    }
    messages.add(Message(
      topic: event[0].topic,
      message: message,
      //qos: recMess.payload.header.qos,
    ));

    notifyListeners();
  }
  // notifyListeners();
}
