part of '../app_flows/app_flow_screens.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: _flowAppBar(context, 'Clinic Map'),
      body: Stack(
        children: [
          Positioned.fill(child: _mockMap()),
          Positioned(
            top: 24,
            right: 18,
            child: FloatingActionButton.small(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Centered map on your current area.'),
                  ),
                );
              },
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryMint,
              child: const Icon(Icons.my_location),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _mapBottomSheet(context),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }
}
