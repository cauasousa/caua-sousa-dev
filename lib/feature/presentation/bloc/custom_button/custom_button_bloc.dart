import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_button_event.dart';
import 'custom_button_state.dart';

class CustomButtonBloc extends Cubit<CustomButtonState> {
  CustomButtonBloc() : super(const CustomButtonState());

  Future<void> onEvent(CustomButtonEvent event) async {
    if (event is CustomButtonHoverChanged) {
      emit(state.copyWith(isHovered: event.isHovered));
      return;
    }

    if (event is CustomButtonPressed) {
      emit(state.copyWith(isLoading: true));
      emit(state.copyWith(isLoading: false));
    }
  }
}
