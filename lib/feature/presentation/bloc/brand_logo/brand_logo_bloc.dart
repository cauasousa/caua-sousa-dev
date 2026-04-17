import 'package:flutter_bloc/flutter_bloc.dart';

import 'brand_logo_event.dart';
import 'brand_logo_state.dart';

class BrandLogoBloc extends Cubit<BrandLogoState> {
  BrandLogoBloc() : super(const BrandLogoState());

  Future<void> onEvent(BrandLogoEvent event) async {
    if (event is BrandLogoCsHoverChanged) {
      emit(state.copyWith(isCsHovered: event.isHovered));
      return;
    }

    if (event is BrandLogoNameHoverChanged) {
      emit(state.copyWith(isNameHovered: event.isHovered));
      return;
    }

    if (event is BrandLogoTapped) {
      emit(state.copyWith(isPressed: true));
      await Future<void>.delayed(const Duration(milliseconds: 120));
      emit(state.copyWith(isPressed: false));
    }
  }
}
