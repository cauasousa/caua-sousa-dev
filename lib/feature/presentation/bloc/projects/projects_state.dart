import 'project_item.dart';

enum ProjectsStatus { initial, loading, success, failure }

class ProjectsState {
  const ProjectsState({
    this.status = ProjectsStatus.initial,
    this.projects = const [],
    this.selectedFilter = 'All',
  });

  final ProjectsStatus status;
  final List<ProjectItem> projects;
  final String selectedFilter;

  ProjectsState copyWith({
    ProjectsStatus? status,
    List<ProjectItem>? projects,
    String? selectedFilter,
  }) {
    return ProjectsState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
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
}
