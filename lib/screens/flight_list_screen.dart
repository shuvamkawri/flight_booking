import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../presentation/providers/flight_provider.dart';
import '../presentation/providers/search_provider.dart';
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
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    // Trigger initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    if (_isInitialLoad) {
      _isInitialLoad = false;
      final flightProvider = Provider.of<FlightProvider>(context, listen: false);
      final searchProvider = Provider.of<SearchProvider>(context, listen: false);

      // Only search if we haven't loaded flights yet or flights are empty
      if (flightProvider.flights.isEmpty) {
        print('Loading initial flight data...');
        print('From: ${searchProvider.from}, To: ${searchProvider.to}');

        await flightProvider.searchFlights(
          from: searchProvider.from,
          to: searchProvider.to,
          departureDate: searchProvider.departureDate,
          passengers: searchProvider.passengers,
          sortBy: searchProvider.sortBy,
          filters: searchProvider.filters,
        );
      }
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    final flightProvider = Provider.of<FlightProvider>(context, listen: false);

    // Don't load more if already loading or no more pages
    if (flightProvider.isLoading) return;

    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    await flightProvider.searchFlights(
      from: searchProvider.from,
      to: searchProvider.to,
      departureDate: searchProvider.departureDate,
      passengers: searchProvider.passengers,
      sortBy: searchProvider.sortBy,
      filters: searchProvider.filters,
      loadMore: true,
    );
  }

  Future<void> _onRefresh() async {
    final flightProvider = Provider.of<FlightProvider>(context, listen: false);
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    await flightProvider.searchFlights(
      from: searchProvider.from,
      to: searchProvider.to,
      departureDate: searchProvider.departureDate,
      passengers: searchProvider.passengers,
      sortBy: searchProvider.sortBy,
      filters: searchProvider.filters,
    );

    _refreshController.refreshCompleted();
  }

  Widget _buildFlightList(FlightProvider provider) {
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: provider.flights.length + (provider.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at the end if loading more
        if (index == provider.flights.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final flight = provider.flights[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FlightInfoCard(
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
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
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
          const SizedBox(height: 20),
          Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              return ElevatedButton(
                onPressed: () async {
                  final flightProvider = Provider.of<FlightProvider>(context, listen: false);
                  await flightProvider.searchFlights(
                    from: searchProvider.from,
                    to: searchProvider.to,
                    departureDate: searchProvider.departureDate,
                    passengers: searchProvider.passengers,
                    sortBy: searchProvider.sortBy,
                    filters: searchProvider.filters,
                  );
                },
                child: const Text('Try Again'),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Flight Results',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _onRefresh,
          ),
        ],
      ),
      body: Consumer<FlightProvider>(
        builder: (context, provider, child) {
          // Show loading only for initial load
          if (provider.isLoading && provider.flights.isEmpty) {
            return const LoadingWidget();
          }

          // Show error
          if (provider.error != null && provider.flights.isEmpty) {
            return CustomErrorWidget(
              message: provider.error!,
              onRetry: () async {
                final searchProvider = Provider.of<SearchProvider>(context, listen: false);
                await provider.searchFlights(
                  from: searchProvider.from,
                  to: searchProvider.to,
                  departureDate: searchProvider.departureDate,
                  passengers: searchProvider.passengers,
                  sortBy: searchProvider.sortBy,
                  filters: searchProvider.filters,
                );
              },
            );
          }

          // Show flights list with pull to refresh
          return SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            enablePullDown: true,
            enablePullUp: false, // We're using scroll listener for pagination
            header: const ClassicHeader(
              idleText: 'Pull to refresh',
              releaseText: 'Release to refresh',
              refreshingText: 'Refreshing...',
              completeText: 'Refresh completed',
              failedText: 'Refresh failed',
            ),
            child: provider.flights.isNotEmpty
                ? _buildFlightList(provider)
                : _buildEmptyState(),
          );
        },
      ),
    );
  }
}