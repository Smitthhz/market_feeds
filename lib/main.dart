import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_feeds/bloc/web_socket_bloc.dart';
import 'package:market_feeds/ui/homepage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  final webSocketChannel = WebSocketChannel.connect(
    Uri.parse('wss://ws-feed.exchange.coinbase.com'),
  );
  runApp(MyApp(
    channel: webSocketChannel,
  ));
}

class MyApp extends StatelessWidget {
  final WebSocketChannel channel;
  const MyApp({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocProvider(
          create: (context) => WebSocketBloc(channel)..add(ConnectWebsocket()),
          child: MarketFeedsPage(),
        ));
  }
}
