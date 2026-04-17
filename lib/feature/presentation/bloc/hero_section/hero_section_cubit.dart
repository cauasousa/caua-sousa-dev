import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'hero_section_state.dart';

class HeroSectionCubit extends Cubit<HeroSectionState> {
  HeroSectionCubit({
    String fullText = 'Desenvolvedor Full Stack',
    Duration typingInterval = const Duration(milliseconds: 100),
    Duration cursorInterval = const Duration(milliseconds: 500),
  })  : _typingInterval = typingInterval,
        _cursorInterval = cursorInterval,
        super(HeroSectionState(fullText: fullText));

  final Duration _typingInterval;
  final Duration _cursorInterval;

  Timer? _typingTimer;
  Timer? _cursorTimer;
  bool _started = false;

  void start() {
    if (_started) {
      return;
    }
    _started = true;

    _cursorTimer = Timer.periodic(_cursorInterval, (_) {
      emit(state.copyWith(showCursor: !state.showCursor));
    });

    _typingTimer = Timer.periodic(_typingInterval, (timer) {
      if (state.isTypingComplete) {
        timer.cancel();
        return;
      }

      final nextIndex = state.currentIndex + 1;
      emit(
        state.copyWith(
          currentIndex: nextIndex,
          currentText: state.fullText.substring(0, nextIndex),
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _typingTimer?.cancel();
    _cursorTimer?.cancel();
    return super.close();
  }
}
