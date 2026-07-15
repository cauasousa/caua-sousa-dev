import 'project_item.dart';

enum ProjectsStatus { initial, loading, success, failure }

enum ProjectReaction { like, fire, heart, sparkle }

class ProjectsState {
  const ProjectsState({
    this.status = ProjectsStatus.initial,
    this.projects = const [],
    this.selectedFilter = 'All',
    this.selectedProjectId,
    this.reactionCounts = const <String, Map<ProjectReaction, int>>{},
  });

  static const Object _sentinel = Object();

  final ProjectsStatus status;
  final List<ProjectItem> projects;
  final String selectedFilter;
  final String? selectedProjectId;
  final Map<String, Map<ProjectReaction, int>> reactionCounts;

  ProjectsState copyWith({
    ProjectsStatus? status,
    List<ProjectItem>? projects,
    String? selectedFilter,
    Object? selectedProjectId = _sentinel,
    Map<String, Map<ProjectReaction, int>>? reactionCounts,
  }) {
    return ProjectsState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedProjectId: selectedProjectId == _sentinel
          ? this.selectedProjectId
          : selectedProjectId as String?,
      reactionCounts: reactionCounts ?? this.reactionCounts,
    );
  }

  List<String> get filterOptions {
    final options = <String>{'All'};
    for (final project in projects) {
      final type = project.type.trim();
      if (type.isNotEmpty) {
        options.add(type);
      }
    }
    return options.toList(growable: false);
  }

  List<ProjectItem> get filteredProjects {
    if (selectedFilter == 'All') {
      return projects;
    }
    return projects.where((project) => project.type == selectedFilter).toList();
  }

  int countFor(String filter) {
    if (filter == 'All') {
      return projects.length;
    }
    return projects.where((project) => project.type == filter).length;
  }

  int reactionCount(String projectId, ProjectReaction reaction) {
    return reactionCounts[projectId]?[reaction] ?? 0;
  }
}
