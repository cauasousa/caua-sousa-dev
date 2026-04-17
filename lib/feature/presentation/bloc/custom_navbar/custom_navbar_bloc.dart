import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_navbar_event.dart';
import 'custom_navbar_state.dart';

class CustomNavbarBloc extends Cubit<CustomNavbarState> {
  CustomNavbarBloc() : super(const CustomNavbarState());

  void onEvent(CustomNavbarEvent event) {
    if (event is NavbarSectionChanged) {
      if (state.activeSection == event.section) {
        return;
      }
      emit(state.copyWith(activeSection: event.section));
    }
  }
}
