import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_portfolio/core/utils/theme.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/projects/project_item.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/projects/projects_cubit.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/projects/projects_state.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  static const filters = ['All', 'Academic', 'Professional'];

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectsCubit, ProjectsState>(
      listenWhen: (previous, current) =>
          previous.selectedProjectId != current.selectedProjectId,
      listener: (context, state) {
        final projectId = state.selectedProjectId;
        if (projectId == null) {
          return;
        }

        ProjectItem? selectedProject;
        for (final project in state.projects) {
          if (project.id == projectId) {
            selectedProject = project;
            break;
          }
        }

        if (selectedProject == null) {
          return;
        }

        showDialog(
          context: context,
          builder: (dialogContext) =>
              ProjectDetailsDialog(project: selectedProject!),
        ).then((_) {
          // Quando o usuário clicar fora ou fechar o modal, limpamos a seleção no Cubit
          if (context.mounted) {
            context
                .read<ProjectsCubit>()
                .closeProjectDetails(); // Substitua pelo método que você usa para limpar o estado
          }
        });
      },
      child: BlocBuilder<ProjectsCubit, ProjectsState>(
        builder: (context, state) {
          return Container(
            width: double.infinity,
            color: const Color(0xFF0A0A0A),
            child: Column(
              children: [
                const _WaveDivider(height: 68),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 80),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Portfolio',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0x66FFFFFF),
                            fontSize: 11,
                            letterSpacing: 3.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Projects',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 28),
                        _FilterBar(state: state, filters: state.filterOptions),
                        const SizedBox(height: 24),
                        if (state.status == ProjectsStatus.loading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 50),
                            child: Center(child: _ProjectSkeletonLoader()),
                          )
                        else if (state.status == ProjectsStatus.failure)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Center(
                              child: Column(
                                children: [
                                  const Text(
                                    'Erro ao carregar projetos.',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(height: 12),
                                  FilledButton(
                                    onPressed: () => context
                                        .read<ProjectsCubit>()
                                        .loadProjects(),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.accentTeal,
                                    ),
                                    child: const Text('Tentar novamente'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          _ProjectsGrid(projects: state.filteredProjects),
                      ],
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

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.state, required this.filters});

  final ProjectsState state;
  final List<String> filters;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectsCubit>();

    return Center(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            for (final filter in filters)
              _FilterButton(
                title: filter,
                count: state.countFor(filter),
                isActive: state.selectedFilter == filter,
                onTap: () => cubit.setFilter(filter),
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatefulWidget {
  const _FilterButton({
    required this.title,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<_FilterButton> {
  bool _isHovered = false;
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = widget.isActive || _isHovered || _hasFocus;

    return Focus(
      onFocusChange: (focused) => setState(() => _hasFocus = focused),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: resolveDuration(context, AppDurations.base),
            curve: AppCurves.standard,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            decoration: BoxDecoration(
              color: isHighlighted ? AppColors.accentTeal : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: isHighlighted ? Colors.black : Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  widget.count.toString(),
                  style: TextStyle(
                    color: isHighlighted ? Colors.black54 : Colors.white38,
                    fontSize: 12,
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

class _ProjectsGrid extends StatelessWidget {
  const _ProjectsGrid({required this.projects});

  final List<ProjectItem> projects;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 1080
            ? 3
            : width >= 720
                ? 2
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: projects.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 16 / 10.6,
          ),
          itemBuilder: (context, index) {
            return _StaggeredReveal(
              index: index,
              child: _ProjectCard(project: projects[index], index: index + 1),
            );
          },
        );
      },
    );
  }
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({required this.project, required this.index});

  final ProjectItem project;
  final int index;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;
  bool _hasFocus = false;
  int _imageIndex = 0;
  Timer? _imageTimer;

  @override
  void dispose() {
    _imageTimer?.cancel();
    super.dispose();
  }

  void _startImageCycle() {
    final images = widget.project.images;
    if (images.length <= 1) return;
    _imageTimer?.cancel();
    _imageTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (!mounted) return;
      setState(() => _imageIndex = (_imageIndex + 1) % images.length);
    });
  }

  void _stopImageCycle() {
    _imageTimer?.cancel();
    _imageTimer = null;
    if (mounted) setState(() => _imageIndex = 0);
  }

  IconData _engineIconFor(ProjectItem project) {
    final tags = project.tags.map((tag) => tag.toUpperCase()).toSet();
    if (tags.contains('UNREAL')) return Icons.precision_manufacturing_outlined;
    if (tags.contains('UNITY')) return Icons.sports_esports_outlined;
    if (tags.contains('THREEJS')) return Icons.auto_awesome_outlined;
    if (tags.contains('WEBGL')) return Icons.videogame_asset_outlined;
    return Icons.bolt_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final images = project.images;
    final titleFontSize = MediaQuery.sizeOf(context).width >= 860 ? 26.0 : 22.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Focus(
        canRequestFocus: true,
        onFocusChange: (focused) {
          if (mounted) {
            setState(() => _hasFocus = focused);
            if (focused) {
              _startImageCycle();
            } else {
              _stopImageCycle();
            }
          }
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) {
            setState(() => _isHovered = true);
            _startImageCycle();
          },
          onExit: (_) {
            setState(() => _isHovered = false);
            _stopImageCycle();
          },
          child: GestureDetector(
            onTap: () =>
                context.read<ProjectsCubit>().openProjectDetails(project.id),
            child: Container(
              color: const Color(0xFF171717),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: ColoredBox(color: Colors.transparent),
                  ),
                  AnimatedScale(
                    duration: resolveDuration(
                      context,
                      const Duration(milliseconds: 420),
                    ),
                    curve: AppCurves.standard,
                    scale: (_isHovered || _hasFocus) ? 1.04 : 1,
                    child: AnimatedSwitcher(
                      duration: resolveDuration(
                        context,
                        const Duration(milliseconds: 260),
                      ),
                      child: Image.asset(
                        images.isNotEmpty ? images[_imageIndex] : '',
                        key: ValueKey('${project.id}-$_imageIndex'),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        frameBuilder: (
                          context,
                          child,
                          frame,
                          wasSynchronouslyLoaded,
                        ) {
                          if (wasSynchronouslyLoaded) {
                            return child;
                          }
                          return AnimatedOpacity(
                            opacity: frame == null ? 0 : 1,
                            duration: resolveDuration(
                              context,
                              AppDurations.base,
                            ),
                            child: child,
                          );
                        },
                        errorBuilder: (context, _, __) => Container(
                          color: const Color(0xFF111111),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: resolveDuration(context, AppDurations.base),
                    curve: AppCurves.standard,
                    color: Colors.black.withValues(
                      alpha: (_isHovered || _hasFocus) ? 0.42 : 0.24,
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.10),
                          Colors.black.withValues(
                            alpha: _isHovered ? 0.90 : 0.78,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Text(
                      widget.index.toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: Colors.white.withValues(
                          alpha: (_isHovered || _hasFocus) ? 0.7 : 0.44,
                        ),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (images.length > 1)
                    Positioned(
                      top: 20,
                      right: 50,
                      child: AnimatedOpacity(
                        duration: resolveDuration(
                          context,
                          const Duration(milliseconds: 220),
                        ),
                        opacity: (_isHovered || _hasFocus) ? 1 : 0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < images.length; i++)
                              AnimatedContainer(
                                duration: resolveDuration(
                                  context,
                                  const Duration(milliseconds: 220),
                                ),
                                margin: const EdgeInsets.only(left: 4),
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i == _imageIndex
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    top: 14,
                    right: 14,
                    child: AnimatedOpacity(
                      duration: resolveDuration(
                        context,
                        const Duration(milliseconds: 260),
                      ),
                      opacity: 0.4,
                      child: Icon(
                        _engineIconFor(project),
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSlide(
                          duration: resolveDuration(
                            context,
                            const Duration(milliseconds: 260),
                          ),
                          curve: AppCurves.standard,
                          offset: (_isHovered || _hasFocus)
                              ? Offset.zero
                              : const Offset(0, 0.08),
                          child: AnimatedOpacity(
                            duration: resolveDuration(
                              context,
                              const Duration(milliseconds: 220),
                            ),
                            opacity: (_isHovered || _hasFocus) ? 1 : 0.78,
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                for (final tag in project.tags.take(4))
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.black.withValues(alpha: 0.35),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: Colors.white
                                            .withValues(alpha: 0.14),
                                      ),
                                    ),
                                    child: Text(
                                      tag,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.7,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: AnimatedSlide(
                                duration: resolveDuration(
                                  context,
                                  const Duration(milliseconds: 280),
                                ),
                                curve: AppCurves.standard,
                                offset: (_isHovered || _hasFocus)
                                    ? Offset.zero
                                    : const Offset(0, 0.12),
                                child: Text(
                                  project.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.w500,
                                    height: 1.04,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            AnimatedScale(
                              duration: resolveDuration(
                                context,
                                const Duration(milliseconds: 260),
                              ),
                              curve: AppCurves.standard,
                              scale: (_isHovered || _hasFocus) ? 1.0 : 0.0,
                              child: AnimatedRotation(
                                duration: resolveDuration(
                                  context,
                                  const Duration(milliseconds: 260),
                                ),
                                curve: AppCurves.standard,
                                turns: (_isHovered || _hasFocus) ? 0.0 : -0.125,
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE6B9F2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_outward,
                                    color: Colors.black,
                                    size: 21,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        AnimatedSlide(
                          duration: resolveDuration(
                            context,
                            const Duration(milliseconds: 280),
                          ),
                          curve: AppCurves.standard,
                          offset: (_isHovered || _hasFocus)
                              ? Offset.zero
                              : const Offset(0, 0.1),
                          child: AnimatedOpacity(
                            duration: resolveDuration(
                              context,
                              const Duration(milliseconds: 220),
                            ),
                            opacity: (_isHovered || _hasFocus) ? 1 : 0.78,
                            child: Text(
                              project.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xB3FFFFFF),
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StaggeredReveal extends StatefulWidget {
  const _StaggeredReveal({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<_StaggeredReveal> createState() => _StaggeredRevealState();
}

class _StaggeredRevealState extends State<_StaggeredReveal> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.index * 55), () {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: resolveDuration(context, AppDurations.base),
      curve: AppCurves.standard,
      opacity: _visible ? 1 : 0,
      child: AnimatedSlide(
        duration: resolveDuration(context, AppDurations.base),
        curve: AppCurves.standard,
        offset: _visible ? Offset.zero : const Offset(0, 0.06),
        child: widget.child,
      ),
    );
  }
}

class _ProjectSkeletonLoader extends StatelessWidget {
  const _ProjectSkeletonLoader();

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = MediaQuery.sizeOf(context).width >= 1080 ? 3 : 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: crossAxisCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 16 / 11,
      ),
      itemBuilder: (context, index) => const _ProjectSkeletonCard(),
    );
  }
}

class _ProjectSkeletonCard extends StatefulWidget {
  const _ProjectSkeletonCard();

  @override
  State<_ProjectSkeletonCard> createState() => _ProjectSkeletonCardState();
}

class _ProjectSkeletonCardState extends State<_ProjectSkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.slow,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final opacity = 0.25 + (0.2 * _controller.value);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 104,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: opacity + 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 120,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: opacity + 0.08),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 180,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: opacity + 0.05),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProjectDetailsDialog extends StatelessWidget {
  const ProjectDetailsDialog({super.key, required this.project});

  final ProjectItem project;

  Future<void> _launchProjectLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainImage = project.images.isNotEmpty ? project.images.first : '';
    final galleryImages = project.images.length > 1
        ? project.images.skip(1).toList(growable: false)
        : <String>[];

    return Dialog(
      backgroundColor: const Color(0xFF111111),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 800),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 850;
            final detailsContent = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        project.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // context.read<ProjectsCubit>().closeProjectDetails();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close, color: Colors.white54),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: project.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: Color(0xFF34D399),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'ABOUT THIS PROJECT',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  project.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                if (project.link != null && project.link!.isNotEmpty) ...[
                  FilledButton.icon(
                    onPressed: () => _launchProjectLink(project.link!),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accentTeal,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text(
                      'Acessar Projeto',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                if (galleryImages.isNotEmpty) ...[
                  const Text(
                    'GALLERY',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 16,
                    runSpacing: 16,
                    children: galleryImages
                        .map(
                          (imagePath) => FractionallySizedBox(
                            widthFactor: isDesktop ? 0.45 : 0.47,
                            // Adiciona o AspectRatio para manter a proporção 16:9
                            alignment: Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight:
                                    220, // <--- Ajuste este valor (ex: 180, 220, 250) até ficar do tamanho desejado
                              ),
                              child: HoverExpandableImage(
                                imagePath: imagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            );

            if (isDesktop) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: mainImage.isNotEmpty
                          ? HoverExpandableImage(
                              imagePath: mainImage,
                              isMain: true,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(0, 24, 24, 24),
                      child: detailsContent,
                    ),
                  ),
                ],
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  if (mainImage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: HoverExpandableImage(
                          imagePath: mainImage,
                          isMain: true,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: detailsContent,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class HoverExpandableImage extends StatefulWidget {
  const HoverExpandableImage({
    super.key,
    required this.imagePath,
    this.isMain = false,
    this.fit = BoxFit.cover,
  });

  final String imagePath;
  final bool isMain;
  final BoxFit fit;

  @override
  State<HoverExpandableImage> createState() => _HoverExpandableImageState();
}

class _HoverExpandableImageState extends State<HoverExpandableImage> {
  bool _isHovered = false;

  void _showFullScreen() {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        child: Stack(
          fit: StackFit.expand,
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.asset(widget.imagePath, fit: BoxFit.contain),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _showFullScreen,
        child: SizedBox.expand(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isHovered
                    ? const Color(0xFF34D399)
                    : Colors.white.withValues(alpha: 0.05),
                width: 2,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: const Color(0xFF34D399).withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : const [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                widget.imagePath,
                fit: widget.fit,
                width: double.infinity,
                height:
                    double.infinity, // widget.isMain ? double.infinity : 120,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WaveDivider extends StatelessWidget {
  const _WaveDivider({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _WavePainter(),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.18);
    path.lineTo(size.width * 0.08, size.height * 0.56);
    path.lineTo(size.width * 0.18, size.height * 0.26);
    path.lineTo(size.width * 0.28, size.height * 0.42);
    path.lineTo(size.width * 0.36, size.height * 0.18);
    path.lineTo(size.width * 0.49, size.height * 0.52);
    path.lineTo(size.width * 0.62, size.height * 0.18);
    path.lineTo(size.width * 0.72, size.height * 0.52);
    path.lineTo(size.width * 0.84, 0);
    path.lineTo(size.width * 0.91, size.height * 0.42);
    path.lineTo(size.width, size.height * 0.18);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final paint = Paint()..color = const Color(0xFF0A0A0A);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
