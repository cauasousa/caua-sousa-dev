import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/utils/theme.dart';
import 'feature/presentation/bloc/custom_navbar/custom_navbar_bloc.dart';
import 'feature/presentation/bloc/custom_navbar/custom_navbar_event.dart';
import 'feature/presentation/bloc/custom_navbar/navbar_section.dart';
import 'feature/presentation/widgets/custom_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: BlocProvider(
        create: (_) => CustomNavbarBloc(),
        child: const ScreenHome(),
      ),
    );
  }
}

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomNavbar(onSectionTap: _scrollToSection),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _buildSection(
              key: _sectionKeys[NavbarSection.inicio]!,
              title: 'Início',
            ),
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
