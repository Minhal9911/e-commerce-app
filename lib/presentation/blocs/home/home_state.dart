
import 'package:equatable/equatable.dart';

sealed class HomeState extends Equatable{
  final int currentIndex;
  const HomeState(this.currentIndex);

  @override
  List<Object?> get props => [currentIndex];
}

final class HomeTabState extends HomeState{
  const HomeTabState(super.currentIndex);
  // const HomeTabState():super(0);
}