import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:alan_voice/alan_voice.dart';

///screen dùng để gửi msg qua MQTT, có thể setting QoS, retain.
class SendMessageDialog extends StatefulWidget {
  final MqttServerClient? client;
  SendMessageDialog({Key? key, required this.client}) : super(key: key);
  @override
  _SendMessageDialogState createState() => _SendMessageDialogState();
}

class _SendMessageDialogState extends State<SendMessageDialog> {
  bool _hasMessage = false;
  bool _hasTopic = false;
  bool _retainValue = false;
  bool _saveNeeded = false;
  int _qosValue = 0;
  String _messageContent = 'null';
  String _topicContent = 'null';

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    AlanVoice.addButton(
        "6de3900962d1bde06cb6e505117311462e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);

    /// Handle commands from Alan Studio
    /// hàm này trả về data nhận được từ Alan API, which is được mình lập trình trước
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
    super.initState();
  }

  void _handleCommand(Map<String, dynamic> command) {
    _topicContent = "device/2825211609/control";
    switch (command["command"]) {
      //living room command
      case "living room lamp on":
        debugPrint('living room lamp on Alan voice debug');
        _sendVoiceMessage('living room lamp on');
        break;
      case "living room lamp off":
        debugPrint('living room lamp off Alan voice debug');
        _sendVoiceMessage('living room lamp off');
        break;
      //kitchen command
      case "kitchen lamp on":
        debugPrint('kitchen lamp on Alan voice debug');
        _sendVoiceMessage('kitchen lamp on');
        break;
      case "kitchen lamp off":
        debugPrint('kitchen lamp off Alan voice debug');
        _sendVoiceMessage('kitchen lamp off');
        break;
      //bed room one command
      case "bed room one lamp on":
        debugPrint('bed room one lamp on Alan voice debug');
        _sendVoiceMessage('bed room one lamp on');
        break;
      case "bed room one lamp off":
        debugPrint('bed room one lamp off Alan voice debug');
        _sendVoiceMessage('bed room one lamp off');
        break;
      //bed room two command
      case "bed room two lamp on":
        debugPrint('bed room two lamp on Alan voice debug');
        _sendVoiceMessage('bed room two lamp on');
        break;
      case "bed room two lamp off":
        debugPrint('bed room two lamp off Alan voice debug');
        _sendVoiceMessage('bed room two lamp off');
        break;
      //default command
      default:
        _sendVoiceMessage('unknown command');
        debugPrint("Unknown command");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('New message'), actions: <Widget>[
        TextButton(
            child: Text('SEND',
                style:
                    theme.textTheme.bodyText1?.copyWith(color: Colors.white)),
            onPressed: () {
              if (true) {
                debugPrint('send button clicked');
                _formKey.currentState?.save();
                _sendMessage();
              }
            })
      ]),
      body: Form(
        key: _formKey,
        onWillPop: _onWillPop,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.bottomLeft,
              child: TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Message', filled: true),
                style: theme.textTheme.headline5,
                maxLines: 2,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'Please enter some text';
                  }
                },
                onSaved: (String? value) {
                  setState(() {
                    _hasMessage = value?.isNotEmpty ?? false;
                    if (_hasMessage) {
                      _messageContent = value ?? 'null';
                    }
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.bottomLeft,
              child: TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Topic', filled: true),
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'Please enter some text';
                  }
                },
                onSaved: (String? value) {
                  setState(() {
                    _hasTopic = value?.isNotEmpty ?? false;
                  });
                  if (_hasTopic) {
                    _topicContent = value ?? 'null';
                  }
                },
              ),
            ),
            _buildQosChoiceChips(),
            Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: theme.dividerColor))),
              child: Row(
                children: <Widget>[
                  Checkbox(
                      value: _retainValue,
                      onChanged: (bool? value) {
                        setState(() {
                          _retainValue = value == true;
                          _saveNeeded = true;
                        });
                      }),
                  const Text('Retained'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Wrap _buildQosChoiceChips() {
    return Wrap(
      spacing: 4.0,
      children: List<Widget>.generate(
        3,
        (int index) {
          return ChoiceChip(
            label: Text('QoS level $index'),
            selected: _qosValue == index,
            onSelected: (bool selected) {
              setState(() {
                _qosValue = selected ? index : 0;
              });
            },
          );
        },
      ).toList(),
    );
  }

  Future<bool> _onWillPop() async {
    _saveNeeded = _hasTopic || _hasMessage || _saveNeeded;

    if (!_saveNeeded) return true;

    final ThemeData theme = Theme.of(context);
    // final TextStyle dialogTextStyle = theme.textTheme.subtitle1
    //     .copyWith(color: theme.textTheme.caption.color) ;

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // content: Text('Discard message?', style: dialogTextStyle),
              content: const Text('Discard message?'),
              actions: <Widget>[
                TextButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.of(context).pop(
                          false); // Pops the confirmation dialog but not the page.
                    }),
                TextButton(
                    child: const Text('DISCARD'),
                    onPressed: () {
                      Navigator.of(context).pop(
                          true); // Returning true to _onWillPop will pop again.
                    })
              ],
            );
          },
        ) ??
        false;
  }

  void _sendMessage() {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(_messageContent);
    widget.client?.publishMessage(
      _topicContent,
      MqttQos.values[_qosValue],
      builder.payload!,
      retain: _retainValue,
    );
    Navigator.pop(context);
  }

  void _sendVoiceMessage(String msg) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    widget.client?.publishMessage(
        _topicContent, MqttQos.values[_qosValue], builder.payload!);
  }
}
