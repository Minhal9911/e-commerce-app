import 'package:e_commerce_app/data/repositories/theme_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository repo;

  ThemeBloc(this.repo) : super(ThemeState(themeMode: ThemeMode.light)) {
    on<LoadTheme>(_loadTheme);
    on<ToggleTheme>(_toggleTheme);
  }

  Future<void> _loadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final isDark = repo.getTheme();

    emit(ThemeState(themeMode: isDark ? ThemeMode.dark : ThemeMode.light));
    //isDark = true means dark mode should show
  }

  ///Toggle between light and dark themes and save the preference---------------
  Future<void> _toggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    //true =dark mood
    //false = light mode
    final isDark = state.themeMode == ThemeMode.dark;
    final newTheme = isDark ? ThemeMode.light : ThemeMode.dark;
    // await repo.saveTheme(newTheme == ThemeMode.dark); or
    await repo.saveTheme(!isDark);
    emit(state.copyWith(themeMode: newTheme));
  }
}
