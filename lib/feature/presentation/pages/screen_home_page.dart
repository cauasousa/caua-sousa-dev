import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';

import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/custom_navbar_bloc.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/custom_navbar_event.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/navbar_section.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/about/about_cubit.dart';
import 'package:flutter_portfolio/feature/presentation/widgets/contact/contact_section.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/projects/projects_cubit.dart';
import 'package:flutter_portfolio/feature/presentation/widgets/about/about_section.dart';
import 'package:flutter_portfolio/feature/presentation/widgets/hero_section/hero_section.dart';
import 'package:flutter_portfolio/feature/presentation/widgets/projects/projects_section.dart';
import 'package:flutter_portfolio/feature/presentation/widgets/navbar/custom_navbar.dart';

import '../widgets/contact/footer.dart';

class ScreenHomePage extends StatefulWidget {
  const ScreenHomePage({super.key});

  @override
  State<ScreenHomePage> createState() => _ScreenHomePageState();
}

class _ScreenHomePageState extends State<ScreenHomePage> {
  final ValueNotifier<double> _heroScrollProgress = ValueNotifier<double>(0);
  final ValueNotifier<double> _aboutScrollProgress = ValueNotifier<double>(0);
  late final AboutCubit _aboutCubit;
  late final ProjectsCubit _projectsCubit;
  NavbarSection? _lastSection;

  final Map<NavbarSection, GlobalKey> _sectionKeys = {
    NavbarSection.home: GlobalKey(),
    NavbarSection.project: GlobalKey(),
    NavbarSection.about: GlobalKey(),
    NavbarSection.contact: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _aboutCubit = AboutCubit();
    _projectsCubit = ProjectsCubit()..loadProjects();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncActiveSectionWithViewport();
    });
  }

  @override
  void dispose() {
    _aboutCubit.close();
    _projectsCubit.close();
    _heroScrollProgress.dispose();
    _aboutScrollProgress.dispose();
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

    _updateAboutRevealProgress(metrics.viewportDimension);

    _syncActiveSectionWithViewport();
  }

  void _updateAboutRevealProgress(double viewportHeight) {
    if (!mounted || viewportHeight <= 0) {
      return;
    }

    final aboutContext = _sectionKeys[NavbarSection.about]?.currentContext;
    if (aboutContext == null) {
      return;
    }

    final renderBox = aboutContext.findRenderObject();
    if (renderBox is! RenderBox) {
      return;
    }

    final top = renderBox.localToGlobal(Offset.zero).dy;
    final start = viewportHeight * 0.92;
    final end = viewportHeight * 0.42;
    final progress = ((start - top) / (start - end)).clamp(0.0, 1.0);

    if ((_aboutScrollProgress.value - progress).abs() > 0.004) {
      _aboutScrollProgress.value = progress;
    }
  }

  void _syncActiveSectionWithViewport() {
    if (!mounted) {
      return;
    }

    const triggerLine = 120.0;
    NavbarSection active = NavbarSection.home;

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

  Widget _buildHomeSection() {
    return KeyedSubtree(
      key: _sectionKeys[NavbarSection.home],
      child: HeroSection(
        scrollProgressListenable: _heroScrollProgress,
        onExplore: () => _scrollToSection(NavbarSection.project),
      ),
    );
  }

  Widget _buildProjectSection() {
    return KeyedSubtree(
      key: _sectionKeys[NavbarSection.project],
      child: BlocProvider.value(
        value: _projectsCubit,
        child: const ProjectsSection(),
      ),
    );
  }

  Widget _buildAboutSection() {
    return KeyedSubtree(
      key: _sectionKeys[NavbarSection.about],
      child: BlocProvider.value(
        value: _aboutCubit,
        child: AboutSection(scrollProgressListenable: _aboutScrollProgress),
      ),
    );
  }

  Widget _buildContactSection() {
    return KeyedSubtree(
      key: _sectionKeys[NavbarSection.contact],
      child: const ContactSection(),
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
                _buildHomeSection(),
                _buildProjectSection(),
                _buildAboutSection(),
                _buildContactSection(),
                Footer(onNavigate: _scrollToSection),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
