import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/custom_navbar_bloc.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/custom_navbar_event.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/custom_navbar/navbar_section.dart';
import 'package:flutter_portfolio/feature/presentation/widgets/hero_section/hero_section.dart';
import 'package:flutter_portfolio/feature/presentation/widgets/navbar/custom_navbar.dart';

class ScreenHomePage extends StatefulWidget {
  const ScreenHomePage({super.key});

  @override
  State<ScreenHomePage> createState() => _ScreenHomePageState();
}

class _ScreenHomePageState extends State<ScreenHomePage> {
  final ScrollController _scrollController = ScrollController();

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
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncActiveSectionWithViewport();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
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

    context.read<CustomNavbarBloc>().onEvent(NavbarSectionChanged(active));
  }

  Future<void> _scrollToSection(NavbarSection section) async {
    final sectionContext = _sectionKeys[section]?.currentContext;
    if (sectionContext == null) {
      return;
    }

    await Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      alignment: 0.05,
    );
  }

  Widget _buildSection({
    required GlobalKey key,
    required String title,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 600),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
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
      child: const HeroSection(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomNavbar(onSectionTap: _scrollToSection),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _buildInicioSection(),
            _buildSection(
              key: _sectionKeys[NavbarSection.sobre]!,
              title: 'Sobre',
            ),
            _buildSection(
              key: _sectionKeys[NavbarSection.habilidades]!,
              title: 'Habilidades',
            ),
            _buildSection(
              key: _sectionKeys[NavbarSection.projetos]!,
              title: 'Projetos',
            ),
            _buildSection(
              key: _sectionKeys[NavbarSection.contato]!,
              title: 'Contato',
            ),
          ],
        ),
      ),
    );
  }
}
