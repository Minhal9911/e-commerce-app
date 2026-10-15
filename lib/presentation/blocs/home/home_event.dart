
import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable{
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class HomeTabChanged extends HomeEvent{
  final int index;
  const HomeTabChanged(this.index);

  @override
  List<Object?> get props => [index];
}