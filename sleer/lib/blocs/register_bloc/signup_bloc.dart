import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleer/blocs/register_bloc/signup_event.dart';
import 'package:sleer/blocs/register_bloc/signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpInitialEvent>((event, emit) {
      emit(SignUpInitial());
    });
  }
}
