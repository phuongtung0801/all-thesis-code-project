import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:provider/provider.dart';
import '../state/mqtt_instance.dart';

///screen này dùng để hiển thị dữ liệu sensor nhận được qua MQTT
class MonitorScreen extends StatelessWidget {
  const MonitorScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('rebuild monitor screen tree');
    //Size size = MediaQuery.of(context).size;
    final _mqttInstance = Provider.of<MqttInstance>(context, listen: true);
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
        Widget>[
      Expanded(
        child: SfRadialGauge(
          title: const GaugeTitle(text: 'Temperature'),
          enableLoadingAnimation: true,
          animationDuration: 4500,
          axes: <RadialAxis>[
            RadialAxis(minimum: -50, maximum: 100, pointers: <GaugePointer>[
              NeedlePointer(
                  value: _mqttInstance.temperature, enableAnimation: true)
            ], ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 50, color: Colors.green),
              GaugeRange(startValue: 50, endValue: 100, color: Colors.orange),
              GaugeRange(startValue: 100, endValue: 150, color: Colors.red),
            ], annotations: const <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Text('C Degrees'), positionFactor: 0.8, angle: 90),
            ]),
          ],
        ),
      ),
      Expanded(
        child: SfRadialGauge(
          title: const GaugeTitle(text: 'Humidity'),
          enableLoadingAnimation: true,
          animationDuration: 4500,
          axes: <RadialAxis>[
            RadialAxis(minimum: 0, maximum: 100, pointers: <GaugePointer>[
              NeedlePointer(
                  value: _mqttInstance.humidity, enableAnimation: true)
            ], ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 50, color: Colors.green),
              GaugeRange(startValue: 50, endValue: 100, color: Colors.orange),
              GaugeRange(startValue: 100, endValue: 150, color: Colors.red),
            ], annotations: const <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Text('Percent'), positionFactor: 0.8, angle: 90),
            ]),
          ],
        ),
      ),
      Expanded(
        child: SfRadialGauge(
          title: const GaugeTitle(text: 'Light Value'),
          enableLoadingAnimation: true,
          animationDuration: 4500,
          axes: <RadialAxis>[
            RadialAxis(minimum: 0, maximum: 500, pointers: <GaugePointer>[
              NeedlePointer(value: _mqttInstance.light, enableAnimation: true)
            ], ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 50, color: Colors.green),
              GaugeRange(startValue: 50, endValue: 100, color: Colors.orange),
              GaugeRange(startValue: 100, endValue: 150, color: Colors.red),
            ], annotations: const <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Text('Unit'), positionFactor: 0.8, angle: 90),
            ]),
          ],
        ),
      )
    ]);
  }
}
