import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofair/domain/repository/users_repository.dart';
import 'package:ofair/presentation/ride_request_bloc/ride_requests_event.dart';
import 'package:ofair/presentation/ride_request_bloc/ride_requests_state.dart';

class RideRequestsBloc extends Bloc<RideRequestEvents, RideRequestsState> {
  final UsersRepository usersRepository;
  RideRequestsBloc({required this.usersRepository})
    : super(RideRequestsState.initial()) {
    on<GetRideRequestEvent>(onGetRideRequests);
    on<CreateRideRequestEvent>(onCreateRideRequest);
  }

  Future onGetRideRequests(GetRideRequestEvent event, Emitter emit) async {
    emit(state.copyWith(status: RideRequestsStatus.loading));
    try {
      var result = await usersRepository.getRideRequests(event.userId);
      emit(
        state.copyWith(
          status: RideRequestsStatus.success,
          rideRequests: result,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RideRequestsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }


    Future<void> onCreateRideRequest(
    CreateRideRequestEvent event,
    Emitter emit,
  ) async {
    emit(state.copyWith(status: RideRequestsStatus.creating));
    try {
      var response = await usersRepository.createRideRequest(
        rideTag: event.rideTag,
        userId: event.userId,
        rideInfoImage: event.rideInfoImage,
      );
      
   if(response.statusCode == 200 || response.statusCode == 201) {
        emit(state.copyWith(status: RideRequestsStatus.created));
      
      // Optional: Automatically refresh the list after creating
      add(GetRideRequestEvent(userId: event.userId));
   }
   else {
     emit(state.copyWith(
        status: RideRequestsStatus.error,
       errorMessage: response.statusMessage
      ));
   }
      
    } catch (e) {
      emit(state.copyWith(
        status: RideRequestsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
