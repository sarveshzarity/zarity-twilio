import "package:bloc/bloc.dart";
import 'package:equatable/equatable.dart';

import 'package:zarity_twilio/shared/twilio_service.dart';

abstract class RoomState extends Equatable {
  const RoomState();
  @override
  List<Object> get props => [];
}

class RoomInitial extends RoomState {}

class RoomError extends RoomState {
  final String error;
  RoomError({required this.error});
  @override
  List<Object> get props => [error];
}

class RoomLoaded extends RoomState {
  final String name;
  final String token;
  final String identity;

  RoomLoaded({required this.name, required this.token, required this.identity});
  @override
  List<Object> get props => [];
}

class RoomLoading extends RoomState {}

class RoomCubit extends Cubit<RoomState> {
  final TwilioFunctionsService backendService;

  String? name;
  RoomCubit({required this.backendService}) : super(RoomInitial());

  submit() async {
    emit(RoomLoading());
    String? token;
    String? identity;
    try {
      if (name != null) {
        final twilioRoomTokenResponse = await backendService.createToken(name!);
        print(twilioRoomTokenResponse);
        token = twilioRoomTokenResponse['accessToken'];
        identity = twilioRoomTokenResponse['user'];
        print(token);
        print(identity);
      }

      if (token != null && identity != null) {
        emit(RoomLoaded(name: name ?? '', token: token, identity: "sa"));
      } else {
        emit(RoomError(error: 'Access token is empty!'));
      }
    } catch (e) {
      emit(RoomError(
          error: 'Something wrong happened when getting the access token'));
    } finally {}
  }
}
