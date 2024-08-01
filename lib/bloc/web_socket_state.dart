part of 'web_socket_bloc.dart';

@immutable
sealed class WebSocketState {}

final class WebSocketInitial extends WebSocketState {}

final class WebSocketConnected extends WebSocketState {}

final class WebSocketDisconnected extends WebSocketState {}

final class WebSocketDataReceived extends WebSocketState {
  final Map<String, dynamic> ethUsdData;
  // final Map<String, dynamic> ethEurData;
  WebSocketDataReceived({
    required this.ethUsdData,
  });
}

final class WebSocketError extends WebSocketState {
  final String message;

  WebSocketError(this.message);
}
