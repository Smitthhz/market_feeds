import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_feeds/bloc/web_socket_bloc.dart';
import 'package:market_feeds/ui/web_socket_manager.dart';

class MarketFeedsPage extends StatelessWidget {
  final WebSocketManager _webSocketManager =
      WebSocketManager('wss://ws-feed.exchange.coinbase.com');

  MarketFeedsPage({super.key}) {
    // Subscribe to the WebSocket when the widget is created
    _webSocketManager.subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coinbase Market Feeds'),
      ),
      body: BlocBuilder<WebSocketBloc, WebSocketState>(
        builder: (context, state) {
          if (state is WebSocketConnected) {
            return const Center(child: Text('Connected to WebSocket'));
          } else if (state is WebSocketDataReceived) {
            return Column(
              children: [
                const Text('ETH-USD'),
                if (state.ethUsdData.isNotEmpty)
                  _buildDataCard(state.ethUsdData),
              ],
            );
          } else if (state is WebSocketError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is WebSocketDisconnected) {
            return const Center(child: Text('Disconnected from WebSocket'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final currentState = context.read<WebSocketBloc>().state;
          if (currentState is WebSocketDisconnected ||
              currentState is WebSocketError) {
            _webSocketManager.subscribe();
            context.read<WebSocketBloc>().add(ConnectWebsocket());
          } else {
            _webSocketManager.unsubscribe();
            context.read<WebSocketBloc>().add(DisconnectWebsocket());
          }
        },
        child: Icon(
          context.read<WebSocketBloc>().state is WebSocketDisconnected ||
                  context.read<WebSocketBloc>().state is WebSocketError
              ? Icons.play_arrow
              : Icons.stop,
        ),
      ),
    );
  }

  Widget _buildDataCard(Map<String, dynamic> data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDataRow('Price', data['price']),
            _buildDataRow('Volume 24h', data['volume_24h']),
            _buildDataRow('High 24h', data['high_24h']),
            _buildDataRow('Low 24h', data['low_24h']),
            _buildDataRow('Best Bid', data['best_bid']),
            _buildDataRow('Best Ask', data['best_ask']),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
