import 'package:e_commerce_app/core/errors/error_mapper.dart';
import 'package:e_commerce_app/core/services/session_services.dart';
import 'package:e_commerce_app/data/repositories/auth_repository.dart';
import 'package:e_commerce_app/presentation/blocs/app/app_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/app/app_event.dart';
import 'package:e_commerce_app/presentation/blocs/auth/auth_event.dart';
import 'package:e_commerce_app/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final SessionServices session;
  final AppBloc appBloc;

  AuthBloc(this.repository,this.session,this.appBloc) : super(AuthInitial()) {
    on<LoginRequested>(_onLogin);
  }


  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit)async{
    emit(AuthLoading());
    try{
      final user= await repository.login(username: event.username, password: event.password);
      await session.saveSession(user);
      appBloc.add(LoggedIn());
      emit(AuthSuccess(user));
    }catch(e){
      emit(AuthFailure(ErrorMapper.map(e)));
    }
  }

  // Helper method to map exceptions to user-friendly messages
 /* String _mapErrorToMessage(Object e) {
    if (e is ServerException) return e.message;
    return "Something went wrong";
  }*/
}

    /*
    UI
    ↓
    Bloc (AuthBloc)
    ↓
    Repository (AuthRepository)
    ↓
    DataSource (AuthRemoteDataSource)
    ↓
    ApiClient
    ↓
    Dio
    ↓
    Internet*/

    /*
    1. ApiClient
    wraps Dio
    handles requests
    handles errors

    2. AuthRemoteDataSource
    makes actual API call
    converts response → model

    3. AuthRepository
    decides data source
    can combine:
    remote
    local (cache later)

    4. AuthBloc
    business logic
    handles events
    emits states

    5. UI
    listens to state
    shows loading / error / success
    */