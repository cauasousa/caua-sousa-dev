abstract class BrandLogoEvent {
  const BrandLogoEvent();
}

class BrandLogoCsHoverChanged extends BrandLogoEvent {
  const BrandLogoCsHoverChanged(this.isHovered);

  final bool isHovered;
}

class BrandLogoNameHoverChanged extends BrandLogoEvent {
  const BrandLogoNameHoverChanged(this.isHovered);

  final bool isHovered;
}

class BrandLogoTapped extends BrandLogoEvent {
  const BrandLogoTapped();
}
