import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

Future<void> testConnection() async {
  final client = MqttServerClient(
    'broker.hivemq.com',
    'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
  );
  client.port = 1883;
  client.logging(on: true);
  client.keepAlivePeriod = 20;
  client.setProtocolV311();

  try {
    await client.connect();
    print('Connected!');
    client.disconnect();
  } catch (e) {
    print('Connection failed: $e');
  }
}
