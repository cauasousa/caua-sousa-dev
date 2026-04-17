class HeroSectionState {
  const HeroSectionState({
    required this.fullText,
    this.currentText = '',
    this.currentIndex = 0,
    this.showCursor = true,
  });

  final String fullText;
  final String currentText;
  final int currentIndex;
  final bool showCursor;

  bool get isTypingComplete => currentIndex >= fullText.length;

  HeroSectionState copyWith({
    String? fullText,
    String? currentText,
    int? currentIndex,
    bool? showCursor,
  }) {
    return HeroSectionState(
      fullText: fullText ?? this.fullText,
      currentText: currentText ?? this.currentText,
      currentIndex: currentIndex ?? this.currentIndex,
      showCursor: showCursor ?? this.showCursor,
    );
  }
}
