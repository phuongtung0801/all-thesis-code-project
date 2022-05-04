import 'dart:core';

import 'package:collection/src/comparators.dart';
import 'package:flutter/material.dart';
//import 'package:mqtt_client/mqtt_client.dart';

class TopicsList extends StatelessWidget {
  Set<String> topics = Set<String>();
  Function unSubscribeTopic;
  TopicsList({Key? key, required this.topics, required this.unSubscribeTopic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      alignment: WrapAlignment.start,
      children: buildTopicList(),
    );
  }

  List<Widget> buildTopicList() {
    // Sort topics
    final List<String> sortedTopics = topics.toList()
      ..sort((String a, String b) {
        return compareNatural(a, b);
      });
    return sortedTopics
        .map((String topic) => Chip(
              backgroundColor: Colors.blueGrey,
              label: Text(
                topic,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              onDeleted: () {
                unSubscribeTopic(topic);
              },
            ))
        .toList();
  }
}
