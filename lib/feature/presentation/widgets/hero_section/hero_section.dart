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
  });

  final ValueListenable<double> scrollProgressListenable;

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
    return value.replaceFirst('Desenvolvedor ', 'Desenvolvedor\n');
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, eu sou',
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
                  'Sou desenvolvedor Full Stack e mestrando em Engenharia de IA no ISEP, graduando em Ciência da Computação pelo IFMA. Desenvolvo aplicações web e mobile com Flutter, integradas a backends em Python (FastAPI) e Firebase, com foco em escalabilidade e performance.',
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
                _actionButton(),
              ],
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

                  final contentOpacity = (1 - (eased * 0.95)).clamp(0.0, 1.0);
                  final contentScale = 1 - (eased * 0.05);
                  final contentOffsetY = -(eased * 72);
                  final backgroundScale = 1 + (eased * 0.04);
                  final backgroundOffsetY = -(eased * 34);
                  return ClipRect(
                    child: RepaintBoundary(
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height,
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
                                      vertical: isDesktop ? 120 : 100,
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
                                        const SizedBox(height: 90),
                                        Opacity(
                                          opacity:
                                              (1 - eased * 1.2).clamp(0.0, 1.0),
                                          child: const Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Color(0xFF34D399),
                                            size: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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

  Widget _actionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
        ),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        ),
        child: const Text(
          'Conhecer meu trabalho',
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
