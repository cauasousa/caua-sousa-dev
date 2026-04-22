import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/custom_navbar_bloc.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/custom_navbar_event.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/custom_navbar_state.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/navbar_section.dart';
import 'package:flutter_portfolio/feature/presentation/widgets/navbar/band_logo.dart';
import 'package:flutter_portfolio/feature/presentation/widgets/custom_button.dart';

class CustomNavbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomNavbar({
    super.key,
    this.onSectionTap,
  });

  final ValueChanged<NavbarSection>? onSectionTap;

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final navBgColor = colorScheme.surface; // Pegará o #020617
    final textColor = colorScheme.onSurface;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 80,
          width: 20,
          decoration: BoxDecoration(
            // Aqui garantimos o fundo escuro do seu pedido
            color: navBgColor.withValues(alpha: 0.90),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.symmetric(horizontal: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- LOGO ---
                BrandLogo(),
                if (MediaQuery.of(context).size.width > 900)
                  Expanded(
                    child: Center(
                      child: BlocBuilder<CustomNavbarBloc, CustomNavbarState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _navItem(
                                "Home",
                                textColor,
                                isActive:
                                    state.activeSection == NavbarSection.home,
                                onTap: () => _onNavTap(
                                  context,
                                  NavbarSection.home,
                                ),
                              ),
                              _navItem(
                                "Project",
                                textColor,
                                isActive: state.activeSection ==
                                    NavbarSection.project,
                                onTap: () => _onNavTap(
                                  context,
                                  NavbarSection.project,
                                ),
                              ),
                              _navItem(
                                "About",
                                textColor,
                                isActive:
                                    state.activeSection == NavbarSection.about,
                                onTap: () => _onNavTap(
                                  context,
                                  NavbarSection.about,
                                ),
                              ),
                              _navItem(
                                "Contact",
                                textColor,
                                isActive: state.activeSection ==
                                    NavbarSection.contact,
                                onTap: () => _onNavTap(
                                  context,
                                  NavbarSection.contact,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                // --- LINKS DESKTOP ---
                if (MediaQuery.of(context).size.width > 900)
                  CustomButton(
                    height: 40,
                    width: 180,
                  )
                else
                  // --- MENU MOBILE ---
                  IconButton(
                    icon: Icon(Icons.menu, color: textColor),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
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
