import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/about/about_cubit.dart';
import '../../bloc/about/about_state.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({
    super.key,
    required this.scrollProgressListenable,
  });

  final ValueListenable<double> scrollProgressListenable;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0A0A0A),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding =
              (constraints.maxWidth * 0.05).clamp(20.0, 90.0);

          return ValueListenableBuilder<double>(
            valueListenable: scrollProgressListenable,
            builder: (context, progress, _) {
              final t = Curves.easeOutCubic.transform(progress.clamp(0.0, 1.0));

              return Transform.translate(
                offset: Offset(0, (1 - t) * 26),
                child: Opacity(
                  opacity: t,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      96,
                      horizontalPadding,
                      56,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1560),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'ABOUT',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.42),
                                  fontSize: 12,
                                  letterSpacing: 7,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Full Stack Developer | AI',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.1,
                                ),
                          ),
                          const SizedBox(height: 20),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 780),
                            child: Text(
                              'Building scalable digital products, intelligent vision systems, and user-centered interfaces with precision and performance.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: const Color(0xFF94A3B8),
                                    height: 1.6,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 54),
                          BlocBuilder<AboutCubit, AboutState>(
                            builder: (context, state) {
                              return LayoutBuilder(
                                builder: (context, gridConstraints) {
                                  final isDesktop =
                                      gridConstraints.maxWidth >= 960;
                                  final crossAxisCount = isDesktop ? 3 : 1;
                                  const spacing = 24.0;
                                  final totalSpacing =
                                      spacing * (crossAxisCount - 1);
                                  final cardWidth =
                                      (gridConstraints.maxWidth - totalSpacing) /
                                          crossAxisCount;

                                  return Wrap(
                                    spacing: spacing,
                                    runSpacing: spacing,
                                    children: [
                                      for (int index = 0;
                                          index < state.capabilities.length;
                                          index++)
                                        SizedBox(
                                          width: cardWidth,
                                          child: _CapabilityCard(
                                            capability:
                                                state.capabilities[index],
                                            isHovered:
                                                state.hoveredCardIndex ==
                                                    index,
                                            onHoverChanged: (hovered) {
                                              context
                                                  .read<AboutCubit>()
                                                  .setCardHovered(index,
                                                      hovered);
                                            },
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CapabilityCard extends StatelessWidget {
  const _CapabilityCard({
    required this.capability,
    required this.isHovered,
    required this.onHoverChanged,
  });

  final Capability capability;
  final bool isHovered;
  final Function(bool) onHoverChanged;

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFF10B981);

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        scale: isHovered ? 1.020 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minHeight: 320),
          padding: const EdgeInsets.all(36),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white.withValues(alpha: 0.03),
            border: Border.all(
              color: isHovered
                  ? accent.withValues(alpha: 0.60)
                  : Colors.white.withValues(alpha: 0.08),
              width: isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              if (isHovered)
                BoxShadow(
                  color: accent.withValues(alpha: 0.05),
                  blurRadius: 28,
                  spreadRadius: 2,
                  offset: const Offset(0, 12),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white.withValues(alpha: 0.05),
                  border: Border.all(
                    color: isHovered
                        ? accent.withValues(alpha: 0.45)
                        : Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Icon(
                  capability.icon,
                  size: 30,
                  color: isHovered
                      ? accent.withValues(alpha: 0.98)
                      : Colors.white.withValues(alpha: 0.62),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                capability.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 24),
              for (final entry in capability.lines.asMap().entries) ...[
                _CapabilityLineView(line: entry.value),
                if (entry.key != capability.lines.length - 1) ...[
                  const SizedBox(height: 14),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  const SizedBox(height: 14),
                ] else
                  const SizedBox(height: 4),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CapabilityLineView extends StatelessWidget {
  const _CapabilityLineView({required this.line});

  final CapabilityLine line;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          line.value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF94A3B8),
                fontSize: 14,
                height: 1.45,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (line.badges.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final badge in line.badges)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: line.badgeColor.withValues(alpha: 0.30),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: line.badgeColor.withValues(alpha: 0.52),
                    ),
                  ),
                  child: Text(
                    badge,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: line.badgeColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
