import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_portfolio/feature/presentation/bloc/brand_logo/brand_logo_bloc.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/brand_logo/brand_logo_event.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/brand_logo/brand_logo_state.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BrandLogoBloc(),
      child: BlocBuilder<BrandLogoBloc, BrandLogoState>(
        builder: (context, state) {
          final isCsInteractive = state.isCsHovered || state.isPressed;
          final isNameInteractive = state.isNameHovered || state.isPressed;

          return InkWell(
            onTap: () {
              context.read<BrandLogoBloc>().onEvent(const BrandLogoTapped());
              onTap?.call();
            },
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => context
                      .read<BrandLogoBloc>()
                      .onEvent(const BrandLogoCsHoverChanged(true)),
                  onExit: (_) => context
                      .read<BrandLogoBloc>()
                      .onEvent(const BrandLogoCsHoverChanged(false)),
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    scale:
                        state.isPressed ? 0.96 : (state.isCsHovered ? 1.03 : 1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withValues(
                              alpha: isCsInteractive ? 0.45 : 0.3,
                            ),
                            blurRadius: isCsInteractive ? 22 : 15,
                            offset: Offset(0, isCsInteractive ? 6 : 4),
                          ),
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF34D399),
                            Color(0xFF06B6D4),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'CS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => context
                      .read<BrandLogoBloc>()
                      .onEvent(const BrandLogoNameHoverChanged(true)),
                  onExit: (_) => context
                      .read<BrandLogoBloc>()
                      .onEvent(const BrandLogoNameHoverChanged(false)),
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    offset: state.isNameHovered
                        ? const Offset(0.02, 0)
                        : Offset.zero,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      scale: state.isPressed
                          ? 0.99
                          : (state.isNameHovered ? 1.03 : 1),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 220),
                        opacity: isNameInteractive ? 1 : 0.8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 6,
                          ),
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFF34D399),
                                Color(0xFF22D3EE),
                                Color(0xFF60A5FA),
                              ],
                            ).createShader(Offset.zero & bounds.size),
                            child: const Text(
                              'Cauã Sousa',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
