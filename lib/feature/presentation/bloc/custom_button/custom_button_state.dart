class CustomButtonState {
  const CustomButtonState({
    this.isHovered = false,
    this.isLoading = false,
  });

  final bool isHovered;
  final bool isLoading;

  CustomButtonState copyWith({
    bool? isHovered,
    bool? isLoading,
  }) {
    return CustomButtonState(
      isHovered: isHovered ?? this.isHovered,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
