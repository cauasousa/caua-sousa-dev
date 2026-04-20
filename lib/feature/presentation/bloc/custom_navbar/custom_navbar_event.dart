import 'navbar_section.dart';

abstract class CustomNavbarEvent {
  const CustomNavbarEvent();
}

class NavbarSectionChanged extends CustomNavbarEvent {
  const NavbarSectionChanged(this.section);

  final NavbarSection section;
}

class NavbarMenuToggled extends CustomNavbarEvent {
  const NavbarMenuToggled();
}

class NavbarMenuClosed extends CustomNavbarEvent {
  const NavbarMenuClosed();
}
