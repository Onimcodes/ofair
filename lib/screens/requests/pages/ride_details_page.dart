import 'package:flutter/material.dart';
import 'package:ofair/common/widgets/gaps.dart';
import 'package:ofair/domain/model/ride_request_models.dart';


class RideDetailsPage extends StatelessWidget {
  final RideRequestModel ride;

  const RideDetailsPage({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ride.rideTag),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                ride.imageUrl,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
              GapWidgets.h16,
            Text(
              'oshodi',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
           GapWidgets.h16,
            Text(
              'Driver: ${ride.rideTag}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
           
            Text(
              'Fare: ₦${500.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
         
            ElevatedButton(
              onPressed: () {
                // Example action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ride booked successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Book Ride'),
            ),
          ],
        ),
      ),
    );
  }
}
