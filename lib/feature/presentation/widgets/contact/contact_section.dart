import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_portfolio/feature/presentation/bloc/contact/contact_cubit.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/contact/contact_state.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/social_links/social_links_cubit.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  late final ContactCubit _contactCubit;
  late final SocialLinksCubit _socialLinksCubit;

  @override
  void initState() {
    super.initState();
    _contactCubit = ContactCubit();
    _socialLinksCubit = SocialLinksCubit();
  }

  @override
  void dispose() {
    _contactCubit.close();
    _socialLinksCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContactCubit>.value(value: _contactCubit),
        BlocProvider<SocialLinksCubit>.value(value: _socialLinksCubit),
      ],
      child: BlocBuilder<ContactCubit, ContactState>(
        builder: (context, state) {
          final screenWidth = MediaQuery.sizeOf(context).width;
          final horizontalPadding = screenWidth > 1200
              ? 112.0
              : screenWidth > 768
                  ? 56.0
                  : 24.0;
          final titleFontSize = screenWidth > 1200
              ? 48.0
              : screenWidth > 768
                  ? 42.0
                  : 34.0;
          final actionSize = screenWidth < 768 ? 56.0 : 64.0;

          return Container(
            width: double.infinity,
            color: const Color(0xFF0A0A0A), // Fundo unificado
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // CONTEÚDO PRINCIPAL (HEADER + ÍCONES)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 96,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'CONTACT',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.42),
                              fontSize: 12,
                              letterSpacing: 7,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Let's Work Together",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.1,
                            ),
                      ),
                      const SizedBox(height: 20),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Text(
                          'Open for freelance projects and collaborations.',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFF94A3B8),
                                    height: 1.6,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 56),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 24,
                        runSpacing: 24,
                        children: [
                          _ContactActionIcon(
                            icon: const Icon(Icons.email_outlined),
                            hoverColor: const Color(0xFFE6B9F2),
                            isHovered: state.hoveredActionIndex == 0,
                            size: actionSize,
                            onHoverChanged: (hovered) {
                              if (hovered) {
                                context
                                    .read<ContactCubit>()
                                    .setHoveredActionIndex(0);
                              } else {
                                context
                                    .read<ContactCubit>()
                                    .clearHoveredAction();
                              }
                            },
                            onTap: () => context
                                .read<SocialLinksCubit>()
                                .openLink('mailto:llkauall055@gmail.com'),
                          ),
                          _ContactActionIcon(
                            icon: const FaIcon(FontAwesomeIcons.linkedin),
                            hoverColor: const Color(0xFF0A66C2),
                            isHovered: state.hoveredActionIndex == 1,
                            size: actionSize,
                            onHoverChanged: (hovered) {
                              if (hovered) {
                                context
                                    .read<ContactCubit>()
                                    .setHoveredActionIndex(1);
                              } else {
                                context
                                    .read<ContactCubit>()
                                    .clearHoveredAction();
                              }
                            },
                            onTap: () => context.read<SocialLinksCubit>().openLink(
                                'https://www.linkedin.com/in/cau%C3%A3-de-sousa-lima-9734a7259/'),
                          ),
                          _ContactActionIcon(
                            icon: const Icon(Icons.file_download_outlined),
                            hoverColor: const Color(0xFF4CAF50),
                            isHovered: state.hoveredActionIndex == 2,
                            size: actionSize,
                            onHoverChanged: (hovered) {
                              if (hovered) {
                                context
                                    .read<ContactCubit>()
                                    .setHoveredActionIndex(2);
                              } else {
                                context
                                    .read<ContactCubit>()
                                    .clearHoveredAction();
                              }
                            },
                            onTap: () => context
                                .read<SocialLinksCubit>()
                                .openLink(
                                    'assets/lib/assets/pdf/caua-sl-resume.pdf'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // JAGGED DIVIDER
                const SizedBox(
                  width: double.infinity,
                  height: 68,
                  child: CustomPaint(
                    painter: _JaggedDividerPainter(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ContactActionIcon extends StatelessWidget {
  const _ContactActionIcon({
    required this.icon,
    required this.hoverColor,
    required this.isHovered,
    required this.size,
    required this.onHoverChanged,
    required this.onTap,
  });

  final Widget icon;
  final Color hoverColor;
  final bool isHovered;
  final double size;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = hoverColor;
    // if the accent is bright, use black icon for contrast (e.g. #E6B9F2), else white
    final iconHoverColor =
        accent.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        scale: isHovered ? 1.10 : 1.0, // hover:scale-110
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), // rounded-2xl
            color: isHovered
                ? accent
                : const Color(0xFF171717).withValues(alpha: 0.3), // bg-card/30
            border: Border.all(
              color: isHovered
                  ? accent
                  : Colors.white.withValues(alpha: 0.1), // border-foreground/10
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: isHovered
                      ? iconHoverColor
                      : Colors.white
                          .withValues(alpha: 0.6), // text-foreground/60
                ),
                child: IconTheme(
                  data: IconThemeData(
                    color: isHovered
                        ? iconHoverColor
                        : Colors.white.withValues(alpha: 0.6),
                    size: size * 0.42, // w-6 h-6 in a 56px box is ~24px
                  ),
                  child: icon,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _JaggedDividerPainter extends CustomPainter {
  const _JaggedDividerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF171717) // var(--card)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 12.5)
      ..lineTo(114, 38)
      ..lineTo(253.5, 18)
      ..lineTo(400.5, 28.5)
      ..lineTo(433.5, 12.5)
      ..lineTo(657, 35)
      ..lineTo(886, 12.5)
      ..lineTo(1020.5, 35)
      ..lineTo(1207, 0)
      ..lineTo(1307.5, 28.5)
      ..lineTo(1440, 12.5)
      ..lineTo(1440, 68)
      ..lineTo(0, 68)
      ..close();

    final matrix = Matrix4.identity()
      ..scale(size.width / 1440.0, size.height / 68.0);
    canvas.drawPath(path.transform(matrix.storage), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
