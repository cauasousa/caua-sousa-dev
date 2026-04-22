import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/navbar_section.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/social_links/social_links_cubit.dart';

class Footer extends StatefulWidget {
  const Footer({super.key, required this.onNavigate});

  final ValueChanged<NavbarSection> onNavigate;

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  late final SocialLinksCubit _socialLinksCubit;

  @override
  void initState() {
    super.initState();
    _socialLinksCubit = SocialLinksCubit();
  }

  @override
  void dispose() {
    _socialLinksCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth > 1200
        ? 112.0
        : screenWidth > 768
            ? 56.0
            : 24.0;

    return BlocProvider<SocialLinksCubit>.value(
      value: _socialLinksCubit,
      child: Container(
        width: double.infinity,
        color: const Color(0xFF171717), // Cor consistente
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          48,
          horizontalPadding,
          40,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 800;
                    return isCompact
                        ? Column(
                            children: [
                              _FooterLogo(onNavigate: widget.onNavigate),
                              const SizedBox(height: 24),
                              _FooterLinks(onNavigate: widget.onNavigate),
                              const SizedBox(height: 24),
                              const _FooterSocials(),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _FooterLogo(onNavigate: widget.onNavigate),
                              _FooterLinks(onNavigate: widget.onNavigate),
                              const _FooterSocials(),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 4),
                const Divider(color: Colors.white10),
                const SizedBox(height: 4),
                Text(
                  '© 2026 · Cauã Sousa · Full Stack & AI Developer',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.25),
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterLogo extends StatefulWidget {
  const _FooterLogo({required this.onNavigate});

  final ValueChanged<NavbarSection> onNavigate;

  @override
  State<_FooterLogo> createState() => _FooterLogoState();
}

class _FooterLogoState extends State<_FooterLogo> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => widget.onNavigate(NavbarSection.home),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          width: 44,
          height: 44,
          alignment: Alignment.center,
          transform: Matrix4.identity()..scale(_isHovered ? 1.08 : 1.0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.55),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
          ),
          child: const Text(
            'CS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks({required this.onNavigate});

  final ValueChanged<NavbarSection> onNavigate;

  @override
  Widget build(BuildContext context) {
    final items = <(String, NavbarSection)>[
      ('HOME', NavbarSection.home),
      ('PROJECTS', NavbarSection.project),
      ('ABOUT', NavbarSection.about),
      ('CONTACT', NavbarSection.contact),
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 24, // gap-6
      runSpacing: 16,
      children: items
          .map((e) => _FooterLink(label: e.$1, onTap: () => onNavigate(e.$2)))
          .toList(),
    );
  }
}

class _FooterLink extends StatefulWidget {
  const _FooterLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            color: _isHovered
                ? const Color(0xFF10B981).withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.4),
            fontSize: 10,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _FooterSocials extends StatelessWidget {
  const _FooterSocials();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _FooterIcon(
            const Icon(Icons.email_outlined), 'mailto:llkauall055@gmail.com'),
        const SizedBox(width: 12),
        _FooterIcon(const FaIcon(FontAwesomeIcons.linkedin),
            'https://www.linkedin.com/in/cau%C3%A3-de-sousa-lima-9734a7259/'),
        const SizedBox(width: 12),
        _FooterIcon(const Icon(Icons.file_download_outlined),
            'assets/lib/assets/pdf/caua-sl-resume.pdf'),
      ],
    );
  }
}

class _FooterIcon extends StatefulWidget {
  final Widget icon;
  final String url;
  const _FooterIcon(this.icon, this.url);

  @override
  State<_FooterIcon> createState() => _FooterIconState();
}

class _FooterIconState extends State<_FooterIcon> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => context.read<SocialLinksCubit>().openLink(widget.url),
        child: IconTheme(
          data: IconThemeData(
            color: _hover
                ? const Color(0xFF10B981).withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.4),
            size: 16,
          ),
          child: widget.icon,
        ),
      ),
    );
  }
}
