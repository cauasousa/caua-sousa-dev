class BrandLogoState {
  const BrandLogoState({
    this.isCsHovered = false,
    this.isNameHovered = false,
    this.isPressed = false,
  });

  final bool isCsHovered;
  final bool isNameHovered;
  final bool isPressed;

  BrandLogoState copyWith({
    bool? isCsHovered,
    bool? isNameHovered,
    bool? isPressed,
  }) {
    return BrandLogoState(
      isCsHovered: isCsHovered ?? this.isCsHovered,
      isNameHovered: isNameHovered ?? this.isNameHovered,
      isPressed: isPressed ?? this.isPressed,
    );
  }
}
