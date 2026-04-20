import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_portfolio/feature/presentation/bloc/projects/project_item.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/projects/projects_cubit.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/projects/projects_state.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  static const filters = ['All', 'Released', 'Personal'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsCubit, ProjectsState>(
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
                      _FilterBar(state: state),
                      const SizedBox(height: 24),
                      if (state.status == ProjectsStatus.loading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 50),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (state.status == ProjectsStatus.failure)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 50),
                          child: Center(
                            child: Text(
                              'Erro ao carregar projetos.',
                              style: TextStyle(color: Colors.white70),
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
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.state});

  final ProjectsState state;

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
            for (final filter in ProjectsSection.filters)
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

class _FilterButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE6B9F2) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              count.toString(),
              style: TextStyle(
                color: isActive ? Colors.black54 : Colors.white38,
                fontSize: 12,
              ),
            ),
          ],
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
            childAspectRatio: 16 / 11,
          ),
          itemBuilder: (context, index) {
            return _ProjectCard(project: projects[index], index: index + 1);
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

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final titleFontSize = MediaQuery.sizeOf(context).width >= 860 ? 26.0 : 22.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          color: const Color(0xFF171717),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                scale: _isHovered ? 1.1 : 1,
                child: Image.asset(
                  project.image,
                  fit: BoxFit.cover,
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
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                color: Colors.black.withValues(alpha: _isHovered ? 0.48 : 0.24),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.10),
                      Colors.black.withValues(alpha: _isHovered ? 0.90 : 0.78),
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
                    color:
                        Colors.white.withValues(alpha: _isHovered ? 0.7 : 0.44),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Positioned(
                top: 14,
                right: 14,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 260),
                  opacity: _isHovered ? 0.52 : 0.36,
                  child: const Icon(
                    Icons.layers_outlined,
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
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      offset: _isHovered ? Offset.zero : const Offset(0, 0.08),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 220),
                        opacity: _isHovered ? 1 : 0.78,
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
                                  color: Colors.black.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.14),
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
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOutCubic,
                            offset: _isHovered
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
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOutBack,
                          scale: _isHovered ? 1 : 0.84,
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
                      ],
                    ),
                    const SizedBox(height: 7),
                    AnimatedSlide(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      offset: _isHovered ? Offset.zero : const Offset(0, 0.1),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 220),
                        opacity: _isHovered ? 1 : 0.78,
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
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        _CardActionIcon(icon: Icons.thumb_up_alt_outlined),
                        _CardActionIcon(
                            icon: Icons.local_fire_department_outlined),
                        _CardActionIcon(icon: Icons.favorite_border),
                        _CardActionIcon(icon: Icons.auto_awesome_outlined),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardActionIcon extends StatelessWidget {
  const _CardActionIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: IconButton(
        onPressed: () {},
        constraints: const BoxConstraints.tightFor(width: 28, height: 28),
        padding: EdgeInsets.zero,
        splashRadius: 16,
        icon: Icon(
          icon,
          size: 15,
          color: Colors.white38,
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
