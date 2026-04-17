import 'navbar_section.dart';

abstract class CustomNavbarEvent {
  const CustomNavbarEvent();
}

class NavbarSectionChanged extends CustomNavbarEvent {
  const NavbarSectionChanged(this.section);

  final NavbarSection section;
}
