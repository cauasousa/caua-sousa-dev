abstract class CustomButtonEvent {
  const CustomButtonEvent();
}

class CustomButtonHoverChanged extends CustomButtonEvent {
  const CustomButtonHoverChanged(this.isHovered);

  final bool isHovered;
}

class CustomButtonPressed extends CustomButtonEvent {
  const CustomButtonPressed();
}
