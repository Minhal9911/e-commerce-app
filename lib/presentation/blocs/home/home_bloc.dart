import 'package:e_commerce_app/presentation/blocs/home/home_event.dart';
import 'package:e_commerce_app/presentation/blocs/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeTabState(0)) {
    on<HomeTabChanged>(_onTabChanged);
  }

  void _onTabChanged(HomeTabChanged event, Emitter<HomeState> emit) {
    emit(HomeTabState(event.index));
  }
}
