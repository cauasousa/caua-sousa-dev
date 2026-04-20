import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/custom_navbar_bloc.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/custom_navbar_event.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/custom_navbar_state.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/navbar_section.dart';
import 'package:flutter_portfolio/feature/presentation/widgets/navbar/band_logo.dart';
import 'package:flutter_portfolio/feature/presentation/widgets/custom_button.dart';

class CustomNavbar extends StatelessWidget {
  const CustomNavbar({
    super.key,
    this.onSectionTap,
  });

  final ValueChanged<NavbarSection>? onSectionTap;
  static const double _desktopAndMobileBarHeight = 78.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final navBgColor = colorScheme.surface;
    final textColor = colorScheme.onSurface;
    final isMobile = MediaQuery.of(context).size.width < 1020;

    return BlocBuilder<CustomNavbarBloc, CustomNavbarState>(
      builder: (context, state) {
        if (!isMobile && state.isMobileMenuOpen) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context
                  .read<CustomNavbarBloc>()
                  .onEvent(const NavbarMenuClosed());
            }
          });
        }

        final targetDropdownHeight = state.isMobileMenuOpen ? 360.0 : 0.0;
        const bottomBorderWidth = 1.0;

        return LayoutBuilder(
          builder: (context, constraints) {
            final maxHeight = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : (_desktopAndMobileBarHeight + targetDropdownHeight);
            final usableHeight =
                (maxHeight - bottomBorderWidth).clamp(0.0, 5000.0);
            final topBarHeight = usableHeight < _desktopAndMobileBarHeight
                ? usableHeight
                : _desktopAndMobileBarHeight;
            final maxDropdownHeight =
                (usableHeight - topBarHeight).clamp(0.0, 1000.0);
            final dropdownHeight =
                targetDropdownHeight.clamp(0.0, maxDropdownHeight);

            return ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: navBgColor.withValues(alpha: 0.90),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withValues(alpha: 0.05),
                        width: bottomBorderWidth,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: topBarHeight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: EdgeInsets.symmetric(
                            horizontal: isMobile ? 16 : 100,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const BrandLogo(),
                              if (!isMobile)
                                Expanded(
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _navItem(
                                            'Início',
                                            textColor,
                                            isActive: state.activeSection ==
                                                NavbarSection.inicio,
                                            onTap: () => _onNavTap(
                                                context, NavbarSection.inicio),
                                          ),
                                          _navItem(
                                            'Sobre',
                                            textColor,
                                            isActive: state.activeSection ==
                                                NavbarSection.sobre,
                                            onTap: () => _onNavTap(
                                                context, NavbarSection.sobre),
                                          ),
                                          _navItem(
                                            'Habilidades',
                                            textColor,
                                            isActive: state.activeSection ==
                                                NavbarSection.habilidades,
                                            onTap: () => _onNavTap(
                                              context,
                                              NavbarSection.habilidades,
                                            ),
                                          ),
                                          _navItem(
                                            'Projetos',
                                            textColor,
                                            isActive: state.activeSection ==
                                                NavbarSection.projetos,
                                            onTap: () => _onNavTap(context,
                                                NavbarSection.projetos),
                                          ),
                                          _navItem(
                                            'Contato',
                                            textColor,
                                            isActive: state.activeSection ==
                                                NavbarSection.contato,
                                            onTap: () => _onNavTap(
                                                context, NavbarSection.contato),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              if (!isMobile)
                                const CustomButton(
                                  height: 40,
                                  width: 180,
                                )
                              else
                                IconButton(
                                  icon: _AnimatedMenuGlyph(
                                    isOpen: state.isMobileMenuOpen,
                                    color: textColor,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<CustomNavbarBloc>()
                                        .onEvent(const NavbarMenuToggled());
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (isMobile)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                          height: dropdownHeight,
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: navBgColor.withValues(alpha: 0.95),
                            border: Border(
                              top: BorderSide(
                                color: Colors.white.withValues(alpha: 0.08),
                                width: state.isMobileMenuOpen ? 1 : 0,
                              ),
                            ),
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _mobileMenuItem(
                                  context,
                                  title: 'Início',
                                  section: NavbarSection.inicio,
                                  isActive: state.activeSection ==
                                      NavbarSection.inicio,
                                ),
                                _mobileMenuItem(
                                  context,
                                  title: 'Sobre',
                                  section: NavbarSection.sobre,
                                  isActive: state.activeSection ==
                                      NavbarSection.sobre,
                                ),
                                _mobileMenuItem(
                                  context,
                                  title: 'Habilidades',
                                  section: NavbarSection.habilidades,
                                  isActive: state.activeSection ==
                                      NavbarSection.habilidades,
                                ),
                                _mobileMenuItem(
                                  context,
                                  title: 'Projetos',
                                  section: NavbarSection.projetos,
                                  isActive: state.activeSection ==
                                      NavbarSection.projetos,
                                ),
                                _mobileMenuItem(
                                  context,
                                  title: 'Contato',
                                  section: NavbarSection.contato,
                                  isActive: state.activeSection ==
                                      NavbarSection.contato,
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomButton(
                                    height: 44,
                                    width: double.infinity,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _onNavTap(BuildContext context, NavbarSection section) {
    context.read<CustomNavbarBloc>().onEvent(NavbarSectionChanged(section));
    onSectionTap?.call(section);
  }

  Widget _navItem(
    String title,
    Color textColor, {
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return _NavItem(
      title: title,
      textColor: textColor,
      isActive: isActive,
      onTap: onTap,
    );
  }

  Widget _mobileMenuItem(
    BuildContext context, {
    required String title,
    required NavbarSection section,
    required bool isActive,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _onNavTap(context, section),
        child: Container(
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF10B981).withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive
                  ? const Color(0xFF10B981).withValues(alpha: 0.25)
                  : Colors.white.withValues(alpha: 0.05),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? const Color(0xFF34D399) : Colors.white70,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              fontFamily: 'ExoRegular',
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedMenuGlyph extends StatelessWidget {
  const _AnimatedMenuGlyph({
    required this.isOpen,
    required this.color,
  });

  final bool isOpen;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: isOpen ? 1 : 0),
      builder: (context, t, _) {
        final middleOpacity = 1 - t;
        final lineWidth = lerpDouble(18, 13, t)!;

        return SizedBox(
          width: 24,
          height: 24,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: middleOpacity,
                child: _glyphLine(
                  width: lineWidth,
                  color: color,
                ),
              ),
              Opacity(
                opacity: t,
                child: Transform.translate(
                  offset:
                      Offset(lerpDouble(0, -1.5, t)!, lerpDouble(0, -3.8, t)!),
                  child: Transform.rotate(
                    angle: lerpDouble(0, -0.72, t)!,
                    child: _glyphLine(width: 14, color: color),
                  ),
                ),
              ),
              Opacity(
                opacity: t,
                child: Transform.translate(
                  offset:
                      Offset(lerpDouble(0, -1.5, t)!, lerpDouble(0, 3.8, t)!),
                  child: Transform.rotate(
                    angle: lerpDouble(0, 0.72, t)!,
                    child: _glyphLine(width: 14, color: color),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _glyphLine({
    required double width,
    required Color color,
  }) {
    return Container(
      width: width,
      height: 2.2,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.title,
    required this.textColor,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final Color textColor;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = widget.isActive || _isHovered;
    final textStyle = TextStyle(
      fontFamily: 'ExoRegular',
      fontSize: 15,
      fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
      letterSpacing: widget.isActive ? 0.2 : 0,
    );
    final fixedTextStyle = textStyle.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    );
    final fixedIndicatorWidth =
        _measureTextWidth(context, widget.title, fixedTextStyle) + 14;
    final indicatorWidth = isHighlighted ? fixedIndicatorWidth : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          onTap: widget.onTap,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: SizedBox(
            width: fixedIndicatorWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  style: textStyle.copyWith(
                    color: widget.isActive
                        ? widget.textColor
                        : widget.textColor
                            .withValues(alpha: _isHovered ? 0.9 : 0.7),
                  ),
                  child: Text(widget.title),
                ),
                const SizedBox(height: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  height: widget.isActive ? 3 : 2.6,
                  width: indicatorWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF10B981),
                        Color(0xFF06B6D4),
                      ],
                    ),
                    boxShadow: [
                      if (isHighlighted)
                        BoxShadow(
                          color: const Color(0xFF10B981).withValues(
                            alpha: widget.isActive ? 0.42 : 0.24,
                          ),
                          blurRadius: widget.isActive ? 7 : 4,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _measureTextWidth(
    BuildContext context,
    String text,
    TextStyle style,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      maxLines: 1,
    )..layout();
    return painter.width;
  }
}
