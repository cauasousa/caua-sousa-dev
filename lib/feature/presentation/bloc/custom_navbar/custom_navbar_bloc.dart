import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_navbar_event.dart';
import 'custom_navbar_state.dart';

class CustomNavbarBloc extends Cubit<CustomNavbarState> {
  CustomNavbarBloc() : super(const CustomNavbarState());

  void onEvent(CustomNavbarEvent event) {
    if (event is NavbarSectionChanged) {
      if (state.activeSection == event.section && !state.isMobileMenuOpen) {
        return;
      }
      emit(
        state.copyWith(
          activeSection: event.section,
          isMobileMenuOpen: false,
        ),
      );
      return;
    }

    if (event is NavbarMenuToggled) {
      emit(state.copyWith(isMobileMenuOpen: !state.isMobileMenuOpen));
      return;
    }

    if (event is NavbarMenuClosed) {
      if (!state.isMobileMenuOpen) {
        return;
      }
      emit(state.copyWith(isMobileMenuOpen: false));
    }
  }
}
