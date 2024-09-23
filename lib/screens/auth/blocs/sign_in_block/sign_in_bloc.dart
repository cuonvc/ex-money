import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {

  final UserRepository userRepository;

  SignInBloc(this.userRepository) : super(SignInInitial()) {
    on<SignInEv>((event, emit) async {
      emit(SignInLoading());
      try {
        await userRepository.signIn(event.signInModel);
        emit(SignInSuccess());
      } catch (e) {
        emit(SignInFailure());
      }
    });
  }
}
