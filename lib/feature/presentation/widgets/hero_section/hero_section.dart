import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_portfolio/feature/presentation/bloc/hero_section/hero_section_cubit.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/hero_section/hero_section_state.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/social_links/social_links_cubit.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    required this.scrollProgressListenable,
    required this.onExplore,
  });

  final ValueListenable<double> scrollProgressListenable;
  final VoidCallback onExplore;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  late final HeroSectionCubit _heroCubit;
  late final SocialLinksCubit _socialLinksCubit;

  @override
  void initState() {
    super.initState();
    _heroCubit = HeroSectionCubit()..start();
    _socialLinksCubit = SocialLinksCubit();
  }

  @override
  void dispose() {
    _heroCubit.close();
    _socialLinksCubit.close();
    super.dispose();
  }

  String _formatRoleText(String value) {
    return value.replaceFirst('Full Stack Developer', 'Full Stack\nDeveloper');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth > 900;
    final contentMargin = isDesktop ? 100.0 : 16.0;
    final contentPadding = isDesktop ? 10.0 : 8.0;
    final greetingFontSize = isDesktop ? 68.0 : 42.0;
    final roleFontSize = isDesktop ? 64.0 : 44.0;
    final descriptionFontSize = isDesktop ? 20.0 : 18.0;

    return MultiBlocProvider(
      providers: [
        BlocProvider<HeroSectionCubit>.value(value: _heroCubit),
        BlocProvider<SocialLinksCubit>.value(value: _socialLinksCubit),
      ],
      child: BlocBuilder<HeroSectionCubit, HeroSectionState>(
        builder: (context, state) {
          final leftContent = ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Container(
              margin: EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, I am',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: greetingFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: roleFontSize * 2.35,
                    child: Stack(
                      children: [
                        Text(
                          _formatRoleText(state.fullText),
                          style: TextStyle(
                            fontSize: roleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.transparent,
                            height: 1.08,
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF34D399),
                              Color(0xFF22D3EE),
                              Color(0xFF60A5FA),
                            ],
                          ).createShader(Offset.zero & bounds.size),
                          child: Text(
                            '${_formatRoleText(state.currentText)}${state.showCursor ? '|' : ' '}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: roleFontSize,
                              fontWeight: FontWeight.bold,
                              height: 1.08,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "I am a Full Stack Developer and a Master's student in AI Engineering at ISEP, while also completing my Bachelor's in Computer Science at IFMA. I develop web and mobile applications using Flutter, integrated with Python (FastAPI) and Firebase backends, focusing on scalability and performance.",
                    style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: descriptionFontSize,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      _socialIcon(
                        context,
                        FontAwesomeIcons.github,
                        'https://github.com/cauasousa/',
                      ),
                      _socialIcon(
                        context,
                        FontAwesomeIcons.linkedin,
                        'https://www.linkedin.com/in/cau%C3%A3-de-sousa-lima-9734a7259/',
                      ),
                      _socialIcon(
                        context,
                        FontAwesomeIcons.whatsapp,
                        'https://wa.me/+351928417031',
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _actionButton(widget.onExplore),
                ],
              ),
            ),
          );

          return ValueListenableBuilder<double>(
            valueListenable: widget.scrollProgressListenable,
            builder: (context, scrollProgress, _) {
              final targetProgress = scrollProgress.clamp(0.0, 1.0);

              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 95),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: 0, end: targetProgress),
                builder: (context, animatedProgress, __) {
                  final transitionT =
                      ((animatedProgress - 0.02) / 0.88).clamp(0.0, 1.0);
                  final eased =
                      Curves.easeInOutCubicEmphasized.transform(transitionT);

                  final contentOpacity = (1 - (eased * 0.82)).clamp(0.0, 1.0);
                  final contentScale = 1 - (eased * 0.05);
                  final contentOffsetY =
                      -(eased * 40); // Reduzido de 72 para 40
                  final dividerOffsetY = contentOffsetY.clamp(-18.0, 0.0);
                  final contentBlur = eased * 1.5; // Reduzido de 2.2 para 1.5
                  final backgroundScale = 1 + (eased * 0.04);
                  final backgroundOffsetY =
                      -(eased * 20); // Reduzido de 34 para 20
                  return ClipRect(
                    child: RepaintBoundary(
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height *
                              (isDesktop ? 0.72 : 0.74),
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0A0A0A),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Transform.translate(
                                offset: Offset(0, backgroundOffsetY),
                                child: Transform.scale(
                                  scale: backgroundScale,
                                  child: DecoratedBox(
                                    decoration: const BoxDecoration(
                                      gradient: RadialGradient(
                                        center: Alignment(-0.15, -0.25),
                                        radius: 1.2,
                                        colors: [
                                          Color(0x0FFFFFFF),
                                          Color(0x06FFFFFF),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(0, contentOffsetY),
                              child: ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                  sigmaX: contentBlur,
                                  sigmaY: contentBlur,
                                ),
                                child: Transform.scale(
                                  scale: contentScale,
                                  alignment: Alignment.topCenter,
                                  child: Opacity(
                                    opacity: contentOpacity,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: contentMargin),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: contentPadding,
                                        vertical: isDesktop ? 72 : 56,
                                      ),
                                      child: Column(
                                        children: [
                                          if (isDesktop)
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: leftContent,
                                                  ),
                                                ),
                                                const SizedBox(width: 32),
                                                Expanded(
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: _buildAvatar(
                                                      isDesktop: true,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          else
                                            Wrap(
                                              alignment: WrapAlignment.center,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              spacing: 50,
                                              runSpacing: 40,
                                              children: [
                                                leftContent,
                                                _buildAvatar(isDesktop: false),
                                              ],
                                            ),
                                          const SizedBox(height: 16),
                                          Opacity(
                                            opacity: (1 - eased * 1.2)
                                                .clamp(0.0, 1.0),
                                            child: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Color(0xFF34D399),
                                              size: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Transform.translate(
                                offset: Offset(0, dividerOffsetY),
                                child: IgnorePointer(
                                  child: Container(
                                    height: 36,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.0),
                                          const Color(0xFF0A0A0A)
                                              .withValues(alpha: 0.92),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 6,
                              child: Transform.translate(
                                offset: Offset(0, dividerOffsetY),
                                child: const JaggedDivider(
                                  backgroundColor: Color(0xFF0A0A0A),
                                  height: 52,
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
        },
      ),
    );
  }

  Widget _socialIcon(BuildContext context, FaIconData icon, String url) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      child: IconButton(
        onPressed: () {
          context.read<SocialLinksCubit>().openLink(url);
        },
        icon: FaIcon(icon, color: const Color(0xFFCBD5E1), size: 28),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.05),
          padding: const EdgeInsets.all(12),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
    );
  }

  Widget _actionButton(VoidCallback onExplore) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
        ),
      ),
      child: ElevatedButton(
        onPressed: onExplore,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        ),
        child: const Text(
          'Explore my work',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildAvatar({required bool isDesktop}) {
    final blurSize = isDesktop ? 360.0 : 300.0;
    final ringSize = isDesktop ? 330.0 : 280.0;
    final initialsSize = isDesktop ? 74.0 : 70.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: blurSize,
          height: blurSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF34D399).withValues(alpha: 0.15),
          ),
        ),
        Container(
          width: ringSize,
          height: ringSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 2,
            ),
            gradient: const LinearGradient(
              colors: [Color(0xFF34D399), Color(0xFF3B82F6)],
            ),
          ),
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: initialsSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Full Stack Developer | AI',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class JaggedDividerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Proporções baseadas no viewBox="0 0 1440 68" do seu SVG
    double factorX = size.width / 1440;
    double factorY = size.height / 68;

    Path path = Path();
    path.moveTo(0 * factorX, 12.5 * factorY);
    path.lineTo(114 * factorX, 38 * factorY);
    path.lineTo(253.5 * factorX, 18 * factorY);
    path.lineTo(400.5 * factorX, 28.5 * factorY);
    path.lineTo(433.5 * factorX, 12.5 * factorY);
    path.lineTo(657 * factorX, 35 * factorY);
    path.lineTo(886 * factorX, 12.5 * factorY);
    path.lineTo(1020.5 * factorX, 35 * factorY);
    path.lineTo(1207 * factorX, 0 * factorY);
    path.lineTo(1307.5 * factorX, 28.5 * factorY);
    path.lineTo(1440 * factorX, 12.5 * factorY);

    // Fecha a forma por baixo para criar o preenchimento sólido
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class JaggedDivider extends StatelessWidget {
  const JaggedDivider({
    super.key,
    this.backgroundColor = const Color(0xFF0A0A0A),
    this.height = 68,
  });

  final Color backgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        children: [
          ClipPath(
            clipper: JaggedDividerClipper(),
            child: Container(
              width: double.infinity,
              height: height,
              decoration: BoxDecoration(
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _JaggedTopLinePainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JaggedTopLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    double factorX = size.width / 1440;
    double factorY = size.height / 68;

    path.moveTo(0 * factorX, 12.5 * factorY);
    path.lineTo(114 * factorX, 38 * factorY);
    path.lineTo(253.5 * factorX, 18 * factorY);
    path.lineTo(400.5 * factorX, 28.5 * factorY);
    path.lineTo(433.5 * factorX, 12.5 * factorY);
    path.lineTo(657 * factorX, 35 * factorY);
    path.lineTo(886 * factorX, 12.5 * factorY);
    path.lineTo(1020.5 * factorX, 35 * factorY);
    path.lineTo(1207 * factorX, 0 * factorY);
    path.lineTo(1307.5 * factorX, 28.5 * factorY);
    path.lineTo(1440 * factorX, 12.5 * factorY);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.14),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Offset.zero & size);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_JaggedTopLinePainter oldDelegate) => false;
}
