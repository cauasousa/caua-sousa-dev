import 'navbar_section.dart';

class CustomNavbarState {
  const CustomNavbarState({
    this.activeSection = NavbarSection.inicio,
  });

  final NavbarSection activeSection;

  CustomNavbarState copyWith({
    NavbarSection? activeSection,
  }) {
    return CustomNavbarState(
      activeSection: activeSection ?? this.activeSection,
    );
  }
}
