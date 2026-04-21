import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';

import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/custom_navbar_bloc.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/custom_navbar_event.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/navbar_section.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/projects/projects_cubit.dart';
import 'package:flutter_portfolio/feature/presentation/widgets/hero_section/hero_section.dart';
import 'package:flutter_portfolio/feature/presentation/widgets/projects/projects_section.dart';
import 'package:flutter_portfolio/feature/presentation/widgets/navbar/custom_navbar.dart';

class ScreenHomePage extends StatefulWidget {
  const ScreenHomePage({super.key});

  @override
  State<ScreenHomePage> createState() => _ScreenHomePageState();
}

class _ScreenHomePageState extends State<ScreenHomePage> {
  final ValueNotifier<double> _heroScrollProgress = ValueNotifier<double>(0);
  late final ProjectsCubit _projectsCubit;
  NavbarSection? _lastSection;

  final Map<NavbarSection, GlobalKey> _sectionKeys = {
    NavbarSection.inicio: GlobalKey(),
    NavbarSection.sobre: GlobalKey(),
    NavbarSection.habilidades: GlobalKey(),
    NavbarSection.projetos: GlobalKey(),
    NavbarSection.contato: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _projectsCubit = ProjectsCubit()..loadProjects();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncActiveSectionWithViewport();
    });
  }

  @override
  void dispose() {
    _projectsCubit.close();
    _heroScrollProgress.dispose();
    super.dispose();
  }

  void _onScrollMetrics(ScrollMetrics metrics) {
    // Keep transition speed consistent across screen sizes.
    const heroTransitionDistance = 520.0;
    final targetProgress =
        (metrics.pixels / heroTransitionDistance).clamp(0.0, 1.0);

    if ((_heroScrollProgress.value - targetProgress).abs() > 0.004) {
      _heroScrollProgress.value = targetProgress;
    }

    _syncActiveSectionWithViewport();
  }

  void _syncActiveSectionWithViewport() {
    if (!mounted) {
      return;
    }

    const triggerLine = 120.0;
    NavbarSection active = NavbarSection.inicio;

    for (final section in NavbarSection.values) {
      final keyContext = _sectionKeys[section]?.currentContext;
      if (keyContext == null) {
        continue;
      }

      final renderBox = keyContext.findRenderObject();
      if (renderBox is! RenderBox) {
        continue;
      }

      final top = renderBox.localToGlobal(Offset.zero).dy;
      if (top <= triggerLine) {
        active = section;
      }
    }

    if (active == _lastSection) {
      return;
    }

    _lastSection = active;
    context.read<CustomNavbarBloc>().onEvent(NavbarSectionChanged(active));
  }

  Future<void> _scrollToSection(NavbarSection section) async {
    final sectionContext = _sectionKeys[section]?.currentContext;
    if (sectionContext == null) {
      return;
    }

    await Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutQuart,
      alignment: 0.05,
    );
  }

  Widget _buildSection({
    required GlobalKey key,
    required String title,
    double verticalPadding = 48,
  }) {
    return Container(
      key: key,
      color: const Color(0xFF0A0A0A),
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 600),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: verticalPadding),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }

  Widget _buildInicioSection() {
    return KeyedSubtree(
      key: _sectionKeys[NavbarSection.inicio],
      child: HeroSection(scrollProgressListenable: _heroScrollProgress),
    );
  }

  Widget _buildProjetosSection() {
    return KeyedSubtree(
      key: _sectionKeys[NavbarSection.projetos],
      child: BlocProvider.value(
        value: _projectsCubit,
        child: const ProjectsSection(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1020;
    final isMenuOpen =
        context.select((CustomNavbarBloc bloc) => bloc.state.isMobileMenuOpen);
    final appBarHeight = isMobile && isMenuOpen ? 438.0 : 78.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: CustomNavbar(onSectionTap: _scrollToSection),
      ),
      body: DynMouseScroll(
        durationMS: 90,
        builder: (context, controller, physics) =>
            NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.depth == 0) {
              _onScrollMetrics(notification.metrics);
            }
            return false;
          },
          child: SingleChildScrollView(
            controller: controller,
            physics: physics,
            child: Column(
              children: [
                _buildInicioSection(),
                _buildSection(
                  key: _sectionKeys[NavbarSection.sobre]!,
                  title: 'Sobre',
                  verticalPadding: 8,
                ),
                _buildSection(
                  key: _sectionKeys[NavbarSection.habilidades]!,
                  title: 'Habilidades',
                ),
                _buildProjetosSection(),
                _buildSection(
                  key: _sectionKeys[NavbarSection.contato]!,
                  title: 'Contato',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
