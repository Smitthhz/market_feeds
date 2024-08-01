import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  final WebSocketChannel _channel;
  bool _isSubscribed = false;

  WebSocketManager(String url)
      : _channel = WebSocketChannel.connect(Uri.parse(url));

  WebSocketChannel get channel => _channel;

  void subscribe() {
    if (!_isSubscribed) {
      _channel.sink.add(jsonEncode({
        "type": "subscribe",
        "product_ids": ["ETH-USD", "ETH-EUR"],
        "channels": [
          "level2",
          "heartbeat",
          {
            "name": "ticker",
            "product_ids": ["ETH-BTC", "ETH-USD"]
          }
        ]
      }));
      _isSubscribed = true;
    }
  }

  void unsubscribe() {
    if (_isSubscribed) {
      _channel.sink.add(jsonEncode({"type": "unsubscribe"}));
      _isSubscribed = false;
    }
  }

  void dispose() {
    _channel.sink.close();
  }
}
