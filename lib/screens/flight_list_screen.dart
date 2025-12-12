import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../presentation/providers/flight_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/common/error_widget.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/flight/flight_info_card.dart';
import 'flight_detail_screen.dart';

class FlightListScreen extends StatefulWidget {
  const FlightListScreen({Key? key}) : super(key: key);

  @override
  _FlightListScreenState createState() => _FlightListScreenState();
}

class _FlightListScreenState extends State<FlightListScreen> {
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  void _loadMore() async {
    final provider = Provider.of<FlightProvider>(context, listen: false);
    await provider.searchFlights(loadMore: true);
  }

  void _onRefresh() async {
    final provider = Provider.of<FlightProvider>(context, listen: false);
    await provider.searchFlights();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Flight Results',
        showBackButton: true,
      ),
      body: Consumer<FlightProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.flights.isEmpty) {
            return const LoadingWidget();
          }

          if (provider.error != null) {
            return CustomErrorWidget(
              message: provider.error!,
              onRetry: () => provider.searchFlights(),
            );
          }

          if (provider.flights.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.airplanemode_inactive,
                    size: 64,
                    color: Theme.of(context).disabledColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No flights found',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try adjusting your search criteria',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            enablePullDown: true,
            enablePullUp: true,
            footer: CustomFooter(
              builder: (context, mode) {
                if (mode == LoadStatus.idle) {
                  return const SizedBox();
                } else if (mode == LoadStatus.loading) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (mode == LoadStatus.failed) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Failed to load more flights'),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No more flights'),
                  );
                }
              },
            ),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: provider.flights.length,
              itemBuilder: (context, index) {
                final flight = provider.flights[index];
                return FlightInfoCard(
                  flight: flight,
                  onTap: () {
                    provider.setSelectedFlight(flight);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FlightDetailScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}