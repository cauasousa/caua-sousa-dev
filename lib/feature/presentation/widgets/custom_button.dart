import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_portfolio/core/utils/theme.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/custom_button/custom_button_bloc.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/custom_button/custom_button_event.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/custom_button/custom_button_state.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.label = 'Vamos conversar',
    this.onPressed,
    this.width,
    this.height,
  });

  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final hasFixedHeight = height != null;
    final contentPadding = hasFixedHeight
        ? const EdgeInsets.symmetric(horizontal: 18)
        : const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 14,
          );

    return BlocProvider(
      create: (_) => CustomButtonBloc(),
      child: BlocBuilder<CustomButtonBloc, CustomButtonState>(
        builder: (context, state) {
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) {
              context
                  .read<CustomButtonBloc>()
                  .onEvent(const CustomButtonHoverChanged(true));
            },
            onExit: (_) {
              context
                  .read<CustomButtonBloc>()
                  .onEvent(const CustomButtonHoverChanged(false));
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0EA5A3), Color(0xFF14B8A6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: state.isHovered
                    ? [
                        BoxShadow(
                          color: AppColors.accentTeal.withValues(alpha: 0.34),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.20),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
              ),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: state.isLoading
                      ? null
                      : () {
                          context
                              .read<CustomButtonBloc>()
                              .onEvent(const CustomButtonPressed());
                          onPressed?.call();
                        },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    alignment: Alignment.center,
                    padding: contentPadding,
                    constraints: hasFixedHeight
                        ? null
                        : const BoxConstraints(minHeight: 44),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: state.isHovered
                          ? Colors.transparent
                          : Colors.black.withValues(alpha: 0.12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state.isLoading)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        else
                          Text(
                            label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.25,
                              fontFamily: 'ExoMedium',
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
