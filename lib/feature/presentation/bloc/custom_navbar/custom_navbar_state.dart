import 'navbar_section.dart';

class CustomNavbarState {
  const CustomNavbarState({
    this.activeSection = NavbarSection.home,
    this.isMobileMenuOpen = false,
  });

  final NavbarSection activeSection;
  final bool isMobileMenuOpen;

  CustomNavbarState copyWith({
    NavbarSection? activeSection,
    bool? isMobileMenuOpen,
  }) {
    return CustomNavbarState(
      activeSection: activeSection ?? this.activeSection,
      isMobileMenuOpen: isMobileMenuOpen ?? this.isMobileMenuOpen,
    );
  }
}
