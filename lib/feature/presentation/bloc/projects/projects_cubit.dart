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
          reactionCounts: _buildReactionCounts(projects),
        ),
      );
    } catch (error) {
      debugPrint('Projects load error: $error');

      emit(
        state.copyWith(
          status: ProjectsStatus.failure,
          projects: _fallbackProjects,
          reactionCounts: _buildReactionCounts(_fallbackProjects),
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
    
  ];

  void setFilter(String filter) {
    if (filter == state.selectedFilter) {
      return;
    }
    emit(state.copyWith(selectedFilter: filter));
  }

  void openProjectDetails(String projectId) {
    if (state.selectedProjectId == projectId) {
      emit(state.copyWith(selectedProjectId: null));
      Future.microtask(() {
        if (!isClosed) {
          emit(this.state.copyWith(selectedProjectId: projectId));
        }
      });
      return;
    }

    emit(state.copyWith(selectedProjectId: projectId));
  }

  void closeProjectDetails() {
    emit(state.copyWith(selectedProjectId: null));
  }

  void incrementReaction(String projectId, ProjectReaction reaction) {
    final nextCounts = Map<String, Map<ProjectReaction, int>>.from(
      state.reactionCounts,
    );
    final projectCounts = Map<ProjectReaction, int>.from(
      nextCounts[projectId] ?? const <ProjectReaction, int>{},
    );
    projectCounts[reaction] = (projectCounts[reaction] ?? 0) + 1;
    nextCounts[projectId] = projectCounts;

    emit(state.copyWith(reactionCounts: nextCounts));
  }

  Map<String, Map<ProjectReaction, int>> _buildReactionCounts(
    List<ProjectItem> projects,
  ) {
    final counts = <String, Map<ProjectReaction, int>>{};

    for (var index = 0; index < projects.length; index++) {
      final project = projects[index];
      counts[project.id] = <ProjectReaction, int>{
        ProjectReaction.like: 23 + index + 1,
        ProjectReaction.fire: 11 + index + 1,
        ProjectReaction.heart: 7 + index + 1,
        ProjectReaction.sparkle: 4 + index + 1,
      };
    }

    return counts;
  }
}
