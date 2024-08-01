part of 'web_socket_bloc.dart';

@immutable
sealed class WebSocketEvent {}

class ConnectWebsocket extends WebSocketEvent {}

class DisconnectWebsocket extends WebSocketEvent {}

class WebSocketMessageReceived extends WebSocketEvent {
  final String message;
  WebSocketMessageReceived(this.message);
}

class WebSocketErrorEvent extends WebSocketEvent {
  final String message;
  WebSocketErrorEvent(this.message);
}

class WebSocketDisconnectedEvent extends WebSocketEvent {}
