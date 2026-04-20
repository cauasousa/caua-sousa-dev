import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'project_item.dart';
import 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  ProjectsCubit() : super(const ProjectsState());

  Future<void> loadProjects() async {
    emit(state.copyWith(status: ProjectsStatus.loading));

    try {
      final jsonString = await _loadProjectsJson();
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      final rawProjects = decoded['projects'] as List<dynamic>? ?? const [];
      final projects = rawProjects
          .whereType<Map<String, dynamic>>()
          .map(ProjectItem.fromJson)
          .toList(growable: false);

      emit(
        state.copyWith(
          status: ProjectsStatus.success,
          projects: projects,
        ),
      );
    } catch (error) {
      debugPrint('Projects load error: $error');

      // Keeps UI working even if web dev-server fails to serve the JSON file.
      emit(
        state.copyWith(
          status: ProjectsStatus.success,
          projects: _fallbackProjects,
        ),
      );
    }
  }

  Future<String> _loadProjectsJson() async {
    return rootBundle.loadString(
      'lib/assets/data/task.json',
      cache: false,
    );
  }

  static const List<ProjectItem> _fallbackProjects = [
    ProjectItem(
      id: 'fallback-1',
      title: 'Rocket League',
      description:
          'Trabalho com materiais, shaders e performance em Unreal Engine.',
      type: 'Released',
      tags: ['UNREAL', 'GAME', '3D', 'SHADERS'],
      image: 'lib/assets/images/image-portfolio.png',
    ),
    ProjectItem(
      id: 'fallback-2',
      title: 'Tamagotchi Toy-Like',
      description: 'Pipeline 3D completo com foco em visual e interacao.',
      type: 'Personal',
      tags: ['UNREAL', '3D', 'SDF'],
      image: 'lib/assets/images/image-portfolio.png',
    ),
    ProjectItem(
      id: 'fallback-3',
      title: 'Fiat Fastback WebGL',
      description:
          'Experiencia web 3D interativa com renderizacao em tempo real.',
      type: 'Released',
      tags: ['THREEJS', 'WEBGL', '3D'],
      image: 'lib/assets/images/image-portfolio.png',
    ),
  ];

  void setFilter(String filter) {
    if (filter == state.selectedFilter) {
      return;
    }
    emit(state.copyWith(selectedFilter: filter));
  }
}
