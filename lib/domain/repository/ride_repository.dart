import 'package:ofair/domain/model/ride_request_models.dart';

abstract class RideRepository {
 Future<List<RideRequestModel>> getRideRequests(String userId);
}