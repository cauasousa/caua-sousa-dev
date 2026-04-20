class SocialLinksState {
  final bool isLoading;
  final String? error;

  SocialLinksState({
    this.isLoading = false,
    this.error,
  });

  SocialLinksState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return SocialLinksState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
