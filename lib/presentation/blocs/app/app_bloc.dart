import 'package:e_commerce_app/core/services/session_services.dart';
import 'package:e_commerce_app/presentation/blocs/app/app_event.dart';
import 'package:e_commerce_app/presentation/blocs/app/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final SessionServices session;

  AppBloc(this.session) : super(AppInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  void _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    await Future.delayed(const Duration(seconds: 1)); // min splash time
    if (session.isLoggedIn) {
      emit(AppAuthenticated());
    } else {
      emit(AppUnauthenticated());
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<AppState> emit) async {
    emit(AppAuthenticated());
  }

  void _onLoggedOut(LoggedOut event, Emitter<AppState> emit) async {
    await session.clearSession();
    emit(AppUnauthenticated());
  }
}
