import 'dart:io';

abstract class RideRequestEvents {}

class GetRideRequestEvent extends RideRequestEvents {
  final userId;
  GetRideRequestEvent({required this.userId});
}


class CreateRideRequestEvent  extends RideRequestEvents {
  final userId;
  final rideTag;
  final File rideInfoImage;
  CreateRideRequestEvent({required this.userId, required this.rideTag, required this.rideInfoImage});

}
