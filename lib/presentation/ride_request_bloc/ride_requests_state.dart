
import 'package:ofair/domain/model/ride_request_models.dart';

enum RideRequestsStatus {
  initial, loading, success, error , creating , created
}



class RideRequestsState {
  final RideRequestsStatus status;
  final String? errorMessage;
  final List<RideRequestModel> ? rideRequests;

  RideRequestsState._({required this.status,  this.errorMessage,  this.rideRequests});


 factory RideRequestsState.initial() =>  RideRequestsState._(status : RideRequestsStatus.initial);

  RideRequestsState copyWith ({RideRequestsStatus? status, String? errorMessage, List<RideRequestModel>? rideRequests  }){
    return RideRequestsState._(status:  status ?? this.status, errorMessage: errorMessage ?? this.errorMessage, rideRequests: rideRequests ?? this.rideRequests);
  }


}