import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'web_socket_event.dart';
part 'web_socket_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final WebSocketChannel channel;
  Map<String, dynamic> ethUsdData = {};

  WebSocketBloc(this.channel) : super(WebSocketInitial()) {
    on<ConnectWebsocket>((event, emit) {
      try {
        _subscribe();
        emit(WebSocketConnected());

        channel.stream.listen(
          (message) {
            add(WebSocketMessageReceived(message));
          },
          onError: (error) {
            add(WebSocketErrorEvent(error.toString()));
          },
          onDone: () {
            add(WebSocketDisconnectedEvent());
          },
        );
      } catch (e) {
        add(WebSocketErrorEvent(e.toString()));
      }
    });

    on<DisconnectWebsocket>((event, emit) {
      _closeConnection();
      emit(WebSocketDisconnected());
    });

    on<WebSocketMessageReceived>((event, emit) {
      try {
        final data = jsonDecode(event.message);
        if (data['type'] == 'ticker' && data['product_id'] == 'ETH-USD') {
          ethUsdData = data;
        }
        emit(WebSocketDataReceived(ethUsdData: ethUsdData));
      } catch (e) {
        add(WebSocketErrorEvent(e.toString()));
      }
    });

    on<WebSocketErrorEvent>((event, emit) {
      emit(WebSocketError(event.message));
    });

    on<WebSocketDisconnectedEvent>((event, emit) {
      emit(WebSocketDisconnected());
    });
  }

  void _subscribe() {
    channel.sink.add(
      jsonEncode(
        {
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
        },
      ),
    );
  }

  void _closeConnection() {
    try {
      channel.sink.close();
    } catch (e) {
      print('Error closing WebSocket connection: $e');
    }
  }
}
